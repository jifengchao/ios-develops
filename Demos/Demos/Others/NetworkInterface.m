//
//  NetworkInterface.m
//  Demos
//
//  Created by hyl on 2022/8/22.
//

#import "NetworkInterface.h"

@implementation NetworkInterface

+ (AFHTTPSessionManager *)httpSessionManager
{
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    return [[self class] httpSessionManager:headerDic];
}

+ (AFHTTPSessionManager *)httpSessionManager:(NSDictionary *)headerDic
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // http请求
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        
        // 设置 http header
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    });
    // headerDic
    NSArray *allKeys = headerDic.allKeys;
    for (NSString *key in allKeys) {
        id value = headerDic[key];
        if (value) {
            [manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
    return manager;
}

/**
 *  post请求体
 *
 *  @param params    参数字典
 *  @param methodURL 方法地址
 *  @param block     回调
 */
+ (void)startPostRequestWithParams:(id)params
                            method:(NSString *)methodURL
                             block:(requestDidFinished)block
{
    [[[self class] httpSessionManager] POST:methodURL parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"-----------------------------------");
        NSLog(@"接口地址：%@\n请求参数：\n%@\n - dictionry：\n%@", methodURL, params, responseObject);
        NSLog(@"-----------------------------------");
        
        if (block) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil, error);
        }
    }];
}

/**
 *  get请求体
 *
 *  @param methodURL 方法地址
 *  @param block     回调
 */
+ (void)startGetRequestWithParams:(id)params
                           method:(NSString *)methodURL
                            block:(requestDidFinished)block
{
    [[[self class] httpSessionManager] GET:methodURL parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"-----------------------------------");
        NSLog(@"接口地址：%@\n请求参数：\n%@\n - dictionry：\n%@", methodURL, params, responseObject);
        NSLog(@"-----------------------------------");
        
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil, error);
        }
    }];
}

@end
