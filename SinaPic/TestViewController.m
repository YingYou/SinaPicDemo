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

@interface TestViewController (){

    NSArray *picArra;
}

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    picArra = [NSArray arrayWithObjects:@"http://ww2.sinaimg.cn/wap720/6204ece1gw1evvzegkumsj20k069f4hm.jpg",@"http://ww4.sinaimg.cn/wap720/6204ece1gw1evvzh9bp37j20fa08yjt5.jpg", nil];
    
     CGSize picSize = CGSizeZero;
    
    CGFloat maxLen = kWBCellContentWidth / 2.0;
    maxLen = CGFloatPixelRound(maxLen);
    picSize = CGSizeMake(maxLen, maxLen);
    
    YYControl *imageView = [YYControl new];
    imageView.size = picSize;
    imageView.hidden = NO;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor redColor];
    imageView.exclusiveTouch = YES;
    imageView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        
        if (state == YYGestureRecognizerStateEnded) {
                        UITouch *touch = touches.anyObject;
                        CGPoint p = [touch locationInView:view];
                        if (CGRectContainsPoint(view.bounds, p)) {
                           
                            NSMutableArray *items = [NSMutableArray new];
                            
                            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
                            item.thumbView = view;
                            item.largeImageURL = [NSURL URLWithString:@"http://ww2.sinaimg.cn/wap720/6204ece1gw1evvzegkumsj20k069f4hm.jpg"];
                            item.largeImageSize = CGSizeMake(640, 1136);
                            [items addObject:item];
                            
                            YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
                            [v presentFromImageView:view toContainer:self.view animated:YES completion:nil];
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

    
    @weakify(imageView);
    [imageView.layer removeAnimationForKey:@"contents"];
    [imageView.layer yy_setImageWithURL:[NSURL URLWithString:@"http://ww2.sinaimg.cn/or360/6fc6f04egw1evuciu6zqlj20hs0vkab3.jpg"]
                         placeholder:nil
                             options:YYWebImageOptionAvoidSetImage
                          completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                              @strongify(imageView);
                              if (!imageView) return;
                              if (image && stage == YYWebImageStageFinished) {
                                  int width = 360;
                                  int height = 639;
                                  CGFloat scale = (height / width) / (imageView.height / imageView.width);
                                  if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
                                      imageView.contentMode = UIViewContentModeScaleAspectFill;
                                      imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                                  } else { // 高图只保留顶部
                                      imageView.contentMode = UIViewContentModeScaleToFill;
                                      imageView.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
                                  }
                                  imageView.image = image;
                                  if (from != YYWebImageFromMemoryCacheFast) {
                                      CATransition *transition = [CATransition animation];
                                      transition.duration = 0.15;
                                      transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                      transition.type = kCATransitionFade;
                                      [imageView.layer addAnimation:transition forKey:@"contents"];
                                  }
                              }
                          }];

    
    [self.view addSubview:imageView];

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
