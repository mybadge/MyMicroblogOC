//
//  MMBStatusCell.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/1.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBStatusCell.h"
#import "MMBStatusFrame.h"
#import "MMBUser.h"
#import "MMBStatus.h"
#import "UIImageView+WebCache.h"
#import "MMBPhoto.h"

@interface MMBStatusCell ()
/** 原创微博 */

/** 原创微博整体 */
@property (nonatomic,weak) UIView *originnalView;
/** 头像 */
@property (nonatomic,weak) UIImageView *iconView;
/** 会员图标 */
@property (nonatomic,weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic,weak) UIImageView *photoView;
/** 昵称 */
@property (nonatomic,weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic,weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic,weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic,weak) UILabel *contentLabel;

@end

@implementation MMBStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"statusCell";
    MMBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /** 原创微博整体 */
        UIView *originnalView = [[UIView alloc] init];
        [self.contentView addSubview:originnalView];
        self.originnalView = originnalView;
        
        /** 头像 */
        UIImageView *iconView = [[UIImageView alloc] init];
        [originnalView addSubview:iconView];
        self.iconView = iconView;
        
        /** 会员图标 */
        UIImageView *vipView = [[UIImageView alloc] init];
        vipView.contentMode = UIViewContentModeCenter;
        [originnalView addSubview:vipView];
        self.vipView = vipView;
        
        /** 配图 */
        UIImageView *photoView = [[UIImageView alloc] init];
        [originnalView addSubview:photoView];
        self.photoView = photoView;
        
        /** 昵称 */
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = MMBStatusCellNameFont;
        [originnalView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        /** 时间 */
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = MMBStatusCellTimeFont;
        [originnalView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        /** 来源 */
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.font = MMBStatusCellSourceFont;
        [originnalView addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        /** 正文 */
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = MMBStatusCellContentFont;
        contentLabel.numberOfLines = 0;
        [originnalView addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
    return self;
}

- (void)setStatusFrame:(MMBStatusFrame *)statusFrame{
    _statusFrame = statusFrame;
    
    MMBStatus *status = statusFrame.status;
    MMBUser *user = status.user;
    
    /** 原创微博整体 */
    self.originnalView.frame = statusFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = statusFrame.iconViewF;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    self.iconView.layer.cornerRadius = 12.5;
    self.iconView.layer.masksToBounds = YES;
    
    /** 会员图标 */
    if (user.isVip) {
        self.imageView.hidden = NO;
        self.vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%zd",user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        self.nameLabel.textColor = [UIColor orangeColor];
    }else{
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipView.hidden = YES;
    }
    
    /** 配图 */
    if (status.pic_urls.count) {
        self.photoView.frame = statusFrame.photoViewF;
        MMBPhoto *photo = [status.pic_urls firstObject];
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
        self.photoView.hidden = NO;
    }else{
        self.photoView.hidden = YES;
    }
    
    
    
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = statusFrame.nameLabelF;
    
    /** 时间 */
    self.timeLabel.text = status.created_at;
    self.timeLabel.frame = statusFrame.timeLabelF;
    
    /** 来源 */
    self.sourceLabel.text = status.source;
    self.sourceLabel.frame = statusFrame.sourceLabelF;
    
    /** 正文 */
    self.contentLabel.text = status.text;
    self.contentLabel.frame = statusFrame.contentLabelF;
}





@end
