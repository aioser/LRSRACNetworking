//
//  LRSNetworkingClient.m
//  LRSNetworking
//
//  Created by sama 刘 on 2021/10/12.
//

#import "LRSNetworkingClient.h"
#import "LRSNetworkingHelper.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface LRSNetworkingClient()
@property (nonatomic, copy, readwrite) NSString *path;
@property (nonatomic, strong, readwrite) AFHTTPSessionManager *session;
@end

NSString *const LRSNetworkingResponseObjectErrorKey = @"LRSNetworkingResponseObjectErrorKey";
NSString *const LRSNetworkingResponseObjectErrorDomain = @"com.lrs.networking";
@implementation LRSNetworkingClient

- (instancetype)initWithPath:(NSString *)path {
    if (self = [super init]) {
        _path = [path copy];
        _session = [AFHTTPSessionManager manager];
    }
    return self;
}

- (NSURLSessionDataTask *)requestPath:(NSString *)path
                           parameters:(NSDictionary * _Nullable)parameters
                              headers:(NSDictionary * _Nullable)headers
                               method:(NSString *)method
                               result:(void(^)(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error))result {

    NSURL *url = [NSURL URLWithString:path relativeToURL:self.baseURL];
    NSMutableURLRequest *request = [self.session.requestSerializer requestWithMethod:method URLString:url.absoluteString parameters:parameters error:nil];

    if (self.signer) {
        int32_t nonce = arc4random() % INT32_MAX;
        int64_t timestamp = 0;
        NSString *sign = [self.signer signParameters:parameters forURL:url timestamp:&timestamp];
        [request setValue:[self.signer signVersion] forHTTPHeaderField:@"signVersion"];
        [request setValue:[@(nonce) stringValue] forHTTPHeaderField:@"nonce"];
        [request setValue:sign forHTTPHeaderField:@"signKey"];
        [request setValue:[@(timestamp) stringValue] forHTTPHeaderField:@"signTime"];
    }

    if (self.blackBoxProvider) {
        NSString *blackBox = [self.blackBoxProvider blackBoxValue];
        [request setValue:blackBox forHTTPHeaderField:@"blackBox"];
    }

    for (NSString *key in headers) {
        [request setValue:headers[key] forHTTPHeaderField:key];
    }

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSError *parasError = error;
        NSDictionary *decoderResponse = responseObject;
        if (error) {
            parasError = error;
            decoderResponse = responseObject;
        } else {
            if (self.responseDecoder) {
                NSError *decodeError = nil;
                NSDictionary *resp = [self.responseDecoder decodeResponseObject:responseObject error:&decodeError];
                if (decodeError) {
                    parasError = decodeError;
                } else {
                    decoderResponse = resp;
                }
            }
        }
        if (parasError) {
            NSMutableDictionary *userInfo = [parasError.userInfo mutableCopy];
            if (responseObject) {
                userInfo[LRSNetworkingResponseObjectErrorKey] = decoderResponse;
            }
            NSError *errorWithRes = [NSError errorWithDomain:parasError.domain code:parasError.code userInfo:[userInfo copy]];
            result(response, nil, errorWithRes);
            [self.errorCatcher catchErrorWithURL:url.absoluteString method:method response:response responseObject:responseObject error:error];
        } else {
            if (!decoderResponse[@"err_code"]) {
                if (self.ormHandler) {
                    NSError *parasError = nil;
                    result(response, [self.ormHandler parasResponseObjectWithURL:url.absoluteString method:method responseObject:decoderResponse error:&parasError], parasError);
                } else {
                    result(response, decoderResponse, nil);
                }
            } else {
                if (self.captchaHandler && [self.captchaHandler checkResponseObjectWithURL:url.absoluteString method:method errorResponse:decoderResponse]) {
                    [self.captchaHandler startCaptchaTaskWithURL:url.absoluteString method:method errorResponse:decoderResponse result:^(NSDictionary * _Nonnull captcha, NSDictionary * _Nonnull extra, NSError * _Nonnull error) {
                        if (!error) {
                            NSMutableDictionary *parametersNext = [NSMutableDictionary dictionaryWithDictionary:parameters];
                            [parametersNext addEntriesFromDictionary:extra];

                            NSMutableDictionary *headersNext = [NSMutableDictionary dictionaryWithDictionary:headers];
                            [headersNext addEntriesFromDictionary:captcha];
                            [self requestPath:path parameters:parametersNext headers:headersNext method:method result:result];
                        } else {
                            NSMutableDictionary *userInfo = [parasError.userInfo mutableCopy];
                            userInfo[NSLocalizedDescriptionKey] = @"验证未完成";
                            if (responseObject) {
                                userInfo[LRSNetworkingResponseObjectErrorKey] = decoderResponse;
                            }
                            NSError *errorWithRes = [NSError errorWithDomain:LRSNetworkingResponseObjectErrorDomain code:10010 userInfo:[userInfo copy]];
                            result(response, nil, errorWithRes);
                        }
                    }];
                } else {
                    result(response, decoderResponse, nil);
                    [self.errorCatcher catchErrorWithURL:url.absoluteString method:method response:response responseObject:decoderResponse error:error];
                }
            }
        }
    }];
    [task resume];
    return task;
}

@end
