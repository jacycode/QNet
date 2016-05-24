//
//  QHttpSession.h
//  Session_Package
//
//  Created by 刘清 on 16/5/13.
//  Copyright © 2016年 LQ. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  *************  QHttpSession ******************
 *  *基于NSURLSession封装的发起Http协议网络请求的工具类*
 *  *支持Get和Post方式                             *
 *  *支持Json数据的解析                             *
 *  **********************************************
 */

/**
 *  下载完成回调block类型
 *
 *  @param httpRespone Http服务器回应
 *  @param responeObjc 下载到的数据
 *  @param error       下载失败的信息
 */
typedef void(^CallBack)(NSHTTPURLResponse *httpRespone, id responeObjc, NSError *error);

@interface QHttpSession : NSObject

/**
 *  Http--Get请求
 *
 *  @param urlString 网络请求的URL
 *  @param callback  完成的回调（成功和失败）
 */
+ (void)getHttpURL:(NSString *)urlString complete:(CallBack)callback;


/**
 *  Http-Post请求
 *
 *  @param urlString 网络请求的URL
 *  @param para      网络请求的参数
 *  @param callback  完成的回调（成功和失败）
 */
+ (void)postHttpURL:(NSString *)urlString parameters:(NSDictionary *)para complete:(CallBack)callback;

/**
 *  Http-Post 大文件
 *
 *  @param urlString 网络请求的URL
 *  @param para      网络请求的一般参数
 *  @param filename  大文件文件名
 *  @param mimetype  大文件文件类型
 *  @param filedata  大文件（二进制数据）
 *  @param callback  完成的回调（成功和失败）
 */
+ (void)postHttpURL:(NSString *)urlString parmaeters:(NSDictionary *)para fileName:(NSString *)filename data:(NSData *)filedata complete:(CallBack)callback;


@end







