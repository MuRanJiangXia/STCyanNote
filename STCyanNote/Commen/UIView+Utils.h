//
//  UIView+Utils.h
//  Petta
//
//  Created by Jiangzhou on 14-3-6.
//  Copyright (c) 2014年 Petta.mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)

// nib loading

+ (id)instanceWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil owner:(id)owner;
- (void)loadContentsWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil;

// hierarchy

- (UIView *)viewMatchingPredicate:(NSPredicate *)predicate;

- (UIView *)viewOfClass:(Class)viewClass;
- (NSArray *)viewsMatchingPredicate:(NSPredicate *)predicate;

- (NSArray *)viewsOfClass:(Class)viewClass;

- (UIView *)firstSuperviewMatchingPredicate:(NSPredicate *)predicate;
- (UIView *)firstSuperviewOfClass:(Class)viewClass;
- (UIView *)firstSuperviewWithTag:(NSInteger)tag;
- (UIView *)firstSuperviewWithTag:(NSInteger)tag ofClass:(Class)viewClass;

- (BOOL)viewOrAnySuperviewMatchesPredicate:(NSPredicate *)predicate;
- (BOOL)viewOrAnySuperviewIsKindOfClass:(Class)viewClass;
- (BOOL)isSuperviewOfView:(UIView *)view;
- (BOOL)isSubviewOfView:(UIView *)view;

- (UIViewController *)firstViewController;
- (UIView *)firstResponder;

// frame accessors

@property(nonatomic, assign) CGPoint origin;
@property(nonatomic, assign) CGSize size;
@property(nonatomic, assign) CGFloat top;
@property(nonatomic, assign) CGFloat left;
@property(nonatomic, assign) CGFloat bottom;
@property(nonatomic, assign) CGFloat right;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;

@property(nonatomic, assign) CGFloat rightPadding;
@property(nonatomic, assign) CGFloat leftPadding;

// bounds accessors

@property(nonatomic, assign) CGSize boundsSize;
@property(nonatomic, assign) CGFloat boundsWidth;
@property(nonatomic, assign) CGFloat boundsHeight;

// content getters

@property(nonatomic, readonly) CGRect contentBounds;
@property(nonatomic, readonly) CGPoint contentCenter;

// additional frame setters

- (void)setLeft:(CGFloat)left right:(CGFloat)right;
- (void)setWidth:(CGFloat)width right:(CGFloat)right;
- (void)setTop:(CGFloat)top bottom:(CGFloat)bottom;
- (void)setHeight:(CGFloat)height bottom:(CGFloat)bottom;

// animation

- (void)crossfadeWithDuration:(NSTimeInterval)duration;
- (void)crossfadeWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion;
// remove all subviews
- (void)removeAllSubviews;

@end
