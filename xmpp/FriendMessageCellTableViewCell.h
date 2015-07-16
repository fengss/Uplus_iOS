//
//  FriendMessageCellTableViewCell.h
//  xmpp
//
//  Created by fengss on 15-4-12.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendMessageModel.h"
#import "WebImageView.h"

@interface FriendMessageCellTableViewCell : UITableViewCell
@property(nonatomic,strong) FriendMessageModel  * fmessage;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *content;
@property(nonatomic,strong) UILabel  * time;
@property (strong, nonatomic) UIImageView *myimageView;
@property(strong,nonatomic) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel * username;
@property(nonatomic,strong) UILabel *tip;
@end
