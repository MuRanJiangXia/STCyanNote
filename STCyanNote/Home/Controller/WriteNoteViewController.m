//
//  WriteNoteViewController.m
//  STCyanNote
//
//  Created by cyan on 2017/6/12.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import "WriteNoteViewController.h"
#import "NoteModel.h"
#import "CyanTextView.h"
#import "DBAccess.h"

@interface WriteNoteViewController ()<UITextViewDelegate>{
    
    CyanTextView  *_noteTextView;
    UIScrollView *_bgScroll;
    
    //超出的height 包括头 和预留的尾部
    CGFloat  _beyondHeight;
    //根据获取光标位置
    CGFloat _moveHeight;
    
    UIImageView *_imageView;
    
    DBAccess *_dbAccess;
    //时间label
    UILabel *_timeLabel;
    //收藏按钮
    UIButton *_collectonBtn;
}

@end

@implementation WriteNoteViewController
-(void)dealloc{
    
    
    NSLog(@"退款底部视图销毁额");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //收键盘 保存数据
    [_noteTextView resignFirstResponder];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    _dbAccess = [DBAccess shareInstance];
    
    _beyondHeight = 35 + 60;
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    NSLog(@"写 note");
    [self creatNavBtn];
    [self creatContexView];
    [self  loadData];

}


-(void)loadData{
    
    _noteTextView.text = self.noteModel.note;
    _collectonBtn.selected = [self.noteModel.isCollectioned boolValue];
    if (!_noteModel.noteId) {
     _timeLabel.text = [CYTools getYearAndMonthAndDayAndHour];
    }else{
    _timeLabel.text = self.noteModel.noteTime;
    }
 
}

-(void)creatContexView{

    _bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 )];
    _bgScroll.backgroundColor = [UIColor clearColor];
    
    _bgScroll.contentSize = CGSizeMake(MainScreenWidth , 676 -10 + _beyondHeight);
    
    _bgScroll.showsVerticalScrollIndicator = NO;
    
    _bgScroll.bounces  = YES;
//    _bgScroll.pagingEnabled = YES;
    [self.view addSubview:_bgScroll];
    
    //给texview添加一个头
    {
    CGFloat headerHeight = 35;
        
    UIView *textHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, headerHeight)];
    textHeader.backgroundColor = CYRGBColor(247, 243, 234);
    [_bgScroll addSubview:textHeader];
    
        
        
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20 +  4,10 , 80, 15);
//    button.backgroundColor = [UIColor purpleColor];
    [button setTitle:@"全部便签" forState:UIControlStateNormal];
        [button setTitleColor:CYRGBColor(194, 178, 160) forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"detail_button_all"];
    image = [image stretchableImageWithLeftCapWidth:0.6 * image.size.width topCapHeight:0 ];
    [button setBackgroundImage:image forState:UIControlStateNormal];
        
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [textHeader addSubview:button];
     
    
   
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(button.right + 2, 0, 160, headerHeight)];
    _timeLabel.text = @"shijian 10:23:44";
    _timeLabel.textColor = CYRGBColor(194, 178, 160);
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [textHeader addSubview:_timeLabel];

 

    //类型按钮
    UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    typeBtn.frame = CGRectMake(MainScreenWidth - 15  -5 , 12, 11, 11);
    [typeBtn setBackgroundImage:[UIImage imageNamed:@"sinaweibo_accountmanage_drawer"] forState:UIControlStateNormal];
    
    [textHeader addSubview:typeBtn];

    //收藏按钮
    _collectonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectonBtn.frame = CGRectMake(typeBtn.left - 15 - 20, 10, 15, 15);
//    collectonBtn.backgroundColor = [UIColor purpleColor];

    [_collectonBtn setBackgroundImage:[UIImage imageNamed:@"star_big_normal"] forState:UIControlStateNormal];
        
    [_collectonBtn setBackgroundImage:[UIImage imageNamed:@"star_big_selected"] forState:UIControlStateSelected];


    //    [collectonBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [textHeader addSubview:_collectonBtn];
        
    {
        //左侧view
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, headerHeight)];
        view.backgroundColor = CYRGBColor(243, 232, 224);
        [textHeader addSubview:view];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(19, 0, 1, headerHeight)];
        lineV.backgroundColor = CYRGBColor(238, 228, 215);
        [textHeader addSubview:lineV];
        
        UIView *lineH = [[UIView alloc]initWithFrame:CGRectMake(0, 34,MainScreenWidth  ,1 )];
        lineH.backgroundColor = CYRGBColor(238, 228, 215);
        [textHeader addSubview:lineH];
        
        
    }
        
    
    }
    

    
    _noteTextView = [[CyanTextView alloc]initWithFrame:CGRectMake(0, 35, MainScreenWidth,676 -6.3 )];
    _noteTextView.backgroundColor = CYRGBColor(247, 243, 234);

    _noteTextView.textColor = CYRGBColor(96, 18, 0);
    _noteTextView.tintColor =  CYRGBColor(96, 18, 0);
    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont systemFontOfSize:16];
    [_bgScroll addSubview:_noteTextView];
    
    //设置边距
