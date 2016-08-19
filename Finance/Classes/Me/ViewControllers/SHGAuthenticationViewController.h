//
//  SHGAuthenticationViewController.h
//  Finance
//
//  Created by 魏虔坤 on 15/11/17.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SHGAuthenticationBlock)(NSString *state);

@interface SHGAuthenticationViewController : BaseViewController

@property (assign, nonatomic) BOOL shouldForceAuth;
@property (copy, nonatomic) SHGAuthenticationBlock block;

@end
