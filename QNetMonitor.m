//
//  QNetMonitor.m
//
//
//  Created by 刘清 on 16/5/31.
//  Copyright © 2016年 LQ. All rights reserved.
//

#import "QNetMonitor.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation QNetMonitor

static SCNetworkReachabilityRef reachability = nil;

static QNetMonitorStatus callme;

static void function_C(SCNetworkReachabilityRef __unused target, SCNetworkReachabilityFlags flags, void *info)
{
    
        BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
        BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
        BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
        BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
        BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
        
        NetStatus status = QNetMonitorStatus_unkown;
        if (isNetworkReachable == NO) {
            status = QNetMonitorStatus_noNet;
        }else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
            
            CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc]init];
            NSString *currentStatus  = networkStatus.currentRadioAccessTechnology;
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]){
                status = QNetMonitorStatus_GPRS;
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]){
                status = QNetMonitorStatus_Edge;
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                status = QNetMonitorStatus_WCDMA;
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                status = QNetMonitorStatus_HSDPA;
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                status = QNetMonitorStatus_HSUPA;
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                status = QNetMonitorStatus_CDMA1x;
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                status = QNetMonitorStatus_CDMAEVDORev0;
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                status = QNetMonitorStatus_CDMAEVDORevA;
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                status = QNetMonitorStatus_CDMAEVDORevB;
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                status = QNetMonitorStatus_HRPD;
            }
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                status = QNetMonitorStatus_LTE;
            }
            
        }else {
            status = QNetMonitorStatus_Wifi;
        }
    

    callme(status);
    
}

+ (void)startMonitorWithStatus:(QNetMonitorStatus)callback
{
    callme = callback;
    reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [@"0.0.0.0" UTF8String]);
    SCNetworkReachabilitySetCallback(reachability, function_C, NULL);
    SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
}

+ (void)stopMonitor
{
    SCNetworkReachabilityUnscheduleFromRunLoop(reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    reachability = nil;
    callme = nil;
}

@end
