//
//  TabBarViewController.h
//  DingDCommunity
//
//  Created by HuMin on 14-12-2.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface TabBarViewController : UITabBarController<UINavigationControllerDelegate,IChatManagerDelegate,UIAlertViewDelegate>
{
    NSDictionary *pushInfo;
}

+ (TabBarViewController *)tabBar;
- (void)jumpToChatList;
- (void)setupUntreatedApplyCount;

@property (nonatomic, assign) BOOL isViewLoad;
@end

