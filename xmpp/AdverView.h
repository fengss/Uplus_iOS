//
//  AdverView.h
//  xmpp
//
//  Created by fengss on 15-4-10.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdverView : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong) NSMutableArray  * arrayData;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
