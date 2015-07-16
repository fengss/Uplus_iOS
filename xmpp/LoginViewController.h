//
//  LoginViewController.h
//  xmpp
//
//  Created by fengss on 15-4-8.
//  Copyright (c) 2015年 zjj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdverView.h"

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (strong, nonatomic) IBOutlet UIButton *MyLoginButton;
@property (strong, nonatomic) IBOutlet UIButton *MyRegistButton;
@property (strong, nonatomic) IBOutlet UIImageView *MyImageView;
@property (weak, nonatomic) IBOutlet AdverView *adverView;

@property(nonatomic,strong) id  target;
@property(nonatomic,assign) SEL action;

- (IBAction)Login:(UIButton *)sender;
- (IBAction)Register:(UIButton *)sender;
@end
