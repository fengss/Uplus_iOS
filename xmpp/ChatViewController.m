//
//  ViewController.m
//  ChatMessageTableViewController
//
//  Created by Yongchao on 21/11/13.
//  Copyright (c) 2013 Yongchao. All rights reserved.
//

#import "ChatViewController.h"
#import "MyXMPP.h"
#import "AppDelegate.h"
#import "DataModel.h"
#import "ChatMessageModel.h"
#import "AFNetworking.h"

@interface ChatViewController () <JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    AFHTTPRequestOperationManager *manger;
}


@property (nonatomic,strong) UIImage *willSendImage;

@property(nonatomic,strong) MyXMPP  * xmpp;
@end

@implementation ChatViewController

@synthesize messageArray;


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createArray];
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    manger=app.manger;
    manger.responseSerializer=[AFCompoundResponseSerializer serializer];
    
    
    self.delegate = self;
    self.dataSource = self;
    
    self.title = @"聊天对象";
    self.xmpp=[(AppDelegate*)[UIApplication sharedApplication].delegate myxmpp];
    //将自己提交到xmpp用来接信息
    self.xmpp.chatvc=self;
     
}
#pragma mark 初始化数据
-(void)createArray{
    self.messageArray = [NSMutableArray array];
    self.timestamps = [NSMutableArray array];
    
    NSArray *arr=[[DataModel sharedDataModel]getAllMessageWithToJid:self.jid withFormJid:[[NSUserDefaults standardUserDefaults]objectForKey:kUserName]];

    for (int i=0; i<[arr count]; i++) {
        ChatMessageModel *model=arr[i];
        NSDictionary *dic;
        if ([model.formJid isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:kUserName]]) {
            
            dic=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@@In",model.messageContent] forKey:@"Text"];
        }
        else{
            dic=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@@Out",model.messageContent] forKey:@"Text"];
        }
        [self.messageArray addObject:dic];
        [self.timestamps addObject:model.messageDate];

    }
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [self.messageArray addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@@In",text] forKey:@"Text"]];
    
    [self.timestamps addObject:[NSDate date]];
    
    //发送的信息提交到内容表单
    [JSMessageSoundEffect playMessageSentSound];
    
    
    NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    //上载聊天数据成功
    [[MyWeb sharedMyWeb]updateChatMessageWithMessage:text withTo:self.jid withForm:username];
    
//    if((self.messageArray.count - 1) % 2)
//        [JSMessageSoundEffect playMessageSentSound];
//    else
//        [JSMessageSoundEffect playMessageReceivedSound];
    /**
     *  发送信息
     */
    [self.xmpp sendMessageWithJid:self.jid WithMessage:text];
    
    [self finishSend];
}

- (void)cameraPressed:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isSelf=NO;
    NSString *text=[(NSMutableDictionary*)[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Text"];
    NSRange range=[text rangeOfString:@"@"];
    NSString *is=[text substringFromIndex:range.location];
    if ([@"@Out" isEqualToString:is]) {
        return JSBubbleMessageTypeIncoming;
    }
    else if([@"@In" isEqualToString:is]){
        return JSBubbleMessageTypeOutgoing;
    }
    
    
    return JSBubbleMessageTypeIncoming;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Text"]){
        return JSBubbleMediaTypeText;
    }else if ([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Image"]){
        return JSBubbleMediaTypeImage;
    }
    
    return -1;
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    /*
     JSMessagesViewTimestampPolicyAll = 0,
     JSMessagesViewTimestampPolicyAlternating,
     JSMessagesViewTimestampPolicyEveryThree,
     JSMessagesViewTimestampPolicyEveryFive,
     JSMessagesViewTimestampPolicyCustom
     */
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    /*
     JSMessagesViewAvatarPolicyIncomingOnly = 0,
     JSMessagesViewAvatarPolicyBoth,
     JSMessagesViewAvatarPolicyNone
     */
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    /*
     JSAvatarStyleCircle = 0,
     JSAvatarStyleSquare,
     JSAvatarStyleNone
     */
    return JSAvatarStyleCircle;
}

- (JSInputBarStyle)inputBarStyle
{
    /*
     JSInputBarStyleDefault,
     JSInputBarStyleFlat

     */
    return JSInputBarStyleFlat;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text=[[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Text"];
    if(text){
        NSRange tmp=[text rangeOfString:@"@"];
        return [text substringToIndex:tmp.location];
    }
    return nil;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.timestamps objectAtIndex:indexPath.row];
}

- (UIImage *)avatarImageForIncomingMessage
{
    return [UIImage imageNamed:@"icon"];
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return [UIImage imageNamed:@"icon"];
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Image"]){
        return [[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Image"];
    }
    return nil;
    
}

#pragma UIImagePicker Delegate

#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog(@"Chose image!  Details:  %@", info);
    
    self.willSendImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.messageArray addObject:[NSDictionary dictionaryWithObject:self.willSendImage forKey:@"Image"]];
    [self.timestamps addObject:[NSDate date]];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
    
	
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
