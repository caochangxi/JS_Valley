//
//  SHGBusinessNewDetailViewController.m
//  Finance
//
//  Created by weiqiankun on 16/6/6.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessNewDetailViewController.h"
#import "SHGBusinessManager.h"
#import "SHGBusinessCommentTableViewCell.h"
#import "SHGCopyTextView.h"
#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "SHGPersonalViewController.h"
#import "SHGEquityInvestSendViewController.h"
#import "SHGBondInvestSendViewController.h"
#import "SHGBondFinanceSendViewController.h"
#import "SHGEquityFinanceSendViewController.h"
#import "SHGSameAndCommixtureSendViewController.h"
#import "CircleLinkViewController.h"
#import "SHGEmptyDataView.h"
#import "NSCharacterSet+Common.h"
typedef NS_ENUM(NSInteger, SHGTapPhoneType)
{
    SHGTapPhoneTypeDialNumber,
    SHGTapPhoneTypeSendMessage
};

@interface SHGBusinessNewDetailViewController ()<CircleActionDelegate,SHGBusinessCommentDelegate,BRCommentViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UIView *PickerBackView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *inPutView;

//头部redView
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *firstHorizontalLine;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

//money和userView
@property (weak, nonatomic) IBOutlet UIView *moneyAndUserView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UIView *centerLine;
@property (weak, nonatomic) IBOutlet UIView *userBottomLine;

//灰色view
@property (weak, nonatomic) IBOutlet UIView *firstGrayView;
@property (weak, nonatomic) IBOutlet UIView *secondGrayView;


//businessMessageVIew
@property (weak, nonatomic) IBOutlet UIView *businessMessageView;
@property (weak, nonatomic) IBOutlet UILabel *businessMessageLabel;
@property (weak, nonatomic) IBOutlet UIView *secondHorizontalLine;
@property (weak, nonatomic) IBOutlet UIView *businessMessageLabelView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet SHGCopyTextView *phoneTextView;
@property (weak, nonatomic) IBOutlet UIView *businessMessageTopLine;
@property (weak, nonatomic) IBOutlet UIView *businessMessageBpttomLine;

@property (weak, nonatomic) IBOutlet UIView *representLabelTopine;
//
@property (weak, nonatomic) IBOutlet UILabel *businessRepresentLabel;
@property (weak, nonatomic) IBOutlet UIView *thirdHorizontalLine;
@property (weak, nonatomic) IBOutlet SHGCopyTextView *contentTextView;

//inputView
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIView *leftVerticalLine;
@property (weak, nonatomic) IBOutlet UIView *rightVerticalLine;
@property (weak, nonatomic) IBOutlet UIView *inputTopLine;

//BP View
@property (weak, nonatomic) IBOutlet UIView *BPView;
@property (weak, nonatomic) IBOutlet UIView *thirdGaryView;
@property (weak, nonatomic) IBOutlet UIView *BPLine;
@property (weak, nonatomic) IBOutlet UILabel *BPLabel;
@property (weak, nonatomic) IBOutlet UIView *BPButtonView;
@property (weak, nonatomic) IBOutlet UIView *BPTopLine;
@property (weak, nonatomic) IBOutlet UIView *BPBottomLine;

@property (strong, nonatomic) UIView *photoView;
@property (strong, nonatomic) SHGBusinessObject *responseObject;
@property (weak, nonatomic) SHGBusinessCommentObject *commentObject;
@property (strong, nonatomic) NSString *copyedString;

@property (strong, nonatomic) BRCommentView *popupView;

@property (strong, nonatomic) NSMutableArray *middleContentArray;
@property (strong, nonatomic) NSMutableArray *phoneArray;
@property (strong, nonatomic) NSMutableArray *mobileArray;

@property (strong, nonatomic) SHGEmptyDataView *emptyView;
@property (assign, nonatomic) SHGTapPhoneType type;
@end

@implementation SHGBusinessNewDetailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareToFriendSuccess:) name:NOTIFI_ACTION_SHARE_TO_FRIENDSUCCESS object:nil];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self initView];
    [self addSdLayout];
    [self initData];
    
}

- (NSMutableArray *)phoneArray
{
    if (!_phoneArray) {
        _phoneArray = [NSMutableArray array];
    }
    return _phoneArray;
}

- (NSMutableArray *)mobileArray
{
    if (!_mobileArray) {
        _mobileArray = [NSMutableArray array];
    }
    return _mobileArray;
}

- (SHGEmptyDataView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[SHGEmptyDataView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
        _emptyView.type = SHGEmptyDateBusinessDeleted;
    }
    return _emptyView;
}


