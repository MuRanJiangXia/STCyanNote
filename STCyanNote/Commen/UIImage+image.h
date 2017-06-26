//
//  UIImage+image.h
//  GuanJiaLaiLeApp
//
//  Created by LingJi on 16/5/26.
//  Copyright © 2016年 ZOE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (image)
//instancetype默认会识别当前是哪个类或者对象调用，就会转换成对应的类对象返回

//加载最原始的图片（无渲染）
+(instancetype)imageWithOriginalName:(NSString *)imageName;
@end
