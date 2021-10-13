//
//  LRSRACNetworking.m
//  LRSRACNetworking
//
//  Created by sama 刘 on 2021/10/13.
//

#import "LRSRACNetworking.h"

@implementation LRSNetworkingClient(RACSupport)
- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters headers:(NSDictionary * _Nullable)headers {
    return [self rac_requestPath:path parameters:parameters headers:headers method:@"GET"];
}
- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters headers:(NSDictionary * _Nullable)headers {
    return [self rac_requestPath:path parameters:parameters headers:headers method:@"POST"];
}

- (RACSignal *)rac_requestPath:(NSString *)path parameters:(id)parameters headers:(NSDictionary * _Nullable)headers method:(NSString *)method {
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        NSURLSessionTask *task = [self requestPath:path parameters:parameters headers:nil method:method result:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

@end
