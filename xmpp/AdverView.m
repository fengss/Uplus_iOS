//
//  AdverView.m
//  xmpp
//
//  Created by fengss on 15-4-10.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import "AdverView.h"
#import "AdverModel.h"
@implementation AdverView

-(void)setArrayData:(NSMutableArray *)arrayData{
    _arrayData=arrayData;

    self.scrollView.contentSize=CGSizeMake(288*[arrayData count], 180);
    self.scrollView.pagingEnabled=YES;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.pageControl.numberOfPages=[arrayData count];
    
    for (int i=0; i< [arrayData count]; i++) {
        AdverModel *model=arrayData[i];
        CGFloat imageViewX=i*288;
        CGFloat imageViewY=0;
        CGFloat imageWidth=288;
        CGFloat imageHeight=180;
        
        self.pageControl.currentPage=i;
        
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"demo-avatar-jobs"]];
        imageView.frame=CGRectMake(imageViewX, imageViewY, imageWidth, imageHeight);

        [self.scrollView addSubview:imageView];
    }
    

    
    NSLog(@"%@",self.scrollView);
    
}



@end
