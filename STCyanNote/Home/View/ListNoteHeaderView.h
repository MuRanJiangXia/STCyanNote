//
//  ListNoteHeaderView.h
//  STCyanNote
//
//  Created by cyan on 2017/6/12.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ListNoteHeaderDelegate<NSObject>

-(void)searchNote:(NSString *)noteText;

@end
@interface ListNoteHeaderView : UITableViewHeaderFooterView
@property(nonatomic,weak)id<ListNoteHeaderDelegate> listNoteHeaderDelegate;

@end
