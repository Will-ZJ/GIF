//
//  GIFHUD.m
//  GifHUD
//
//  Created by Will on 2017/8/23.
//  Copyright © 2017年 Will. All rights reserved.
//

#import "GIFHUD.h"
#import <ImageIO/ImageIO.h>
@interface GIFHUD ()

@property (nonatomic,strong) UIView *cover_view;

@end
@implementation GIFHUD

static GIFHUD *_sharedView;

+ (GIFHUD *)sharedView {
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
//        _sharedView = [[GIFHUD alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
        _sharedView = [[GIFHUD alloc] init];
    });
    return _sharedView;
}
+ (void)imagesWithGif:(NSString *)gifNameInBundle returnData:(void(^)(NSArray<UIImage *> *imageArray,float totalTime))dataBlock{
    
    NSString *newStr;
    if ([gifNameInBundle containsString:@".gif"]){
        newStr = [gifNameInBundle stringByReplacingOccurrencesOfString:@".gif" withString:@""];
    }else{
        newStr = gifNameInBundle;
    }

    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:newStr withExtension:@"gif"];
    
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);
    size_t gifCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    float alltime = 0;
    for (size_t i = 0; i< gifCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [frames addObject:image];
        CGImageRelease(imageRef);
        //获取图片信息
        NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL);
        NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
        alltime += time;
    }
    dataBlock(frames,alltime);
}
- (void)showWithGifNameInBundle:(NSString *)gifName AndHUDFrame:(CGRect)HUD_frame{
    
    GIFHUD *hud = [GIFHUD sharedView];
    hud.frame = HUD_frame;

    [GIFHUD imagesWithGif:gifName returnData:^(NSArray<UIImage *> *imageArray, float totalTime) {
        NSArray *imgArray = imageArray;
        NSInteger allTime = totalTime;
        
        hud.animationImages = imgArray;
        
        // 设置UIImageView的动画时间（动画用时）
        
        hud.animationDuration = allTime;
        
        // 永远重复（如果是1，就是1次，以此类推。。）
        
        hud.animationRepeatCount = 0;
        
        // 开始动画
        
        [hud startAnimating];
        
        self.cover_view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.cover_view.backgroundColor = [UIColor blackColor];
        self.cover_view.alpha = 0.5;
        
        UIWindow *w = [UIApplication sharedApplication].keyWindow;
        [w addSubview:self.cover_view];
        hud.center = w.center;
        [w addSubview:hud];

    }];
    
    
    
    
}
+ (void)showWithGifNameInBundle:(NSString *)gifName AndHUDFrame:(CGRect)HUD_frame{
    [[GIFHUD sharedView] showWithGifNameInBundle:gifName AndHUDFrame:HUD_frame];
}

+ (void)dissmiss{
    [[GIFHUD sharedView].cover_view removeFromSuperview];
    [[GIFHUD sharedView] removeFromSuperview];
}


@end
