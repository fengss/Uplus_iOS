//
//  MyFriendCell.m
//  xmpp
//
//  Created by fengss on 15-4-10.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import "MyFriendCell.h"
@implementation MyFriendCell

-(void)awakeFromNib{
    self.icoImageView.layer.masksToBounds=YES;
    self.icoImageView.layer.cornerRadius=20.0f;
}

-(void)setModel:(FriednModel *)model{
    _model=model;
   
    if (![model.avator isKindOfClass:[NSNull class]]) {
        if ([model.avator rangeOfString:@"_"].location!=NSNotFound) {
            [self.icoImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GETPICTURE,model.avator]] placeholderImage:[UIImage imageNamed:@"icon"]];
        }
        else{
            [self.icoImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GETPICTURERAND,model.avator]] placeholderImage:[UIImage imageNamed:@"icon"]];
        }
    }
    else{
        [self.icoImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GETPICTURERAND,model.avator]] placeholderImage:[UIImage imageNamed:@"icon"]];
    }
    
    if (model.name==nil) {
        self.username.text=model.username;
    }
    else{
        self.username.text=model.name;
    }
    
}

@end