- (void)addSdLayout
{
    //inputView
    self.inPutView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(50.0f));
    
    self.leftVerticalLine.sd_layout
    .centerXIs(SCREENWIDTH / 3.0)
    .centerYEqualToView(self.inPutView)
    .widthIs(0.5f)
    .heightIs(MarginFactor(20.0f));
    
    self.rightVerticalLine.sd_layout
    .centerXIs(2 * SCREENWIDTH / 3.0)
    .centerYEqualToView(self.inPutView)
    .widthIs(0.5f)
    .heightIs(MarginFactor(20.0f));
    
    self.collectionButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, MarginFactor(8.0f), 0.0f, 0.0f);
    self.commentButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, MarginFactor(8.0f), 0.0f, 0.0f);
    self.shareButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, MarginFactor(8.0f), 0.0f, 0.0f);
    self.editButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, MarginFactor(8.0f), 0.0f, 0.0f);
    
    self.collectionButton.sd_layout
    .centerYEqualToView(self.inPutView)
    .leftSpaceToView(self.inPutView, 0.0f)
    .rightSpaceToView(self.leftVerticalLine, 0.0f)
    .heightRatioToView(self.inPutView, 1.0f);
    
    self.editButton.sd_layout
    .centerYEqualToView(self.inPutView)
    .leftSpaceToView(self.inPutView, 0.0f)
    .rightSpaceToView(self.leftVerticalLine, 0.0f)
    .heightRatioToView(self.inPutView, 1.0f);
    
    self.commentButton.sd_layout
    .centerYEqualToView(self.inPutView)
    .leftSpaceToView(self.leftVerticalLine, 0.0f)
    .rightSpaceToView(self.rightVerticalLine, 0.0f)
    .heightRatioToView(self.inPutView, 1.0f);
    
    self.shareButton.sd_layout
    .centerYEqualToView(self.inPutView)
    .leftSpaceToView(self.rightVerticalLine, 0.0f)
    .rightSpaceToView(self.inPutView, 0.0f)
    .heightRatioToView(self.inPutView, 1.0f);
    
    self.inputTopLine.sd_layout
    .leftSpaceToView(self.inPutView, 0.0f)
    .rightSpaceToView(self.inPutView, 0.0f)
    .topSpaceToView(self.inPutView, 0.0f)
    .heightIs(0.5f);
    
    
    
    //redView
    self.redView.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(124.0f));
    
    self.titleNameLabel.sd_layout
    .topSpaceToView(self.redView, 0.0f)
    .centerXEqualToView(self.redView)
    .heightIs(self.titleNameLabel.font.lineHeight);
    [self.titleNameLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    self.titleDetailLabel.sd_layout
    .centerYIs(self.redView.centerY - MarginFactor(20.0f) - MarginFactor(10.0f))
    .centerXEqualToView(self.redView)
    .widthIs(MarginFactor(240.0f))
    .heightIs(MarginFactor(83.0f));
    
    
    self.firstHorizontalLine.sd_layout
    .leftSpaceToView(self.redView, MarginFactor(14.0f))
    .rightSpaceToView(self.redView, MarginFactor(14.0f))
    .bottomSpaceToView(self.redView, MarginFactor(41.0f))
    .heightIs(1 / SCALE);
    
    self.typeButton.sd_layout
    .leftSpaceToView(self.redView, MarginFactor(14.0f))
    .topSpaceToView(self.firstHorizontalLine, MarginFactor(21.0f))
    .widthIs(10.0f)
    .heightIs(10.0f);
    
    self.areaButton.sd_layout
    .leftSpaceToView(self.typeButton, MarginFactor(9.0f))
    .centerYEqualToView(self.typeButton)
    .widthIs(10.0f)
    .heightIs(10.0f);
    
    //moneyAndUserView
    self.moneyAndUserView.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.headerView, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.centerLine.sd_layout
    .centerYEqualToView(self.moneyAndUserView)
    .centerXEqualToView(self.moneyAndUserView)
    .widthIs(0.5f)
    .heightIs(MarginFactor(35.0f));
    
    self.moneyLabel.sd_layout
    .centerXIs(SCREENWIDTH / 4.0)
    .centerYEqualToView(self.moneyAndUserView)
    .widthIs(MarginFactor(115.0f))
    .heightRatioToView(self.moneyAndUserView, 1.0f);
    
    self.userLabel.sd_layout
    .centerXIs(3 * SCREENWIDTH / 4.0)
    .centerYEqualToView(self.moneyAndUserView)
    .widthIs(MarginFactor(115.0f))
    .heightRatioToView(self.moneyAndUserView, 1.0f);
    
    [self.userButton sizeToFit];
    CGSize userButtonSize = self.userButton.frame.size;
    self.userButton.sd_layout
    .rightSpaceToView(self.moneyAndUserView, MarginFactor(14.0f))
    .centerYEqualToView(self.moneyAndUserView)
    .widthIs(userButtonSize.width)
    .heightIs(userButtonSize.height);
    
    self.userBottomLine.sd_layout
    .leftSpaceToView(self.moneyAndUserView, 0.0f)
    .rightSpaceToView(self.moneyAndUserView, 0.0f)
    .bottomSpaceToView(self.moneyAndUserView, 0.0f)
    .heightIs(0.5f);
    
    self.firstGrayView.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.moneyAndUserView, 0.0f)
    .heightIs(MarginFactor(10.0f));
    
    //messageView
    self.businessMessageView.sd_layout
    .topSpaceToView(self.firstGrayView, 0.0f)
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f);
    
    self.businessMessageTopLine.sd_layout
    .leftSpaceToView(self.businessMessageView, 0.0f)
    .rightSpaceToView(self.businessMessageView, 0.0f)
    .topSpaceToView(self.businessMessageView, 0.0f)
    .heightIs(0.5f);
    
    self.businessMessageLabel.sd_layout
    .leftSpaceToView(self.businessMessageView, MarginFactor(14.0f))
    .rightSpaceToView(self.businessMessageView, 0.0f)
    .topSpaceToView(self.businessMessageTopLine, 0.0f)
    .heightIs(MarginFactor(44.0f));
    
    self.secondHorizontalLine.sd_layout
    .leftEqualToView(self.businessMessageLabel)
    .rightSpaceToView(self.businessMessageView, MarginFactor(14.0f))
    .topSpaceToView(self.businessMessageLabel, 0.0f)
    .heightIs(0.5f);
    
    self.businessMessageLabelView.sd_layout
    .leftEqualToView(self.secondHorizontalLine)
    .rightEqualToView(self.secondHorizontalLine)
    .topSpaceToView(self.secondHorizontalLine, MarginFactor(14.0f))
    .bottomSpaceToView(self.businessMessageView, 0.0f);
    
    self.phoneTextView.sd_layout
    .rightEqualToView(self.businessMessageLabelView)
    .topSpaceToView(self.businessMessageLabelView,0.0f)
    .widthIs(MarginFactor(150.0f));
    
    self.phoneLabel.sd_layout
    .leftEqualToView(self.businessMessageLabelView)
    .topEqualToView(self.phoneTextView)
    .heightIs(self.phoneLabel.font.lineHeight);
    [self.phoneLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
    [self.businessMessageView setupAutoHeightWithBottomView:self.phoneTextView bottomMargin:0.0f];

    self.businessMessageBpttomLine.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.businessMessageView, MarginFactor(13.0f))
    .heightIs(0.5f);
    
    self.secondGrayView.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.businessMessageBpttomLine, 0.0f)
    .heightIs(MarginFactor(10.0f));
    
    //BPView
    self.BPView.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.secondGrayView,0.0f);
    
    self.BPTopLine.sd_layout
    .leftSpaceToView(self.BPView, 0.0f)
    .rightSpaceToView(self.BPView, 0.0f)
    .topSpaceToView(self.BPView, 0.0f)
    .heightIs(0.5f);
    
    self.BPLabel.sd_layout
    .leftSpaceToView(self.BPView, MarginFactor(14.0f))
    .rightSpaceToView(self.BPView, MarginFactor(14.0f))
    .topSpaceToView(self.BPView, 1.0f)
    .heightIs(MarginFactor(44.0f));
    
    self.BPLine.sd_layout
    .leftEqualToView(self.BPLabel)
    .rightEqualToView(self.BPLabel)
    .topSpaceToView(self.BPLabel, 0.0f)
    .heightIs(0.5f);
    
    self.BPButtonView.sd_layout
    .leftSpaceToView(self.BPView, 0.0f)
    .rightSpaceToView(self.BPView, 0.0f)
    .topSpaceToView(self.BPLine, 0.0f)
    .heightIs(MarginFactor(110.0f));
    
    self.BPBottomLine.sd_layout
    .leftSpaceToView(self.BPView, 0.0f)
    .rightSpaceToView(self.BPView, 0.0f)
    .topSpaceToView(self.BPButtonView, 0.0f)
    .heightIs(0.5f);
    
    self.thirdGaryView.sd_layout
    .leftEqualToView(self.BPButtonView)
    .rightEqualToView(self.BPButtonView)
    .topSpaceToView(self.BPBottomLine,0.0f)
    .heightIs(MarginFactor(10.0f));
    
   
    [self.BPView setupAutoHeightWithBottomView:self.thirdGaryView bottomMargin:0.0f];
    
    self.representLabelTopine.sd_layout
    .leftSpaceToView(self.headerView, 0.0f)
    .rightSpaceToView(self.headerView, 0.0f)
    .topSpaceToView(self.secondGrayView, 0.0f)
    .heightIs(0.5f);
    
    self.businessRepresentLabel.sd_layout
    .leftSpaceToView(self.headerView, MarginFactor(14.0f))
    .rightSpaceToView(self.headerView, MarginFactor(14.0f))
    .topSpaceToView(self.representLabelTopine, 0.0f)
    .heightIs(MarginFactor(44.0f));
    
    self.thirdHorizontalLine.sd_layout
    .leftEqualToView(self.businessRepresentLabel)
    .rightEqualToView(self.businessRepresentLabel)
    .topSpaceToView(self.businessRepresentLabel, 1.0f)
    .heightIs(0.5);
    
    self.contentTextView.sd_layout
    .leftEqualToView(self.thirdHorizontalLine)
    .rightEqualToView(self.thirdHorizontalLine)
    .topSpaceToView(self.thirdHorizontalLine, MarginFactor(15.0f));
    
    self.photoView = [[UIView alloc] init];
    [self.headerView addSubview:self.photoView];
    self.photoView.sd_layout
    .leftSpaceToView(self.headerView, MarginFactor(15.0f))
    .rightSpaceToView(self.headerView, MarginFactor(15.0f))
    .topSpaceToView(self.contentTextView,0.0f)
    .heightIs(0.0f);
    
    [self.headerView setupAutoHeightWithBottomView:self.photoView bottomMargin:MarginFactor(15.0f)];
    
    [self.tableView setTableHeaderView:self.headerView];
    
    self.tableView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.redView,0.0f)
    .bottomSpaceToView(self.inPutView, 0.0f);
}

