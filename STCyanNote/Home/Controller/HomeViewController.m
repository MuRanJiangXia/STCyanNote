//
//  HomeViewController.m
//  STCyanNote
//
//  Created by cyan on 2017/6/12.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import "HomeViewController.h"
#import "WriteNoteViewController.h"
#import "ListNoteCell.h"
#import "ListNoteHeaderView.h"
#import "NoteModel.h"
#import "DBAccess.h"
#import "RTDragCellTableView.h"


#define  KDeleteNone -1000
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,ListNoteDelegate,RTDragCellTableViewDataSource,RTDragCellTableViewDelegate,ListNoteHeaderDelegate>{
    NSMutableArray *_cellArr;
    //删除状态的的cell
    NSInteger _deleteIndex;
    
    DBAccess *_dbAccess;
}

@property(nonatomic,strong)RTDragCellTableView *table;

@end

@implementation HomeViewController


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    //    self.table.editing = NO;
    [self.view endEditing:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"全部便签";
    _deleteIndex = KDeleteNone;
    [self creatNavBtn];
    
    [self.view addSubview:self.table];
    
    _dbAccess = [DBAccess shareInstance];
    
    
}

-(void)loadData{
    
    
    /**
     isCollectioned
     noteId;
     *note;
     *noteTime;
     *noteName;
     *noteImage;
     
     */
    NSArray *notes =  [_dbAccess findAllUsersWithFMDB];
    
    _cellArr = [NSMutableArray array];
    _cellArr = [notes mutableCopy];
    
    [self.table reloadData];
    
}


-(void)creatNavBtn{
    //    text_btn_bg_n
    //左侧按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    //    button.backgroundColor = [UIColor purpleColor];
    
    [button addTarget:self action:@selector(setBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    [button setImage:[UIImage imageNamed:@"btn_about"] forState:UIControlStateNormal];
    
    UIImage *btnBgImage = [UIImage imageNamed:@"btn_bg_n"];
    //拉伸
    btnBgImage = [btnBgImage stretchableImageWithLeftCapWidth:.5 * btnBgImage.size.width topCapHeight:.5 * btnBgImage.size.width  ];
    [button setBackgroundImage:btnBgImage forState:UIControlStateNormal];
    //    button.size = button.currentBackgroundImage.size;
    
    
    UIBarButtonItem *leftBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:button];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -15 + 10;//这个值可以根据自己需要自己调整
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer, leftBarButtonItems];
    
    
    //右侧按钮
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 40, 40);
    //    button.backgroundColor = [UIColor purpleColor];
    
    [button2 addTarget:self action:@selector(writeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    [button2 setImage:[UIImage imageNamed:@"btn_new"] forState:UIControlStateNormal];
    
    UIImage *btnBgImage2 = [UIImage imageNamed:@"btn_bg_n"];
    //拉伸
    btnBgImage2 = [btnBgImage2 stretchableImageWithLeftCapWidth:.5 * btnBgImage.size.width topCapHeight:.5 * btnBgImage.size.width  ];
    [button2 setBackgroundImage:btnBgImage2 forState:UIControlStateNormal];
    //    button.size = button.currentBackgroundImage.size;
    
    
    UIBarButtonItem *rightBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:button2];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer2.width = -15 +10;//这个值可以根据自己需要自己调整
    self.navigationItem.rightBarButtonItems = @[ nagetiveSpacer2,rightBarButtonItems];
    
}

#pragma mark --- table
-(UITableView *)table{
    if (!_table) {
        _table = [[RTDragCellTableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-64) style:UITableViewStyleGrouped];
        
        //        _table.frame =CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-64);
        
        [_table registerClass:[ListNoteCell class] forCellReuseIdentifier:@"ListNoteCell"];
        [_table registerClass:[ListNoteHeaderView class] forHeaderFooterViewReuseIdentifier:@"ListNoteHeaderView"];
        
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundColor = [UIColor clearColor];
        //去掉头部留白
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
        view.backgroundColor = [UIColor redColor];
        _table.tableHeaderView = view;
        //去掉边线
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.showsVerticalScrollIndicator = YES;
        //        _table.showsHorizontalScrollIndicator = YES;
    }
    return _table;
}
#pragma mark RTDragCellTableViewDelegate
- (NSArray *)originalArrayDataForTableView:(RTDragCellTableView *)tableView{
    return [_cellArr copy];
}

- (void)tableView:(RTDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NoteModel *noteModel in _cellArr) {
        int noteId  = noteModel.noteId;
        [arr addObject:[NSNumber numberWithInt:noteId]];
    }
    
    
    NSMutableArray *cellNewArr = [NSMutableArray array];
    for (NSInteger index = 0; index < newArray.count; index++) {
        
        NoteModel *noteModel = [newArray[index] copy];
        
        NSLog(@"noteId : %d",noteModel.noteId);
        int noteId = [arr[index] intValue];
        
        noteModel.noteId = noteId;
        NSLog(@"noteId2 :%d",noteModel.noteId);
        [_dbAccess upDateNote:noteModel];
        [cellNewArr addObject:noteModel];
    }
    _cellArr = cellNewArr;
    
    //    for (NSInteger index = 0; index < arr.count; index++) {
    //
    //        NoteModel *noteModel2 = newArray[index];
    //        NSLog(@"noteId : %d",noteModel2.noteId);
    //        int noteId = [arr[index] intValue];
    //        //相同的就不更新了
    ////        if (noteId == noteModel2.noteId) {
    ////            return;
    ////        }
    //        noteModel2.noteId = noteId;
    //        NSLog(@"noteId2 :%d",noteModel2.noteId);
    //        [_dbAccess upDateNote:noteModel2];
    //
    ////
    //    }
    //    _cellArr = [newArray mutableCopy];
    
    //
}

