//
//  ListNoteCell.h
//  STCyanNote
//
//  Created by cyan on 2017/6/12.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoteModel;

@protocol ListNoteDelegate<NSObject>

@required

-(void)cellTapAction:(UITapGestureRecognizer *)tap byIndexPath:(NSIndexPath *)indexPath;

-(void)cellSwipeAction:(UISwipeGestureRecognizer *)swipe byIndexPath:(NSIndexPath *)indexPath;

-(void)cellCollectionByIndexPath:(NSIndexPath *)indexPath;

-(void)cellDeleteByIndexPath:(NSIndexPath *)indexPath;

@optional

-(void)jumpWrightNoteVC:(NoteModel *)noteModel;

@end

@interface ListNoteCell : UITableViewCell

@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,weak)id<ListNoteDelegate>listNoteDelagate;

@property(nonatomic,strong)NoteModel *noteModel;


/**
  删除，刷新view位置

 @param isChoose 是否是删除状态
 */
-(void)reloadView:(BOOL )isChoose;
@end