//    _noteTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);

    _noteTextView.scrollEnabled = NO;
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    _noteTextView.typingAttributes = attributes;
    
}
-(void)creatNavBtn{
    //    text_btn_bg_n
    //左侧按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 40);
    //    button.backgroundColor = [UIColor purpleColor];
    
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    button.titleLabel.font = [UIFont  systemFontOfSize:14];
    
    //   btn文字偏左
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //    使文字距离做边框保持10个像素的距离。
    button.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 10);
    
    [self.view addSubview:button];
    [button setTitle:@"列表" forState:UIControlStateNormal];
    [button setBackgroundImage: [self cyStrecthImage:[UIImage imageNamed:@"btn_long_bg_n"]] forState:UIControlStateNormal];
    
    
    UIBarButtonItem *leftBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:button];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -15 + 10;//这个值可以根据自己需要自己调整
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer, leftBarButtonItems];
    
    
    //右侧删除按钮
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 40, 40);
    //    button.backgroundColor = [UIColor purpleColor];
    
    [button2 addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    [button2 setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"btn_camera"] forState:UIControlStateSelected];

//
    [button2 setBackgroundImage: [self cyStrecthImage:[UIImage imageNamed:@"btn_red_bg_n"]] forState:UIControlStateNormal];
    [button2 setBackgroundImage: [self cyStrecthImage:[UIImage imageNamed:@"btn_bg_n"]] forState:UIControlStateSelected];
    
    
    
    //右侧分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 40, 40);
    //    button.backgroundColor = [UIColor purpleColor];
    
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    
    [shareBtn setImage:[UIImage imageNamed:@"btn_send"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"btn_done"] forState:UIControlStateSelected];
    
    [shareBtn setBackgroundImage: [self cyStrecthImage:[UIImage imageNamed:@"btn_bg_n"]] forState:UIControlStateNormal];
    
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc]initWithCustomView:button2];

    
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer2.width = -15 +10;//这个值可以根据自己需要自己调整
    self.navigationItem.rightBarButtonItems = @[ nagetiveSpacer2,shareItem,deleteItem];
    
}
/**拉伸图片*/
-(UIImage *)cyStrecthImage:(UIImage *)image{
    
    //拉伸
    image = [image stretchableImageWithLeftCapWidth:.5 * image.size.width topCapHeight:.5 * image.size.width  ];
    return image;
    
}


-(void)shareAction:(UIButton *)btn{
    
    [_noteTextView resignFirstResponder];

    [self reloadNavBtn:NO];
    NSLog(@"分享");
}
-(void)backAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void)deleteAction:(UIButton *)btn{
    
    NSLog(@"删除");
}

/**编辑状态 改变btn显示*/
-(void)reloadNavBtn:(BOOL)isEdited{
    
    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        UIButton *btn =  (UIButton *)item.customView;
        btn.selected = isEdited;
    }
}

/**插入图片*/
- (void)copyBtnClick{

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:_noteTextView.attributedText];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    textAttachment.image = [UIImage imageNamed:@"150"]; //要添加的图片
    UIImage *image = textAttachment.image;
    NSLog(@" image width : %f,height : %f",image.size.width,image.size.height);
    //获取宽高比例
    CGFloat widthHight =  image.size.height/image.size.width;
    
    textAttachment.bounds = CGRectMake(0, 0, MainScreenWidth, widthHight * MainScreenWidth);
    

    
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
    [string insertAttributedString:textAttachmentString atIndex:0];//index为用户指定要插入图片的位置
//    [string insertAttributedString:textAttachmentString atIndex:_noteTextView.selectedRange.location];//index为用户指定要插入图片的位置
    _noteTextView.attributedText = string;
    
}
#pragma  mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    //    具体的点击效果可以写在这个方法中，最后的返回值为YES，则图片可以被复制、保存，返回值NO则不能，但是都不会影响返回之前的其他操作
    
    NSLog(@"点击了图片");
    return  NO;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //编辑状态 改变btn显示
    [self reloadNavBtn:YES];
    //编辑状态的时候需要解决键盘遮挡问题， bgSrollview frame向上移动
    //添加图片
