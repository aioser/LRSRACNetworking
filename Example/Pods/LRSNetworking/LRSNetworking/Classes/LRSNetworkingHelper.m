//
//  LRSNetworkingHelper.m
//  LRSNetworking
//
//  Created by sama 刘 on 2021/10/12.
//

#import "LRSNetworkingHelper.h"

@implementation LRSNetworkingHelper
+ (NSString *)ptype {
    return @"2";
}
+ (NSString *)pcode {
    return [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]];
}
+ (NSString *)systemVersion {
    return UIDevice.currentDevice.systemVersion ? : @"0";
}
+ (NSSet<NSString *> *)acceptableContentTypes {
    return [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
}
+ (NSInteger)timeoutInterval {
    return 20;
}
@end
