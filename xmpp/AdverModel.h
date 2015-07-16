//
//  AdverModel.h
//  xmpp
//
//  Created by fengss on 15-4-10.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdverModel : NSObject
/**
 *  广告标题
 */
@property(nonatomic,copy) NSString  * name;
/**
 *  广告图片
 */
@property(nonatomic,copy) NSString  * imageSrc;

-(instancetype)initWithName:(NSString*)name WithImageSrc:(NSString*)imageSrc;
@end
