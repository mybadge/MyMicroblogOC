//
//  MMBComposeViewController.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/4.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBComposeViewController.h"
#import "MMBAccountTool.h"
#import "MMBAccount.h"
#import "MMBTextView.h"
#import "MMBComposeToolbar.h"
#import "MMBNetworkTool.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "MMBComposePhotosView.h"

@interface MMBComposeViewController ()<MMBComposeToolbarDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, weak) MMBTextView *textView;
@property (nonatomic, weak) MMBComposeToolbar *toolbar;
@property (nonatomic, weak) MMBComposePhotosView *photosView;
@end

@implementation MMBComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    
    [self setupTextView];
    
    [self setupToolbar];
    
    [self setupPhotosView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

#pragma mark - 初始化导航栏
/**
 * 初始化导航栏
 */
- (void)setupNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [rightButton setTitle:@"发布" forState:UIControlStateDisabled];
    [rightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7] forState:UIControlStateDisabled];
    [rightButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSString *prefix = @"发微博";
    MMBAccount *account = [MMBAccountTool account];
    NSString *name = account.name;
    if (name) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.width = 300;
        titleLabel.height = 50;
        titleLabel.numberOfLines = 0;
        NSString *str = [NSString stringWithFormat:@"%@\n%@", prefix, account.name];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:[str rangeOfString:prefix]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[str rangeOfString:account.name]];
        titleLabel.attributedText = attrStr;
        self.navigationItem.titleView = titleLabel;
    }else{
        self.title = prefix;
    }
}

/**
 * 初始化文本框
 */
- (void)setupTextView{
    // 在这个控制器中，textView的contentInset.top默认会等于64
    MMBTextView *textView = [[MMBTextView alloc] init];
    // 垂直方向上永远可以拖拽（有弹簧效果）
    textView.alwaysBounceVertical = YES;
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholderColor = [UIColor orangeColor];
    textView.placeholder = @"分享一下你的新鲜事...";
    [self.view addSubview:textView];
    self.textView = textView;
    self.textView.delegate = self;
    
    // 文字改变的通知
    [MMBNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    // 键盘通知
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    //    UIKeyboardWillChangeFrameNotification
    //    UIKeyboardDidChangeFrameNotification
    // 键盘显示时发出的通知
    //    UIKeyboardWillShowNotification
    //    UIKeyboardDidShowNotification
    // 键盘隐藏时发出的通知
    //    UIKeyboardWillHideNotification
    //    UIKeyboardDidHideNotification
    [MMBNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

/**
 * 初始化工具栏
 */
- (void)setupToolbar{
    MMBComposeToolbar *toolbar = [MMBComposeToolbar toolbar];
    toolbar.x = 0;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.width = self.view.width;
    toolbar.delegate = self;
    self.toolbar = toolbar;
    [self.view addSubview:toolbar];
}

/**
 * 初始化相册
 */
- (void)setupPhotosView{
    MMBComposePhotosView *photoView = [[MMBComposePhotosView alloc] init];
    //photoView.backgroundColor = [UIColor redColor];
    photoView.y = 100;
    photoView.width = self.view.width;
    photoView.height = self.view.height;
    [self.textView addSubview:photoView];
    self.photosView = photoView;
}


- (void)textDidChange{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    //动画持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        if (keyboardF.origin.y > self.view.height) {
            self.toolbar.y = self.view.height - self.toolbar.height;
        }else{
            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
        }
    }];
}

/**
 * 发布微博
 */
- (void)send{
    if (self.photosView.photos.count){
        [self sendMicroblogWithImage];
    }else{
        [self sendMicroblog];
    }
    [self back];
}

/**
 * 发送微博 不含图片
 */
- (void)sendMicroblog{
    // URL: https://api.weibo.com/2/statuses/upload.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	access_token true string*/
    /**	pic true binary 微博的配图。*/
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [MMBAccountTool account].access_token;
    params[@"status"] = self.textView.text;
    
    [[MMBNetworkTool shareNetworkTool] POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"发送失败"];
        NSLog(@"%@",error);
    }];
}

/**
 * 发送微博 包含图片
 */
- (void)sendMicroblogWithImage{
    // URL: https://upload.api.weibo.com/2/statuses/upload.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	access_token true string*/
    /**	pic true binary 微博的配图。*/
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [MMBAccountTool account].access_token;
    params[@"status"] = self.textView.text;
    
    [[MMBNetworkTool shareNetworkTool] POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //拼接文件路径
        UIImage *image = [self.photosView.photos firstObject];
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"发送失败"];
    }];
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - textView(scrollView)的 滚动代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - MMBComposeToolbar 代理方法
- (void)composeToolbar:(MMBComposeToolbar *)composeToolbar didClickButton:(NSUInteger)buttonType{
    switch (buttonType) {
        case MMBComposeToolbarButtonTypeCamera:
            [self openCamera];
            break;
        case MMBComposeToolbarButtonTypePicture:
            NSLog(@"%d",MMBComposeToolbarButtonTypePicture);
            [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        case MMBComposeToolbarButtonTypeMention:
            NSLog(@"@ %d",MMBComposeToolbarButtonTypeMention);
            break;
        case MMBComposeToolbarButtonTypeTrend:
            NSLog(@"话题%d",MMBComposeToolbarButtonTypeTrend);
            break;
        case MMBComposeToolbarButtonTypeEmotion:
            NSLog(@"表情 %d",MMBComposeToolbarButtonTypeEmotion);
            break;
        default:
            break;
    }
}

- (void)openCamera{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

- (void)openAlbum{
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSLog(@"%@",image);
    [self.photosView addPhoto:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
