//
//  CyanTextView.m
//  CyanNote
//
//  Created by liran on 16/5/16.
//  Copyright © 2016年 liran. All rights reserved.
//

#import "CyanTextView.h"

@implementation CyanTextView
#define  kViewWidth   self.bounds.size.width
#define  kViewHeight   self.bounds.size.height
-(instancetype)initWithFrame:(CGRect)frame{
    
    
  self=   [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];

//        self.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:16.5];
//        self.font = [UIFont fontWithName:@"Arial" size:16.5f];
    }
    return self;
}



-(void)drawRect:(CGRect)rect{
    //需要在这里设置 文本颜色
    self.textColor = CYRGBColor(96, 18, 0);
    //字体高度
    //根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
//    CGRect rect2 = [self.text boundingRectWithSize:CGSizeMake(300, 999)
//                                              options:NSStringDrawingUsesLineFragmentOrigin
//                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}
//                                              context:nil];
    
    
    //  self.bounds.size.height
    //   self.bounds.size.width
    
    //16号字体 ，字体高度 ：19， 间距 ：10
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat lineHeight = 19.093750 + 10;
//    CGFloat lineHeight =  16 + 10;

    NSUInteger numberOfLines = (self.contentSize.height + self.bounds.size.height) / lineHeight;
//    NSUInteger numberOfLines = (self.contentSize.height + self.bounds.size.height) / self.font.leading;
    //创建一个可变路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置线条颜色
//    CGContextSetRGBFillColor(context, 254/155.0, 201/255.0, 22/155.0, 1);
    CGContextSetStrokeColorWithColor(context, CYRGBColor(238, 228, 215).CGColor);
    //设置线条宽
    CGContextSetLineWidth(context, 1.0);
    
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapRound);
    //第一行+ 4
    for (NSInteger index = 1;index < numberOfLines ; index++) {
        if (index == 1) {
            //设置路径起点
            CGPathMoveToPoint(path, nil, 0, lineHeight  );
            //移动到某一点
            CGPathAddLineToPoint(path, nil, kViewWidth, lineHeight );
        }else{
            //设置路径起点
            CGPathMoveToPoint(path, nil, 0, lineHeight * index );
            
            //移动到某一点
            CGPathAddLineToPoint(path, nil, kViewWidth, lineHeight * index);
        } 
        
        
    }
    //将路径，添加到上下文
    CGContextAddPath(context, path);
    
    //渲染    kCGPathStroke kCGPathFillStroke
    CGContextDrawPath(context, kCGPathStroke);
    
    //释放路径
    CGPathRelease(path);
   
}

//重写父类方法: 改变光标 宽高
- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    CGRect originalRect = [super caretRectForPosition:position];
    
    originalRect.size.height = self.font.lineHeight + 2;
    originalRect.size.width = 1;
    
    return originalRect;
}


@end
