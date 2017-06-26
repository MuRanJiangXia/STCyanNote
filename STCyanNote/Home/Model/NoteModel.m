//
//  NoteModel.m
//  STCyanNote
//
//  Created by cyan on 2017/6/12.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import "NoteModel.h"
#import <objc/runtime.h>

//是否为空或是[NSNull null]
#define NotNilAndNull(_ref) (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) count] == 0))

@implementation NoteModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


- (id)copyWithZone:(NSZone *)zone {
    NoteModel *instance = [[NoteModel allocWithZone:zone] init];
    instance.note = self.note;
    instance.noteId =self.noteId ;
    instance.noteTime = self.noteTime;
    instance.noteImage =self.noteImage ;
    instance.noteTitle = self.noteTitle;
    instance.isCollectioned = self.isCollectioned;
//    NSArray *modelNames =    [self allPropertyNames];
//    for (NSInteger index = 0; index < modelNames.count; index ++) {
//        [instance setValue:[self displayCurrentModlePropertyBy:modelNames[index]] forKey:modelNames[index]];
//    }
//    
    return instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    NoteModel *instance = [[NoteModel allocWithZone:zone] init];
//    NSArray *modelNames =    [self allPropertyNames];
//    for (NSInteger index = 0; index < modelNames.count; index ++) {
//        [instance setValue:[self displayCurrentModlePropertyBy:modelNames[index]] forKey:modelNames[index]];
//    }
    
    instance.note = self.note;
    instance.noteId =self.noteId ;
    instance.noteTime = self.noteTime;
    instance.noteImage =self.noteImage ;
    instance.noteTitle = self.noteTitle;
    instance.isCollectioned = self.isCollectioned;

    return instance;
}

///通过运行时获取当前对象的所有属性的名称，以数组的形式返回
- (NSArray *) allPropertyNames{
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    
    objc_property_t  * propertys = class_copyPropertyList([self class], &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}

#pragma mark -- 通过字符串来创建该字符串的Setter方法，并返回
- (SEL) creatGetterWithPropertyName: (NSString *) propertyName{
    //1.返回get方法: oc中的get方法就是属性的本身
    return NSSelectorFromString(propertyName);
}
//获取
- (id) displayCurrentModlePropertyBy:(NSString *)propertyName{
    //接收返回的值
    NSObject *__unsafe_unretained returnValue = nil;
    //获取get方法
    SEL getSel = [self creatGetterWithPropertyName:propertyName];
    NSLog(@"propertyName : %@",propertyName);
    if ([self respondsToSelector:getSel]) {
        //获得类和方法的签名
        NSMethodSignature *signature = [self methodSignatureForSelector:getSel];
        //从签名获得调用对象
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        //设置target
        [invocation setTarget:self];
        
        //设置selector
        [invocation setSelector:getSel];
        
        //调用
        [invocation invoke];
        
        //获得返回值类型
        const char *returnType = signature.methodReturnType;
        
        //如果没有返回值，也就是消息声明为void，那么returnValue=nil
        if( !strcmp(returnType, @encode(void)) ){
            returnValue =  nil;
        }
        //如果返回值为对象，那么为变量赋值
        else if( !strcmp(returnType, @encode(id)) ){
            [invocation getReturnValue:&returnValue];
        }
        else{
            //如果返回值为普通类型NSInteger  BOOL
            //返回值长度
            NSUInteger length = [signature methodReturnLength];
            //根据长度申请内存
            void *buffer = (void *)malloc(length);
            //为变量赋值
            [invocation getReturnValue:buffer];
            //以下代码为参考:具体地址我忘记了，等我找到后补上，(很对不起原作者)
            if( !strcmp(returnType, @encode(BOOL)) ) {
                returnValue = [NSNumber numberWithBool:*((BOOL*)buffer)];
            }
            else if( !strcmp(returnType, @encode(NSInteger)) ){
                returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
            }else{
                
                returnValue = [NSValue valueWithBytes:buffer objCType:returnType];
                
            }
        }
        
        //
        //        //接收返回值
        //        [invocation getReturnValue:&returnValue];
        
//        NSLog(@"returnValue  : %@",returnValue);
    }
    return  returnValue ;
    
}


@end
