//
//  DBAccess.m
//  Cyanfmb
//
//  Created by liran on 16/5/17.
//  Copyright © 2016年 liran. All rights reserved.
//

#import "DBAccess.h"
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "NoteModel.h"

#define  databaseName @"user.sqlite"

static DBAccess *instace = nil;

@implementation DBAccess
+(instancetype) shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instace = [[self alloc]init ];
        [instace copyDatabseTolcolFile];
    });
    return instace;
}


//新建路径
-(NSString *)databasePath{
    NSString *descPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", databaseName]];
    return descPath;
}


//拷贝sqlite 文件
-(void)copyDatabseTolcolFile{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //首先判断，当前路径下是否含有数据库文件
    
    BOOL isExsit = [manager fileExistsAtPath:[self databasePath]];
    
    if (!isExsit) {
        
        //不存在 把数据库文件从程序包中拷贝到沙盒路径下
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"user" ofType:@"sqlite"];
        NSError *error  =  nil;
        BOOL isSuccess =  [manager copyItemAtPath:filePath toPath:[self databasePath] error:&error];
        
        if ( isSuccess) {
            //拷贝成功
            [self creatUserTable];
            
        }else{
            //拷贝失败
            NSLog(@"拷贝失败%@",error);
            
        }
        
    }
    
    
    
}

-(void)creatUserTable{
    sqlite3 *database = nil;
    
    //1.打开数据库
    /**
     数据库的文件路径 const char *filename c语言中的字符串
     // 数据库句柄 ---> 对象指针
     */
    //判断一下返回值,如果返回值是
    if (sqlite3_open([[self databasePath] UTF8String], &database) != SQLITE_OK) {
        //打开失败
        NSLog(@"打开数据库失败");
        return;
    }

    /**
     时间 ，文本内容， 图片（可以为空）, 是否收藏
     */
    
    //2.打开数据库成功，准备sql  字符串中 \后 可以换行 integer text
    NSString *sql = @"create table user ( id integer primary key,\
    noteTitle text not null,\
    noteTime text not null,\
    note text not null,\
    isCollectioned boolean not null,\
    noteImage blob\
    )";
    
    
    //    int sqlite3_exec(
    //     sqlite3*,                                  /* An open database */
    //   const char *sql,                           /* SQL to be evaluated */
    //   int (*callback)(void*,int,char**,char**),  /* Callback function */
    //  void *,                                    /* 1st argument to callback */
    //   char **errmsg                              /* Error msg written here */
    
    //执行sql语句
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL) != SQLITE_OK) {
        NSLog(@"创建image表失败");
        return;
    }
    //关闭数据库
    sqlite3_close(database);

    
}


//使用FMDB插入数据 (一般保存url ，不直接保存数据)
-(void)saveNoteWithFMDB:(NoteModel *)note{
    FMDatabase *database = [[FMDatabase alloc]initWithPath:[self databasePath]];
    
    //1.打开数据库
    [database open];
    if (note.noteId != 0) {//插入到指定的表中
        //编写sql
        NSString *sql = @"insert into user values (?,?,?,?,?,?)";
        
        //写入数据
        [database executeUpdate:sql,[NSString stringWithFormat:@"%d",note.noteId], note.noteTitle,note.noteTime,note.note,note.isCollectioned,note.noteImage];
        
    }else{//插入到最后
        //编写sql
        NSString *sql = @"insert into user values (NULL,?,?,?,?,?)";
        
        //写入数据
        [database executeUpdate:sql, note.noteTitle,note.noteTime,note.note,note.isCollectioned,note.noteImage];
        
    }
    
    //关闭数据
    [database close];
    
    
}
//删除某个
-(BOOL)deleteNote:(NoteModel *)note{
    


    FMDatabase *database = [[FMDatabase alloc]initWithPath:[self databasePath]];
    
    //1.打开数据库
    [database open];
    
    //2,创建语句
    NSString *sqlString = @"delete from user where id = ?";
    
    //写入数据
   int result =  [database executeUpdate:sqlString,[NSString stringWithFormat:@"%d",note.noteId]];
    //关闭数据
    [database close];
    
    return result;
}

