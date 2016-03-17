//
//  DBLocationManager.h
//  DBLocationManager
//
//  Created by DengBin on 15/1/30.
//  Copyright (c) 2015年 dengbin. All rights reserved.
//

//  适用于百度地图

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^CompletionBlock)(CGFloat latitude,CGFloat longitude);
typedef void(^ErrorBlock)();

@interface DBLocationManager : NSObject

+ (DBLocationManager *)sharedInstance;

- (void)startUpdateLocation;

- (void)stopUpdateLocation;

@property (assign, nonatomic) CGFloat latitude;       // 维度
@property (assign, nonatomic) CGFloat longitude;      // 经度

@property (copy, nonatomic) CompletionBlock completionBlock;
@property (copy, nonatomic) ErrorBlock errorBlockBlock;



@end
