//
//  QNetMonitor.h
//  
//
//  Created by 刘清 on 16/5/31.
//  Copyright © 2016年 LQ. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 ******************
 *   网络状态监测类　*
 *    （清哥出品）  *
 ******************
 */

/**
 *  网络状态
 */
typedef NS_ENUM(NSInteger, NetStatus) {
    /**
     *  未知
     */
    QNetMonitorStatus_unkown       = 0,
    /**
     *  无网
     */
    QNetMonitorStatus_noNet        = 1,
    /**
     *  WiFi
     */
    QNetMonitorStatus_Wifi         = 2,
    /**
     *  G网（2G）
     */
    QNetMonitorStatus_GPRS         = 3,
    /**
     *  E网 (2.75G)
     */
    QNetMonitorStatus_Edge         = 4,
    /**
     *  3G网
     */
    QNetMonitorStatus_WCDMA        = 5,
    /**
     *  3.5G网
     */
    QNetMonitorStatus_HSDPA        = 6,
    /**
     *  3.5G网
     */
    QNetMonitorStatus_HSUPA        = 7,
    /**
     *  2G网
     */
    QNetMonitorStatus_CDMA1x       = 8,
    /**
     *  3G
     */
    QNetMonitorStatus_CDMAEVDORev0 = 9,
    /**
     *  3G
     */
    QNetMonitorStatus_CDMAEVDORevA = 10,
    /**
     *  3G
     */
    QNetMonitorStatus_CDMAEVDORevB = 11,
    /**
     *  3G
     */
    QNetMonitorStatus_HRPD         = 12,
    /**
     *  4G
     */
    QNetMonitorStatus_LTE          = 13,
};

/**
 *  网络状态改变回到
 *
 *  @param status 网络状态
 */
typedef void(^QNetMonitorStatus)(NetStatus status);

@interface QNetMonitor : NSObject

/**
*  开始监测网络状态
*
*  @param callback 网络状态改变回调Block
*/
+ (void)startMonitorWithStatus:(QNetMonitorStatus)callback;

/**
 *  停止监测网络状态
 */
+ (void)stopMonitor;


@end