//修改某个
-(BOOL)upDateNote:(NoteModel *)note{
//    *isCollectioned;
//    *noteTitle;
//    *noteTime;
//    *note;
//    *noteImage;
    
    FMDatabase *database = [[FMDatabase alloc]initWithPath:[self databasePath]];
    
    //1.打开数据库
    [database open];
    
    //2.创建语句
    NSString *sqlString = @"update user set noteTitle = ?, noteTime = ?, note = ?, isCollectioned = ?, noteImage = ? where id = ?";
    
    //写入数据
   int result =  [database executeUpdate:sqlString,note.noteTitle,note.noteTime, note.note,note.isCollectioned,note.noteImage,[NSString stringWithFormat:@"%d", note.noteId]];
    //关闭数据
    [database close];
    
    return result;
}


//找出所有 数据
-(NSArray *)findAllUsersWithFMDB{
    FMDatabase *database = [[FMDatabase alloc]initWithPath:[self databasePath]];
    
    //打开数据库
    [database open];
    //编写数据库
    //所有数据
//    NSString *sql = @"select * from user u";
//    KEY_ENDTIME ASC 升序
//    KEY_ENDTIME DESC 降序
    NSString *sql = @"select * from user u order by datetime(u.id) DESC";
    FMResultSet *resultSet = [database executeQuery:sql];
    //3
    NSMutableArray *array  = [NSMutableArray array];
    NoteModel *note = nil;
    while (resultSet.next) {
        //索引值是从0开始的.
        note = [[NoteModel alloc]init];
        note.noteId = [resultSet[0] intValue];
        note.noteTitle = resultSet[1];
        note.noteTime = resultSet[2];
        note.note = resultSet[3];
        note.isCollectioned = resultSet[4];
        note.noteImage = resultSet[5];

        [array addObject:note];
    }
    
    return [array copy];
}

//根据id 找数据
-(NoteModel *)findNOteById:(int)noteId{
    
    FMDatabase *database = [[FMDatabase alloc]initWithPath:[self databasePath]];
    
    //打开数据库
    [database open];
    //编写数据库
    NSString *sql = @"select * from user u where u.id = ?";
    
    FMResultSet *resultSet = [database executeQuery:sql,[NSString stringWithFormat:@"%d",noteId ]];
    NSLog(@"columnCount :%d",resultSet.columnCount);
    //3
    NSMutableArray *array  = [NSMutableArray array];
    NoteModel *note = nil;
    while (resultSet.next) {
        //索引值是从0开始的.
        NSLog(@"%@",resultSet[0]);
        note = [[NoteModel alloc]init];
        note.noteTitle = resultSet[1];
        note.noteTime = resultSet[2];
        note.note = resultSet[3];
        [array addObject:note];
    }

    return note;
}
/**
 表中插入新的一列
 */

-(void)addColumn:(NSString *)columnName byTable:(NSString *)tableName type:(NSString *)type {
    
    [self isHaveColumn];
//    alter table table add column l列名 数据类型
    FMDatabase *database = [[FMDatabase alloc]initWithPath:[self databasePath]];
    
    //1.打开数据库
    [database open];
    
    /**
     先判断 是是否存在 这个表
     */
    
    /**
     blob data 类型
     text string类型
     integer int类型
     */
    if (![database columnExists:columnName inTableWithName:tableName]){
        //2.创建语句
        //表名  字段名  类型名
        NSString *sqlString = [NSString stringWithFormat:@"alter table %@ add column %@ %@",tableName,columnName,type];
        
        //写入数据
        int reslut =   [database executeUpdate:sqlString];
        
        NSLog(@"%d",reslut);
    }else{
        
        NSLog(@"存在这个字段");
    }

    //关闭数据
    [database close];
    

}

/**
 表中删除新的一列
 */