- (void)initView
{
    self.titleNameLabel.hidden = YES;
    [self.userButton setEnlargeEdgeWithTop:10.0f right:0.0f bottom:10.0f left:150.0f];
    UITapGestureRecognizer *tableHeaderViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableHeaderView:)];
    [self.headerView addGestureRecognizer:tableHeaderViewRecognizer];
    //inputView
    self.inPutView.backgroundColor = Color(@"f4f4f4");
    self.leftVerticalLine.backgroundColor = self.rightVerticalLine.backgroundColor =  Color(@"dddddd");
    
    self.inputTopLine.backgroundColor = Color(@"e2e2e2");
    [self.collectionButton setTitleColor:Color(@"a5a5a5") forState:UIControlStateNormal];
    [self.commentButton setTitleColor:Color(@"a5a5a5") forState:UIControlStateNormal];
    [self.shareButton setTitleColor:Color(@"a5a5a5") forState:UIControlStateNormal];
    [self.editButton setTitleColor:Color(@"a5a5a5") forState:UIControlStateNormal];
    self.editButton.titleLabel.font = self.collectionButton.titleLabel.font = self.commentButton.titleLabel.font = self.shareButton.titleLabel.font = FontFactor(15.0f);
    
    //redView
    self.redView.backgroundColor = Color(@"f04f46");
    self.titleNameLabel.textColor = Color(@"fbdfdd");
    self.titleNameLabel.font = FontFactor(13.0f);
    self.firstHorizontalLine.backgroundColor = Color(@"fd665d");
    self.typeButton.titleLabel.font = self.areaButton.titleLabel.font = FontFactor(12.0f);
    [self.typeButton setTitleColor:Color(@"ffffff") forState:UIControlStateNormal];
    [self.areaButton setTitleColor:Color(@"ffffff") forState:UIControlStateNormal];
    self.typeButton.adjustsImageWhenHighlighted = self.areaButton.adjustsImageWhenHighlighted = NO;
    self.moneyLabel.isAttributedContent = self.userLabel.isAttributedContent = YES;
    self.userLabel.numberOfLines = self.moneyLabel.numberOfLines = 0;
    self.moneyLabel.textAlignment = self.userLabel.textAlignment = NSTextAlignmentCenter;
    
    self.firstGrayView.backgroundColor = self.secondGrayView.backgroundColor = self.thirdGaryView.backgroundColor = Color(@"f7f7f7");
    self.secondHorizontalLine.backgroundColor = self.thirdHorizontalLine.backgroundColor = self.centerLine.backgroundColor = Color(@"e6e7e8");
    self.userBottomLine.backgroundColor = self.businessMessageBpttomLine.backgroundColor = self.businessMessageTopLine.backgroundColor = self.BPBottomLine.backgroundColor = self.BPTopLine.backgroundColor = self.representLabelTopine.backgroundColor = Color(@"e6e7e8");
    self.businessMessageLabel.font = FontFactor(16.0f);
    self.businessMessageLabel.textColor = Color(@"3A3A3A");
    
    self.contentTextView.editable = NO;
    self.contentTextView.scrollEnabled = NO;
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(0, -5.0f, 0, 0);
    
}

