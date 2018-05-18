//
//  TestViewController.m
//  SinaPic
//
//  Created by yangwei on 16/8/29.
//  Copyright © 2016年 yw. All rights reserved.
//

#import "TestViewController.h"
#import "YYControl.h"
#import <YYCategories/YYCategories.h>
#import "YYPhotoGroupView.h"
#import "CALayer+YYWebImage.h"

#define kWBCellPadding 12       // cell 内边距
#define kWBCellContentWidth (kScreenWidth - 2 * kWBCellPadding) // cell 内容宽度

#define kWBCellPaddingPic 4     // cell 多张图片中间留白

@interface TestViewController (){
    
    NSArray *picArra;
    
    
    
    
    
}

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    picArra = [NSArray arrayWithObjects:@"http://ww2.sinaimg.cn/wap720/6204ece1gw1evvzegkumsj20k069f4hm.jpg",@"http://ww4.sinaimg.cn/wap720/6204ece1gw1evvzh9bp37j20fa08yjt5.jpg",@"http://ww4.sinaimg.cn/wap720/6204ece1gw1evvzh9bp37j20fa08yjt5.jpg",@"http://ww4.sinaimg.cn/wap720/6204ece1gw1evvzh9bp37j20fa08yjt5.jpg",@"http://ww4.sinaimg.cn/wap720/6204ece1gw1evvzh9bp37j20fa08yjt5.jpg",@"http://ww4.sinaimg.cn/wap720/6204ece1gw1evvzh9bp37j20fa08yjt5.jpg",@"http://ww4.sinaimg.cn/wap720/6204ece1gw1evvzh9bp37j20fa08yjt5.jpg", nil];
    [self _layoutPicsWithStatus:NO];
//    CGSize picSize = CGSizeZero;
    
    NSMutableArray *picViews = [NSMutableArray new];
    
//    CGFloat maxLen = kWBCellContentWidth / 2.0;
//    maxLen = CGFloatPixelRound(maxLen);
//    picSize = CGSizeMake(maxLen, maxLen);
    
    for (int i = 0; i < 9; i++) {
        
        YYControl *imageView = [YYControl new];
        imageView.size = CGSizeMake(100, 100);
        imageView.hidden = YES;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor redColor];
        imageView.exclusiveTouch = YES;
        imageView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
             UIView *fromView = nil;
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:view];
                if (CGRectContainsPoint(view.bounds, p)) {
                    
                    NSMutableArray *items = [NSMutableArray new];
                    
                    for (NSUInteger j = 0; j < picArra.count; j++) {
                        
                        UIView *imgView = picViews[j];
                        
                        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
                        item.thumbView = imgView;
                        item.largeImageURL = [NSURL URLWithString:picArra[j]];
                        if(i == 0){
                        
                            item.largeImageSize = CGSizeMake(720, 8115);
                        }else{
                        
                            item.largeImageSize = CGSizeMake(550, 322);
                        }
                        
                        [items addObject:item];
                        if (j == i) {
                            fromView = imageView;
                        }


                    }
                    
                    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
                    [v presentFromImageView:fromView toContainer:self.view animated:YES completion:nil];
                }
            }
            
        };
        
        UIView *badge = [UIImageView new];
        badge.userInteractionEnabled = NO;
        badge.contentMode = UIViewContentModeScaleAspectFit;
        badge.size = CGSizeMake(56 / 2, 36 / 2);
        badge.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        badge.right = imageView.width;
        badge.bottom = imageView.height;
        badge.hidden = YES;
        [imageView addSubview:badge];
        [self.view addSubview:imageView];
        [picViews addObject:imageView];
    }
    _picViews = picViews;
    
    [self _setImageViewWithTop:100 isRetweet:NO];
}

