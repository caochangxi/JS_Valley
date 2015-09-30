//
//  CircleSomeOneViewController.h
//  Finance
//
//  Created by HuMin on 15/4/20.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CircleListTableViewCell.h"
#import "CircleListObj.h"
#import "CircleDetailViewController.h"
#import "ChatViewController.h"
#import "ChatListViewController.h"
@interface CircleSomeOneViewController :BaseTableViewController<CircleListDelegate,BRCommentViewDelegate,circleActionDelegate,UIAlertViewDelegate,circleActionDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSString *userName;

@property (nonatomic, weak)id<circleActionDelegate> delegate;

- (void)smsShareSuccess:(NSNotification *)noti;

@end
