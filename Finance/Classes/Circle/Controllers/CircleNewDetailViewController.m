//
//  CircleNewDetailViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/12/14.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "CircleNewDetailViewController.h"
#import "MLEmojiLabel.h"
#import "LinkViewController.h"
#import "TWEmojiKeyBoard.h"
#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "SHGNavigationView.h"
#import "SHGPersonalViewController.h"
#import "CircleListDelegate.h"
#import "CircleLinkViewController.h"

#define PRAISE_SEPWIDTH     10
#define PRAISE_RIGHTWIDTH     40
#define PRAISE_WIDTH 30.0f
#define kItemMargin 7.0f * XFACTOR


@interface CircleNewDetailViewController ()<MLEmojiLabelDelegate, CircleListDelegate>
{
    UIControl *backView;
    UIView *PickerBackView;
    NSString *copyString;
    NSString *commentRid;
    
}
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIView *viewInput;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPraise;
@property (weak, nonatomic) IBOutlet UIButton *btnNickname;
@property (weak, nonatomic) IBOutlet UIButton *btnCollet;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnPraise;
@property (weak, nonatomic) IBOutlet UIView *viewPraise;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIButton *btnAttention;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lbldepartName;
@property (weak, nonatomic) IBOutlet UILabel *lblCompanyName;
@property (weak, nonatomic) IBOutlet headerView *imageHeader;
@property (strong, nonatomic) BRCommentView *popupView;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (weak,nonatomic) IBOutlet UIView *breakLineView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orignLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkAll;
@property (weak, nonatomic) IBOutlet UIButton *shareFriend;
@property (strong, nonatomic) UILabel * commentNumLabel;
- (IBAction)checkAllMessage:(id)sender;
//- (IBAction)actionAttention:(id)sender;
- (IBAction)actionComment:(id)sender;
- (IBAction)actionPraise:(id)sender;
- (IBAction)actionShare:(id)sender;
- (IBAction)actionCollection:(id)sender;
//- (IBAction)actionGoSome:(id)sender;
//- (IBAction)actionDelete:(id)sender;
- (IBAction)shareFriendSing:(id)sender;
- (IBAction)btnCommentClick:(id)sender;


@end

@implementation CircleNewDetailViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"CircleNewDetailViewController" label:@"onClick"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentNumLabel = [[UILabel alloc]init];
    self.commentNumLabel.backgroundColor = [UIColor redColor];
    self.commentNumLabel.textAlignment = NSTextAlignmentCenter;
    self.commentNumLabel.textColor = [UIColor whiteColor];
    self.commentNumLabel.bounds = CGRectMake(0, 0, 15, 15);
    self.commentNumLabel.layer.masksToBounds = YES;
    self.commentNumLabel.layer.cornerRadius = 7.5;
    self.commentNumLabel.font = [UIFont systemFontOfSize:10];
    self.commentNumLabel.center = CGPointMake(self.btnComment.frame.size.width-5.0, 5.0);
    [self.btnComment addSubview:self.commentNumLabel];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = self.navigationView;
    [CommonMethod setExtraCellLineHidden:self.listTable];
    [self addHeaderRefresh:self.listTable headerRefesh:NO andFooter:NO];
    [Hud showLoadingWithMessage:@"加载中"];
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circledetail"] class:[CircleListObj class] parameters:@{@"rid":self.rid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]} success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        NSLog(@"%@  arr === %@",response.data,response.dataDictionary);
        if (response.dataDictionary) {
            [weakSelf parseObjWithDic:response.dataDictionary];
            [weakSelf loadDatasWithObj:weakSelf.obj];
            [weakSelf detailHomeListShouldRefresh:weakSelf.obj];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:response.errorMessage];
    }];
    
    self.lblContent.numberOfLines = 0;
    //self.lblContent.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblContent.font = [UIFont systemFontOfSize:15.0f];
    //self.lblContent.delegate = self;
    self.lblContent.textColor = [UIColor colorWithHexString:@"606060"];
    self.lblContent.backgroundColor = [UIColor clearColor];
    
    [self initData];
    self.viewHeader.hidden = YES;
    self.listTable.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:self.viewInput];
    
    self.btnSend.layer.masksToBounds = YES;
    self.btnSend.layer.cornerRadius = 4;
    
    DDTapGestureRecognizer *hdGes = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapHeaderView:)];
    [self.viewHeader addGestureRecognizer:hdGes];
    self.viewHeader.userInteractionEnabled = YES;
    
    UIImage *image = self.backImageView.image;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 35.0f, 9.0f, 11.0f) resizingMode:UIImageResizingModeStretch];
    self.backImageView.image = image;
    
    
    CGRect frame = self.lineView.frame;
    frame.size.height = 0.5f;
    self.lineView.frame = frame;
    
    frame = self.btnAttention.frame;
    frame.origin.x *= XFACTOR;
    self.btnAttention.frame = frame;

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)parseObjWithDic:(NSDictionary *)dics
{
    NSDictionary *dic = dics[@"circle"][0];
    NSArray *cmArr = dics[@"comments"];
    if (!IsArrEmpty(cmArr)) {
        self.obj.comments = [NSMutableArray array];
        for (NSDictionary *cmt in cmArr) {
            commentOBj *obj = [[commentOBj alloc] init];
            obj.cdetail = cmt[@"cdetail"];
            obj.cid = cmt[@"cid"];
            obj.cnickname = cmt[@"cnickname"];
            obj.rnickname = cmt[@"rnickname"];
            obj.rid = cmt[@"rid"];
            [self.obj.comments addObject:obj];
        }
        
    }
    self.obj.ispraise = dic[@"ispraise"];
    self.obj.iscollection = dics[@"iscollection"];
    NSArray *heads = dics[@"heads"];
    for (NSDictionary *head in heads) {
        praiseOBj *obj = [[praiseOBj alloc] init];
        obj.pnickname = head[@"pnickname"];
        obj.ppotname = head[@"ppotname"];
        obj.puserid = head[@"puserid"];
        [self.obj.heads addObject:obj];
    }
    
    self.obj.cmmtnum = [NSString stringWithFormat:@"%@",dic[@"cmmtnum"]];
    self.obj.company = dic[@"company"];
    self.obj.detail = dic[@"detail"];
    self.obj.isattention = dic[@"isattention"];
    self.obj.nickname = dic[@"nickname"];
    self.obj.photos = dic[@"attach"];
    self.obj.potname = dic[@"potname"];
    self.obj.praisenum = dic[@"praisenum"];
    self.obj.publishdate = dic[@"publishdate"];
    self.obj.type = dic[@"attachtype"];
    self.obj.rid = dic[@"rid"];
    self.obj.pcurl = dic[@"pcurl"];
    self.obj.sharenum = dic[@"sharenum"];
    self.obj.status = dic[@"status"];
    self.obj.title = dic[@"title"];
    self.obj.userstatus = [dic objectForKey:@"userstatus"];
    self.obj.userid = dic[@"userid"];
    //    self.obj.sizes = dic[@"sizes"];
    NSDictionary *link = dic[@"link"];
    if ([self.obj.type isEqualToString:@"link"]){
        linkOBj *linkObj = [[linkOBj alloc] init];
        linkObj.title = link[@"title"];
        linkObj.desc = link[@"desc"];
        linkObj.thumbnail = link[@"thumbnail"];
        self.obj.linkObj = linkObj;
    }
    
}

