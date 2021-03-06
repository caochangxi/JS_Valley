//
//  SHGBusinessScrollView.h
//  Finance
//
//  Created by changxicao on 16/4/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBusinessScrollViewHeight MarginFactor(42.0f)

@protocol SHGBusinessScrollViewDelegate <NSObject>

- (void)didMoveToIndex:(NSInteger)index;

@end

@interface SHGBusinessScrollView : UIView

+ (instancetype)sharedBusinessScrollView;

@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (assign, nonatomic) id<SHGBusinessScrollViewDelegate>categoryDelegate;

- (NSInteger)currentIndex;
- (NSString *)currentType;
- (NSString *)currentName;
- (NSInteger)indexForName:(NSString *)name;
- (void)moveToIndex:(NSInteger)index;
@end