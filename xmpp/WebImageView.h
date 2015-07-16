//
//  WebImageView.h
//  xmpp
//
//  Created by fengss on 15-4-12.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebImageView : UIImageView
+(instancetype)sharedWebImageView;
@property(nonatomic,copy) NSString* path;
-(void)setImageViewWithUrl:(NSString*)url;
@end
