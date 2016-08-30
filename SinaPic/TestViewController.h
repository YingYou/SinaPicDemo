//
//  TestViewController.h
//  SinaPic
//
//  Created by yangwei on 16/8/29.
//  Copyright © 2016年 yw. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 图片标记
typedef NS_ENUM(NSUInteger, WBPictureBadgeType) {
    WBPictureBadgeTypeNone = 0, ///< 正常图片
    WBPictureBadgeTypeLong,     ///< 长图
    WBPictureBadgeTypeGIF,      ///< GIF
};

@interface TestViewController : UIViewController
// 转发
@property (nonatomic, strong) NSArray<UIView *> *picViews;      // 图片

@property (nonatomic, assign) CGFloat retweetPicHeight;
@property (nonatomic, assign) CGSize retweetPicSize;

// 图片
@property (nonatomic, assign) CGFloat picHeight; //图片高度，0为没图片
@property (nonatomic, assign) CGSize picSize;

@end
