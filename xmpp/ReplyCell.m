//
//  ReplyCell.m
//  xmpp
//
//  Created by fengss on 15-4-17.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import "ReplyCell.h"

@implementation ReplyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}


-(void)createUI{
    self.username=[[UILabel alloc]initWithFrame:CGRectMake(15, 15,UISCREEN_WIDTH/2/3*2, 20)];
    self.username.font=[UIFont systemFontOfSize:19.0f];
    [self.contentView addSubview:self.username];
    
    self.content=[[UILabel alloc]initWithFrame:CGRectMake(self.username.frame.origin.x,self.username.frame.size.height+self.username.frame.origin.y+15, self.username.frame.size.width, 50)];
    self.content.font=[UIFont systemFontOfSize:13.0f];
    self.content.numberOfLines=3;
    [self.contentView addSubview:self.content];
    
    self.iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.username.frame.origin.x+self.username.frame.size.width+15, self.username.frame.origin.y, UISCREEN_WIDTH/2/3,UISCREEN_WIDTH/2/3)];
    self.iconImageView.layer.cornerRadius=UISCREEN_WIDTH/2/3/2;
    self.iconImageView.layer.masksToBounds=YES;
    self.iconImageView.image=[UIImage imageNamed:@"icon"];
    [self.contentView addSubview:self.iconImageView];
    
    self.replytime=[[UILabel alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH/2-100,self.iconImageView.frame.size.height+self.iconImageView.frame.origin.y+35, 130, 11)];
    self.replytime.font=[UIFont systemFontOfSize:10.0f];
    self.replytime.numberOfLines=1;
    [self.contentView addSubview:self.replytime];
}


-(void)configUI:(ReplyModel *)model{
    self.username.text=model.formusername;
    self.content.text=model.replymessage;
    self.replytime.text=[NSString stringWithFormat:@"留言时间:%@",model.addtime];
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GETPICTURE,model.avator]] placeholderImage:[UIImage imageNamed:@"icon"]];
}
@end