- (void)initData
{
    if (!self.obj) {
        self.obj = [[CircleListObj alloc] init];
    }
}


- (void)shareSuccess
{
    self.obj.sharenum = [NSString stringWithFormat:@"%ld",(long)([self.obj.sharenum integerValue] + 1)];
}

- (void)smsShareSuccess:(NSNotification *)noti
{
    id obj = noti.object;
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *rid = obj;
        if ([self.obj.rid isEqualToString:rid]) {
            [self otherShareWithObj:self.obj];
        }
    }
}

- (void)detailHomeListShouldRefresh:(CircleListObj *)obj
{
    NSString *shareNum = obj.sharenum;
    NSString *commentNum =  obj.cmmtnum;
    NSString *praiseNum = obj.praisenum;
    if(![shareNum isEqualToString:[self.itemInfoDictionary objectForKey:kShareNum]] || ![commentNum isEqualToString:[self.itemInfoDictionary objectForKey:kCommentNum]] || ![praiseNum isEqualToString:[self.itemInfoDictionary objectForKey:kPraiseNum]]){
        if(self.delegate && [self.delegate respondsToSelector:@selector(detailHomeListShouldRefresh:)]){
            [self.delegate detailHomeListShouldRefresh:obj];
        }
    }
}

-(void)loadDatasWithObj:(CircleListObj *)obj
{
    self.commentNumLabel.text = obj.cmmtnum;
    self.viewHeader.hidden = NO;
    self.title = obj.nickname;
    self.titleLabel.text = obj.title;
    self.titleLabel.numberOfLines = 0;
    UIFont * tfont = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.font = tfont;
    self.titleLabel.lineBreakMode =NSLineBreakByTruncatingTail ;
    self.titleLabel.text = obj.title ;
   //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    CGSize tsize =CGSizeMake(self.titleLabel.frame.size.width,MAXFLOAT);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize  actualsize =[obj.title boundingRectWithSize:tsize options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    self.titleLabel.frame =CGRectMake(self.titleLabel.frame.origin.x,self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, actualsize.height);
   
    self.orignLabel.text = [NSString stringWithFormat:@"来源： %@  %@",obj.nickname,obj.publishdate];
    self.orignLabel.frame = CGRectMake(self.orignLabel.frame.origin.x, self.titleLabel.frame.origin.y+actualsize.height+5.0, self.orignLabel.frame.size.width, self.orignLabel.frame.size.height);
    self.obj.photoArr = (NSArray *)obj.photos;
    if ([obj.userid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]] || [obj.userid isEqualToString:CHATID_MANAGER]) {
        self.btnAttention.hidden = YES;
    }
    if ([obj.userid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]]){
        self.btnDelete.hidden = NO;
    } else{
        self.btnDelete.hidden = YES;
    }
    
    [self.imageHeader updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.potname] placeholderImage:[UIImage imageNamed:@"default_head"]];
    [self.imageHeader updateStatus:[obj.userstatus isEqualToString:@"true"] ? YES : NO];
    CGRect frame = self.imageHeader.frame;
    self.imageHeader.frame = frame;
    
    [self.shareFriend setImage:[UIImage imageNamed:@"newFreindRing"] forState:UIControlStateNormal];
     self.shareFriend.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 2);
    if (![obj.ispraise isEqualToString:@"Y"]) {
        [self.btnPraise setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    } else{
        [self.btnPraise setImage:[UIImage imageNamed:@"home_yizan"] forState:UIControlStateNormal];
    }
    if (![obj.iscollection isEqualToString:@"Y"]) {
        [self.btnCollet setImage:[UIImage imageNamed:@"uncollected"] forState:UIControlStateNormal];
    } else{
        [self.btnCollet setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateNormal];
    }
    NSString *name = obj.nickname;
    if (obj.nickname.length > 4){
        name = [obj.nickname substringToIndex:4];
        name = [NSString stringWithFormat:@"%@…",name];
    }
    self.btnNickname.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.btnNickname setTitle:name forState:UIControlStateNormal];
    [self.btnNickname setBackgroundImage:[UIImage imageWithColor:BTN_SELECT_BACK_COLOR andSize:self.btnNickname.size] forState:UIControlStateHighlighted];
    
   
    [self.btnPraise setTitle:[NSString stringWithFormat:@"%@人推荐",obj.praisenum] forState:UIControlStateNormal];
    [self.btnSend setImage:[UIImage imageNamed:@"newWriteComment"] forState:UIControlStateNormal];
    self.btnSend.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.btnSend setTitle:@"   写评论" forState:UIControlStateNormal];
    
    if ([obj.isattention isEqualToString:@"Y"]){
        [self.btnAttention setImage:[UIImage imageNamed:@"detail_addationed"] forState:UIControlStateNormal] ;
    } else{
        [self.btnAttention setImage:[UIImage imageNamed:@"detail_addAttation"] forState:UIControlStateNormal];
    }
    
    self.lblContent.text = obj.detail;
    CGSize lsize =CGSizeMake(self.lblContent.frame.size.width,MAXFLOAT);
    
    NSDictionary * ldic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName,nil];
    
    CGSize  lactualsize =[obj.detail boundingRectWithSize:lsize options:NSStringDrawingUsesLineFragmentOrigin  attributes:ldic context:nil].size;
    self.lblContent.frame = CGRectMake(self.lblContent.frame.origin.x, CGRectGetMaxY(self.orignLabel.frame) +10.0, self.lblContent.frame.size.width, lactualsize.height);
    //[self sizeUIWithObj:obj];1.6原来顶部头的view
    
    self.checkAll.frame = CGRectMake(self.checkAll.frame.origin.x, CGRectGetMaxY(self.lblContent.frame)+15.0f, self.checkAll.frame.size.width, self.checkAll.frame.size.height);
    self.checkAll.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    self.btnPraise.frame = CGRectMake(self.btnPraise.frame.origin.x, CGRectGetMaxY(self.checkAll.frame)+14.0f, self.btnPraise.frame.size.width, self.btnPraise.frame.size.height);
    [self.btnPraise.layer setBorderColor:[UIColor colorWithHexString:@"D8D8D8"].CGColor];
    //加边框
    [self.btnPraise.layer setBorderWidth:0.5];
    [self.btnPraise.layer setMasksToBounds:YES];
    self.shareFriend.frame = CGRectMake(self.shareFriend.frame.origin.x, CGRectGetMaxY(self.checkAll.frame)+14.0f, self.shareFriend.frame.size.width, self.shareFriend.frame.size.height);
    [self.shareFriend.layer setBorderColor:[UIColor colorWithHexString:@"D8D8D8"].CGColor];
    [self.shareFriend.layer setBorderWidth:0.5];
    [self.shareFriend.layer setMasksToBounds:YES];
    self.viewPraise.hidden = YES;
    [self.viewHeader setSize:CGSizeMake(self.viewHeader.width, self.btnPraise.bottom+15.0f)];
    [self.listTable reloadData];
}

