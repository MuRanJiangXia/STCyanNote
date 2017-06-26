//
//  NoteModel.h
//  STCyanNote
//
//  Created by cyan on 2017/6/12.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject<NSMutableCopying,NSCopying>

//用来判断是否是删除状态
@property(nonatomic,assign)BOOL isDeleted;

@property(nonatomic,copy)NSString *isCollectioned;

@property (nonatomic,assign) int noteId;

@property(nonatomic,copy)NSString *noteTitle;
@property(nonatomic,copy)NSString *noteTime;
@property(nonatomic,copy)NSString *note;
@property(nonatomic,strong)NSData *noteImage;

- (NSArray *) allPropertyNames;
- (id ) displayCurrentModlePropertyBy:(NSString *)propertyName;
@end
