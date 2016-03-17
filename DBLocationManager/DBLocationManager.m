//
//  DBLocationManager.m
//  DBLocationManager
//
//  Created by DengBin on 15/1/30.
//  Copyright (c) 2015年 dengbin. All rights reserved.
//

#import "DBLocationManager.h"
@import CoreLocation;
@import UIKit;

@interface DBLocationManager () <CLLocationManagerDelegate,BMKLocationServiceDelegate>

@property (strong, nonatomic) BMKLocationService *locService;

@end

@implementation DBLocationManager

+ (DBLocationManager *)sharedInstance {

    static DBLocationManager *locationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager = [[self alloc] init];
    });
    return locationManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    return self;
}

- (void)startUpdateLocation {
    if (![CLLocationManager locationServicesEnabled]) {
        if (self.errorBlockBlock) {
            self.errorBlockBlock();
        }
        return;
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        if (self.errorBlockBlock) {
            self.errorBlockBlock();
        }
    }
    else{
        
        CLLocationDistance distance = 100.0;
        [BMKLocationService setLocationDistanceFilter:distance];
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
        [_locService startUserLocationService];
    }
}

- (void)stopUpdateLocation {
    [_locService stopUserLocationService];
}



/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    CLLocation *location = userLocation.location;
    CLLocationCoordinate2D coordinate = location.coordinate;
    CLLocationDegrees latitude = coordinate.latitude;
    CLLocationDegrees longitude = coordinate.longitude;
    NSLog(@"latitude: %f, longitude: %f", latitude, longitude);
    _latitude = latitude;
    _longitude = longitude;
    [self stopUpdateLocation];
    if (self.completionBlock) {
        self.completionBlock(latitude,longitude);
    }
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}




@end