- (void)initData
{
    __weak typeof(self) weakSelf = self;
    [SHGBusinessManager getBusinessDetail:weakSelf.object success:^(SHGBusinessObject *detailObject) {
        weakSelf.responseObject = detailObject;
        NSString *value = [[SHGGloble sharedGloble] businessKeysForValues:self.responseObject.middleContent showEmptyKeys:NO];
        NSArray *array = [value componentsSeparatedByString:@"\n"];
        weakSelf.middleContentArray = [NSMutableArray arrayWithArray:array];
        NSLog(@"%@",weakSelf.responseObject);
        [weakSelf loadData];
        [weakSelf.tableView reloadData];
    }];
}


- (void)didCreateOrModifyBusiness
{
    [self initData];
    [self.businessMessageLabelView removeAllSubviews];
    [self.photoView removeAllSubviews];
}

- (void)addEmptyViewIfNeeded
{
    if ([self.responseObject.isDeleted isEqualToString:@"Y"]) {
        self.title = @"业务详情";
        [self.view addSubview:self.emptyView];
    }
}

- (void)loadData
{
    [self addEmptyViewIfNeeded];
    [self loadRedView];
    
    [self loadUserAndMoneyView];
    
    [self loadBusinessMessageView];
    
    [self loadBPView];
    if ([UID isEqualToString:self.responseObject.createBy]) {
        self.editButton.hidden = NO;
        self.collectionButton.hidden = YES;
    } else {
        self.editButton.hidden = YES;
        self.collectionButton.hidden = NO;
    }
    
    NSMutableParagraphStyle * contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [contentParagraphStyle setLineSpacing:MarginFactor(5.0f)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.responseObject.detail attributes:@{NSFontAttributeName:FontFactor(14.0f), NSForegroundColorAttributeName: Color(@"3a3a3a"), NSParagraphStyleAttributeName:contentParagraphStyle}];
    self.contentTextView.attributedText = attributedString;
    
    CGSize size = [self.contentTextView sizeThatFits:CGSizeMake(SCREENWIDTH - 2 * MarginFactor(12.0f), CGFLOAT_MAX)];
    self.contentTextView.sd_resetLayout
    .leftSpaceToView(self.headerView, MarginFactor(14.0f))
    .rightSpaceToView(self.headerView, MarginFactor(14.0f))
    .topSpaceToView(self.thirdHorizontalLine, MarginFactor(15.0f))
    .heightIs(size.height);
    
    if (self.responseObject.url.length > 0) {
        self.photoView.sd_resetLayout
        .leftSpaceToView(self.headerView, MarginFactor(15.0f))
        .rightSpaceToView(self.headerView, MarginFactor(15.0f))
        .topSpaceToView(self.contentTextView, MarginFactor(15.0f))
        .heightIs(MarginFactor(135.0f) + 64.0f);
        self.photoView.clipsToBounds = YES;
        SDPhotoGroup * photoGroup = [[SDPhotoGroup alloc] init];
        NSMutableArray *temp = [NSMutableArray array];
        SDPhotoItem *item = [[SDPhotoItem alloc] init];
        item.thumbnail_pic = [NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.responseObject.url];
        [temp addObject:item];
        photoGroup.photoItemArray = temp;
        [self.photoView addSubview:photoGroup];
    }
    [self.headerView layoutSubviews];
    self.tableView.tableHeaderView = self.headerView;
    
}

- (void)loadRedView
{
    NSString *title = self.responseObject.businessTitle;
    self.titleDetailLabel.textAlignment = NSTextAlignmentCenter;
    self.titleDetailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleDetailLabel.textColor = Color(@"ffffff");
    self.titleDetailLabel.numberOfLines = 0;
    if (title.length < 10) {
        self.titleDetailLabel.font = BoldFontFactor(25.0f);
    } else if (title.length > 20){
        title = [NSString stringWithFormat:@"%@...",[title substringToIndex:19]];
        self.titleDetailLabel.font = BoldFontFactor(23.0f);
    } else{
        self.titleDetailLabel.font = BoldFontFactor(23.0f);
    }
    self.titleDetailLabel.text = title;
    if ([self.responseObject.type isEqualToString:@"moneyside"]) {
        [self.typeButton setTitle:@"投资机构" forState:UIControlStateNormal];
    } else if ([self.responseObject.type isEqualToString:@"trademixed"]){
        [self.typeButton setTitle:@"银证业务" forState:UIControlStateNormal];
    } else if ([self.responseObject.type isEqualToString:@"equityfinancing"]){
        [self.typeButton setTitle:@"股权融资" forState:UIControlStateNormal];
    } else if ([self.responseObject.type isEqualToString:@"bondfinancing"]){
        [self.typeButton setTitle:@"债权融资" forState:UIControlStateNormal];
    }
    NSString *typeString = self.typeButton.titleLabel.text;
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:FontFactor(12.0f),NSFontAttributeName,nil];
    CGRect typeRect = [typeString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, MarginFactor(40.0f)) options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil];
    NSString *areaString = self.areaButton.titleLabel.text;
    CGRect areaRect = [areaString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, MarginFactor(40.0f)) options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil];
    
    [self.typeButton setBackgroundImage:[[UIImage imageNamed:@"newBusiness_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [self.areaButton setBackgroundImage:[[UIImage imageNamed:@"newBusiness_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    self.typeButton.sd_resetLayout
    .leftEqualToView(self.firstHorizontalLine)
    .topSpaceToView(self.firstHorizontalLine, MarginFactor(10.0f))
    .widthIs(typeRect.size.width + MarginFactor(28.0f))
    .heightIs(MarginFactor(20.0f));
    
    self.areaButton.sd_resetLayout
    .leftSpaceToView(self.typeButton, MarginFactor(9.0f))
    .centerYEqualToView(self.typeButton)
    .widthIs(areaRect.size.width + MarginFactor(48.0f))
    .heightIs(MarginFactor(20.0f));
}

- (void)loadUserAndMoneyView
{
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:MarginFactor(6.0f)];
    
    NSString *money = @"";
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.middleContentArray];
    for (NSString *obj in tempArray) {
        if ([obj containsString:@"金额"]) {
            NSArray *array = [obj componentsSeparatedByString:@"："];
            if ([[array lastObject] length] == 0) {
                money = @"暂未说明";
            } else{
                money = [array lastObject];
            }
            [self.middleContentArray removeObject:obj];
        }
    }
    
    NSString *allMoney = [NSString stringWithFormat:@"%@\n%@",@"金额",money];
    NSMutableAttributedString *moneyStr= [[NSMutableAttributedString alloc] initWithString:allMoney attributes:@{NSFontAttributeName:FontFactor(12.0f), NSForegroundColorAttributeName: Color(@"8d8d8d"), NSParagraphStyleAttributeName:paragraphStyle}];
    [moneyStr addAttribute:NSFontAttributeName value:FontFactor(14.0f) range:[allMoney rangeOfString:money]];
    [moneyStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"f04f46"] range: [allMoney rangeOfString:money]];
    self.moneyLabel.attributedText = moneyStr;
    
    NSString *sender = @"";
    NSString *allSender = @"";
    if ([self.responseObject.realName isEqualToString:@"大牛助手"]) {
        sender = @"委托大牛助手";
        self.userButton.hidden = YES;
        allSender = [NSString stringWithFormat:@"%@\n%@",@"发布人",sender];
    } else{
        sender = self.responseObject.realName;
        if (self.responseObject.realName.length > 7) {
            sender = [NSString stringWithFormat:@"%@...",[sender substringToIndex:7]];
            allSender = [NSString stringWithFormat:@"%@\n%@...",@"发布人",[sender substringToIndex:7]];
        } else{
            allSender = [NSString stringWithFormat:@"%@\n%@",@"发布人",sender];
        }
    }
    
    
    NSMutableAttributedString *senderStr= [[NSMutableAttributedString alloc] initWithString:allSender attributes:@{NSFontAttributeName:FontFactor(12.0f), NSForegroundColorAttributeName: Color(@"8d8d8d"), NSParagraphStyleAttributeName:paragraphStyle}];
    [senderStr addAttribute:NSFontAttributeName value:FontFactor(14.0f) range:[allSender rangeOfString:sender]];
    [senderStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"f04f46"] range: [allSender rangeOfString:sender]];
    self.userLabel.attributedText = senderStr;
}

