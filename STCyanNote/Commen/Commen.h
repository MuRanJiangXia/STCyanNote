//
//  Commen.h
//  CloudTiger
//
//  Created by cyan on 16/9/5.
//  Copyright © 2016年 cyan. All rights reserved.
//

#ifndef Commen_h
#define Commen_h

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s中%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],[[[NSString stringWithUTF8String:__FUNCTION__] lastPathComponent] UTF8String] ,__LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(FORMAT, ...) nil
#endif


#define STATE_BAR_BLACK [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault]

#define STATE_BAR_WHITE [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

#define CYRGBColor(R,G,B) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:1]
#define COMMANDCOLOR GJLLColor(51, 15, 75)
//屏幕尺寸
#define ISIPHONE3_5  CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE4_0  CGSizeEqualToSize(CGSizeMake(320, 568), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE4_7  CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE5_5  CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size)
// 屏幕宽度
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height

/** 用十六进制创建颜色*/
#define UIColorFromRGB(rgbValue, alp)                                                                                                      \
[UIColor colorWithRed:((float) ((rgbValue & 0xFF0000) >> 16)) / 255.0                                                                  \
green:((float) ((rgbValue & 0x00FF00) >> 8)) / 255.0                                                                   \
blue:((float) (rgbValue & 0x0000FF)) / 255.0                                                                          \
alpha:(float) alp]

//是否为空或是[NSNull null]
#define NotNilAndNull(_ref) (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) count] == 0))

#define CommFont12 [UIFont systemFontOfSize:12]

#define CommFont13 [UIFont systemFontOfSize:13]

#define CommFont14 [UIFont systemFontOfSize:14]

//常用颜色
#define BlueColor UIColorFromRGB(0x00aaee, 1)

//UIColorFromRGB(0x5bb85d, 1) 浅绿色 | UIColorFromRGB(0x27A005, 1) 深绿色
#define GreenColor UIColorFromRGB(0x5bb85d, 1)

#define RedColor UIColorFromRGB(0xE52A2A, 1)

#define OrangeColor UIColorFromRGB(0xFF5B11, 1)

#define PinkColor UIColorFromRGB(0xFF7682, 1)


#define PaleColor UIColorFromRGB(0xF5F5F9, 1)

#define GrayColor UIColorFromRGB(0xA3A3A3, 1)

#define BlackColor UIColorFromRGB(0x727272, 1)

#define CYSrceenHight   667.0f;
#define CYSrceenWidth   375.0f;
#define CYAdaptationH(x) x/667.0f*[[UIScreen mainScreen]bounds].size.height
#define CYAdaptationW(x) x/375.0f*[[UIScreen mainScreen]bounds].size.width
#define CYAdapationLabelFont(n) n*([[UIScreen mainScreen]bounds].size.width/375.0f)

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

/** 支付宝 微信 二维码扫描功能 */
enum PayState{
    kAllPay   = 0,//所有的权限都有
    kAliPay   =  10,//只有支付宝扫码
    kWXPay   =  20,//只有微信扫码
    kNoPay  = 30 ,//没有扫码功能
};




#endif /* Commen_h */
