//
//  SHGMarketDetailViewController.h
//  Finance
//
//  Created by changxicao on 15/12/12.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SHGMarketObject.h"
#import "MyCollectionViewController.h"

@interface SHGMarketDetailViewController : BaseTableViewController
@property (strong, nonatomic) SHGMarketObject *object;
@property (weak, nonatomic) MyCollectionViewController *controller;
@end
