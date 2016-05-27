//
//  SHGDiscoveryDisplayViewController.m
//  Finance
//
//  Created by changxicao on 16/5/25.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGDiscoveryDisplayViewController.h"
#import "SHGDiscoveryManager.h"
#import "EMSearchBar.h"

@interface SHGDiscoveryDisplayViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (assign, nonatomic) NSInteger pageNumber;
@property (strong, nonatomic) NSString *searchText;

@property (assign, nonatomic) BOOL hideSearchBar;

@end

@implementation SHGDiscoveryDisplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.object.industryName;
    [self initView];
    [self addAutoLayout];

}

- (void)initView
{
    self.pageNumber = 1;
    [self.view insertSubview:self.searchBar belowSubview:self.tableView];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
    self.tableView.mj_footer.automaticallyHidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.hideSearchBar = NO;
    self.searchText = @"";
}

- (void)addAutoLayout
{
    self.searchBar.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f);
}

- (EMSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入姓名/公司名";
    }
    return _searchBar;
}

- (void)setHideSearchBar:(BOOL)hideSearchBar
{
    _hideSearchBar = hideSearchBar;
    self.tableView.sd_resetLayout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(hideSearchBar ? self.view : self.searchBar, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    self.pageNumber = 1;
    [self.dataArr removeAllObjects];
    [self loadData];
}

- (void)refreshFooter
{
    [self loadData];
}

- (void)loadData
{
    __weak typeof(self)weakSelf = self;
    void(^block)(NSArray *firstArray, NSArray *secondArray) = ^(NSArray *firstArray, NSArray *secondArray) {
        [weakSelf.dataArr addObjectsFromArray:firstArray];

        if (firstArray.count < 10) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        weakSelf.pageNumber++;
        [weakSelf.tableView reloadData];
    };


    if ([self.object.industryName isEqualToString:@"邀请好友"]) {
        //不显示搜索框
        self.hideSearchBar = YES;
        NSDictionary *param = @{@"uid":UID, @"pageNum":@(self.pageNumber), @"pageSize":@"10"};
        [SHGDiscoveryManager loadDiscoveryInvateData:param block:block];
    } else {
        NSDictionary *param = @{@"uid":UID, @"pageNum":@(self.pageNumber), @"pageSize":@"10", @"condition":self.searchText, @"industry":self.object.industry, @"industryTotal":self.object.industryNum};
        [SHGDiscoveryManager loadDiscoveryMyDepartmentData:param block:block];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        NSObject *object = [self.dataArr objectAtIndex:indexPath.row];
        CGFloat height = [tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGDiscoveryDisplayCell class] contentViewWidth:SCREENWIDTH];
        return height;
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGDiscoveryDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHGDiscoveryDisplayCell"];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGDiscoveryDisplayCell" owner:self options:nil] lastObject];
    }
    cell.object = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.searchText = searchBar.text;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end



@interface SHGDiscoveryDisplayCell()

@property (weak, nonatomic) IBOutlet SHGUserHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *spliteView;
@property (weak, nonatomic) IBOutlet UIImageView *relationShipImageView;

@end


@implementation SHGDiscoveryDisplayCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.firstLabel.font = FontFactor(16.0f);
    self.secondLabel.font = self.thirdLabel.font = FontFactor(14.0f);
    self.firstLabel.textColor = Color(@"161616");
    self.secondLabel.textColor = self.thirdLabel.textColor = Color(@"898989");
    self.spliteView.backgroundColor = Color(@"e6e7e8");
}

- (void)addAutoLayout
{
    self.headerView.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(12.0f))
    .topSpaceToView(self.contentView, MarginFactor(12.0f))
    .widthIs(MarginFactor(60.0f))
    .heightEqualToWidth(1.0f);

    self.firstLabel.sd_layout
    .topEqualToView(self.headerView)
    .leftSpaceToView(self.headerView, MarginFactor(10.0f));
    [self.firstLabel setSingleLineAutoResizeWithMaxWidth:MarginFactor(200.0f)];

    self.secondLabel.sd_layout
    .centerYEqualToView(self.headerView)
    .leftEqualToView(self.firstLabel);
    [self.secondLabel setSingleLineAutoResizeWithMaxWidth:MarginFactor(200.0f)];

    self.thirdLabel.sd_layout
    .bottomEqualToView(self.headerView)
    .leftEqualToView(self.firstLabel);
    [self.thirdLabel setSingleLineAutoResizeWithMaxWidth:MarginFactor(200.0f)];

    self.spliteView.sd_layout
    .leftSpaceToView(self.contentView, MarginFactor(10.0f))
    .topSpaceToView(self.headerView, MarginFactor(12.0f))
    .rightSpaceToView(self.contentView, 0.0f)
    .heightIs(1 / SCALE);

    [self setupAutoHeightWithBottomView:self.spliteView bottomMargin:0.0f];
}