- (void)loadBusinessMessageView
{
    NSString *titleStr = @"";
    NSString *detailceStr = @"";
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.middleContentArray];
    for (NSString *obj in tempArray) {
        if ([obj containsString:@"融资阶段"] || [obj containsString:@"投资方式"]){
            NSArray *array = [obj componentsSeparatedByString:@"："];
            titleStr = [array firstObject];
            detailceStr = [array lastObject];
            [self.middleContentArray removeObject:obj];
        } else if ([obj containsString:@"类型"]) {
            NSArray *array = [obj componentsSeparatedByString:@"："];
            titleStr = [NSString stringWithFormat:@"%@",[array firstObject]];
            detailceStr = [array lastObject];
            [self.middleContentArray removeObject:obj];
        } else if ([obj containsString:@"地区"]) {
            NSArray *array = [obj componentsSeparatedByString:@"："];
            [self.areaButton setTitle:[array lastObject] forState:UIControlStateNormal];
            [self.middleContentArray removeObject:obj];
        }
    }
    
    __block NSMutableArray *leftArray = [[NSMutableArray alloc] init];
    __block NSMutableArray *rightArray = [[NSMutableArray alloc] init];
    [leftArray removeAllObjects];
    [rightArray removeAllObjects];
    [leftArray addObject:titleStr];
    [rightArray addObject:detailceStr];
    [self.middleContentArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = [obj componentsSeparatedByString:@"："];
        [leftArray addObject:[array firstObject]];
        [rightArray addObject:[array lastObject]];
    }];
    
    NSInteger topMargin = MarginFactor(21.0f);
    NSString *rightString = @"";
    CGFloat height = 0.0f;
    NSMutableParagraphStyle * labelParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    labelParagraphStyle.alignment = NSTextAlignmentRight;
    [labelParagraphStyle setLineSpacing:MarginFactor(5.0f)];
    for (NSInteger i = 0; i < rightArray.count - 2 ; i ++) {
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.numberOfLines = 0;
        rightLabel.textColor = Color(@"3a3a3a");
        rightLabel.font = FontFactor(14.0f);
        rightString = [rightArray objectAtIndex:i];
        NSMutableAttributedString *string= [[NSMutableAttributedString alloc] initWithString:rightString attributes:@{NSFontAttributeName:FontFactor(14.0f), NSForegroundColorAttributeName: Color(@"3a3a3a"), NSParagraphStyleAttributeName:labelParagraphStyle}];
        rightLabel.attributedText = string;
        [rightLabel sizeToFit];
        CGSize size = [rightLabel sizeThatFits:CGSizeMake(MarginFactor(223.0f), CGFLOAT_MAX)];
        rightLabel.frame = CGRectMake(MarginFactor(125.0f), height +  i * topMargin , MarginFactor(223.0f), size.height);
        [self.businessMessageLabelView addSubview:rightLabel];
        
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.textColor = Color(@"8d8d8d");
        leftLabel.font = FontFactor(12.0f);
        leftLabel.text = [leftArray objectAtIndex:i];
        leftLabel.frame = CGRectMake(0.0f, height +  i * topMargin - 1, MarginFactor(100.0f),leftLabel.font.lineHeight);
        [self.businessMessageLabelView addSubview:leftLabel];
        
        height =  height + size.height  ;
        
    }
    self.businessMessageLabelView.sd_resetLayout
    .leftEqualToView(self.secondHorizontalLine)
    .rightEqualToView(self.secondHorizontalLine)
    .topSpaceToView(self.secondHorizontalLine, MarginFactor(14.0f))
    .heightIs(height + (rightArray.count-3) * topMargin );
    
    self.phoneLabel.textAlignment = NSTextAlignmentLeft;
    self.phoneLabel.textColor = Color(@"8d8d8d");
    self.phoneLabel.font = FontFactor(12.0f);
    self.phoneLabel.text = [leftArray objectAtIndex:rightArray.count - 2];
    
    self.phoneTextView.font = BoldFontFactor(15.0f);
    self.phoneTextView.textColor = Color(@"3d86e0");
    self.phoneTextView.editable = NO;
    UITapGestureRecognizer *phoneTextViewRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoneTextView:)];
    [self.phoneTextView addGestureRecognizer:phoneTextViewRecognizer];
    __block NSString *phoneNum = @"";
    if (!self.responseObject.userState) {
        phoneNum = @"认证可见";
    } else{
        NSString *numString = [rightArray objectAtIndex:rightArray.count - 2];
        NSArray *array = [numString componentsSeparatedByCharactersInSet:[NSCharacterSet formUnionWithArray:@[@",",@" "]]];
        [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.length > 0) {
                phoneNum = [phoneNum stringByAppendingFormat:@"%@\n",obj];
            }
        }];
        phoneNum = [phoneNum substringToIndex:(phoneNum.length - 1)];
    }
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentRight;
    [paragraphStyle setLineSpacing:MarginFactor(5.0f)];
    NSMutableAttributedString *string= [[NSMutableAttributedString alloc] initWithString:phoneNum attributes:@{NSFontAttributeName:FontFactor(14.0f), NSForegroundColorAttributeName: Color(@"4277B2"), NSParagraphStyleAttributeName:paragraphStyle}];
    self.phoneTextView.attributedText = string;
    CGSize size = [self.phoneTextView sizeThatFits:CGSizeMake(MarginFactor(150.0f), CGFLOAT_MAX)];
    self.phoneTextView.sd_resetLayout
    .rightEqualToView(self.businessMessageLabelView)
    .topSpaceToView(self.businessMessageLabelView, MarginFactor(14.0f))
    .widthIs(MarginFactor(200.0f))
    .heightIs(size.height);
    
    self.phoneLabel.sd_resetLayout
    .leftEqualToView(self.businessMessageLabelView)
    .topSpaceToView(self.businessMessageLabelView, MarginFactor(21.0f))
    .heightIs(self.phoneLabel.font.lineHeight);
    [self.phoneLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];
    
}

