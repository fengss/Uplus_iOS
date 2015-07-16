//
//  WebImageView.m
//  xmpp
//
//  Created by fengss on 15-4-12.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import "WebImageView.h"
#import "NetWorking.h"
@implementation WebImageView

+(instancetype)sharedWebImageView{
    static WebImageView * webimage=nil;
    if (webimage==nil) {
        webimage=[[WebImageView alloc]init];
    }
    return webimage;
}

-(NSString *)path{
    if (_path==nil) {
        NSString *home=NSHomeDirectory();
        _path=[NSString stringWithFormat:@"%@/Documents/",home];
    }
    return _path;
}

-(void)setImageViewWithUrl:(NSString *)url{
    NSString *tmpPath=[NSString stringWithFormat:@"%@%@",self.path,url];
    NSLog(@"%@",tmpPath);
    NSFileManager *fm=[NSFileManager defaultManager];
    if ([fm fileExistsAtPath:tmpPath]) {
        NSData *data=[NSData dataWithContentsOfFile:tmpPath];
        self.image=[[UIImage alloc] initWithData:data];
        NSLog(@"从本地加载图片");
    }
    else{
        [[NetWorking sharedNetWorking]sendAsynchronousRequestWithURLString:[NSString stringWithFormat:@"http://uplus.coderss.cn/upload/%@",url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeOutInterval:30 completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
            if (error!=nil) {
                NSLog(@"webImageView下载出错--->%@",error);
            }
            else{
                NSLog(@"从网络加载图片成功");
                BOOL rec=[data writeToFile:tmpPath atomically:YES];
                if (rec) {
                    NSLog(@"写入本地成功");
                }
                else{
                    NSLog(@"写入失败");
                }
                UIImage *image=[[UIImage alloc]initWithData:data];
                self.image=image;
                NSLog(@"%@",NSStringFromCGRect(self.frame));
            }
        }];
    }
    
}
@end
