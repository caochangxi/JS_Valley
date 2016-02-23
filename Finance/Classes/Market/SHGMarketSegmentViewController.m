//
//  SHGMarketSegmentViewController.m
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketSegmentViewController.h"
#import "SHGMarketSendViewController.h"
#import "SHGMarketSearchViewController.h"
#import "SHGMarketManager.h"
#import "SHGProvincesViewController.h"
#import "SHGMomentCityViewController.h"

@interface SHGMarketSegmentViewController ()
@property (nonatomic, strong) NSArray *rightBarButtonItems;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *titleImageView;
@end

@implementation SHGMarketSegmentViewController
{
    UISegmentedControl *tabButtonsContainerView;
    UIView *contentContainerView;
}
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;


+ (instancetype)sharedSegmentController
{
    static SHGMarketSegmentViewController *sharedGlobleInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobleInstance = [[self alloc] init];
    });
    return sharedGlobleInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    tabButtonsContainerView = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects:@"全部", @"我的", nil]];
    tabButtonsContainerView.frame = CGRectMake(0.0f, 50.0f, 170.0f, 26.0f);;
    tabButtonsContainerView.enabled = YES;
    tabButtonsContainerView.layer.masksToBounds = YES;
    tabButtonsContainerView.layer.cornerRadius = 4;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"d53432"],NSForegroundColorAttributeName,[UIFont systemFontOfSize:kNavBarTitleFontSize],NSFontAttributeName ,nil];

    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:kNavBarTitleFontSize],NSFontAttributeName ,nil];
    //设置标题的颜色 字体和大小 阴影和阴影颜色
    [tabButtonsContainerView setTitleTextAttributes:dic1 forState:UIControlStateNormal];
    [tabButtonsContainerView setTitleTextAttributes:dic forState:UIControlStateSelected];
    tabButtonsContainerView.tintColor = [UIColor clearColor];
    tabButtonsContainerView.layer.borderColor =  [UIColor whiteColor].CGColor;
    tabButtonsContainerView.layer.borderWidth = 1.0;
    UIImage *segImage = [CommonMethod imageWithColor:[UIColor colorWithHexString:@"d53432"] andSize:CGSizeMake(85, 26)];
    UIImage *selectImage = [CommonMethod imageWithColor:[UIColor whiteColor] andSize:CGSizeMake(85, 26)];
    [tabButtonsContainerView setBackgroundImage:segImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    [tabButtonsContainerView setBackgroundImage:selectImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];

    [tabButtonsContainerView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d53432"] andSize:CGSizeMake(85, 26)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];


    tabButtonsContainerView.selected = NO;
    tabButtonsContainerView.selectedSegmentIndex = 0;

    [tabButtonsContainerView addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];

    contentContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    contentContainerView.backgroundColor = [UIColor whiteColor];
    contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:contentContainerView];
    [self reloadTabButtons];

    if(self.block){
        self.block(self.titleButton);
    }
}

- (UIButton *)titleButton
{
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.backgroundColor = [UIColor clearColor];
        [_titleButton addTarget:self action:@selector(moveToProvincesViewController:) forControlEvents:UIControlEventTouchUpInside];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:kNavBarTitleFontSize];
        self.titleLabel.textColor = [UIColor whiteColor];
        [_titleButton addSubview:self.titleLabel];

        self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"market_locationArrow"]];
        [self.titleImageView sizeToFit];
        self.titleImageView.origin = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + 4.0f, (CGRectGetHeight(self.titleLabel.frame) - CGRectGetHeight(self.titleImageView.frame)) / 2.0f);
        [_titleButton addSubview:self.titleImageView];
    }
    return _titleButton;
}

#pragma mark ------变更城市代理

- (void)changeTitleCityName:(NSString *)city
{
    if ([city isEqualToString:@"其他城市"]) {
        city = @"其他";
    }
    if (![city isEqualToString:self.titleLabel.text] && city.length > 0) {
        self.titleButton.frame = CGRectZero;
        self.titleLabel.text = city;
        [self.titleLabel sizeToFit];
        self.titleImageView.origin = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + 4.0f, (CGRectGetHeight(self.titleLabel.frame) - CGRectGetHeight(self.titleImageView.frame)) / 2.0f);
        self.titleButton.size = CGSizeMake(CGRectGetMaxX(self.titleImageView.frame), CGRectGetHeight(self.titleLabel.frame));

        UIViewController *controller = [self.viewControllers firstObject];
        [controller performSelector:@selector(clearAndReloadData) withObject:nil];
    } else if (city.length == 0){
        self.titleLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_AREA];
        [self.titleLabel sizeToFit];
    }
}

