//
//  LRSNetworking.m
//  LRSNetworking
//
//  Created by sama 刘 on 2021/10/12.
//

#import "LRSNetworking.h"
#import "LRSNetworkingClient.h"
#import "LRSNetworkingHelper.h"

@implementation LRSNetworking
/// weak reference for all instances
static NSMapTable *_globalInstances;
static dispatch_semaphore_t _globalInstancesLock;

static void _LRSNetworkingClientInitGlobal() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _globalInstancesLock = dispatch_semaphore_create(1);
        _globalInstances = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory capacity:0];
    });
}

static LRSNetworkingClient *_LRSNetworkingClientGetGlobal(NSString *path) {
    if (path.length == 0) return nil;
    _LRSNetworkingClientInitGlobal();
    dispatch_semaphore_wait(_globalInstancesLock, DISPATCH_TIME_FOREVER);
    id cache = [_globalInstances objectForKey:path];
    dispatch_semaphore_signal(_globalInstancesLock);
    return cache;
}

static void _LRSNetworkingClientSetGlobal(LRSNetworkingClient *cache) {
    if (cache.path.length == 0) return;
    _LRSNetworkingClientInitGlobal();
    dispatch_semaphore_wait(_globalInstancesLock, DISPATCH_TIME_FOREVER);
    [_globalInstances setObject:cache forKey:cache.path];
    dispatch_semaphore_signal(_globalInstancesLock);
}

+ (LRSNetworkingClient *)clientWithPath:(NSString *)path {
    return [self clientWithPath:path defaultHeaderValues:nil];
}

+ (LRSNetworkingClient *)clientWithPath:(NSString *)path defaultHeaderValues:(NSDictionary<NSString *, NSString *> * _Nullable)defaultHeaderValues {
    return [self clientWithPath:path defaultHeaderValues:defaultHeaderValues requestSerializerBuilder:nil responseSerializerBuilder:nil];
}

+ (LRSNetworkingClient *)clientWithPath:(NSString *)path defaultHeaderValues:(NSDictionary<NSString *,NSString *> * _Nullable)defaultHeaderValues requestSerializerBuilder:(void (^ _Nullable)(AFHTTPRequestSerializer * ))requestSerializerBuilder responseSerializerBuilder:(void (^ _Nullable)(AFHTTPResponseSerializer * ))responseSerializerBuilder {
    LRSNetworkingClient *client = _LRSNetworkingClientGetGlobal(path);
    if (client) {

    } else {
        client = [[LRSNetworkingClient alloc] initWithPath:path];
        client.session.requestSerializer.timeoutInterval = [LRSNetworkingHelper timeoutInterval];
        [client.session.requestSerializer setValue:[LRSNetworkingHelper ptype] forHTTPHeaderField:@"ptype"];
        [client.session.requestSerializer setValue:[LRSNetworkingHelper pcode] forHTTPHeaderField:@"pcode"];
        [client.session.requestSerializer setValue:[LRSNetworkingHelper systemVersion] forHTTPHeaderField:@"systemVersion"];
        client.session.responseSerializer.acceptableContentTypes = [LRSNetworkingHelper acceptableContentTypes];
        _LRSNetworkingClientSetGlobal(client);
    }
    if (defaultHeaderValues) {
        for (NSString *key in defaultHeaderValues) {
            [client.session.requestSerializer setValue:defaultHeaderValues[key] forHTTPHeaderField:key];
        }
    }
    if (requestSerializerBuilder) {
        requestSerializerBuilder(client.session.requestSerializer);
    }
    if (responseSerializerBuilder) {
        responseSerializerBuilder(client.session.responseSerializer);
    }
    return client;
}


@end
