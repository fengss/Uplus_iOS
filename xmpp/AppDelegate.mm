//
//  AppDelegate.m
//  xmpp
//
//  Created by In8 on 14-4-21.
//  Copyright (c) 2014年 zjj. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"

BMKMapManager* _mapManager;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.myxmpp=[[MyXMPP alloc]init];
    self.manger=[AFHTTPRequestOperationManager manager];

    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"Y9TN5LVVz9abaEj8DQ2XMZgv" generalDelegate:self];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
   [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
//     [[MyXMPP sharedMyXMPP] disconnect];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
//   [[MyXMPP sharedMyXMPP] connect];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


@end