/**选中的cell完成移动，手势已松开*/
- (void)cellDidEndMovingInTableView:(RTDragCellTableView *)tableView{
    
    [self loadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _cellArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListNoteCell  *cell =  [tableView dequeueReusableCellWithIdentifier:@"ListNoteCell" forIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.noteModel = _cellArr[indexPath.row];
    cell.listNoteDelagate = self;
    cell.indexPath = indexPath;
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    ListNoteHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ListNoteHeaderView"];
    view.listNoteHeaderDelegate = self;
    //    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}


-(void)setBtnAction:(UIButton *)btn{
    
    NSLog(@"设置");
}

-(void)writeAction:(UIButton *)btn{
    if (_deleteIndex != KDeleteNone) {//之前已经有过一个删除状态了，需要把之前的回到初始状态
        if (_deleteIndex < _cellArr.count) {
            NoteModel *preModel = _cellArr[_deleteIndex];
            preModel.isDeleted = NO;
            NSIndexPath *indexP = [NSIndexPath indexPathForRow:_deleteIndex inSection:0];
            [self.table reloadRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        
    }
    WriteNoteViewController *write = [WriteNoteViewController new];
    write.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:write animated:YES];
}
#pragma mark ListNoteHeaderDelegate

-(void)searchNote:(NSString *)noteText{
    
    NSLog(@"noteText : %@",noteText);
    if (noteText.length) {
        NSArray *arr  =   [_dbAccess findNotesBy:noteText];
        _cellArr = [arr mutableCopy];
        [self.table reloadData];
        NSLog(@"arr : %@",arr);
    }else{
        
        [self loadData];
    }
    
}
#pragma mark  ListNoteDelegate
-(void)jumpWrightNoteVC:(NoteModel *)noteModel{
    WriteNoteViewController *write = [WriteNoteViewController new];
    write.hidesBottomBarWhenPushed = YES;
    write.noteModel = noteModel;
    [self.navigationController pushViewController:write animated:YES];
}


-(void)cellCollectionByIndexPath:(NSIndexPath *)indexPath{
    
    
    NoteModel *note = _cellArr[indexPath.row];
    if ([[NSString stringWithFormat:@"%@",note.isCollectioned] isEqualToString:@"1"]) {//是收藏状态 则为否，反之
        note.isCollectioned = @"0";
    }else{
        note.isCollectioned = @"1";
        
    }
    
    [_dbAccess  upDateNote:note];
    //刷新
    [self loadData];
}
//删除
-(void)cellDeleteByIndexPath:(NSIndexPath *)indexPath{
    
    NoteModel *note = _cellArr[indexPath.row];
    [_dbAccess deleteNote:note];
    
    //刷新
    [self loadData];
    
}

-(void)cellSwipeAction:(UISwipeGestureRecognizer *)swipe byIndexPath:(NSIndexPath *)indexPath{
    
    NoteModel *model = _cellArr[indexPath.row];
    //只有向右滑动 且 是初始状态的时候才会 向右滑动 ，否则都是回到初始状态
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight && !model.isDeleted) {
        if (_deleteIndex != KDeleteNone) {//之前已经有过一个删除状态了，需要把之前的回到初始状态
            
            if (_deleteIndex < _cellArr.count) {
                NoteModel *preModel = _cellArr[_deleteIndex];
                preModel.isDeleted = NO;
                NSIndexPath *indexP = [NSIndexPath indexPathForRow:_deleteIndex inSection:0];
                [self.table reloadRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            
        }
        //初始状态变为删除状态
        
        model.isDeleted = YES;
        _deleteIndex = indexPath.row;
        
    }else{
        //制空
        if (model.isDeleted) {
            _deleteIndex = KDeleteNone;
        }
        //变为初始状态
        model.isDeleted = NO;
        
        
    }
    
    [self.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    NSLog(@"侧滑了");
}
-(void)cellTapAction:(UITapGestureRecognizer *)tap byIndexPath:(NSIndexPath *)indexPath{
    
    
    NoteModel *model = _cellArr[indexPath.row];
    NSLog(@"note : %@",model.note);
    if (model.isDeleted) {//侧滑状态 返回
        //制空
        _deleteIndex = KDeleteNone;
        //变为初始状态
        model.isDeleted = NO;
        [self.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }else{
        if (_deleteIndex != KDeleteNone) {//之前已经有过一个删除状态了，需要把之前的回到初始状态
            
            if (_deleteIndex >= _cellArr.count) {
                return;
            }
            NoteModel *preModel = _cellArr[_deleteIndex];
            preModel.isDeleted = NO;
            NSIndexPath *indexP = [NSIndexPath indexPathForRow:_deleteIndex inSection:0];
            [self.table reloadRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationNone];
            _deleteIndex = KDeleteNone;
            
        }else{
            
            //跳转noteVC
            WriteNoteViewController *write = [WriteNoteViewController new];
            write.hidesBottomBarWhenPushed = YES;
            write.noteModel = model;
            [self.navigationController pushViewController:write animated:YES];
        }
        
        
    }
    
    NSLog(@"点击了");
}

@end
