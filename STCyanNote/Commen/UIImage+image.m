//
//  UIImage+image.m
//  GuanJiaLaiLeApp
//
//  Created by LingJi on 16/5/26.
//  Copyright © 2016年 ZOE. All rights reserved.
//

#import "UIImage+image.h"

@implementation UIImage (image)
+(instancetype)imageWithOriginalName:(NSString *)imageName{
    UIImage *image=[UIImage imageNamed:imageName];

    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

}
@end
