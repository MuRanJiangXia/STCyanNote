//
//  ListNoteHeaderView.m
//  STCyanNote
//
//  Created by cyan on 2017/6/12.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import "ListNoteHeaderView.h"
@interface ListNoteHeaderView ()<UITextFieldDelegate>

@end
@implementation ListNoteHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, MainScreenWidth , 35)];
    //    imageView.backgroundColor = [UIColor yellowColor];
    imageView.image = [UIImage imageNamed:@"bg_searchbar_n_iphone6"];
    [self.contentView addSubview:imageView];
    
    
    
    UITextField *textField  = [[UITextField alloc]initWithFrame:CGRectMake(50, 5, MainScreenWidth -100, 35)];
    //    textField.placeholder = @"快速搜索关键字";
    //    textField.backgroundColor = [UIColor whiteColor];
    
    NSMutableParagraphStyle *style = [textField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    
    style.minimumLineHeight = textField.font.lineHeight - (textField.font.lineHeight - [UIFont systemFontOfSize:10.0].lineHeight) / 2.0;
    
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"快速搜索关键字"
                                                                      attributes:
                                       @{
                                         
                                         NSForegroundColorAttributeName: CYRGBColor(194, 178, 160),
                                         
                                         NSFontAttributeName : [UIFont systemFontOfSize:13.0],
                                         
                                         NSParagraphStyleAttributeName : style
                                         
                                         }];
    
    [self.contentView addSubview:textField];
    //更改光标
    textField.tintColor = CYRGBColor(96, 18, 0);
    textField.textColor = CYRGBColor(96, 18, 0);
    
    textField.delegate = self;
    
    textField.returnKeyType = UIReturnKeySearch;
    
    [textField addTarget:self action:@selector(chageValue:) forControlEvents:UIControlEventEditingChanged];
}

-(void)chageValue:(UITextField *)textField{
    
    if ([self.listNoteHeaderDelegate respondsToSelector:@selector(searchNote:)]) {
        [self.listNoteHeaderDelegate searchNote:textField.text];
    }
    NSLog(@"text : %@",textField.text);
}
#pragma mark UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        
        if ([self.listNoteHeaderDelegate respondsToSelector:@selector(searchNote:)]) {
            [self.listNoteHeaderDelegate searchNote:textField.text];
        }
    }
    
    return YES;
}



@end
