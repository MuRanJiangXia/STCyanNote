//
//  DBAccess.h
//  Cyanfmb
//
//  Created by liran on 16/5/17.
//  Copyright © 2016年 liran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModel.h"

@interface DBAccess : NSObject
+(instancetype) shareInstance;

-(void)saveNoteWithFMDB:(NoteModel *)note;

//删除某个
-(BOOL)deleteNote:(NoteModel *)note;

//修改某个
-(BOOL)upDateNote:(NoteModel *)note;

-(NSArray *)findAllUsersWithFMDB;


-(NoteModel *)findNOteById:(int)noteId;


/**
 向表中插入字段
 @param columnName 字段名
 @param tableName 表名
 @param type 字段类型
 */
-(void)addColumn:(NSString *)columnName byTable:(NSString *)tableName type:(NSString *)type;

-(void)deleteColumn;

//图片
- (void) createaImageTable;

-(void)saveImageWithFMDB:(NSData *)data;

-(NSArray *)findImageWithFMDB;

@end
