//
//  MMBIconView.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/4.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBIconView.h"
#import "UIImageView+WebCache.h"
#import "MMBUser.h"

@interface MMBIconView ()

@property (nonatomic, weak) UIImageView *verifiedView;
@property (nonatomic,strong) UIImageView *userIconView;
@end

@implementation MMBIconView

- (UIImageView *)verifiedView{
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc] init];
        [self addSubview:verifiedView];
        _verifiedView = verifiedView;
    }
    return _verifiedView;
}

- (UIImageView *)userIconView{
    if (!_userIconView) {
        UIImageView *userIconView = [[UIImageView alloc] init];
        userIconView.layer.cornerRadius = 25;
        userIconView.clipsToBounds = YES;
        [self addSubview:userIconView];
        _userIconView =  userIconView;

    }
    return _userIconView;
}




- (void)setUser:(MMBUser *)user
{
    _user = user;
    if (user.verified_type != MMBUserVerifiedTypeNone) {
        NSLog(@"name = %@ type = %d  %p",user.name ,user.verified_type,self.verifiedView);
        
    }
    
    // 1.下载图片
    [self.userIconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    self.verifiedView.image = nil;
    // 2.设置加V图片
    switch (user.verified_type) { // 这里cell重用有问题
        case MMBUserVerifiedPersonal: // 个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
            
        case MMBUserVerifiedOrgEnterprice:
        case MMBUserVerifiedOrgMedia:
        case MMBUserVerifiedOrgWebsite: // 官方认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
            
        case MMBUserVerifiedDaren: // 微博达人
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
            self.verifiedView.hidden = YES; // 当做没有任何认证
            break;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.userIconView.x = 0;
    self.userIconView.y = 0;
    self.userIconView.width = self.width;
    self.userIconView.height = self.height;
    CGFloat scale = 0.7;
    CGFloat w = 17;
    self.verifiedView.x = self.width - w * scale;
    self.verifiedView.y = self.height - w * scale;
    self.verifiedView.size = CGSizeMake(w, w);
    //NSLog(@"%@",NSStringFromCGSize(self.verifiedView.image.size));
}

@end