-(void)cnickClick:(NSInteger)index
{
    commentOBj *obj = self.obj.comments[index];
    [self gotoSomeOneWithId:obj.cid name:obj.cnickname];
    
}
-(void)pushSome:(DDTapGestureRecognizer *)ges
{
    
    praiseOBj *obj = self.obj.heads[ges.tag-1000];
    [self gotoSomeOneWithId:obj.puserid name:obj.pnickname];
    
}
-(void)gotoSomeOneWithId:(NSString *)uid name:(NSString *)name
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    controller.userId = uid;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)rnickClick:(NSInteger)index
{
    commentOBj *obj = self.obj.comments[index];
    [self gotoSomeOneWithId:obj.rid name:obj.rnickname];
}
-(void)replyClick:(NSInteger )index
{
    [self replyClicked:self.obj commentIndex:index];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionComment:(id)sender
{
    [[SHGGloble  sharedGloble] requsetUserVerifyStatus:^(BOOL status) {
        if (status) {
            _popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"comment"];
            _popupView.delegate = self;
            _popupView.fid = @"-1";//评论
            _popupView.tag = 222;
            _popupView.detail = @"";
            _popupView.rid = self.obj.rid;
            [self.navigationController.view addSubview:_popupView];
            [_popupView showWithAnimated:YES];
        } else{
            VerifyIdentityViewController *controller = [[VerifyIdentityViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } failString:@"认证后才能发起评论哦～"];
    
}

#pragma mark -- sdc
#pragma mark -- 评论
- (void)commentViewDidComment:(NSString *)comment rid:(NSString *)rid
{
    [_popupView hideWithAnimated:YES];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
    
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"rid":rid, @"fid":@"-1", @"detail":comment};
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"comments"];
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.data);
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            NSDictionary *dic =response.dataDictionary;
            commentOBj *obj = [[commentOBj alloc] init];
            obj.cnickname = nickName;
            obj.cdetail = comment;
            obj.rid = [dic valueForKey:@"rid"];
            obj.cid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
            [self.obj.comments addObject:obj];
            self.obj.cmmtnum = [NSString stringWithFormat:@"%ld",(long)([self.obj.cmmtnum integerValue] + 1)];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COMMENT_CLIC object:self.obj];
        }
        [self.listTable reloadData];
        [self loadDatasWithObj:self.obj];
        [self.delegate detailCommentWithRid:self.obj.rid commentNum:self.obj.cmmtnum comments:self.obj.comments];
        
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
}