//    [self copyBtnClick];
//里延时调用一个函数，只要延0.1s，之后再获取光标就正常了
    [self performSelector:@selector(textViewDidChange:) withObject:textView afterDelay:0.1f];

    
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

//    [self performSelector:@selector(loadTextAttri) withObject:nil afterDelay:0.1];
    if ([text isEqualToString:@"\n"]) {
        
//        [self loadTextAttri];

        //获取光标位置
        CGFloat cursorPosition= [textView caretRectForPosition:textView.selectedTextRange.start].origin.y;
    
        if (cursorPosition < _imageView.top) {
            [UIView animateWithDuration:0.1 animations:^{
                
                _imageView.top = _imageView.top + 19.093750 + 10;
              
//                [self reloadImageViewLocation];
                
            } completion:^(BOOL finished) {
                
            }];
        }
        
        
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{

    //获取光标位置
    CGFloat cursorPosition;
    if (textView.selectedTextRange) {
        cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin.y;
    } else {
        cursorPosition = 0;
    }
    _moveHeight = cursorPosition;
    NSLog(@"开始获取 cursorPosition : %f",cursorPosition);
 
//    static CGFloat maxHeight = 667.f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }else{
        // to update NoteView
        [textView setNeedsDisplay];
    }
    
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    NSLog(@"size.height : %f ,contentSize.height :  %f ",size.height,_bgScroll.contentSize.height);
    if (size.height + _beyondHeight >  _noteTextView.contentSize.height) {
//        [self reloadBGScrollView];
         _bgScroll.contentSize = CGSizeMake(MainScreenWidth, size.height + _beyondHeight);
    }


    
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    
    
    /**
     获取textview 的第一行文本
     */

     NSArray *arr   = [CYTools getLinesArrayOfStringInLabel:textView];
    
    
    /**
     两性婚姻，一堂缔约，良缘永结，匹配同称
     看此日桃花灼灼，宜室宜家，卜他年瓜瓞绵绵，尔昌尔炽
     */
    NSString *time =    [CYTools getYearAndMonthAndDayAndHour];
    if (self.noteModel.noteId == 0) {//新建的 note
        if (arr.count==0) {
            return;
        }
        NoteModel *note = [[NoteModel alloc]init];

        note.noteTime = time;
        note.noteTitle = arr[0];
        note.isCollectioned = @"0";
        note.note = textView.text;
        //        note.noteImage = @"";
        [_dbAccess saveNoteWithFMDB:note];
    }else{
        if (arr.count == 0) {//删除
            [_dbAccess deleteNote:self.noteModel];
            
        }else{
            self.noteModel.noteTime = time;
            self.noteModel.noteTitle = arr[0];
            self.noteModel.note = textView.text;
            [_dbAccess upDateNote:self.noteModel];
        }
   
    }

    
}

#pragma mark - 键盘
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    //获取键盘的高度
    /*
     iphone 6:
     中文
     2014-12-31 11:16:23.643 Demo[686:41289] 键盘高度是  258
     2014-12-31 11:16:23.644 Demo[686:41289] 键盘宽度是  375
     英文
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘高度是  216
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘宽度是  375
     
     iphone  6 plus：
     英文：
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘高度是  226
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘宽度是  414
     中文：
     2015-01-07 09:22:49.438 Demo[622:14908] 键盘高度是  271
     2015-01-07 09:22:49.439 Demo[622:14908] 键盘宽度是  414
     
     iphone 5 :
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘高度是  216
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘宽度是  320
     
     ipad Air：
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘高度是  264
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘宽度是  768
     
     ipad2 ：
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘高度是  264
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘宽度是  768
     */

    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
//    NSLog(@"键盘高度是  %d",height);
//    NSLog(@"键盘宽度是  %d",width);
//    NSLog(@"center.y :%f",_bgScroll.center.y);
    [UIView animateWithDuration:0.3 animations:^{
        _bgScroll.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 - height);
        //光标位置加上 导航栏高度 加上头部高度， 如果在键盘下面 减去相对高度
        CGFloat selectedHeight = _moveHeight + 35 + 64 - ( MainScreenHeight - height);
        if ( selectedHeight > 0) {//移动scrollview 使光标永远在键盘上面
            [_bgScroll setContentOffset:CGPointMake(_bgScroll.contentOffset.x, selectedHeight) animated:YES];
            
        
            
        }
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{

    [UIView animateWithDuration:0.3 animations:^{
        _bgScroll.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 );
    }];
    
}


@end