-(void)deleteColumn{
    
    [self isHaveColumn];
    //    alter table table add column l列名 数据类型
    FMDatabase *database = [[FMDatabase alloc]initWithPath:[self databasePath]];
    
    //1.打开数据库
    [database open];
    
    /**
     先判断 是是否存在 这个表
     */
    
    //2.创建语句
    NSString *sqlString = @"alter table user delete column qing";
    
    //写入数据
    int reslut =   [database executeUpdate:sqlString];
    //    int result =  [database executeUpdate:sqlString,note.note,note.noteName, note.noteTime, [NSString stringWithFormat:@"%d", note.noteId]];
    NSLog(@"%d",reslut);
    //关闭数据
    [database close];
    
    
}


//*******************************************************

//EGO 不支持多线程
// FMDB 支持多线程
// 支持一边写一边读取
- (void) createaImageTable {
    sqlite3 *database = nil;
    
    //1.打开数据库
    /**
     数据库的文件路径 const char *filename c语言中的字符串
     // 数据库句柄 ---> 对象指针
     */
    //判断一下返回值,如果返回值是
    if (sqlite3_open([[self databasePath] UTF8String], &database) != SQLITE_OK) {
        //打开失败
        NSLog(@"打开数据库失败");
        return;
    }
#warning blob 将image 用二进制保存
    //2.打开数据库成功,准备sql blob 将image 用二进制保存
    NSString *sql = @"create table image (id integer primary key,\
    name text not null,\
    image blob not null \
    )";
    
    
    //    int sqlite3_exec(
    //     sqlite3*,                                  /* An open database */
    //   const char *sql,                           /* SQL to be evaluated */
    //   int (*callback)(void*,int,char**,char**),  /* Callback function */
    //  void *,                                    /* 1st argument to callback */
    //   char **errmsg                              /* Error msg written here */
    
    //执行sql语句
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL) != SQLITE_OK) {
        NSLog(@"创建image表失败");
        return;
    }
    //关闭数据库
    sqlite3_close(database);
}

//使用FMDB插入数据 (一般保存url ，不直接保存数据)
-(void)saveImageWithFMDB:(NSData *)data{
    FMDatabase *database = [[FMDatabase alloc]initWithPath:[self databasePath]];
    
    //1.打开数据库
    [database open];
    
    //编写sql
    NSString *sql = @"insert into image values (NULL,?,?)";
    
    //写入数据
    [database executeUpdate:sql ,@"bus",data];
    //关闭数据
    [database close];
    
    
}

//找出数据
-(NSArray *)findImageWithFMDB{
    FMDatabase *database = [[FMDatabase alloc]initWithPath:[self databasePath]];
    
    //打开数据库
    [database open];
    //编写数据库
    NSString *sql = @"select * from image";
    
    
    FMResultSet *resultSet = [database executeQuery:sql];
    
    //
    NSMutableArray *array  = [NSMutableArray array];
    while (resultSet.next) {
        
        //索引值是从0开始的.
        //        NSData *imageData = [resultSet dataForColumn:@"image"];
        NSData *imageData = [resultSet dataForColumnIndex:2];
        
        [array addObject:imageData];
    }
    
    return [array copy];
}


/**
 判断某个列 是否存在
 */
-(void)isHaveColumn{
    
    
    FMDatabase *database = [[FMDatabase alloc]initWithPath:[self databasePath]];
    
    //1.打开数据库
    [database open];
    
    
    /**
     先判断 是是否存在 这个表
     */
    
    //2.创建语句
    NSString *sqlString = @"select * from user";
    
    //写入数据
    int reslut =   [database executeUpdate:sqlString];

    NSLog(@"%d",reslut);
    //关闭数据
    [database close];
}
/**
 判断 是否存在 某个表
 */
- (int)isExistTable:(NSString *)tableName
{
    NSString *name =nil;
    int isExistTable =0;
    FMDatabase *database = [[FMDatabase alloc]initWithPath:[self databasePath]];
    if ([database open]) {
        NSString * sql = [[NSString alloc]initWithFormat:@"select name from sqlite_master where type = 'table' and name = '%@'",tableName];
        FMResultSet * rs = [database executeQuery:sql];
        while ([rs next]) {
            name = [rs stringForColumn:@"name"];
            
            if ([name isEqualToString:tableName])
            {
                isExistTable =1;
            }
        }
        [database close];
    }
    return isExistTable;
}
@end
