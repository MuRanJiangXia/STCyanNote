//
//  CYTools.m
//  STCyanNote
//
//  Created by cyan on 2017/6/21.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import "CYTools.h"
#import <CoreText/CoreText.h>

@implementation CYTools
/** 获取现在都得时间 年-月-日 时分秒*/
+(NSString *)getYearAndMonthAndDayAndHour{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    yyyy-MM-dd HH:mm:ss:SSS
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *time = [formatter stringFromDate:date];
    return time;
    
}


//获取所有行数
+ (NSArray *)getLinesArrayOfStringInLabel:(UITextView *)textView;{
    NSString *text = [textView text];
    UIFont *font = [textView font];
    CGSize size1 = textView.textContainer.size;
    //需要处理内边距  默认要减去左右的5
    //    UIEdgeInsets insets =  textView.contentInset;
    //    NSLog(@"top : %f,left : %f,bottom : %f,right : %f",insets.top,insets.left,insets.bottom,insets.right);
    
    CGRect rect = CGRectMake(0, 0, size1.width -10, size1.height) ;
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        //NSLog(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}


@end
