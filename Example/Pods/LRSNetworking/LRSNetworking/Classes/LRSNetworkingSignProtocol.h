//
//  LRSNetworkingSignProtocol.h
//  LRSNetworking
//
//  Created by sama 刘 on 2021/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LRSNetworkingSignProtocol <NSObject>
- (NSString *)signParameters:(NSDictionary *)parameters forURL:(NSURL *)URL timestamp:(inout int64_t *)timestamp;
- (NSString *)signVersion;
@end

@protocol LRSNetworkingBlackBoxProviderProtocol <NSObject>
- (NSString *)blackBoxValue;
- (NSString *)blackBoxVersion;
@end

@protocol LRSNetworkingDecoderProtocol <NSObject>
- (NSDictionary *)decodeResponseObject:(NSDictionary *)reponseObject error:(NSError **)error;
@end

@protocol LRSNetworkingORMHandlerProtocol <NSObject>
- (id _Nullable)parasResponseObjectWithURL:(NSString *)URL method:(NSString *)method responseObject:(NSDictionary *)responseObject error:(NSError **)error;
@end

@protocol LRSNetworkingErrorCatchProtocol <NSObject>
- (void)catchErrorWithURL:(NSString *)URL method:(NSString *)method response:(NSURLResponse *)response responseObject:(NSDictionary *)responseObject error:(NSError *)error;
@end

@protocol LRSNetworkingCaptchaHandlerProtocol <NSObject>
- (BOOL)checkResponseObjectWithURL:(NSString *)URL method:(NSString *)method errorResponse:(NSDictionary *)responseObject;
- (void)startCaptchaTaskWithURL:(NSString *)URL method:(NSString *)method errorResponse:(NSDictionary *)responseObject result:(void(^)(NSDictionary *captcha, NSDictionary *extra, NSError *error))result;
@end
NS_ASSUME_NONNULL_END
