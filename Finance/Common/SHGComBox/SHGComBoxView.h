//
//  LMComBoxView.h
//  ComboBox
//
//  Created by tkinghr on 14-7-9.
//  Copyright (c) 2014年 Eric Che. All rights reserved.
//  实现下拉框ComBox



#import <UIKit/UIKit.h>
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define kBorderColor [UIColor colorWithRed:219/255.0 green:217/255.0 blue:216/255.0 alpha:1]
#define kTextColor   [UIColor darkGrayColor]

@class SHGComBoxView;
@protocol SHGComBoxViewDelegate <NSObject>

-(void)selectAtIndex:(NSInteger)index inCombox:(SHGComBoxView *)combox;

@end

@interface SHGComBoxView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id<SHGComBoxViewDelegate>delegate;
@property (strong, nonatomic) UIView *parentView;
@property (strong, nonatomic) UIImageView *arrowView;
@property (strong, nonatomic) NSArray *titlesList;
@property (assign, nonatomic) NSInteger defaultIndex;

- (void)reloadData;
- (void)closeOtherCombox;
- (NSInteger)currentIndex;
@end


/*
    注意：
    1.单元格默认跟控件本身的高度一致
 */