//
//  UpMyFriendMessageViewController.m
//  xmpp
//
//  Created by fengss on 15-4-16.
//  Copyright (c) 2015年 xmpp. All rights reserved.
//

#import "UpMyFriendMessageViewController.h"
#import "AFNetworking.h"
#import "ProgressHUD.h"

@interface UpMyFriendMessageViewController ()<UIActionSheetDelegate,UITextViewDelegate,UIImagePickerControllerDelegate>
{
    //图片路径
    NSString* filePath;
    //图片区域
    UIImageView *imageView;
    //文件的data
    NSData *imageData;
    //发表的心情
    UITextView *content;
}

@end

@implementation UpMyFriendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}


/**
 *  创建等待
 */
-(void)createProgress{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-69)];
    view.backgroundColor=[UIColor whiteColor];
    view.tag=900;
    [self.view endEditing:YES];
    [ProgressHUD showOnView:view];
    [self.view addSubview:view];
}

/**
 *  移除等待
 */
-(void)removeProgress{
    UIView *view=[self.view viewWithTag:900];
    [ProgressHUD hideOnView:view];
    [view removeFromSuperview];
}


/**
 *  等比例缩放
 *
 *  @param targetSize 大小
 *
 *  @return
 */
// 改变图像的尺寸，方便上传服务器
- (UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(void)createUI{
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-69)];
    
    content=[[UITextView alloc]initWithFrame:CGRectMake(15, 30, UISCREEN_WIDTH-30, 100)];
    content.font=[UIFont systemFontOfSize:18.0f];
    content.layer.borderColor=[UIColor blueColor].CGColor;
    content.layer.borderWidth=1.0f;
    content.layer.cornerRadius=7.0f;
    content.layer.shadowColor=[UIColor blueColor].CGColor;
    content.layer.shadowOffset=CGSizeMake(1, 1);
    content.layer.shadowRadius=20.0f;
    content.layer.shadowOpacity=YES;
    content.textColor=[UIColor blueColor];
    content.tintColor=[UIColor whiteColor];
    content.delegate=self;
    
    //点击添加图片的按钮
    UIButton *add=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    add.frame=CGRectMake(15, content.frame.origin.y+content.frame.size.height+25, 35, 35);
    UIImage *jia=[UIImage imageNamed:@"jia.gif"];
    UIImage *toJia=[jia imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [add setImage:toJia forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:add];
    
    //图片备选区域
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(add.frame.origin.x+add.frame.size.width+25, add.frame.origin.y, add.frame.size.width*2, add.frame.size.height*2)];
    imageView.layer.cornerRadius=7.0f;
    imageView.layer.masksToBounds=YES;
    imageView.image=[UIImage imageNamed:@"icon"];
    [self.view addSubview:imageView];

    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(uploadImage)];
    self.navigationItem.rightBarButtonItem=item;
    
    [view addSubview:content];
    
    [self.view addSubview:view];
}


/**
 *  添加图片
 */
-(void)addPhoto:(UIButton*)btn{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"打开照相机" otherButtonTitles:@"打开相册",nil];
    [action showInView:self.view];
}

#pragma mark action delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",buttonIndex);
    
    if (buttonIndex==0) {
        //打开照相机
        UIImagePickerControllerSourceType imageType=UIImagePickerControllerSourceTypeCamera;
        //判断相机是否可活动
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //实例化
            UIImagePickerController *pickerController=[[UIImagePickerController alloc]init];
            pickerController.delegate=self;
            //被拍照后可编辑
            pickerController.allowsEditing=YES;
            pickerController.sourceType=imageType;
            [self presentViewController:pickerController animated:YES completion:nil];
        }
    }
    else if (buttonIndex==1){
        //打开相册
        UIImagePickerController *pickerController=[[UIImagePickerController alloc]init];
        pickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.delegate=self;
        [self presentViewController:pickerController animated:YES completion:nil];
    }
    else if (buttonIndex==2){
        [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
    }
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        imageView.image=[self scaleFromImage:image toSize:CGSizeMake(300, 400)];

        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //放入变量NSData中
        imageData=data;
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        imageView.image = image;
        
        
    }
}


#pragma mark 上传图片
- ( void )uploadImage{
    
    //上传请求POST
    AFHTTPRequestOperationManager *manger=[AFHTTPRequestOperationManager manager];
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSDictionary *dic=@{
                        };
    

    //开始等待
    [self createProgress];
    
    
    [manger POST:@"http://uplus.coderss.cn/index.php?m=UploadImage&a=Upload" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(imageView.image)
                                    name:@"uploadedfile"
                                fileName:@"avatar.png"
                                mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        //成功接收到数据再次发送消息到朋友圈
        
        NSDictionary *dic=@{
                            //安全认证
                            @"safe":@"fss",
                            @"message":content.text,
                            @"username":[[NSUserDefaults standardUserDefaults]objectForKey:kUserName],
                            @"image":str
                            };
        
        [manger GET:@"http://uplus.coderss.cn/index.php?m=FriendMessage&a=toMessageIos" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *rec=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            UIAlertView *alert;
            if ([rec isEqualToString:@"OK"]) {
               alert=[[UIAlertView alloc]initWithTitle:@"提  示" message:@"心情已经发表成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                
            }
            else{
                alert=[[UIAlertView alloc]initWithTitle:@"提  示" message:@"心情发表失败,sorry" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            }
            [alert show];
            //移除等待
            [self removeProgress];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma mark textView delegate
-(void)textViewDidEndEditing:(UITextView *)textView{
    [textView endEditing:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
