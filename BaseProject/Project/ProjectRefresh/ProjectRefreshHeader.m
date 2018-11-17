//
//  ProjectRefreshHeader.m
//  BaseProject
//
//  Created by 意一yiyi on 2017/10/23.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "ProjectRefreshHeader.h"
#import "MJRefresh.h"

#define kGifImageCount 3


/***************
 *  NormalHeader
 **************/

typedef NS_ENUM(NSInteger, NormalHeaderStyle) {
    
    NormalHeaderStyle_Arrow_StateLabel_TimeLabel = 0,
    NormalHeaderStyle_Arrow_StateLabel = 1,
    NormalHeaderStyle_Arrow = 2
};

@interface NormalHeader : MJRefreshNormalHeader

@property (assign, nonatomic) NormalHeaderStyle style;

@end


@implementation NormalHeader

// 重写 prepare 方法来配置 refreshHeader 的样式
- (void)prepare {
    
    [super prepare];
    
    // NormalHeader 默认样式
    self.style = NormalHeaderStyle_Arrow_StateLabel;
}


#pragma mark - headerStyle

- (void)set_arrow_stateLabel_timeLabel_headerStyle {
    
    // 恢复到初始状态
    [self mjRefresh_initState];
    
    // stateLabel
    [self setTitle:@"下拉刷新" forState:(MJRefreshStateIdle)];
    [self setTitle:@"释放更新" forState:(MJRefreshStatePulling)];
    [self setTitle:@"加载中..." forState:(MJRefreshStateRefreshing)];
    
    // timeLabel
    self.lastUpdatedTimeText = ^NSString *(NSDate *lastUpdatedTime) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        if (String_Is_Empty(time)) {
            
            time = @"无记录";
        }
        return time;
    };
}

- (void)set_arrow_stateLabel_headerStyle {
    
    // 恢复到初始状态
    [self mjRefresh_initState];
    
    // stateLabel
    [self setTitle:@"下拉刷新" forState:(MJRefreshStateIdle)];
    [self setTitle:@"释放更新" forState:(MJRefreshStatePulling)];
    [self setTitle:@"加载中..." forState:(MJRefreshStateRefreshing)];
    
    // timeLabel
    self.lastUpdatedTimeLabel.hidden = YES;
}

- (void)set_arrow_headerStyle {
    
    // 恢复到初始状态
    [self mjRefresh_initState];
    
    // stateLabel
    self.stateLabel.hidden = YES;
    
    // timeLabel
    self.lastUpdatedTimeLabel.hidden = YES;
}


#pragma mark - setter, getter

- (void)setStyle:(NormalHeaderStyle)style {
    
    _style = style;
    
    switch (_style) {
        case NormalHeaderStyle_Arrow_StateLabel_TimeLabel:
            [self set_arrow_stateLabel_timeLabel_headerStyle];
            break;
        case NormalHeaderStyle_Arrow_StateLabel:
            [self set_arrow_stateLabel_headerStyle];
            break;
        case NormalHeaderStyle_Arrow:
            [self set_arrow_headerStyle];
            break;
    }
}


#pragma mark - MJRefresh 初始状态

- (void)mjRefresh_initState {
    
    self.stateLabel.hidden = NO;
    self.lastUpdatedTimeLabel.hidden = NO;
    
    if ([self.lastUpdatedTimeLabel.text isEqualToString:@"最后更新：无记录"]) {

        self.lastUpdatedTimeLabel.text = @"无记录";
    }
    
    if (self.lastUpdatedTimeLabel.text.length == 13) {
        
        self.lastUpdatedTimeLabel.text = [self.lastUpdatedTimeLabel.text substringFromIndex:8];
    }
}

@end



/************
 *  GifHeader
 ***********/

typedef NS_ENUM(NSInteger, GifHeaderStyle) {
    
    GifHeaderStyle_Gif_StateLabel_TimeLabel = 3,
    GifHeaderStyle_Gif_StateLabel = 4,
    GifHeaderStyle_Gif = 5
};

@interface GifHeader : MJRefreshGifHeader

@property (assign, nonatomic) GifHeaderStyle style;

@end


@implementation GifHeader

// 重写 prepare 方法来配置 refreshHeader 的样式
- (void)prepare {
    [super prepare];
    
    // GifHeader 默认样式
    self.style = GifHeaderStyle_Gif;
}


#pragma mark - headerStyle

