//
//  ReplyCell.h
//  xmpp
//
//  Created by fengss on 15-4-17.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplyModel.h"

@interface ReplyCell : UITableViewCell
@property(nonatomic,strong) UILabel  * username;
@property(nonatomic,strong) UILabel  * content;
@property(nonatomic,strong) UIImageView  * iconImageView;
@property(nonatomic,strong) UILabel  * replytime;


-(void)configUI:(ReplyModel*)model;
@end
