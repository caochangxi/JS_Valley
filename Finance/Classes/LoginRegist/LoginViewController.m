//
//  LoginViewController.m
//  Finance
//
//  Created by HuMin on 15/4/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "RegistViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "BindPhoneViewController.h"
#import "ApplyViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textUser;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *leftLine;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLine;
@property (weak, nonatomic) IBOutlet UIButton *weChatButton;
@property (weak, nonatomic) IBOutlet UIButton *QQButton;
@property (weak, nonatomic) IBOutlet UIButton *weiBoButton;
@property (strong, nonatomic) NSString *isFull;

@end

@implementation LoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        self.title = @"登录/注册";
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self addAutoLayout];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:KEY_PHONE]){
        self.textUser.text = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_PHONE];
    }
}

- (void)initView
{
    self.navigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = Color(@"efeeef");

    self.textUser.font = FontFactor(16.0f);
    self.textUser.textColor = Color(@"161616");

    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, MarginFactor(12.0f), MarginFactor(55.0f))];
    self.textUser.leftView = leftView;
    self.textUser.leftViewMode = UITextFieldViewModeAlways;

    self.textUser.placeholder = @"请输入手机号";
    [self.textUser setValue:Color(@"afafaf") forKeyPath:@"_placeholderLabel.textColor"];
    [self.textUser setValue:FontFactor(16.0f) forKeyPath:@"_placeholderLabel.font"];

    self.introduceLabel.font = FontFactor(12.0f);
    self.introduceLabel.textColor = Color(@"989898");

    self.nextButton.titleLabel.font = FontFactor(16.0f);

    self.middleLabel.textColor = Color(@"9d9d9d");
    self.middleLabel.font = FontFactor(13.0f);
}


- (void)addAutoLayout
{
    self.textUser.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));

    self.introduceLabel.sd_layout
    .topSpaceToView(self.textUser, MarginFactor(10.0f))
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);

    self.nextButton.sd_layout
    .topSpaceToView(self.textUser, MarginFactor(181.0f))
    .leftEqualToView(self.introduceLabel)
    .rightEqualToView(self.introduceLabel)
    .heightIs(MarginFactor(40.0f));

    CGFloat margin = 0.0f;
    CGSize size = self.weChatButton.currentImage.size;
    if(![WXApi isWXAppInstalled]){
        self.weChatButton.hidden = YES;
        margin = ceilf((SCREENWIDTH - 2 * size.width) / 3.0f);

        self.QQButton.sd_layout
        .bottomSpaceToView(self.view, MarginFactor(50.0f))
        .leftSpaceToView(self.view, margin)
        .widthIs(size.width)
        .heightIs(size.height);

        self.weiBoButton.sd_layout
        .centerYEqualToView(self.QQButton)
        .leftSpaceToView(self.QQButton, margin)
        .widthIs(size.width)
        .heightIs(size.height);

    } else{
        margin = ceilf((SCREENWIDTH - 3 * size.width) / 4.0f);

        self.QQButton.sd_layout
        .bottomSpaceToView(self.view, MarginFactor(50.0f))
        .centerXEqualToView(self.view)
        .widthIs(size.width)
        .heightIs(size.height);

        self.weChatButton.sd_layout
        .centerYEqualToView(self.QQButton)
        .rightSpaceToView(self.QQButton, margin)
        .widthIs(size.width)
        .heightIs(size.height);

        self.weiBoButton.sd_layout
        .centerYEqualToView(self.QQButton)
        .leftSpaceToView(self.QQButton, margin)
        .widthIs(size.width)
        .heightIs(size.height);
    }

    self.middleLabel.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(self.QQButton, MarginFactor(21.0f))
    .autoHeightRatio(0.0f);
    [self.middleLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.leftLine.sd_layout
    .rightSpaceToView(self.middleLabel, MarginFactor(14.0f))
    .centerYEqualToView(self.middleLabel)
    .widthIs(MarginFactor(125.0f))
    .heightIs(0.5f);

    self.rightLine.sd_layout
    .leftSpaceToView(self.middleLabel, MarginFactor(14.0f))
    .centerYEqualToView(self.middleLabel)
    .widthIs(MarginFactor(125.0f))
    .heightIs(0.5f);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark =============  Button Action =============

-(void)actionRegist:(id)sender
{
    NSLog(@"regist");
    RegistViewController *vc = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)actionLogin:(id)sender
{
    NSLog(@"login");
    if (IsStrEmpty(_textUser.text)) {
        [Hud showMessageWithText:@"手机号码不能为空"];
        return;
    }
    if (![_textUser.text isValidateMobile]) {
        [Hud showMessageWithText:@"手机号码不合法"];

        return;
    }
    [Hud showWait];
    [self login];
}

- (IBAction)thirdPartyLog:(id)sender
{
    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    [ShareSDK cancelAuthorize:SSDKPlatformSubTypeQZone];
    UIButton *button =(UIButton*)sender;
    SSDKPlatformType type = SSDKPlatformTypeUnknown;
    NSString *loginType = @"";
    switch (button.tag) {
        case 1000:
            type = SSDKPlatformTypeSinaWeibo;
            loginType = @"weibo";
            break;
        case 1001:
            type= SSDKPlatformTypeWechat;
            loginType = @"weixin";
            break;
        case 1002:
            type = SSDKPlatformSubTypeQZone;
            loginType = @"qq";
            break;
        default:
            break;
    }
    [Hud showWait];
    [ShareSDK getUserInfo:type onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        [Hud hideHud];
        if (user){
            [Hud showWait];
            __weak typeof(self) weakSelf = self;
            NSString *channelId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_CHANNELID];
            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_USERID];
            NSDictionary *param = @{@"loginNum":user.uid, @"loginType":loginType, @"ctype":@"iPhone", @"os":@"iOS", @"osv":[UIDevice currentDevice].systemVersion, @"appv":LOCAL_Version, @"yuncid":channelId?:@"", @"yunuid":userId?:@"", @"phoneType":[SHGGloble sharedGloble].platform};

            [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"thirdLogin/isThirdLogin"] class:nil parameters:param success:^(MOCHTTPResponse *response){
                [Hud hideHud];
                NSString *isthirdlogin = response.dataDictionary[@"isthirdlogin"];
                NSString *uid = response.dataDictionary[@"uid"];
                NSString *token = response.dataDictionary[@"token"];
                NSString *state = response.dataDictionary[@"state"];
                NSString *name = response.dataDictionary[@"name"];
                NSString *head_img = response.dataDictionary[@"head_img"];
                NSString *pwd = response.dataDictionary[@"pwd"];
                NSString *area = response.dataDictionary[@"area"];
                weakSelf.isFull = response.dataDictionary[@"isfull"];
                [[NSUserDefaults standardUserDefaults] setObject:uid forKey:KEY_UID];
                [[NSUserDefaults standardUserDefaults] setObject:user.uid forKey:KEY_THIRDPARTY_UID];
                [[NSUserDefaults standardUserDefaults] setObject:weakSelf.isFull forKey:KEY_ISFULL];
                [[NSUserDefaults standardUserDefaults] setObject:loginType forKey:KEY_THIRDPARTY_TYPE];
                [[NSUserDefaults standardUserDefaults] setObject:state forKey:KEY_AUTHSTATE];
                [[NSUserDefaults standardUserDefaults] setObject:name forKey:KEY_USER_NAME];
                [[NSUserDefaults standardUserDefaults] setObject:area forKey:KEY_USER_AREA];
                [[NSUserDefaults standardUserDefaults] setObject:head_img forKey:KEY_HEAD_IMAGE];
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey: KEY_AUTOLOGIN];
                [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:KEY_PASSWORD];
                [[NSUserDefaults standardUserDefaults] synchronize];

                if ([isthirdlogin isEqualToString:@"false"]){
                    BindPhoneViewController *bindViewCon =[[BindPhoneViewController alloc]init];
                    [weakSelf.navigationController pushViewController:bindViewCon animated:YES];
                } else{
                    [weakSelf registerToken];
                }

            } failed:^(MOCHTTPResponse *response) {
                [Hud hideHud];
                [Hud showMessageWithText:response.errorMessage];
            }];

        }
    }];
}