-(void)_setImageViewWithTop:(CGFloat)imageTop isRetweet:(BOOL)isRetweet{
    
    CGSize picSize = isRetweet ? self.retweetPicSize : self.picSize;
    NSArray *pics = picArra;
    int picsCount = (int)pics.count;
    
    for (int i = 0; i < 9; i++) {
        UIView *imageView = _picViews[i];
        if (i >= picsCount) {
            [imageView.layer yy_cancelCurrentImageRequest];
            imageView.hidden = YES;
        } else {
            CGPoint origin = {0};
            switch (picsCount) {
                case 1: {
                    origin.x = kWBCellPadding;
                    origin.y = imageTop;
                } break;
                case 4: {
                    origin.x = kWBCellPadding + (i % 2) * (picSize.width + kWBCellPaddingPic);
                    origin.y = imageTop + (int)(i / 2) * (picSize.height + kWBCellPaddingPic);
                } break;
                default: {
                    origin.x = kWBCellPadding + (i % 3) * (picSize.width + kWBCellPaddingPic);
                    origin.y = imageTop + (int)(i / 3) * (picSize.height + kWBCellPaddingPic);
                } break;
            }
            imageView.frame = (CGRect){.origin = origin, .size = picSize};
            imageView.hidden = NO;
            [imageView.layer removeAnimationForKey:@"contents"];
            NSString *pic = pics[i];
            
            UIView *badge = imageView.subviews.firstObject;
            switch (WBPictureBadgeTypeNone) {
                case WBPictureBadgeTypeNone: {
                    if (badge.layer.contents) {
                        badge.layer.contents = nil;
                        badge.hidden = YES;
                    }
                } break;
                case WBPictureBadgeTypeLong: {
                    //                    badge.layer.contents = (__bridge id)([WBStatusHelper imageNamed:@"timeline_image_longimage"].CGImage);
                    badge.hidden = NO;
                } break;
                case WBPictureBadgeTypeGIF: {
                    //                    badge.layer.contents = (__bridge id)([WBStatusHelper imageNamed:@"timeline_image_gif"].CGImage);
                    badge.hidden = NO;
                } break;
            }
            
            @weakify(imageView);
            [imageView.layer removeAnimationForKey:@"contents"];
            [imageView.layer yy_setImageWithURL:[NSURL URLWithString:pic]
                                    placeholder:nil
                                        options:YYWebImageOptionAvoidSetImage
                                     completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                         @strongify(imageView);
                                         if (!imageView) return;
                                         if (image && stage == YYWebImageStageFinished) {
                                             int width = 0;
                                             int height = 0;
                                             //461,270
                                             //360,1200
                                             if (i == 0) {
                                                 width = 360;
                                                 height = 1200;
                                             }else {
                                                 width = 461;
                                                  height = 270;

                                                 
                                             }
                                             CGFloat scale = (height / width) / (imageView.height / imageView.width);
                                             if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
                                                 imageView.contentMode = UIViewContentModeScaleAspectFill;
                                                 imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                                             } else { // 高图只保留顶部
                                                 imageView.contentMode = UIViewContentModeScaleToFill;
                                                 imageView.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
                                             }
                                             ((YYControl *)imageView).image = image;
                                             if (from != YYWebImageFromMemoryCacheFast) {
                                                 CATransition *transition = [CATransition animation];
                                                 transition.duration = 0.15;
                                                 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                                 transition.type = kCATransitionFade;
                                                 [imageView.layer addAnimation:transition forKey:@"contents"];
                                             }
                                         }
                                     }];
            
        }
        
    }
}



- (void)_layoutPicsWithStatus:(BOOL)isRetweet {
    if (isRetweet) {
        _retweetPicSize = CGSizeZero;
        _retweetPicHeight = 0;
    } else {
        _picSize = CGSizeZero;
        _picHeight = 0;
    }
//    if (status.pics.count == 0) return;
    
    CGSize picSize = CGSizeZero;
    CGFloat picHeight = 0;
    
    CGFloat len1_3 = (kWBCellContentWidth + kWBCellPaddingPic) / 3 - kWBCellPaddingPic;
    len1_3 = CGFloatPixelRound(len1_3);
    switch (picArra.count) {
        case 1: {
//            WBPicture *pic = _status.pics.firstObject;
//            WBPictureMetadata *bmiddle = pic.bmiddle;
//            if (pic.keepSize || bmiddle.width < 1 || bmiddle.height < 1) {
//                CGFloat maxLen = kWBCellContentWidth / 2.0;
//                maxLen = CGFloatPixelRound(maxLen);
//                picSize = CGSizeMake(maxLen, maxLen);
//                picHeight = maxLen;
//            } else {
                CGFloat maxLen = len1_3 * 2 + kWBCellPaddingPic;
            CGFloat width = 360;
            CGFloat height = 480;
                if (width < height) {
                    picSize.width = (float)width / (float)height * maxLen;
                    picSize.height = maxLen;
                } else {
                    picSize.width = maxLen;
                    picSize.height = (float)height / (float)width * maxLen;
                }
                picSize = CGSizePixelRound(picSize);
                picHeight = picSize.height;
//            }
        } break;
        case 2: case 3: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3;
        } break;
        case 4: case 5: case 6: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 2 + kWBCellPaddingPic;
        } break;
        default: { // 7, 8, 9
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 3 + kWBCellPaddingPic * 2;
        } break;
    }
    
    if (isRetweet) {
        _retweetPicSize = picSize;
        _retweetPicHeight = picHeight;
    } else {
        _picSize = picSize;
        _picHeight = picHeight;
    }
    
    NSLog(@"_picHeight:%f",_picHeight);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
