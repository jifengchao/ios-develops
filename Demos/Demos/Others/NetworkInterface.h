//
//  NetworkInterface.h
//  Demos
//
//  Created by hyl on 2022/8/22.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void (^requestDidFinished)(NSDictionary *response, NSError *error);

NS_ASSUME_NONNULL_BEGIN

@interface NetworkInterface : NSObject

/**
 *  post请求体
 *
 *  @param params    参数字典
 *  @param methodURL 方法地址
 *  @param block     回调
 */
+ (void)startPostRequestWithParams:(id)params
                            method:(NSString *)methodURL
                             block:(requestDidFinished)block;

/**
 *  get请求体
 *
 *  @param methodURL 方法地址
 *  @param block     回调
 */
+ (void)startGetRequestWithParams:(id)params
                           method:(NSString *)methodURL
                            block:(requestDidFinished)block;

@end

NS_ASSUME_NONNULL_END
