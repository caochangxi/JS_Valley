//
//  SHGCompanyDisplayViewController.h
//  Finance
//
//  Created by changxicao on 16/8/11.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "BaseViewController.h"
#import "SHGCompanyObject.h"

@interface SHGCompanyDisplayViewController : BaseTableViewController

@property (strong, nonatomic) NSString *companyName;

@end

@interface SHGCompanyDisplayHeaderView : UIView

@end

@interface SHGCompanyDisplayTableViewCell : UITableViewCell

@property (strong, nonatomic) SHGCompanyObject *object;

@end