- (void)setObject:(NSObject *)object
{
    _object = object;
    if ([object isKindOfClass:[SHGDiscoveryPeopleObject class]]) {
        //发现的搜索
        SHGDiscoveryPeopleObject *peopleObject = (SHGDiscoveryPeopleObject *)object;
        [self.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,peopleObject.headImg] placeholderImage:[UIImage imageNamed:@"default_head"] status:peopleObject.status userID:peopleObject.userID];
        self.firstLabel.text = peopleObject.realName;
        self.secondLabel.text = peopleObject.company;
        self.thirdLabel.text = peopleObject.area;
        if (peopleObject.isAttention) {
            [self.button setImage:[UIImage imageNamed:@"me_follow"] forState:UIControlStateNormal];
        } else {
            [self.button setImage:[UIImage imageNamed:@"me_followed"] forState:UIControlStateNormal];
        }
    } else if ([object isKindOfClass:[SHGDiscoveryInvateObject class]]) {
        //邀请好友
        SHGDiscoveryInvateObject *invateObject = (SHGDiscoveryInvateObject *)object;

        self.firstLabel.text = invateObject.realName;
        self.secondLabel.text = @"暂未提供公司信息";
        self.thirdLabel.text = @"通讯录联系人";
        [self.button setImage:[UIImage imageNamed:@"discovery_invate"] forState:UIControlStateNormal];
    } else if ([object isKindOfClass:[SHGDiscoveryDepartmentObject class]]) {
        //我的人脉
        SHGDiscoveryDepartmentObject *depentmentObject = (SHGDiscoveryDepartmentObject *)object;
        [self.headerView updateHeaderView:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,depentmentObject.headImg] placeholderImage:[UIImage imageNamed:@"default_head"] status:depentmentObject.userStatus userID:depentmentObject.userID];
        self.firstLabel.text = depentmentObject.realName;
        self.secondLabel.text = depentmentObject.company;
        self.thirdLabel.text = depentmentObject.area;
        self.relationShipImageView.image = depentmentObject.friendTypeImage;
    }
    self.button.sd_layout
    .rightSpaceToView(self.contentView, MarginFactor(12.0f))
    .centerYEqualToView(self.headerView)
    .heightIs(self.button.currentImage.size.height)
    .widthIs(self.button.currentImage.size.width);

    self.relationShipImageView.sd_layout
    .centerYEqualToView(self.firstLabel)
    .leftSpaceToView(self.firstLabel, MarginFactor(10.0f))
    .heightIs(self.relationShipImageView.image.size.height)
    .widthIs(self.relationShipImageView.image.size.width);
}


@end


@interface SHGDiscoveryDisplayExpandViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) NSString *searchText;

@end

@implementation SHGDiscoveryDisplayExpandViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.object.moduleName;
    [self initView];
    [self addAutoLayout];
    [self loadDataWithTarget:@"first"];

}

- (void)initView
{
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self addHeaderRefresh:self.tableView headerRefesh:NO andFooter:YES];
    self.tableView.mj_footer.automaticallyHidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.searchText = @"";
}

- (void)addAutoLayout
{
    self.searchBar.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f);

    self.tableView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.searchBar, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);
}

- (EMSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        if (self.object.moduleType == SHGDiscoveryGroupingTypeIndustry) {
            _searchBar.placeholder = @"请输入城市名/姓名查找精准人脉";
        } else {
            _searchBar.placeholder = @"请输入行业名/姓名查找精准人脉";
        }
    }
    return _searchBar;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)refreshFooter
{
    [self loadDataWithTarget:@"load"];
}

- (NSString *)minUserID
{
    NSString *maxUserID = [NSString stringWithFormat:@"%ld",NSIntegerMax];
    NSString *uid = maxUserID;
    for (SHGDiscoveryPeopleObject *object in self.dataArr) {
        NSString *userID = object.userID;
        if ([userID compare:uid options:NSNumericSearch] == NSOrderedAscending) {
            uid = userID;
        }
    }
    return [uid isEqualToString:maxUserID] ? @"-1" : uid;
}

- (void)loadDataWithTarget:(NSString *)target
{
    __weak typeof(self)weakSelf = self;
    void(^block)(NSArray *firstArray, NSArray *secondArray) = ^(NSArray *firstArray, NSArray *secondArray) {
        if ([target isEqualToString:@"first"]) {
            [weakSelf.dataArr removeAllObjects];
        }
        [weakSelf.dataArr addObjectsFromArray:firstArray];

        if (firstArray.count < 10) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.tableView reloadData];
    };

    if (self.object.moduleType == SHGDiscoveryGroupingTypeIndustry) {

        NSDictionary *param = @{@"target":target, @"industry":self.object.module, @"userId":[self minUserID], @"pageSize":@"10", @"positionCondition":self.searchText, @"uid":UID};
        [SHGDiscoveryManager loadDiscoveryGroupUserDetail:param block:block];
    } else {
        
        NSDictionary *param = @{@"target":target, @"position":self.object.module, @"userId":[self minUserID], @"pageSize":@"10", @"industryCondition":self.searchText, @"uid":UID};
        [SHGDiscoveryManager loadDiscoveryGroupUserDetail:param block:block];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count > 0) {
        NSObject *object = [self.dataArr objectAtIndex:indexPath.row];
        CGFloat height = [tableView cellHeightForIndexPath:indexPath model:object keyPath:@"object" cellClass:[SHGDiscoveryDisplayCell class] contentViewWidth:SCREENWIDTH];
        return height;
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGDiscoveryDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHGDiscoveryDisplayCell"];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGDiscoveryDisplayCell" owner:self options:nil] lastObject];
    }
    cell.object = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.searchText = searchBar.text;
    [self loadDataWithTarget:@"first"];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
