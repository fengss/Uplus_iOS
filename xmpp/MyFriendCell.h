//
//  MyFriendCell.h
//  xmpp
//
//  Created by fengss on 15-4-10.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriednModel.h"


@interface MyFriendCell : UITableViewCell
@property(nonatomic,strong) FriednModel  * model;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *icoImageView;
@end
