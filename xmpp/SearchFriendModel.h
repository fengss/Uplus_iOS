//
//  SearchFriendModel.h
//  xmpp
//
//  Created by fengss on 15-4-18.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchFriendModel : NSObject
//[{"username":"jiayou","plainPassword":null,"encryptedPassword":"f14c244ef9fef56096d6eafe5a7a7ae99ea187a6423274b9","name":null,"email":null,"creationDate":"001429348231873","modificationDate":"001429348231873"},
@property(nonatomic,copy) NSString  * username;
@property(nonatomic,copy) NSString  * plainPassword;
@property(nonatomic,copy) NSString  * encryptedPassword;
@property(nonatomic,copy) NSString  * name;
@property(nonatomic,copy) NSString  * email;
@property(nonatomic,copy) NSString  * creationDate;
@property(nonatomic,copy) NSString  * modificationDate;
@end