- (void)set_gif_stateLabel_timeLabel_headerStyle {
    
    // 恢复到初始状态
    [self mjRefresh_initState];
    
    // gif
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSInteger i = 0; i < kGifImageCount; i ++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%ld", i]];
        [imageArray addObject:image];
    }
    [self setImages:@[[UIImage imageNamed:@"refresh_0"]] forState:(MJRefreshStateIdle)];// 设置闲置状态的图片(闲置状态 = 闲置 + 下拉但还没有下拉到松手即刷新的状态)
    [self setImages:imageArray forState:(MJRefreshStatePulling)];// 设置松手即刷新的图片
    [self setImages:imageArray forState:(MJRefreshStateRefreshing)];// 设置正在刷新的图片
    
    // stateLabel
    [self setTitle:@"下拉刷新" forState:(MJRefreshStateIdle)];
    [self setTitle:@"释放更新" forState:(MJRefreshStatePulling)];
    [self setTitle:@"加载中..." forState:(MJRefreshStateRefreshing)];
    
    // timeLabel
    self.lastUpdatedTimeText = ^NSString *(NSDate *lastUpdatedTime) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        if (String_Is_Empty(time)) {
            
            time = @"无记录";
        }
        return time;
    };
}

- (void)set_gif_stateLabel_headerStyle {
    
    // 恢复到初始状态
    [self mjRefresh_initState];
    
    // gif
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSInteger i = 0; i < kGifImageCount; i ++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%ld", i]];
        [imageArray addObject:image];
    }
    [self setImages:@[[UIImage imageNamed:@"refresh_0"]] forState:(MJRefreshStateIdle)];// 设置闲置状态的图片(闲置状态 = 闲置 + 下拉但还没有下拉到松手即刷新的状态)
    [self setImages:imageArray forState:(MJRefreshStatePulling)];// 设置松手即刷新的图片
    [self setImages:imageArray forState:(MJRefreshStateRefreshing)];// 设置正在刷新的图片
    
    // stateLabel
    [self setTitle:@"下拉刷新" forState:(MJRefreshStateIdle)];
    [self setTitle:@"释放更新" forState:(MJRefreshStatePulling)];
    [self setTitle:@"加载中..." forState:(MJRefreshStateRefreshing)];
    
    // timeLabel
    self.lastUpdatedTimeLabel.hidden = YES;
}

- (void)set_gif_headerStyle {
    
    // 恢复到初始状态
    [self mjRefresh_initState];
    
    // gif
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSInteger i = 0; i < kGifImageCount; i ++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%ld", i]];
        [imageArray addObject:image];
    }
    [self setImages:@[[UIImage imageNamed:@"refresh_0"]] forState:(MJRefreshStateIdle)];// 设置闲置状态的图片(闲置状态 = 闲置 + 下拉但还没有下拉到松手即刷新的状态)
    [self setImages:imageArray forState:(MJRefreshStatePulling)];// 设置松手即刷新的图片
    [self setImages:imageArray forState:(MJRefreshStateRefreshing)];// 设置正在刷新的图片
    
    // stateLabel
    self.stateLabel.hidden = YES;
    
    // timeLabel
    self.lastUpdatedTimeLabel.hidden = YES;
}


#pragma mark - setter, getter

- (void)setStyle:(GifHeaderStyle)style {
    
    _style = style;
    
    switch (_style) {
        case GifHeaderStyle_Gif_StateLabel_TimeLabel:
            [self set_gif_stateLabel_timeLabel_headerStyle];
            break;
        case GifHeaderStyle_Gif_StateLabel:
            [self set_gif_stateLabel_headerStyle];
            break;
        case GifHeaderStyle_Gif:
            [self set_gif_headerStyle];
            break;
    }
}


#pragma mark - MJRefresh 初始状态

- (void)mjRefresh_initState {
    
    self.stateLabel.hidden = NO;
    self.lastUpdatedTimeLabel.hidden = NO;
    
    if ([self.lastUpdatedTimeLabel.text isEqualToString:@"最后更新：无记录"]) {
        
        self.lastUpdatedTimeLabel.text = @"无记录";
    }
    
    if (self.lastUpdatedTimeLabel.text.length == 13) {
        
        self.lastUpdatedTimeLabel.text = [self.lastUpdatedTimeLabel.text substringFromIndex:8];
    }
}

@end



/***********************
 *  ProjectRefreshHeader
 **********************/

@interface ProjectRefreshHeader ()

@property (nonatomic, strong) NormalHeader *normalHeader;
@property (nonatomic, strong) GifHeader *gifHeader;

@end

@implementation ProjectRefreshHeader

- (id)initNormalHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action; {
    
    _normalHeader = [[NormalHeader alloc] init];
    [_normalHeader setRefreshingTarget:target refreshingAction:action];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    return _normalHeader;
#pragma clang diagnostic pop
}

- (id)initGifHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action; {

    _gifHeader = [[GifHeader alloc] init];
    [_gifHeader setRefreshingTarget:target refreshingAction:action];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    return _gifHeader;
#pragma clang diagnostic pop
}

@end


