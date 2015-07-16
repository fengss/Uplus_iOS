//
//  MyProfileViewController.h
//  xmpp
//
//  Created by fengss on 15-4-8.
//  Copyright (c) 2015年 zjj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageview;
- (IBAction)upButtonImage:(id)sender;
- (IBAction)upGo:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userId;
@property (weak, nonatomic) IBOutlet UITextField *qq;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *resignTime;
@property (weak, nonatomic) IBOutlet UITextField *sex;
@end
