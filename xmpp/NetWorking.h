//
//  NetWorking.h
//  xmpp
//
//  Created by fengss on 15-4-12.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorking : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property(nonatomic,assign) NSURLRequestCachePolicy  * policy;
@property(nonatomic,assign) NSTimeInterval  * timer;
@property(nonatomic,strong) NSError  * error;
@property(nonatomic,strong) NSURLRequest  * request;
@property(nonatomic,strong) NSURLResponse  * response;
@property(nonatomic,strong) NSMutableData  * data;
@property(nonatomic,copy) void (^myhandler)(NSURLResponse * response, NSData * data, NSError * error);

+(instancetype)sharedNetWorking;

-(void)sendAsynchronousRequestWithURLString:(NSString *)urlStr cachePolicy:(NSURLRequestCachePolicy)policy timeOutInterval:(NSTimeInterval)interval completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))handler;

-(void)sendAsynchronousRequestWithURLString:(NSString *)urlStr completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))handler;
@end