- (NSArray *)rightBarButtonItems
{
    if (!_rightBarButtonItems) {
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setTitle:@"发布" forState:UIControlStateNormal];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [sendButton sizeToFit];
        [sendButton addTarget:self action:@selector(addNewMarket:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
        _rightBarButtonItems = @[sendItem];
    }
    return  _rightBarButtonItems;

}

- (UIBarButtonItem *)leftBarButtonItem
{
    if (!_leftBarButtonItem) {
        UIView *leftView = [[UIView alloc] init];
        leftView.userInteractionEnabled = YES;
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"marketSearch"];
        [leftButton setImage:image forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(searchMarket:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton sizeToFit];

        leftView.frame = leftButton.bounds;
        [leftView addSubview:leftButton];
        _leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    }
    return _leftBarButtonItem;
}

- (void)moveToProvincesViewController:(UIButton *)button
{
    SHGMomentCityViewController * controller = [[SHGMomentCityViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)searchMarket:(UIButton *)button
{
    [MobClick event:@"ActionMarketSearchClicked" label:@"onClick"];
    SHGMarketSearchViewController *controller = [[SHGMarketSearchViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)addNewMarket:(UIButton *)button
{
    __weak typeof(self)weakSelf = self;
    [[SHGGloble sharedGloble] requsetUserVerifyStatus:^(BOOL status) {
        if (status) {
            SHGMarketSendViewController *controller = [[SHGMarketSendViewController alloc] init];
            controller.delegate = [SHGMarketSegmentViewController sharedSegmentController];
            [weakSelf.navigationController pushViewController:controller animated:YES];
        } else{
            VerifyIdentityViewController *controller = [[VerifyIdentityViewController alloc] init];
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
    } failString:@"认证后才能发起活动哦～"];
}

- (void)reloadTabButtons
{
    NSUInteger lastIndex = _selectedIndex;
    _selectedIndex = NSNotFound;
    self.selectedIndex = lastIndex;
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
    NSAssert([newViewControllers count] >= 2, @"MHTabBarController requires at least two view controllers");

    UIViewController *oldSelectedViewController = self.selectedViewController;

    // This follows the same rules as UITabBarController for trying to
    // re-select the previously selected view controller.
    NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
    if (newIndex != NSNotFound)
        _selectedIndex = newIndex;
    else if (newIndex < [_viewControllers count])
        _selectedIndex = newIndex;
    else
        _selectedIndex = 0;

    // Remove the old child view controllers.
    for (UIViewController *viewController in _viewControllers)
    {
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
    }

    _viewControllers = [newViewControllers copy];

    // Add the new child view controllers.
    for (UIViewController *viewController in _viewControllers)
    {
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }

    if ([self isViewLoaded])
        [self reloadTabButtons];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
    [self setSelectedIndex:newSelectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
    NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");
    if (![self isViewLoaded]){
        _selectedIndex = newSelectedIndex;
    }
    else if (_selectedIndex != newSelectedIndex){
        UIViewController *fromViewController;
        UIViewController *toViewController;

        if (_selectedIndex != NSNotFound){
            fromViewController = self.selectedViewController;
        }

        NSUInteger oldSelectedIndex = _selectedIndex;
        _selectedIndex = newSelectedIndex;

        if (_selectedIndex != NSNotFound){
            toViewController = self.selectedViewController;
        }

        if (toViewController == nil){  // don't animate
            [fromViewController.view removeFromSuperview];
        } else if (fromViewController == nil){  // don't animate
            dispatch_async(dispatch_get_main_queue(), ^{
                toViewController.view.frame = contentContainerView.bounds;
                [contentContainerView addSubview:toViewController.view];
            });
        } else if (animated){
            CGRect rect = contentContainerView.bounds;
            if (oldSelectedIndex < newSelectedIndex)
                rect.origin.x = rect.size.width;
            else
                rect.origin.x = -rect.size.width;

            toViewController.view.frame = rect;
            tabButtonsContainerView.userInteractionEnabled = NO;

            [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.3 options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect rect = fromViewController.view.frame;
                if (oldSelectedIndex < newSelectedIndex){
                    rect.origin.x = -rect.size.width;
                } else{
                    rect.origin.x = rect.size.width;
                }
                fromViewController.view.frame = rect;
                toViewController.view.frame = contentContainerView.bounds;
            } completion:^(BOOL finished){
                tabButtonsContainerView.userInteractionEnabled = YES;
            }];
        } else{ // not animated
            [fromViewController.view removeFromSuperview];
            toViewController.view.frame = contentContainerView.bounds;
            [contentContainerView addSubview:toViewController.view];
        }
    }
}

- (UIViewController *)selectedViewController
{
    if (self.selectedIndex != NSNotFound)
        return [self.viewControllers objectAtIndex:self.selectedIndex];
    else
        return nil;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
    [self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated;
{
    NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
    if (index != NSNotFound)
        [self setSelectedIndex:index animated:animated];
}

- (void)valueChange:(UISegmentedControl *)seg
{
    [self setSelectedIndex:seg.selectedSegmentIndex animated:YES];
}
#pragma mark ------ 收藏和取消收藏
- (void)addOrDeleteCollect:(SHGMarketObject *)object state:(void(^)(BOOL state))block
{
    __weak typeof(self)weakSelf = self;
    if (!object.isCollection) {
        [SHGMarketManager addCollectWithObject:object finishBlock:^{
            [weakSelf didChangeCollectState:object iscollection:YES];
            object.isCollection = YES;
            if (block) {
                block(YES);
            }
        }];
    } else{
        [SHGMarketManager deleteCollectWithObject:object finishBlock:^{
            [weakSelf didChangeCollectState:object iscollection:NO];
            object.isCollection = NO;
            if (block) {
                block(NO);
            }
        }];
    }

}
- (void)didChangeCollectState:(SHGMarketObject *)object iscollection:(BOOL)iscollection
{
    for (UIViewController *controller in self.viewControllers){
        if ([controller respondsToSelector:@selector(currentDataArray)]) {
            NSMutableArray *array = [controller performSelector:@selector(currentDataArray)];
            for (SHGMarketObject * obj in array){
                if ([object.marketId isEqualToString:obj.marketId]) {
                    obj.isCollection = iscollection;
                }
            }
        }
        [controller performSelector:@selector(reloadData)];
    }
    
}

#pragma mark ------ 点赞和取消点赞
- (void)addOrDeletePraise:(SHGMarketObject *)object block:(void (^)(BOOL success))block
{
    __weak typeof(self)weakSelf = self;
    if ([object.isPraise isEqualToString:@"N"]) {
        [SHGMarketManager addPraiseWithObject:object finishBlock:^(BOOL success) {
            [weakSelf didChangePraiseState:object isPraise:YES];
            if (block) {
                block(success);
            }
        }];
    } else{
        [SHGMarketManager deletePraiseWithObject:object finishBlock:^(BOOL success) {
            [weakSelf didChangePraiseState:object isPraise:NO];
            if (block) {
                block(success);
            }
        }];
    }
}

- (void)didChangePraiseState:(SHGMarketObject *)object isPraise:(BOOL)isPraise
{
    for (UIViewController *controller in self.viewControllers){
        if ([controller respondsToSelector:@selector(currentDataArray)]) {
            NSMutableArray *array = [controller performSelector:@selector(currentDataArray)];
            //可能存在2个对象 在热门列表和自身的列表中
            for (SHGMarketObject * obj in array){
                if ([object.marketId isEqualToString:obj.marketId]) {
                    obj.isPraise = isPraise ? @"Y" : @"N";
                    if (isPraise) {
                        obj.praiseNum = [NSString stringWithFormat:@"%ld",(long)[obj.praiseNum integerValue] + 1];
                    } else{
                        obj.praiseNum = [NSString stringWithFormat:@"%ld",(long)[obj.praiseNum integerValue] - 1];

                    }
                }
            }
        }
        [controller performSelector:@selector(reloadData)];
    }

    NSInteger count = self.navigationController.viewControllers.count;
    if (count >= 1) {
        UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:count - 1];

        if ([NSStringFromClass([controller class]) isEqualToString:@"SHGMarketMineViewController"]) {
            if ([controller respondsToSelector:@selector(currentDataArray)]) {
                NSMutableArray *array = [controller performSelector:@selector(currentDataArray)];
                for (SHGMarketObject * obj in array){
                    if ([object.marketId isEqualToString:obj.marketId]) {
                        obj.isPraise = isPraise ? @"Y" : @"N";
                        if (isPraise) {
                            obj.praiseNum = [NSString stringWithFormat:@"%ld",(long)[obj.praiseNum integerValue] + 1];
                        } else{
                            obj.praiseNum = [NSString stringWithFormat:@"%ld",(long)[obj.praiseNum integerValue] - 1];

                        }
                    }
                }
            }
            [controller performSelector:@selector(reloadData)];
        }
    }

}

- (void)updateToNewestMarket:(SHGMarketObject *)object
{
    //详情界面消失的时候做下数据统计
    for (UIViewController *controller in self.viewControllers){
        if ([controller respondsToSelector:@selector(currentDataArray)]) {
            NSMutableArray *array = [controller performSelector:@selector(currentDataArray)];
            for (SHGMarketObject * obj in array){
                if ([object.marketId isEqualToString:obj.marketId]) {
                    obj.commentNum = object.commentNum;
                    obj.praiseNum = object.praiseNum;
                    obj.isPraise = object.isPraise;
                    obj.isCollection = object.isCollection;
                }
            }
        }
        [controller performSelector:@selector(reloadData)];
    }

    //我的业务被移动到个人中心后 要刷新
    NSInteger count = self.navigationController.viewControllers.count;
    if (count >= 1) {
        UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:count - 1];

        if ([NSStringFromClass([controller class]) isEqualToString:@"SHGMarketMineViewController"]) {
            if ([controller respondsToSelector:@selector(currentDataArray)]) {
                NSMutableArray *array = [controller performSelector:@selector(currentDataArray)];
                for (SHGMarketObject * obj in array){
                    if ([object.marketId isEqualToString:obj.marketId]) {
                        obj.commentNum = object.commentNum;
                        obj.praiseNum = object.praiseNum;
                        obj.isPraise = object.isPraise;
                        obj.isCollection = object.isCollection;
                    }
                }
            }
            [controller performSelector:@selector(reloadData)];
        }
    }
}

- (void)didCreateNewMarket:(SHGMarketFirstCategoryObject *)object
{
    //移动选项 加载更多
    UIViewController *firstController = [self.viewControllers firstObject];
    [firstController performSelector:@selector(scrollToCategory:) withObject:object];
    [firstController performSelector:@selector(refreshHeader) withObject:nil];
    //加载更多
    UIViewController *secondController = [self.viewControllers lastObject];
    [secondController performSelector:@selector(refreshHeader) withObject:nil];
}

- (void)didModifyMarket:(SHGMarketFirstCategoryObject *)object
{
    //移动选项 重新请求
    UIViewController *firstController = [self.viewControllers firstObject];
    if ([firstController isViewLoaded]) {
        [firstController performSelector:@selector(scrollToCategory:) withObject:object];
        [firstController performSelector:@selector(refreshData) withObject:nil];
    }

    //重新请求
    UIViewController *secondController = [self.viewControllers lastObject];
    if ([secondController isViewLoaded]) {
        [secondController performSelector:@selector(refreshData) withObject:object];
    }

    //我的业务被移动到个人中心后 要刷新
    NSInteger count = self.navigationController.viewControllers.count;
    if (count >= 2) {
        UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:count - 2];

        if ([NSStringFromClass([controller class]) isEqualToString:@"SHGMarketMineViewController"]) {
            [controller performSelector:@selector(refreshData) withObject:object];
        }
    }

}

//用户切换用户的时候重新去请求用户数据（仅限我的界面）
- (void)refreshListViewController
{
    //重新请求
    [[SHGMarketManager shareManager] clearAllData];
    UIViewController *controller = [self.viewControllers firstObject];
    [controller performSelector:@selector(refreshData) withObject:nil];

}

- (void)deleteMarket:(SHGMarketObject *)object
{
    DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"确认删除吗?" leftButtonTitle:@"取消" rightButtonTitle:@"删除"];
    alertView.rightBlock = ^{
        [SHGMarketManager deleteMarket:object success:^(BOOL success) {
            //移动选项 重新请求
            UIViewController *firstController = [self.viewControllers firstObject];
            //创建一个分类 让首页去查找到 然后刷新
            SHGMarketFirstCategoryObject *categoryObject = [[SHGMarketFirstCategoryObject alloc] init];
            categoryObject.firstCatalogId = object.firstcatalogid;
            if ([firstController isViewLoaded]) {
                [firstController performSelector:@selector(scrollToCategory:) withObject:categoryObject];
                [firstController performSelector:@selector(refreshData) withObject:object];
            }
            //重新请求
            UIViewController *secondController = [self.viewControllers lastObject];
            if ([secondController isViewLoaded]) {
                [secondController performSelector:@selector(refreshData) withObject:object];
            }
            //我的业务被移动到个人中心后 要刷新
            NSInteger count = self.navigationController.viewControllers.count;
            if (count >= 1) {
                UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:count - 1];

                if ([NSStringFromClass([controller class]) isEqualToString:@"SHGMarketMineViewController"]) {
                    [controller performSelector:@selector(refreshData) withObject:object];
                }
            }
        }];
    };
    [alertView show];

}

- (void)scrollToCategory:(SHGMarketFirstCategoryObject *)object
{

}

- (void)refreshData
{

}

- (void)clearAndReloadData
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    tabButtonsContainerView = nil;
    contentContainerView = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