- (void)commentViewDidComment:(NSString *)comment reply:(NSString *) reply fid:(NSString *) fid rid:(NSString *)rid
{
    [_popupView hideWithAnimated:YES];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
    commentOBj *cmntObj= [[commentOBj alloc] init];
    for (commentOBj *cObj in self.obj.comments)
    {
        if ([cObj.cid isEqualToString:fid]) {
            cmntObj = cObj;
            break;
        }
    }
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"rid":rid, @"fid":cmntObj.cid, @"detail":comment};
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"comments"];
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSLog(@"%@",response.data);
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"])
        {
            commentOBj *obj = [[commentOBj alloc] init];
            obj.cnickname = nickName;
            obj.cdetail = comment;
            obj.cid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
            obj.rid = rid;
            obj.rnickname = cmntObj.cnickname;
            [self.obj.comments addObject:obj];
            self.obj.cmmtnum = [NSString stringWithFormat:@"%ld",(long)([self.obj.cmmtnum integerValue] + 1)];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COMMENT_CLIC object:self.obj];
            [MobClick event:@"ActionCommentClick" label:@"onClick"];
        }
        [self.listTable reloadData];
        [self loadDatasWithObj:self.obj];
        [self.delegate detailCommentWithRid:self.obj.rid commentNum:self.obj.cmmtnum comments:self.obj.comments];
        
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
    
}

- (void)replyClicked:(CircleListObj *)obj commentIndex:(NSInteger)index;
{
    [[SHGGloble sharedGloble] requsetUserVerifyStatus:^(BOOL status) {
        if (status) {
            commentOBj *cmbObj = obj.comments[index];
            _popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"reply" name:cmbObj.cnickname];
            _popupView.delegate = self;
            _popupView.fid=cmbObj.cid;//评论
            _popupView.tag = 222;
            _popupView.detail=@"";
            _popupView.rid = obj.rid;
            [self.navigationController.view addSubview:_popupView];
            [_popupView showWithAnimated:YES];
           
        } else{
            VerifyIdentityViewController *controller = [[VerifyIdentityViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } failString:@"认证后才能发起评论哦～"];
    
}

- (IBAction)actionPraise:(id)sender
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"praisesend"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],@"rid":self.obj.rid};
    
    if (![self.obj.ispraise isEqualToString:@"Y"]) {
        [Hud showLoadingWithMessage:@"正在点赞"];
        
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            NSLog(@"%@",response.data);
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                self.obj.ispraise = @"Y";
                self.obj.praisenum = [NSString stringWithFormat:@"%ld",(long)([self.obj.praisenum integerValue] + 1)];
                praiseOBj *obj = [[praiseOBj alloc] init];
                obj.pnickname = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_NAME];
                obj.ppotname = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_HEAD_IMAGE];
                obj.puserid =[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
                [self.obj.heads addObject:obj];
                
                [Hud showMessageWithText:@"赞成功"];
                [MobClick event:@"ActionPraiseClicked_On" label:@"onClick"];
                [self loadDatasWithObj:self.obj];
                [self.listTable reloadData];
                
                [self.delegate detailPraiseWithRid:self.obj.rid praiseNum:self.obj.praisenum isPraised:@"Y"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_PRAISE_CLICK object:self.obj];
            }
            [Hud hideHud];
        } failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }];
        
    } else{
        [Hud showLoadingWithMessage:@"正在取消点赞"];
        [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                self.obj.ispraise = @"N";
                self.obj.praisenum = [NSString stringWithFormat:@"%ld",(long)([self.obj.praisenum integerValue] - 1)];
                for (praiseOBj *obj in self.obj.heads) {
                    if ([obj.puserid isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID]]) {
                        [self.obj.heads removeObject:obj];
                        break;
                    }
                }
                [Hud showMessageWithText:@"取消点赞"];
                [MobClick event:@"ActionPraiseClicked_Off" label:@"onClick"];
                [self loadDatasWithObj:self.obj];
                [self.listTable reloadData];
                
                [self.delegate detailPraiseWithRid:self.obj.rid praiseNum:self.obj.praisenum isPraised:@"N"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_PRAISE_CLICK object:self.obj];
                
            }
            [Hud hideHud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Hud showMessageWithText:error.domain];
            [Hud hideHud];
        }];
    }
}

