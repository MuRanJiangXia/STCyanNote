//
//  CYTools.h
//  STCyanNote
//
//  Created by cyan on 2017/6/21.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYTools : NSObject


/** 获取现在都得时间 年-月-日 时分秒*/
+(NSString *)getYearAndMonthAndDayAndHour;

//获取所有行数
+ (NSArray *)getLinesArrayOfStringInLabel:(UITextView *)textView;



@end