- (void)registerToken
{
    [Hud showWait];
    NSString *channelId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_CHANNELID];
    NSString *uid =  [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];

    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_TOKEN];
    NSDictionary *param = @{@"uid":uid, @"t":token?:@"", @"channelid":channelId?:@"", @"channeluid":@"getui"};
    __weak typeof(self) weakSelf = self;

    [[SHGGloble sharedGloble] registerToken:param block:^(BOOL success, MOCHTTPResponse *response) {
        if (success) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                [weakSelf chatLoagin];
                [weakSelf loginSuccess];
            }
        } else{
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }
    }];
}


- (void)login
{
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"login",@"validate"] class:[LoginObj class] parameters:@{@"phone":self.textUser.text}success:^(MOCHTTPResponse *response){

        [[NSUserDefaults standardUserDefaults] setObject:self.textUser.text forKey:KEY_PHONE];
        [Hud hideHud];
        NSLog(@"%@",response.dataDictionary);
        NSLog(@"%@",response);
        NSString *state = response.dataDictionary[@"state"];
        if ([state boolValue]){
            LoginNextViewController *vc = [[LoginNextViewController alloc] initWithNibName:@"LoginNextViewController" bundle:nil];
            vc.phone = self.textUser.text;
            vc.rid = self.rid;
            [self.navigationController pushViewController:vc animated:YES];
        } else{
            //未注册;
            RegistViewController *vc = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
            vc.phoneNumber = self.textUser.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failed:^(MOCHTTPResponse *response){
        [Hud hideHud];
        [Hud showMessageWithText:response.errorMessage];
        NSLog(@"%@",response.data);
        NSLog(@"%@",response.errorMessage);

    }];
}

- (void)chatLoagin
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];

    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:uid password:password completion: ^(NSDictionary *loginInfo, EMError *error) {
        if (loginInfo && !error) {
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
            //发送自动登陆状态通知
            //             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            //将旧版的coredata数据导入新的数据库
            EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
            if (!error) {
                error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
            }

            [[ApplyViewController shareController] loadDataSourceFromLocalDB];

        } else{
            switch (error.errorCode){
                case EMErrorServerNotReachable:
                    NSLog(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                    break;
                case EMErrorServerAuthenticationFailure:
                    break;
                case EMErrorServerTimeout:
                    NSLog(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                    break;
                default:
                    break;
            }
        }
    } onQueue:nil];
}

- (void)loginSuccess
{
    [[AppDelegate currentAppdelegate] moveToRootController:self.rid];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textUser resignFirstResponder];
}

@end
