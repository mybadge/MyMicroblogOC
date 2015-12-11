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
#import "MMBComposeToolbar.h"
#import "MMBNetworkTool.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "MMBComposePhotosView.h"
#import "MMBEmotioinKeyBoard.h"
#import "MMBEmotion.h"
#import "MMBEmotionTextView.h"

@interface MMBComposeViewController ()<MMBComposeToolbarDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, weak) MMBEmotionTextView *textView;
@property (nonatomic, weak) MMBComposeToolbar *toolbar;
@property (nonatomic, weak) MMBComposePhotosView *photosView;
@property (nonatomic, strong) MMBEmotioinKeyBoard *emotionKeyBoard;
/** 是否正在切换键盘 */
@property (nonatomic, assign) BOOL switchingKeybaord;
@end

@implementation MMBComposeViewController

#pragma mark - 懒加载
- (MMBEmotioinKeyBoard *)emotionKeyBoard{
    if (!_emotionKeyBoard) {
        _emotionKeyBoard = [[MMBEmotioinKeyBoard alloc] init];
        _emotionKeyBoard.width = self.view.width;
        _emotionKeyBoard.height = 216;
    }
    return _emotionKeyBoard;
}

#pragma mark - 系统方法
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

- (void)dealloc{
    [MMBNotificationCenter removeObserver:self];
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
    MMBEmotionTextView *textView = [[MMBEmotionTextView alloc] init];
    // 垂直方向上永远可以拖拽（有弹簧效果）
    textView.alwaysBounceVertical = YES;
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:23];
//    textView.placeholderColor = [UIColor orangeColor];
//    textView.placeholder = @"分享一下你的新鲜事...";
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
    
    //监听插入表情的通知
    [MMBNotificationCenter addObserver:self selector:@selector(emotionDidSelected:) name:MMBEmotionDidSelectedNotification object:nil];
    //监听删除表情通知
    [MMBNotificationCenter addObserver:self selector:@selector(emotionDidDeleted) name:MMBEmotionDidDeletedNotification object:nil];
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


#pragma mark - 监听方法

/**
 *  删除表情按钮
 */
- (void)emotionDidDeleted{
    [self.textView deleteBackward];
}

/**
 *  插入表情
 */
- (void)emotionDidSelected:(NSNotification *)notification{
    MMBEmotion *emotion = notification.userInfo[MMBSelectEmotionKey];
    [self.textView insertEmotion:emotion];
}

- (void)textDidChange{
    //NSLog(@"textView=========%@",self.textView.attributedText);
    NSLog(@"textView.fullText=========%@",self.textView.fullText);
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    if (self.switchingKeybaord) return;
    NSDictionary *userInfo = notification.userInfo;
    //动画持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //NSLog(@"%f",keyboardF.size.height);
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) {
            self.toolbar.y = self.view.height - self.toolbar.height;
        }else{
            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
        }
    }];
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  选择键盘
 */
- (void)switchKeyboard{
    self.toolbar.showKeyboardButton = !self.toolbar.isShowKeyboardButton;
    if (self.textView.inputView == nil) {
        self.textView.inputView = self.emotionKeyBoard;
        //显示键盘按钮
        self.toolbar.showKeyboardButton = YES;
    }else{
        self.textView.inputView = nil;
        //显示表情按钮
        self.toolbar.showKeyboardButton = NO;
    }
    self.switchingKeybaord = YES;
    [self.textView endEditing:YES];
    self.switchingKeybaord = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
        
    });
}

#pragma mark -发送微博
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
    params[@"status"] = self.textView.fullText;
    
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
    params[@"status"] = self.textView.fullText;
    
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
            [self switchKeyboard];
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