- (IBAction)actionShare:(id)sender {
    
    id<ISSCAttachment> image  = [ShareSDK pngImageWithImage:[UIImage imageNamed:@"80"]];
    NSString *postContent = @"";
    NSString *shareContent = @"";
    NSString *shareTitle = @"";
    if(IsStrEmpty(self.obj.detail)){
        postContent = SHARE_CONTENT;
        shareTitle = SHARE_TITLE;
        shareContent = SHARE_CONTENT;
    } else{
        postContent = self.obj.detail;
        shareTitle = self.obj.detail;
        shareContent = self.obj.detail;
    }
    if(self.obj.detail.length > 15){
        postContent = [NSString stringWithFormat:@"%@…",[self.obj.detail substringToIndex:15]];
    }
    if(self.obj.detail.length > 15){
        shareTitle = [self.obj.detail substringToIndex:15];
        shareContent = [NSString stringWithFormat:@"%@…",[self.obj.detail substringToIndex:15]];
    }
    NSString *content = [NSString stringWithFormat:@"%@\"%@\"%@%@",@"Hi，我在金融大牛圈上看到了一个非常棒的帖子,关于",postContent,@"，赶快下载大牛圈查看吧！",[NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,self.obj.rid]];
    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"动态" icon:[UIImage imageNamed:@"圈子图标"] clickHandler:^{
        [self circleShareWithObj:self.obj];
    }];
    id<ISSShareActionSheetItem> item2 = [ShareSDK shareActionSheetItemWithTitle:@"圈内好友" icon:[UIImage imageNamed:@"圈内好友图标"] clickHandler:^{
        
        [self shareToFriendWithText:self.obj.detail];
    }];
    
    id<ISSShareActionSheetItem> item3 = [ShareSDK shareActionSheetItemWithTitle:@"短信" icon:[UIImage imageNamed:@"sns_icon_19"] clickHandler:^{
        [self shareToSMS:content rid:self.obj.rid];
    }];
    
    id<ISSShareActionSheetItem> item4 = [ShareSDK shareActionSheetItemWithTitle:@"微信朋友圈" icon:[UIImage imageNamed:@"sns_icon_23"] clickHandler:^{
        [[AppDelegate currentAppdelegate]wechatShare:self.obj shareType:1];
    }];
    
    id<ISSShareActionSheetItem> item5 = [ShareSDK shareActionSheetItemWithTitle:@"微信好友" icon:[UIImage imageNamed:@"sns_icon_22"] clickHandler:^{
        [[AppDelegate currentAppdelegate]wechatShare:self.obj shareType:0];
    }];
    NSArray *shareArray = nil;
    if ([WXApi isWXAppSupportApi]) {
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item3, item5, item4, SHARE_TYPE_NUMBER(ShareTypeQQ), item1, item2, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, item5, item4, item1, item2, nil];
        }
    } else{
        if ([QQApiInterface isQQSupportApi]) {
            shareArray = [ShareSDK customShareListWithType: item3, SHARE_TYPE_NUMBER(ShareTypeQQ), item1, item2, nil];
        } else{
            shareArray = [ShareSDK customShareListWithType: item3, item1, item2, nil];
        }
    }
    
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,self.obj.rid];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent defaultContent:shareContent image:image title:SHARE_TITLE url:shareUrl description:shareContent mediaType:SHARE_TYPE];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:shareArray content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess){
            [self otherShareWithObj:self.obj];
        } else if (state == SSResponseStateFail){
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];
}
- (IBAction)shareFriendSing:(id)sender
{
    [[AppDelegate currentAppdelegate]wechatShare:self.obj shareType:1];
}

- (IBAction)btnCommentClick:(id)sender
{
    [self.listTable scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
    if (self.obj.comments.count > 0 ) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.listTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }else
    {
        [self actionComment:sender];
    }
}
-(void)shareToSMS:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendSmsWithText:text rid:rid];
}

