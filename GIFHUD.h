//
//  GIFHUD.h
//  GifHUD
//
//  Created by Will on 2017/8/23.
//  Copyright © 2017年 Will. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GIFHUD : UIImageView

+ (void)showWithGifNameInBundle:(NSString *)gifName AndHUDFrame:(CGRect)HUD_frame;

+ (void)dissmiss;

@end