- (void)loadBPView
{
    if (self.responseObject.bpnameList) {
        self.BPView.hidden = NO;
        self.BPLine.backgroundColor = Color(@"e6e7e8");
        self.representLabelTopine.sd_resetLayout
        .leftSpaceToView(self.headerView, 0.0f)
        .rightSpaceToView(self.headerView, 0.0f)
        .topSpaceToView(self.BPView, 0.0f)
        .heightIs(0.5f);
        self.businessRepresentLabel.sd_resetLayout
        .leftSpaceToView(self.headerView, MarginFactor(14.0f))
        .rightSpaceToView(self.headerView, MarginFactor(14.0f))
        .topSpaceToView(self.representLabelTopine, 0.0f)
        .heightIs(MarginFactor(44.0f));
        self.BPLabel.text = @"项目BP";
        CGFloat buttonWidth = SCREENWIDTH / 3.0;
        CGFloat labelWidth = (SCREENWIDTH - MarginFactor(60.0f)) / 3.0;
        CGFloat buttonHeight = MarginFactor(95.0f);
        for (NSInteger i = 0 ; i < self.responseObject.bpnameList.count ; i ++) {
            SHGBusinessPDFObject *obj = [[SHGBusinessPDFObject alloc] init];
            NSDictionary *dicName = [self.responseObject.bpnameList objectAtIndex:i];
            NSDictionary *dicPath = [self.responseObject.bppathList objectAtIndex:i];
            obj.bpName = [dicName valueForKey:@"bpname"];
            obj.bpPath = [dicPath valueForKey:@"bppath"];
            SHGBusinessCategoryButton *button = [SHGBusinessCategoryButton buttonWithType:UIButtonTypeCustom];
            CGRect frame = CGRectMake(i * buttonWidth , MarginFactor(15.0f) , buttonWidth, buttonHeight);
            button.frame = frame;
            button.object = obj;
            [self.BPButtonView addSubview:button];
            [button addTarget:self action:@selector(pdfButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *nameLabel = [[UILabel alloc] init];
            if (obj.bpName.length > 8) {
                NSMutableString *name = [[NSMutableString alloc] initWithString:obj.bpName];
                [name insertString:@"\n" atIndex:8];
                if (name.length > 16) {
                    nameLabel.text = [NSString stringWithFormat:@"%@...",[name substringToIndex:16]];
                } else{
                    nameLabel.text = name;
                }
            } else{
                nameLabel.text = obj.bpName;
            }
            
            nameLabel.numberOfLines = 0;
            nameLabel.font = FontFactor(11.0f);
            nameLabel.textColor = Color(@"8d8d8d");
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.frame = CGRectMake(MarginFactor(10.0f) + i *(MarginFactor(20.0f) + labelWidth), MarginFactor(65.0f), labelWidth, MarginFactor(40.0f));
            [self.BPButtonView addSubview:nameLabel];
            
        }
        
    } else{
        self.BPView.hidden = YES;
    }
    
}


- (void)pdfButtonClick:(SHGBusinessCategoryButton *)btn
{
    SHGBusinessPDFObject *obj = [[SHGBusinessPDFObject alloc] init];
    obj = btn.pdfObject;
    CircleLinkViewController *viewControll = [[CircleLinkViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.bpPath];
    viewControll.linkTitle = obj.bpName;
    viewControll.link = url;
    [self.navigationController pushViewController:viewControll animated:YES];
}

#pragma mark ----tableView----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.responseObject.commentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    SHGBusinessCommentObject *object = [self.responseObject.commentList objectAtIndex:indexPath.row];
    CGFloat height = [object heightForCell];
    if(indexPath.row == 0){
        height += kCommentTopMargin;
    }
    if (indexPath.row == self.responseObject.commentList.count - 1){
        height += kCommentBottomMargin;
    }
    return height + kCommentMargin;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SHGBusinessCommentTableViewCell";
    SHGBusinessCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGBusinessCommentTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesturecognized:)];
        [cell.contentView addGestureRecognizer:longPress];
    }
    cell.index = indexPath.row;
    SHGBusinessCommentType type = SHGBusinessCommentTypeNormal;
    NSLog(@"index.row%ld",(long)indexPath.row);
    if(indexPath.row == 0){
        type = SHGBusinessCommentTypeFirst;
    } else if(indexPath.row == self.responseObject.commentList.count - 1){
        type = SHGBusinessCommentTypeLast;
    }
    SHGBusinessCommentObject *object = [self.responseObject.commentList objectAtIndex:indexPath.row];
    [cell loadUIWithObj:object commentType:type];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGBusinessCommentObject *object = [self.responseObject.commentList objectAtIndex:indexPath.row];
    self.commentObject = object;
    self.copyedString = object.commentDetail;
    if ([object.commentUserName isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USER_NAME]]) {
        //复制删除试图
        [self createPickerView];
    } else{
        [self replyClicked:object commentIndex:indexPath.row];
    }
}