-(void)shareToWeibo:(NSString *)text rid:(NSString *)rid
{
    [[AppDelegate currentAppdelegate] sendmessageToShareWithObjContent:text rid:rid];
}
-(void)shareToFriendWithText:(NSString *)text
{
    NSString *shareText = [NSString stringWithFormat:@"转自:%@的帖子：%@",self.obj.nickname,text];
    FriendsListViewController *vc=[[FriendsListViewController alloc] init];
    vc.isShare = YES;
    vc.shareContent = shareText;
    vc.shareRid = self.obj.rid;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)otherShareWithObj:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [[AFHTTPRequestOperationManager manager] PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            obj.sharenum = [NSString stringWithFormat:@"%ld",(long)([obj.sharenum integerValue] + 1)];
            [self.delegate detailShareWithRid:obj.rid shareNum:obj.sharenum];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_SHARE_CLIC object:obj];
            
            [self loadDatasWithObj:obj];
            [self.listTable reloadData];
            [Hud showMessageWithText:@"分享成功"];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud showMessageWithText:error.domain];
        
    }];
}
-(void)circleShareWithObj:(CircleListObj *)obj
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttpCircle,@"circle",obj.rid];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            self.obj.sharenum = [NSString stringWithFormat:@"%ld",(long)([self.obj.sharenum integerValue] + 1)];
            [self loadDatasWithObj:self.obj];
            [Hud showMessageWithText:@"分享成功"];
            [self.delegate detailShareWithRid:obj.rid shareNum:obj.sharenum];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_SHARE_CLIC object:obj];
            
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
    }];
}

#pragma mark -收藏
- (IBAction)actionCollection:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circlestore"];
    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID],
                            @"rid":self.obj.rid};
    if (![self.obj.iscollection isEqualToString:@"Y"])
    {
        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                self.obj.iscollection = @"Y";
            }
            [self loadDatasWithObj:self.obj];
            [Hud showMessageWithText:@"收藏成功"];
            [MobClick event:@"ActionCollection_On" label:@"onClick"];
            if (self.delegate && [self.delegate respondsToSelector:@selector(detailCollectionWithRid:collected:)]){
                [self.delegate detailCollectionWithRid:self.obj.rid collected:self.obj.iscollection];
            }
        } failed:^(MOCHTTPResponse *response) {
            [Hud showMessageWithText:response.errorMessage];
        }];
    } else{
        [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSString *code = [responseObject valueForKey:@"code"];
             if ([code isEqualToString:@"000"]) {
                 self.obj.iscollection = @"N";
             }
             [self loadDatasWithObj:self.obj];
             if (self.delegate && [self.delegate respondsToSelector:@selector(detailCollectionWithRid:collected:)]){
                 [self.delegate detailCollectionWithRid:self.obj.rid collected:self.obj.iscollection];
             }
             [MobClick event:@"ActionCollection_Off" label:@"onClick"];
             [Hud showMessageWithText:@"取消收藏"];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [Hud showMessageWithText:error.domain];
         }];
    }
}
//查看原文
- (IBAction)checkAllMessage:(id)sender {
    if (![self.obj.pcurl isEqualToString:@""]) {
        UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.listTable.frame.size.width, self.view.frame.size.height)];
        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.obj.pcurl]];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }else
    {
        self.checkAll.hidden = YES;
    }
}

//- (IBAction)actionAttention:(id)sender
//{
//    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friends"];
//    NSDictionary *param = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID], @"oid":self.obj.userid};
//    [Hud showLoadingWithMessage:@"请稍等..."];
//    if ([self.obj.isattention isEqualToString:@"N"]) {
//        [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
//            [Hud hideHud];
//            NSString *code = [response.data valueForKey:@"code"];
//            if ([code isEqualToString:@"000"])
//            {
//                self.obj.isattention = @"Y";
//                [Hud showMessageWithText:@"关注成功"];
//                
//            }
//            [self loadDatasWithObj:self.obj];
//            
//            [self.delegate detailAttentionWithRid:self.obj.userid attention:self.obj.isattention];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:self.obj];
//        } failed:^(MOCHTTPResponse *response) {
//            [Hud hideHud];
//            [Hud showMessageWithText:response.errorMessage];
//        }];
//    } else{
//        [[AFHTTPRequestOperationManager manager] DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [Hud hideHud];
//            NSString *code = [responseObject valueForKey:@"code"];
//            if ([code isEqualToString:@"000"]){
//                self.obj.isattention = @"N";
//                [Hud showMessageWithText:@"取消关注成功"];
//            }
//            [self loadDatasWithObj:self.obj];
//            [self.delegate detailAttentionWithRid:self.obj.userid attention:self.obj.isattention];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COLLECT_CLIC object:self.obj];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [Hud hideHud];
//            [Hud showMessageWithText:error.domain];
//        }];
//    }
//}

