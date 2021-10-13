//
//  LRSNetworking.h
//  LRSNetworking
//
//  Created by sama 刘 on 2021/10/12.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "LRSNetworkingClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface LRSNetworking : NSObject

+ (LRSNetworkingClient *)clientWithPath:(NSString *)path;

+ (LRSNetworkingClient *)clientWithPath:(NSString *)path
                    defaultHeaderValues:(NSDictionary<NSString *, NSString *> * _Nullable)defaultHeaderValues;

+ (LRSNetworkingClient *)clientWithPath:(NSString *)path
                    defaultHeaderValues:(NSDictionary<NSString *, NSString *> * _Nullable)defaultHeaderValues
               requestSerializerBuilder:(void(^ _Nullable)(AFHTTPRequestSerializer *))requestSerializerBuilder
              responseSerializerBuilder:(void(^ _Nullable)(AFHTTPResponseSerializer *))responseSerializerBuilder;


@end

NS_ASSUME_NONNULL_END