#pragma mark -- 删除评论
- (void)longPressGesturecognized:(id)sender
{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;//这是长按手势的状态   下面switch用到了
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    switch (state){
        case UIGestureRecognizerStateBegan:{
            if (indexPath){
                //判断是否是自己
                SHGBusinessCommentObject *obj = self.responseObject.commentList[indexPath.row];
                self.commentObject = obj;
                self.copyedString = obj.commentDetail;
                
                if ([obj.commentUserName isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_USER_NAME]]){
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
                }
            }
            break;
        }
        default:{
            
        }
    }
}


//创建删除试图
- (void)createPickerView
{
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
    NSLog(@"....%@",self.copyedString);
    [UIPasteboard generalPasteboard].string = self.copyedString;
    self.tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self.view sendSubviewToBack:PickerBackView];
}
//删除
- (void)deleteButton
{
    __weak typeof(self)weakSelf = self;
    [SHGBusinessManager deleteCommentWithID:self.commentObject.commentId finishBlock:^(BOOL finish) {
        if (finish) {
            [weakSelf.responseObject.commentList removeObject:weakSelf.commentObject];
            [weakSelf.tableView reloadData];
        }
    }];
    [self.view sendSubviewToBack:PickerBackView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma  mark ----btnClick---

- (IBAction)editButtonClick:(UIButton *)sender
{
    
    if ([self.responseObject.type isEqualToString:@"moneyside"]) {
        if ([self.responseObject.moneysideType isEqualToString:@"equityInvest"]) {
            SHGEquityInvestSendViewController *viewController = [[SHGEquityInvestSendViewController alloc] init];
            viewController.object = self.responseObject;
            [self.navigationController pushViewController:viewController animated:YES];
            
        } else if ([self.responseObject.moneysideType isEqualToString:@"bondInvest"]){
            SHGBondInvestSendViewController *viewController = [[SHGBondInvestSendViewController alloc] init];
            viewController.object = self.responseObject;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else if ([self.responseObject.type isEqualToString:@"bondfinancing"]){
        SHGBondFinanceSendViewController *viewController = [[SHGBondFinanceSendViewController alloc] init];
        viewController.object = self.responseObject;
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([self.responseObject.type isEqualToString:@"equityfinancing"]){
        SHGEquityFinanceSendViewController *viewController = [[SHGEquityFinanceSendViewController alloc] init];
        viewController.object = self.responseObject;
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([self.responseObject.type isEqualToString:@"trademixed"]){
        SHGSameAndCommixtureSendViewController *viewController = [[SHGSameAndCommixtureSendViewController alloc] init];
        viewController.object = self.responseObject;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

- (IBAction)comment:(id)sender
{
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state) {
        if (state) {
            self.popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"comment"];
            self.popupView.delegate = self;
            self.popupView.sendColor = @"429fff";
            self.popupView.type = @"comment";
            self.popupView.fid = @"-1";
            self.popupView.detail = @"";
            [self.navigationController.view addSubview:self.popupView];
            [self.popupView showWithAnimated:YES];
            [self.navigationController.view addSubview:_popupView];
            [_popupView showWithAnimated:YES];
        } else{
            SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [[SHGGloble sharedGloble] recordUserAction:@"" type:@"business_identity"];
        }
    } showAlert:YES leftBlock:^{
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"business_identity_cancel"];
    } failString:@"认证后才能发起评论哦～"];
    
}

- (void)replyClicked:(SHGBusinessCommentObject *)obj commentIndex:(NSInteger)index
{
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state) {
        if (state) {
            self.popupView = [[BRCommentView alloc] initWithFrame:self.view.bounds superFrame:CGRectZero isController:YES type:@"reply" name:obj.commentUserName];
            self.popupView.delegate = self;
            self.popupView.sendColor = @"429fff";
            self.popupView.fid = obj.commentUserId;
            self.popupView.detail = @"";
            self.popupView.rid = obj.commentId;
            self.popupView.type = @"repley";
            [self.navigationController.view addSubview:self.popupView];
            [self.popupView showWithAnimated:YES];
        } else{
            SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [[SHGGloble sharedGloble] recordUserAction:@"" type:@"business_identity"];
        }
    } showAlert:YES leftBlock:^{
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"business_identity_cancel"];
    } failString:@"认证后才能发起评论哦～"];
}

- (void)rightUserClick:(NSInteger)index
{
    SHGBusinessCommentObject *obj = self.responseObject.commentList[index];
    [self gotoSomeOneWithId:obj.commentOtherId name:obj.commentOtherName];
}

- (void)leftUserClick:(NSInteger)index
{
    SHGBusinessCommentObject *obj = self.responseObject.commentList[index];
    [self gotoSomeOneWithId:obj.commentUserId name:obj.commentUserName];
}

-(void)gotoSomeOneWithId:(NSString *)uid name:(NSString *)name
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    controller.userId = uid;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)commentViewDidComment:(NSString *)comment rid:(NSString *)rid
{
    __weak typeof(self) weakSelf = self;
    [self.popupView hideWithAnimated:YES];
    
    [SHGBusinessManager addCommentWithObject:self.responseObject content:comment toOther:nil finishBlock:^(BOOL finish) {
        if (finish) {
            [weakSelf loadCommentBtnState];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)commentViewDidComment:(NSString *)comment reply:(NSString *)reply fid:(NSString *)fid rid:(NSString *)rid
{
    __weak typeof(self) weakSelf = self;
    [self.popupView hideWithAnimated:YES];
    [SHGBusinessManager addCommentWithObject:self.responseObject content:comment toOther:fid finishBlock:^(BOOL finish) {
        if (finish) {
            [weakSelf loadCommentBtnState];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void) loadCommentBtnState
{
    
}

- (IBAction)share:(id)sender
{
    [[SHGGloble sharedGloble] recordUserAction:[NSString stringWithFormat:@"%@#%@", self.responseObject.businessID, self.responseObject.type] type:@"business_share"];
    [[SHGBusinessManager shareManager] shareAction:self.responseObject baseController:self finishBlock:^(BOOL success) {
        
    }];
}

- (IBAction)collectionClick:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;
    
    if (self.responseObject.isCollection) {
        [SHGBusinessManager unCollectBusiness:self.responseObject success:^(BOOL success) {
            if (success) {
                weakSelf.responseObject.isCollection = NO;
                [weakSelf loadCollectButtonState];
                [Hud showMessageWithText:@"取消收藏成功"];
                
            }
        }];
    } else {
        [SHGBusinessManager collectBusiness:self.responseObject success:^(BOOL success) {
            if (success) {
                weakSelf.responseObject.isCollection = YES;
                [weakSelf loadCollectButtonState];
                [Hud showMessageWithText:@"收藏成功"];
            }
        }];
    }
    
}
- (void)loadCollectButtonState
{
    if (self.responseObject.isCollection) {
        [self.collectionButton setImage:[UIImage imageNamed:@"red_businessCollectied"] forState:UIControlStateNormal];
    } else{
        [self.collectionButton setImage:[UIImage imageNamed:@"red_businessCollection"] forState:UIControlStateNormal];
    }
}



- (IBAction)userButton:(UIButton *)sender
{
    SHGPersonalViewController *viewController = [[SHGPersonalViewController alloc] init];
    if ([self.responseObject.realName isEqualToString:@"大牛助手"]) {
        viewController.userId = @"-2";
    } else{
        viewController.userId = self.responseObject.createBy;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tapTableHeaderView:(UITapGestureRecognizer *)recognizer
{
    [self.phoneTextView resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}

- (void)tapPhoneTextView:(UITapGestureRecognizer *)recognizer
{
    [self.mobileArray removeAllObjects];
    [self.phoneArray removeAllObjects];
    NSString *string = self.phoneTextView.text;
    if ([string containsString:@"认证可见"]) {
        [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state) {
            if (!state) {
                SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc]init];
                [self.navigationController pushViewController:controller animated:YES];
            }
        } showAlert:YES leftBlock:^{
        } failString:@"认证后才能查看联系方式～"];
    } else {
        NSArray *array = [string componentsSeparatedByCharactersInSet:[NSCharacterSet formUnionWithArray:@[@":", @"：", @"，", @",", @" ", @"\n"]]];
        
        [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"((13|15|18|17)[0-9]{9})"];
            if ([mobilePredicate evaluateWithObject:obj]) {
                [self.mobileArray addObject:obj];
            }
            
            NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(0[1,2]{1}\\d{1}-?\\d{8})|(0[3-9] {1}\\d{2}-?\\d{7,8})|(0[1,2]{1}\\d{1}-?\\d{8}-(\\d{1,4}))|(0[3-9]{1}\\d{2}-? \\d{7,8}-(\\d{1,4}))|0[7,8]\\d{2}-?\\d{8}|0\\d{2,3}-?\\d{7,8}"];
            if ([phonePredicate evaluateWithObject:obj]) {
                [self.phoneArray addObject:obj];
            }
        }];
        
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        if (self.mobileArray.count > 0) {
            [sheet addButtonWithTitle:@"拨打电话"];
            [sheet addButtonWithTitle:@"发送短信"];
        } else if (self.phoneArray.count > 0) {
            [sheet addButtonWithTitle:@"拨打电话"];
        };
        if (sheet.numberOfButtons > 1) {
            [sheet showInView:self.view];
        }
    }
    NSLog(@"%@", string);
}

#pragma mark ------分享到圈内好友的通知
- (void)shareToFriendSuccess:(NSNotification *)notification
{
    [SHGBusinessManager shareSuccessCallBack:self.responseObject finishBlock:^(BOOL success) {
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [Hud showMessageWithText:@"分享成功"];
    });
}

#pragma mark -- sdc
#pragma mark -- 拨打电话

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSString *string = [actionSheet buttonTitleAtIndex:buttonIndex];
        NSMutableArray *array = [NSMutableArray array];
        if ([string containsString:@"电话"]) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [self.mobileArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject:obj];
                [sheet addButtonWithTitle:obj];
            }];
            [self.phoneArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject:obj];
                [sheet addButtonWithTitle:obj];
            }];
            if (array.count == 1) {
                [self openTel:[array firstObject]];
            } else {
                self.type = SHGTapPhoneTypeDialNumber;
                [sheet showInView:self.view];
            }
        } else if ([string containsString:@"短信"]) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [self.mobileArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject:obj];
                [sheet addButtonWithTitle:obj];
            }];
            if (array.count == 1) {
                [[SHGGloble sharedGloble] showMessageView:array body:@"你好，我在大牛圈看到您发布的业务，请问"];
            } else {
                self.type = SHGTapPhoneTypeSendMessage;
                [sheet showInView:self.view];
            }
        } else {
            //直接拨号
            if (self.type == SHGTapPhoneTypeSendMessage) {
                [[SHGGloble sharedGloble] showMessageView:@[string] body:@"你好，我在大牛圈看到您发布的业务，请问"];
            } else {
                [self openTel:string];
            }
        }
    }
}

