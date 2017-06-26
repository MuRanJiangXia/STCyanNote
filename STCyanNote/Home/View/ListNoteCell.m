//
//  ListNoteCell.m
//  STCyanNote
//
//  Created by cyan on 2017/6/12.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import "ListNoteCell.h"
#import "NoteModel.h"
@interface  ListNoteCell(){
    
    //是否侧滑
    BOOL _isLeft;
}

@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)UIButton *leftBtn;

@property(nonatomic,strong)UIButton *deleteBtn;


@property(nonatomic,strong)UILabel *contextLabel;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIButton *collectionBtn;


@end

@implementation ListNoteCell

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
        [self createUI];
        [self setConfigure];

    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUI];
    [self setConfigure];

    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        
        [self setConfigure];
    }
    return self;
}

-(void)setNoteModel:(NoteModel *)noteModel{
    if (_noteModel != noteModel) {
        _noteModel = noteModel;
        [self setNeedsLayout];
    }
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    _contextLabel.text = [ NSString stringWithFormat:@"%@",_noteModel.noteTitle];
    _timeLabel.text = [ NSString stringWithFormat:@"%@",_noteModel.noteTime];
    _collectionBtn.selected = [ _noteModel.isCollectioned integerValue];
    
    if (_noteModel.isDeleted) {
        //变为删除状态
        [self reloadView:YES];
    }else{
        [self reloadView:NO];

    }
    
    BOOL isCollection = [_noteModel.isCollectioned boolValue];
    _collectionBtn.selected = isCollection;
    
}
-(void)createUI{
    self.backgroundColor  = [UIColor clearColor];
   

    CGFloat  cellHeight = 60;


    //删除按钮
    {
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(10, 0, 80, 60);
//    _deleteBtn.backgroundColor = [UIColor purpleColor];
    [_deleteBtn addTarget:self action:@selector(cellDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];

//    bg_iphone6   bg_slider_delete_n
//中间照片 （12，17，48，25）
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"bg_slider_delete_n"]  forState:UIControlStateNormal];
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"bg_slider_delete_p"]  forState:UIControlStateHighlighted];
        
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 +3, 17 , 30, 25)];
//    imageView.backgroundColor = [UIColor blueColor];
    imageView.image = [UIImage imageNamed:@"btn_delete"];
    [_deleteBtn addSubview:imageView];

    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + 5, 0, 30, cellHeight)];
//    label.backgroundColor = [UIColor redColor];
    label.text = @"删除";
        label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [_deleteBtn addSubview:label];

    }
    
    
    //背景试图
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, MainScreenWidth -20, cellHeight)];
    _bgView.backgroundColor = CYRGBColor(247, 243, 234);
    [self.contentView addSubview:_bgView];
    

    
    {
        
        _timeLabel  = [[UILabel alloc]initWithFrame:CGRectMake(20 + 10, 0, 120, 20)];
//        _timeLabel.backgroundColor = [UIColor redColor];
        _timeLabel.text = @"昨天 下午 9:42";
        _timeLabel.textColor = CYRGBColor(194, 178, 160);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:_timeLabel];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        
    }
    
    
    {
        
        _contextLabel  = [[UILabel alloc]initWithFrame:CGRectMake(20 + 10, 20, MainScreenWidth -20 -30 , 40)];
//        _contextLabel.backgroundColor = [UIColor redColor];
        _contextLabel.text = @"也许这一生很短暂，但是我遇到了你，我觉...";
        _contextLabel.textColor = CYRGBColor(96, 18, 0);
        _contextLabel.textAlignment = NSTextAlignmentLeft;
        [_bgView addSubview:_contextLabel];
        _contextLabel.font = [UIFont systemFontOfSize:16];
        
    }
    
    {
        
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionBtn.frame = CGRectMake(MainScreenWidth - 20 -16 -4 , 2, 16, 16);
//        _collectionBtn.backgroundColor = [UIColor purpleColor];
        [_collectionBtn addTarget:self action:@selector(cellConcllectionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_collectionBtn];

        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"star_big_normal"] forState:UIControlStateNormal];
        
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"star_big_selected"] forState:UIControlStateSelected];
    }
    
    
    {
        //左侧view
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, cellHeight)];
        view.backgroundColor = CYRGBColor(243, 232, 224);
        [_bgView addSubview:view];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(19, 0, 1, cellHeight)];
        lineV.backgroundColor = CYRGBColor(238, 228, 215);
        [_bgView addSubview:lineV];
        
        UIView *lineH = [[UIView alloc]initWithFrame:CGRectMake(0, 22,MainScreenWidth -20 ,1 )];
        lineH.backgroundColor = CYRGBColor(238, 228, 215);
        [_bgView addSubview:lineH];
        
        
    }
    
    //夹子
    {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, 0, 24, 54);
//        _leftBtn.backgroundColor = [UIColor purpleColor];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"clip_n"] forState:UIControlStateNormal];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"clip_p"] forState:UIControlStateSelected];
        [self.contentView addSubview:_leftBtn];
        
        
    }

}

//设置侧滑
-(void)setConfigure{
    // 右滑手势
    UISwipeGestureRecognizer *rightSwipe = [[ UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [_bgView addGestureRecognizer:rightSwipe];
    
    
    // 左滑手势
    UISwipeGestureRecognizer *leftSwipe = [[ UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [_bgView addGestureRecognizer:leftSwipe];
    
    
    //轻击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_bgView addGestureRecognizer:tap];
    
    
}

//刷新夹子按钮的显示
-(void)setLeftBtnSelected:(BOOL )isSelected{
    
    _leftBtn.selected = isSelected;
    
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    
//    if (_noteModel.isDeleted) {//侧滑状态 返回
    if ([self.listNoteDelagate respondsToSelector:@selector(cellTapAction:byIndexPath:)]) {
        [self.listNoteDelagate cellTapAction:tap byIndexPath:self.indexPath];
    }

    NSLog(@"轻击手势");
    
}

-(void)swipeAction:(UISwipeGestureRecognizer *)swipe{
    
    //只有向右滑动 且 是初始状态的时候才会 向右滑动 ，否则都是回到初始状态
//    if (swipe.direction == UISwipeGestureRecognizerDirectionRight && !_isLeft) {
    if ([self.listNoteDelagate respondsToSelector:@selector(cellSwipeAction:byIndexPath:)]) {
        [self.listNoteDelagate cellSwipeAction:swipe byIndexPath:self.indexPath];
    }

    NSLog(@"侧滑了");

    }

-(void)cellConcllectionAction:(UIButton *)btn{
    
    NSLog(@"收藏");
    if ([self.listNoteDelagate respondsToSelector:@selector(cellCollectionByIndexPath:)]) {
        [self.listNoteDelagate  cellCollectionByIndexPath:self.indexPath];
    }
    
}

-(void)cellDeleteAction:(UIButton *)btn{
    
    if ([self.listNoteDelagate respondsToSelector:@selector(cellDeleteByIndexPath:)]) {
        [self.listNoteDelagate cellDeleteByIndexPath:self.indexPath];
    }
    NSLog(@"删除");
}


#pragma mark ReloadView

-(void)reloadView:(BOOL )isChoose{
    
    
    [self setLeftBtnSelected:isChoose];
    
    CGFloat x = 10 + 80;
    
    //初始时是 NO
    if (!isChoose) {
        x = 10;
    }
    
    [UIView animateWithDuration:0.2 animations
                               :^{
                                   
     _bgView.frame = CGRectMake(x , 0, _bgView.width, _bgView.height);
                                   
                                   
                               }
                     completion:^(BOOL finished) {
                         
                         
                         
                     }];
    
    
}

@end