- (void)didTapHeaderView:(DDTapGestureRecognizer *)ges
{
    //[self gotoSomeOneWithId:self.obj.userid name:self.obj.nickname];
    [self.listTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

-(void)refreshFooter
{
    
}
#pragma mark =============  UITableView DataSource  =============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commentOBj *obj = self.obj.comments[indexPath.row];
    static NSString *cellIdentifier = @"cellIdentifier";
    ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReplyTableViewCell" owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    cell.index = indexPath.row;
    SHGCommentType type = SHGCommentTypeNormal;
    if(indexPath.row == 0){
        type = SHGCommentTypeFirst;
        [cell makeFirstCell];
        
    }else if(indexPath.row == self.obj.comments.count - 1){
        type = SHGCommentTypeLast;
    }
    [cell loadUIWithObj:obj commentType:type];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesturecognized:)];
    [cell addGestureRecognizer:longPress];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commentOBj *obj = self.obj.comments[indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    
    NSString *text;
    if (IsStrEmpty(obj.rnickname))
    {
        text = [NSString stringWithFormat:@"%@:x%@",obj.cnickname,obj.cdetail];
    }else{
        text = [NSString stringWithFormat:@"%@回复%@:x%@",obj.cnickname,obj.rnickname,obj.cdetail];
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:3];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [string length])];
    UILabel *replyLabel = [[UILabel alloc] init];
    replyLabel.numberOfLines = 0;
    replyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    replyLabel.font = [UIFont systemFontOfSize:14.0f];
    replyLabel.attributedText = string;
    CGSize size = [replyLabel sizeThatFits:CGSizeMake(SCREENWIDTH - kPhotoViewRightMargin - kPhotoViewLeftMargin - CELLRIGHT_COMMENT_WIDTH, MAXFLOAT)];
    NSLog(@"%f",size.height);
    CGFloat height = size.height;
    if(indexPath.row == 0){
        height += kCommentTopMargin;
    }
    if (indexPath.row == self.obj.comments.count - 1){
        height += kCommentBottomMargin;
    }
    return height + kCommentMargin;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _viewHeader.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _viewHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.obj.comments.count;
}

#pragma mark =============  UITableView Delegate  =============

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You Click At Section: %ld Row: %ld",(long)indexPath.section,(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    commentOBj *obj = self.obj.comments[indexPath.row];
    copyString = obj.cdetail;
    commentRid = obj.rid;
    if ([obj.cnickname isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USER_NAME]]) {
        NSLog(@"%@",obj.cnickname);
        //复制删除试图
        [self createPickerView];
    }else{
        [self replyClick:indexPath.row];
        NSLog(@"%@",obj.cnickname);
        NSLog(@"%@",self.obj.nickname);
    }
}



- (IBAction)actionGoSome:(id)sender {
    [self gotoSomeOneWithId:self.obj.userid name:self.obj.nickname];
}

-(void)linkTap:(DDTapGestureRecognizer *)ges
{
    CircleLinkViewController *vc = [[CircleLinkViewController alloc] init];
    vc.link = self.obj.linkObj.link;
    UINavigationController *nav =  (UINavigationController *)[AppDelegate currentAppdelegate].window.rootViewController;
    [nav pushViewController:vc animated:YES];
}



#pragma mark - textFieldDelegate

#pragma mark detailDelagte

-(void)detailDeleteWithRid:(NSString *)rid
{
    [self.delegate detailDeleteWithRid:rid];
    [self loadDatasWithObj:self.obj];
    [self.listTable reloadData];
    
}

-(void)detailPraiseWithRid:(NSString *)rid praiseNum:(NSString *)num isPraised:(NSString *)isPrased
{
    if ([self.obj.rid isEqualToString:rid]) {
        self.obj.praisenum = num;
        self.obj.ispraise = isPrased;
    }
    
    [self loadDatasWithObj:self.obj];
    
    [self.listTable reloadData];
    [self.delegate detailPraiseWithRid:rid praiseNum:num isPraised:isPrased];
    
}

-(void)detailShareWithRid:(NSString *)rid shareNum:(NSString *)num
{
    if ([self.obj.rid isEqualToString:rid]) {
        self.obj.sharenum = num;
    }
    [self loadDatasWithObj:self.obj];
    [self.listTable reloadData];
    [self.delegate detailShareWithRid:rid shareNum:num];
    
}

-(void)detailAttentionWithRid:(NSString *)rid attention:(NSString *)atten
{
    if ([self.obj.userid isEqualToString:rid]) {
        self.obj.isattention = atten;
    }
    [self loadDatasWithObj:self.obj];
    
    [self.listTable reloadData];
    [self.delegate detailAttentionWithRid:rid attention:atten];
    
}

-(void)detailCommentWithRid:(NSString *)rid commentNum:(NSString*)num comments:(NSMutableArray *)comments
{
    if ([self.obj.rid isEqualToString:rid]){
        self.obj.cmmtnum = num;
        self.obj.comments = comments;
    }
    [self loadDatasWithObj:self.obj];
    [self.listTable reloadData];
    [self.delegate detailCommentWithRid:rid commentNum:num comments:comments];
    
}

-(void)deleteSelf
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"circle"];
    NSDictionary *dic = @{@"rid":self.obj.rid,
                          @"uid":self.obj.userid};
    [[AFHTTPRequestOperationManager manager] DELETE:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"])
        {
            [self.delegate detailDeleteWithRid:self.obj.rid];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud showMessageWithText:error.domain];
    }];
}
- (IBAction)actionDelete:(id)sender {
    //删除
    __weak typeof(self)weakSelf = self;
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"确认删除吗?" leftButtonTitle:@"取消" rightButtonTitle:@"删除"];
    alert.rightBlock = ^{
        [weakSelf deleteSelf];
        
    };
    [alert show];
    
}


