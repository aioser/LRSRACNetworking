//
//  LRSNetworkingClient.h
//  LRSNetworking
//
//  Created by sama 刘 on 2021/10/12.
//

#import <Foundation/Foundation.h>
#import "LRSNetworkingSignProtocol.h"

NS_ASSUME_NONNULL_BEGIN
extern NSString *const LRSNetworkingResponseObjectErrorKey;
extern NSString *const LRSNetworkingResponseObjectErrorDomain;
@class AFHTTPSessionManager;
@interface LRSNetworkingClient : NSObject

- (instancetype)initWithPath:(NSString *)path;
@property (nonatomic, copy) NSURL *baseURL;
@property (nonatomic, copy, readonly) NSString *path;
@property (nonatomic, strong, readonly) AFHTTPSessionManager *session;

// DI
@property (nonatomic, strong) id<LRSNetworkingSignProtocol> signer;
@property (nonatomic, strong) id<LRSNetworkingBlackBoxProviderProtocol> blackBoxProvider;

@property (nonatomic, strong) id<LRSNetworkingDecoderProtocol> responseDecoder;
@property (nonatomic, strong) id<LRSNetworkingORMHandlerProtocol> ormHandler;
@property (nonatomic, strong) id<LRSNetworkingCaptchaHandlerProtocol> captchaHandler;
@property (nonatomic, strong) id<LRSNetworkingErrorCatchProtocol> errorCatcher;

- (NSURLSessionDataTask *)requestPath:(NSString *)path
                           parameters:(NSDictionary * _Nullable)parameters
                              headers:(NSDictionary * _Nullable)headers
                               method:(NSString *)method
                               result:(void(^)(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error))result;

@end

NS_ASSUME_NONNULL_END
