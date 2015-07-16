//
//  ProgressHUD.h
//  Kitchen
//
//  Created by fengss on 14-10-22.
//  Copyright (c) 2014年 fengss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressHUD : UIView

+ (void)showOnView:(UIView *)view;

+ (void)hideAfterSuccessOnView:(UIView *)view;

+ (void)hideAfterFailOnView:(UIView *)view;

+ (void)hideOnView:(UIView *)view;
//秀在回复框
+ (void)showOnReplyView:(UIView *)view;

@end
