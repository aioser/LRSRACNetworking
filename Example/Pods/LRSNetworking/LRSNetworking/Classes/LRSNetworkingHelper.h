//
//  LRSNetworkingHelper.h
//  LRSNetworking
//
//  Created by sama 刘 on 2021/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRSNetworkingHelper : NSObject
+ (NSString *)ptype;
+ (NSString *)pcode;
+ (NSString *)systemVersion;
+ (NSSet<NSString *> *)acceptableContentTypes;
+ (NSInteger)timeoutInterval;
@end

NS_ASSUME_NONNULL_END
