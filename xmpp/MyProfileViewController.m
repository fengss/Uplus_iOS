//
//  MyProfileViewController.m
//  xmpp
//
//  Created by fengss on 15-4-8.
//  Copyright (c) 2015年 zjj. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ProgressHUD.h"
#import "PersonModel.h"

@interface MyProfileViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSString *filePath;
    NSData *imageData;
    AFHTTPRequestOperationManager *manger;
}
@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //上传请求POST
    manger=[AFHTTPRequestOperationManager manager];
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [self createUI];
    
}

/**
 *  UI初始化
 */
-(void)createUI{
    NSDictionary *dic=@{
                        @"username":[[NSUserDefaults standardUserDefaults]objectForKey:kUserName]
                        };
    [manger GET:GETPERSONAL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        //获取到数据,并解析数据
        NSArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *data=[arr lastObject];
        
        PersonModel *model=[[PersonModel alloc]init];
        
        [model setValuesForKeysWithDictionary:data];
        
        //直接设置ui
        [self configUI:model];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    
    //设置代理
    self.userName.delegate=self;
    self.qq.delegate=self;
    self.userId.delegate=self;
    self.resignTime.delegate=self;
    self.email.delegate=self;
    self.sex.delegate=self;
    
    
    //创建rightBarItem
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"更新资料" style:UIBarButtonItemStyleDone target:self action:@selector(updateMyProfile:)];
    self.navigationItem.rightBarButtonItem=item;
}

#pragma mark 保存/更新信息
-(void)updateMyProfile:(UIButton*)btn{
    [self.view endEditing:YES];
    
    NSDictionary *dic=@{
                        @"safe":@"fss",
                        @"nickname":self.userName.text,
                        @"email":self.email.text,
                        @"sex":self.sex.text,
                        @"qq":self.qq.text,
                        @"addtime":self.resignTime.text,
                        @"username":self.userId.text
                        };
    
    [manger GET:UPDATEPERSONALALL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([str isEqual:@"OK"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"更新资料成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"更新资料失败\n可能根本无更改\n导致失败の^_^" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)configUI:(PersonModel*)model{
    self.userName.text=model.nickname;
    self.userId.text=model.username;
    self.sex.text=model.sex;
    self.email.text=model.email;
    self.qq.text=model.qq;
    self.resignTime.text=model.addtime;
    
    [self.avatorImageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GETPICTURE,model.avator]] placeholderImage:[UIImage imageNamed:@"Avator"]];
}



- (IBAction)upButtonImage:(id)sender {
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"打开相册" destructiveButtonTitle:@"打开照相机" otherButtonTitles:nil];
    [action showInView:self.view];
}

- (IBAction)upGo:(id)sender {
    
    
    NSDictionary *dic=@{
                        };
    
    
    //开始等待
    [self createProgress];
    
    
    [manger POST:UPLOADPIC parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(self.avatorImageview.image)
                                    name:@"uploadedfile"
                                fileName:@"avatar.png"
                                mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        //成功接收到数据再次发送个人中心头像路径
        
        NSDictionary *dic=@{
                            //安全认证
                            @"safe":@"fss",
                            @"username":[[NSUserDefaults standardUserDefaults]objectForKey:kUserName],
                            @"avator":str
                            };
        
        [manger GET:UPDATEPERSONAL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *rec=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            UIAlertView *alert;
            if ([rec isEqualToString:@"OK"]) {
                alert=[[UIAlertView alloc]initWithTitle:@"提  示" message:@"头像已经更新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                
            }
            else{
                alert=[[UIAlertView alloc]initWithTitle:@"提  示" message:@"头像更新失败,sorry" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            }
            [alert show];
            //移除等待
            [self removeProgress];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

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



#pragma mark action delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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
        self.avatorImageview.image=[self scaleFromImage:image toSize:CGSizeMake(300, 300)];
        
        
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
        
        
    }
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


#pragma mark textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==self.resignTime) {
        UIDatePicker *picker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 0, 240)];
        picker.locale=[NSLocale localeWithLocaleIdentifier:@"zh-Hans"];
        picker.datePickerMode=UIDatePickerModeDate;
        picker.timeZone=[NSTimeZone localTimeZone];
        picker.date=[NSDate dateWithTimeIntervalSinceNow:0];
        [picker addTarget:self action:@selector(datePickerPick:) forControlEvents:UIControlEventValueChanged];
        textField.inputView=picker;
    }
    else if (textField==self.sex){
        UIPickerView *picker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 0, 240)];
        picker.dataSource=self;
        picker.delegate=self;
        textField.inputView=picker;
    }
    return YES;
}

-(void)datePickerPick:(UIDatePicker*)picker{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=picker.date;
    self.resignTime.text=[formatter stringFromDate:date];
}

#pragma mark picker delegate / datasource
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row==0) {
        self.sex.text=@"男人";
    }
    else{
        self.sex.text=@"女人";
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row==0) {
        return @"男性";
    }
    else{
        return @"女性";
    }
}


@end