- (BOOL)openTel:(NSString *)tel
{
    [[SHGGloble sharedGloble] recordUserAction:[NSString stringWithFormat:@"%@#%@", self.responseObject.businessID, self.responseObject.type] type:@"business_call"];
    NSString *str = [NSString stringWithFormat:@"telprompt://%@",tel];
    NSLog(@"str======%@",str);
    return  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.popupView) {
        [self.popupView hideWithAnimated:NO];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

@interface SHGBusinessCategoryButton()

@end

@implementation SHGBusinessCategoryButton

- (void)setObject:(id)object
{
    if ([object isKindOfClass:[SHGBusinessPDFObject class]]) {
        SHGBusinessPDFObject *businessPdfObject = (SHGBusinessPDFObject *)object;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = MarginFactor(2.0f);
        style.alignment = NSTextAlignmentCenter;
        NSString *name = businessPdfObject.bpName;
        if (name.length > 16) {
            businessPdfObject.bpName = [NSString stringWithFormat:@"%@...",[name substringToIndex:15]];
        }
        style.lineBreakMode = NSLineBreakByTruncatingTail|NSLineBreakByCharWrapping;
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:FontFactor(11.0f), NSForegroundColorAttributeName:Color(@"8d8d8d"), NSParagraphStyleAttributeName:style}];
        UIImage *image = [UIImage imageNamed:@"business_pdf"];
        [self setAttributedTitle:title image:image];
        self.titleLabel.numberOfLines = 2;
        [self.titleLabel sizeToFit];
    }
    _pdfObject = object;
}


@end