#pragma mark -- sdc
#pragma mark -- url点击
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    NSLog(@"1111");
    LinkViewController *vc=  [[LinkViewController alloc]init];
    vc.url = link;
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            [self.navigationController pushViewController:vc animated:YES];
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            [self openTel:link];
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
    
}
#pragma mark -- sdc
#pragma mark -- 拨打电话
- (BOOL)openTel:(NSString *)tel
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tel];
    NSLog(@"str======%@",str);
    return  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
#pragma mark -- sdc
#pragma mark -- 打开url
- (BOOL)openURL:(NSURL *)url
{
    BOOL safariCompatible = [url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"] ;
    if (safariCompatible && [[UIApplication sharedApplication] canOpenURL:url]){
        
        NSLog(@"%@",url);
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    } else {
        return NO;
    }
}
#pragma mark -- sdc
#pragma mark -- 删除评论
- (void)longPressGesturecognized:(id)sender{
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;//这是长按手势的状态   下面switch用到了
    CGPoint location = [longPress locationInView:self.listTable];
    NSIndexPath *indexPath = [self.listTable indexPathForRowAtPoint:location];
    switch (state)
    {
        case UIGestureRecognizerStateBegan:{
            if (indexPath){
                //判断是否是自己
                commentOBj *obj = self.obj.comments[indexPath.row];
                commentRid = obj.rid;
                copyString = obj.cdetail;
                
                if ([obj.cnickname isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USER_NAME]]){
                    [self createPickerView];
                } else{
                    NSLog(@"2");
                    PickerBackView = [[UIView alloc] initWithFrame:self.view.bounds];
                    PickerBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
                    tap.cancelsTouchesInView = YES;
                    [PickerBackView addGestureRecognizer:tap];
                    PickerBackView.userInteractionEnabled = YES;
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(30, (self.view.bounds.size.height-50)/2, self.view.bounds.size.width - 60, 50);
                    button.backgroundColor = [UIColor whiteColor];
                    [button setTitle:@"复制" forState:UIControlStateNormal];
                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
                    [button addTarget:self action:@selector(copyButton) forControlEvents:UIControlEventTouchUpInside];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [PickerBackView addSubview:button];
                    [self.view addSubview:PickerBackView];
                    [self.view bringSubviewToFront:PickerBackView];
                    //[self.view sendSubviewToBack:PickerBackView];
                }
            }
            break;
        }
        default:{
            
        }
    }
}
//创建删除试图
- (void)createPickerView{
    PickerBackView = [[UIView alloc] initWithFrame:self.view.bounds];
    PickerBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    tap.cancelsTouchesInView = YES;
    [PickerBackView addGestureRecognizer:tap];
    PickerBackView.userInteractionEnabled = YES;
    
    UIButton *copy = [UIButton buttonWithType:UIButtonTypeCustom];
    copy.frame = CGRectMake(30, (self.view.bounds.size.height-50)/2-50, self.view.bounds.size.width - 60, 50);
    copy.backgroundColor = [UIColor whiteColor];
    [copy setTitle:@"复制" forState:UIControlStateNormal];
    copy.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    copy.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [copy addTarget:self action:@selector(copyButton) forControlEvents:UIControlEventTouchUpInside];
    [copy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [PickerBackView addSubview:copy];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(30, (self.view.bounds.size.height-50)/2, self.view.bounds.size.width - 60, 1)];
    view.backgroundColor = [UIColor grayColor];
    [PickerBackView addSubview:view];
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    delete.frame = CGRectMake(30, (self.view.bounds.size.height-50)/2+1, self.view.bounds.size.width - 60, 50);
    delete.backgroundColor = [UIColor whiteColor];
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    delete.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    delete.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [delete addTarget:self action:@selector(deleteButton) forControlEvents:UIControlEventTouchUpInside];
    [delete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [PickerBackView addSubview:delete];
    
    [self.view addSubview:PickerBackView];
    [self.view bringSubviewToFront:PickerBackView];
}
- (void)closeView
{
    [PickerBackView removeFromSuperview];
}
//复制
- (void)copyButton
{
    NSLog(@"....%@",copyString);
    [UIPasteboard generalPasteboard].string = copyString;
    self.listTable.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self.view sendSubviewToBack:PickerBackView];
}
//删除
- (void)deleteButton
{
    NSDictionary *param = @{@"rid":commentRid};
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,@"deleteComments"];
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response)
     {
         [Hud hideHud];
         NSLog(@"%@",response.dataDictionary);
         for (commentOBj *obj in self.obj.comments)
         {
             if ([obj.rid  isEqualToString:commentRid])
             {
                 [self.obj.comments removeObject:obj];
                 self.obj.cmmtnum = [NSString stringWithFormat:@"%ld",(long)([self.obj.cmmtnum integerValue] - 1)];
                 break;
             }
         }
         [self loadDatasWithObj:self.obj];
         [self.listTable reloadData];
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_COLLECT_COMMENT_CLIC object:self.obj];
     } failed:^(MOCHTTPResponse *response)
     {
         [Hud showMessageWithText:response.errorMessage];
         NSLog(@"response.errorMessage==%@",response.errorMessage);
     }];
    //listTable适应屏幕
    self.listTable.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self.view sendSubviewToBack:PickerBackView];
    
}



@end
