//
//  QHttpSession.m
//  Session_Package
//
//  Created by 刘清 on 16/5/13.
//  Copyright © 2016年 LQ. All rights reserved.
//

#import "QHttpSession.h"


@implementation QHttpSession

//Http-Get请求方法的实现
+ (void)getHttpURL:(NSString *)urlString complete:(CallBack)callback
{
    
    //生成NSURL对象
    NSURL *url = [NSURL URLWithString:urlString];
    //生成NSURLRequest对象
    NSURLRequest *requst = [NSURLRequest requestWithURL:url];
    //使用NSURLSession进行网络下载
    [self createSessionWithRequest:requst complete:callback];
}

//Http-Post请求方法的实现
+ (void)postHttpURL:(NSString *)urlString parameters:(NSDictionary *)para complete:(CallBack)callback
{
    //NSString-->NSURL-->NSMutableURLReqeust
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //Request  Post相关设置
    [request setHTTPMethod:@"POST"];
    //字符串形式的参数
    NSMutableString *paraString = [NSMutableString string];
    for (NSString *key in para) {
        //拼key
        [paraString appendString:key];
        //拼value
        [paraString appendFormat:@"=%@&", para[key]];
    }
    //二进制形式的参数
    NSData *paraData = [paraString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:paraData];
    //Session
    [self createSessionWithRequest:request complete:callback];
}

//Http-Post大文件实现
+ (void)postHttpURL:(NSString *)urlString parmaeters:(NSDictionary *)para fileName:(NSString *)filename data:(NSData *)filedata complete:(CallBack)callback
{
    //Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    //用于拼接的bodyData
    NSMutableData *bodyData = [NSMutableData data];
    
    //根据一般参数的有误，来添加一般参数
    if (para) {
        //字符串形式的参数
        NSMutableString *paraString = [NSMutableString string];
        for (NSString *key in para) {
            //拼key
            [paraString appendString:key];
            //拼value
            [paraString appendFormat:@"=%@&", para[key]];
        }
        //二进制形式的参数
        NSData *paraData = [paraString dataUsingEncoding:NSUTF8StringEncoding];
        //拼接一般参数
        [bodyData appendData:paraData];
    }
    
    //上传大文件  模拟表单上传
    //1、开始部分
    NSString *boundary = @"fileBoundary";//文件边界
    NSMutableString *startStr = [NSMutableString string];//开始部分字符串
    [startStr appendFormat:@"--%@\r\n", boundary];
    [startStr appendFormat:@"Content-Disposition:form-data;name=\"file\";filename=\"%@\"\r\n", filename];
    [startStr appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
    NSData *startData = [startStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //2、数据部分（图片、音频。。。）
    NSData *contentData = filedata;
    
    //3、结束部分
    NSMutableString *endStr = [NSMutableString string];
    [endStr appendFormat:@"\r\n--%@--\r\n", boundary];
    NSData *endData = [endStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //拼接 三个部分
    [bodyData appendData:startData];
    [bodyData appendData:contentData];
    [bodyData appendData:endData];
    
    //放入Http-body
    [request setHTTPBody:bodyData];
    
    //设置Content—Type
    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    //设置数据长度Content-Length
    //[request setValue:[NSString stringWithFormat:@"%ld", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
    
    //Session
    [self createSessionWithRequest:request complete:callback];
    
}

//封装独立的创建Session方法
+ (void)createSessionWithRequest:(NSURLRequest *)request complete:(CallBack)callback
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //回调主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            //判断网络请求有没有成功
            if (error) {
                //父类-->子类，可以强转；反之，一般不这样操作。不同类型，一般不强转。
                callback((NSHTTPURLResponse *)response, nil, error);
            }else{
                
                //如果返回的数据是json数据，返回解析后的json类型；
                //如果返回得数据不是json数据，返回NSData类型。
                //if ([NSJSONSerialization isValidJSONObject:data]) {
                //转成json数据
                //NSJSONReadingAllowFragments 可调整为最外层非数组或字典
                id jsonObjc = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                callback((NSHTTPURLResponse *)response, jsonObjc, nil);
                //            }else{
                //                callback((NSHTTPURLResponse *)response, data, nil);
                //            }
                
            }
            
            
            
        });

    }];
    [task resume];
}

@end













