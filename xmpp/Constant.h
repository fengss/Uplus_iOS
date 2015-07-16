//
//  Constant.h
//  xmpp
//
//  Created by In8 on 14-4-23.
//  Copyright (c) 2014年 zjj. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserName    @"userName"
#define kPassword    @"password"
#define kServerHost  @"www.coderss.cn"
#define kDomain      @"in"
#define kNickName    @"nickName"
#define kfix         @"@www.coderss.cn"

#pragma mark 服务器的网址
//朋友圈信息
#define FRIENDMESSAGE @"http://uplus.coderss.cn/index.php?m=FriendMessage&a=getMessageIos"

#define PICTURE @"http://uplus.coderss.cn/upload/"
#define GETPICTURE @"http://uplus.coderss.cn/Upload/%@"

//获得系统随机的头像
#define GETPICTURERAND @"http://uplus.coderss.cn/uploadfile/upfiles/%@"

//上传图片
#define UPLOADPIC @"http://uplus.coderss.cn/index.php?m=UploadImage&a=Upload"

//更新个人头像
#define UPDATEPERSONAL @"http://uplus.coderss.cn/index.php?m=User&a=UpUserIos"

//更新个人全部资料
#define UPDATEPERSONALALL @"http://uplus.coderss.cn/index.php?m=User&a=UpdateUserIos"

//获得单个人数据
#define GETPERSONAL @"http://uplus.coderss.cn/index.php?m=User&a=getUserIos&safe=fss"

//获取好友资料
#define GETFRIEND @"http://uplus.coderss.cn/index.php?m=Friend&a=getFriendByName"

//获取好友信息,以数组的形式带进去,降低服务器的请求次数和资源
#define GETFRIEND_ARRAY @"http://uplus.coderss.cn/index.php?m=NearChat&a=getUser"



#define UISCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height



