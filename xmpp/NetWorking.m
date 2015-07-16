//
//  NetWorking.m
//  xmpp
//
//  Created by fengss on 15-4-12.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import "NetWorking.h"

@implementation NetWorking
+(instancetype)sharedNetWorking{
    static NetWorking * net=nil;
    if (net==nil) {
        net=[[NetWorking alloc]init];
    }
    return net;
}

-(void)sendAsynchronousRequestWithURLString:(NSString *)urlStr cachePolicy:(NSURLRequestCachePolicy)policy timeOutInterval:(NSTimeInterval)interval completionHandler:(void (^)(NSURLResponse * response, NSData * data, NSError * error))handler{
    self.myhandler=handler;
    self.data=[[NSMutableData alloc]init];
    NSURL *url=[NSURL URLWithString:urlStr];
    self.request=[[NSURLRequest alloc]initWithURL:url cachePolicy:policy timeoutInterval:interval];
    
    self.response=nil;
    
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:NO];
    
    [connection start];
}

-(void)sendAsynchronousRequestWithURLString:(NSString *)urlStr completionHandler:(void (^)(NSURLResponse * response, NSData * data, NSError * error))handler{
    [self sendAsynchronousRequestWithURLString:urlStr cachePolicy:NSURLRequestReloadIgnoringCacheData timeOutInterval:30 completionHandler:handler];
}



-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //接受失败
    self.error=error;
    self.myhandler(self.response,self.data,self.error);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.data appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.response=response;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.myhandler(self.response,self.data,self.error);
}

@end
