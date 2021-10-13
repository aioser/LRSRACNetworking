//
//  LRSRACNetworking.h
//  LRSRACNetworking
//
//  Created by sama 刘 on 2021/10/13.
//

#import <Foundation/Foundation.h>
#import <LRSNetworking/LRSNetworkingClient.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRSNetworkingClient(RACSupport)
- (RACSignal *)rac_GET:(NSString *)path parameters:(NSDictionary *)parameters headers:(NSDictionary * _Nullable)headers;
- (RACSignal *)rac_POST:(NSString *)path parameters:(NSDictionary *)parameters headers:(NSDictionary * _Nullable)headers;
@end

NS_ASSUME_NONNULL_END
