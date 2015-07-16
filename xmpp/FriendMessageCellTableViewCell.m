//
//  FriendMessageCellTableViewCell.m
//  xmpp
//
//  Created by fengss on 15-4-12.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import "FriendMessageCellTableViewCell.h"


@implementation FriendMessageCellTableViewCell

-(void)setFmessage:(FriendMessageModel *)fmessage{
    _fmessage=fmessage;
    _username.text=fmessage.username;
    _content.text=fmessage.message;
    
    _time.text=[NSString stringWithFormat:@"发表于-%@",fmessage.addtime];
    
    //头像
    [_iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GETPICTURE,fmessage.avator]] placeholderImage:[UIImage imageNamed:@"icon"]];
    
    
    [self.myimageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICTURE,fmessage.image]] placeholderImage:[UIImage imageNamed:@"icon"]];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 70, 70)];
        _iconImageView.layer.cornerRadius=35.0f;
        _iconImageView.layer.masksToBounds=YES;
        _iconImageView.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:_iconImageView];
        
        
        _username=[[UILabel alloc]initWithFrame:CGRectMake(_iconImageView.frame.origin.x, _iconImageView.frame.origin.y+_iconImageView.frame.size.height+5, _iconImageView.frame.size.width, 20)];
        _username.font=[UIFont systemFontOfSize:15.0f];
        _username.numberOfLines=0;
        _username.text=@"用户名";
        _username.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_username];
        
        
        _title=[[UILabel alloc]initWithFrame:CGRectMake(_iconImageView.frame.origin.x+_iconImageView.frame.size.width+15, _iconImageView.frame.origin.y, 200, 0)];
        self.title.font=[UIFont systemFontOfSize:27.0f];
        [self.contentView addSubview:self.title];
        
        _content=[[UILabel alloc]initWithFrame:CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y+self.title.frame.size.height+5, 175, 30)];
        self.content.font=[UIFont systemFontOfSize:15.0f];
        self.content.contentMode=UIViewContentModeCenter;
        self.content.numberOfLines=0;
        self.content.text=@"内容";
        [self.contentView addSubview:self.content];

        
        
        _myimageView=[[UIImageView alloc]initWithFrame:CGRectMake(_content.frame.origin.x, _content.frame.origin.y+_content.frame.size.height, 200, 120)];
        _myimageView.layer.cornerRadius=4.0f;
        _myimageView.layer.masksToBounds=YES;
        [self.contentView addSubview:self.myimageView];
        
        
        _time=[[UILabel alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH-130, _myimageView.frame.origin.y+_myimageView.frame.size.height+15, 130, 20)];
        self.time.font=[UIFont systemFontOfSize:10.0f];
        self.tip.textColor=[UIColor grayColor];
        self.time.text=@"时间这是时间啊";
        [self.contentView addSubview:self.time];
        
        _tip=[[UILabel alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH-130, _time.frame.origin.y+_time.frame.size.height+5, 130, 20)];
        self.tip.font=[UIFont systemFontOfSize:10.0f];
        self.tip.textColor=[UIColor grayColor];
        self.tip.text=@"<--向左移出评论信息";
        [self.contentView addSubview:self.tip];

    }
    return self;
}


@end
