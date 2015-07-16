//
//  AdverModel.m
//  xmpp
//
//  Created by fengss on 15-4-10.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import "AdverModel.h"

@implementation AdverModel
-(instancetype)initWithName:(NSString *)name WithImageSrc:(NSString *)imageSrc{
    if (self==[super init]) {
        _name=name;
        _imageSrc=imageSrc;
    }
    return self;
}
@end
