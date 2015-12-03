//
//  SHGActionViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/12.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionListViewController.h"
#import "SHGActionTableViewCell.h"
#import "SHGActionObject.h"
#import "SHGActionDetailViewController.h"
#import "SHGActionSendViewController.h"
#import "SHGActionManager.h"
#import "SHGActionSegmentViewController.h"
#import "SHGPersonalViewController.h"

@interface SHGActionListViewController ()<UITableViewDataSource, UITableViewDelegate, SHGActionTableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (weak, nonatomic) IBOutlet UIImageView *emptyBgImage;
@property (weak, nonatomic) IBOutlet UIView *emptyBgView;

@end

@implementation SHGActionListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){

    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listTable.delegate = self;
    self.listTable.dataSource = self;
    [self addHeaderRefresh:self.listTable headerRefesh:YES andFooter:YES];
    [self loadDataWithType:@"first" meetID:@"-1"];
}
-(void)emptyBg
{
    if (self.dataArr.count == 0) {
        self.emptyBgView.hidden = NO;
    } else{
        self.emptyBgView.hidden = YES;
    }
}
- (void)refreshData
{
    [self loadDataWithType:@"first" meetID:@"-1"];
}

- (void)reloadData
{
    [self.listTable reloadData];
}

- (NSMutableArray *)currentDataArray
{
    return self.dataArr;
}

- (void)addNewAction:(UIButton *)button
{
    SHGActionSendViewController *controller = [[SHGActionSendViewController alloc] initWithNibName:@"SHGActionSendViewController" bundle:nil];
    controller.delegate = [SHGActionSegmentViewController sharedSegmentController];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)loadDataWithType:(NSString *)target meetID:(NSString *)meetID
{
    NSString *request = [rBaseAddressForHttp stringByAppendingString:@"/meetingactivity/getMeetingActivityAll"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *pageSize = @"10";
    NSString *type = @"all";
    NSDictionary *dictionary = @{@"uid":uid, @"meetId":meetID, @"pageSize":pageSize, @"target":target, @"type":type};
    __weak typeof(self) weakSelf = self;
    [Hud showLoadingWithMessage:@"请稍等..."];
    [MOCHTTPRequestOperationManager postWithURL:request class:[SHGActionObject class] parameters:dictionary success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [weakSelf.listTable.header endRefreshing];
        [weakSelf.listTable.footer endRefreshing];
        if ([target isEqualToString:@"first"]) {
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:response.dataArray];
        } else if([target isEqualToString:@"refresh"]){
            for (NSInteger i = response.dataArray.count - 1; i >= 0; i--){
                CircleListObj *obj = [response.dataArray objectAtIndex:i];
                [weakSelf.dataArr insertObject:obj atIndex:0];
            }
        } else{
            [weakSelf.dataArr addObjectsFromArray:response.dataArray];
            if (response.dataArray.count < 10) {
                [weakSelf.listTable.footer endRefreshingWithNoMoreData];
            }
        }
        [weakSelf.listTable reloadData];
        [weakSelf emptyBg];
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"网络连接失败"];
        [weakSelf.listTable.header endRefreshing];
        [weakSelf.listTable.footer endRefreshing];
        self.emptyBgView.hidden = NO;
    }];
}

- (void)refreshHeader
{
    if (self.dataArr.count > 0) {
        [self loadDataWithType:@"refresh" meetID:[self maxMeetID]];
    } else{
        [self loadDataWithType:@"first" meetID:@"-1"];
    }
}


- (void)refreshFooter
{
    if (self.dataArr.count > 0) {
        [self loadDataWithType:@"load" meetID:[self minMeetID]];
    } else{
        [self loadDataWithType:@"first" meetID:@"-1"];
    }
}

- (NSString *)maxMeetID
{
    return ((SHGActionObject *)[self.dataArr firstObject]).meetId;
}

- (NSString *)minMeetID
{
    return ((SHGActionObject *)[self.dataArr lastObject]).meetId;
}
#pragma mark ------tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SHGActionTableViewCell";
    SHGActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGActionTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    SHGActionObject *object = [self.dataArr objectAtIndex:indexPath.row];
    [cell loadDataWithObject:object index:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHGActionDetailViewController *controller = [[SHGActionDetailViewController alloc] init];
    SHGActionObject *object = [self.dataArr objectAtIndex:indexPath.row];
    controller.object = object;
    controller.delegate = [SHGActionSegmentViewController sharedSegmentController];
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kActionCellHeight;
}

#pragma mark ------cell代理
- (void)clickPrasiseButton:(SHGActionObject *)object
{
    __weak typeof(self)weakSelf = self;
    if ([object.isPraise isEqualToString:@"N"]) {
        [[SHGActionManager shareActionManager] addPraiseWithObject:object finishBlock:^(BOOL success) {
            if (success) {
                [weakSelf.listTable reloadData];
            }
        }];
    } else{
        [[SHGActionManager shareActionManager] deletePraiseWithObject:object finishBlock:^(BOOL success) {
            if (success) {
                [weakSelf.listTable reloadData];
            }
        }];
    }
}

- (void)clickCommentButton:(SHGActionObject *)object
{
    SHGActionDetailViewController *controller = [[SHGActionDetailViewController alloc] init];
    controller.object = object;
    controller.delegate = [SHGActionSegmentViewController sharedSegmentController];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickEditButton:(SHGActionObject *)object
{
    [self loadUserPermissionStatefinishBlock:^(BOOL success) {
        if (success) {
            SHGActionSendViewController *controller = [[SHGActionSendViewController alloc] initWithNibName:@"SHGActionSendViewController" bundle:nil];
            controller.object = object;
            controller.delegate = [SHGActionSegmentViewController sharedSegmentController];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];

}

- (void)loadUserPermissionStatefinishBlock:(void (^)(BOOL))block
{
    [[SHGActionManager shareActionManager] loadUserPermissionState:^(NSString *state) {
        if ([state isEqualToString:@"0"]) {
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"您当前有活动正在审核中，请等待审核后再提交，谢谢。" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            block(NO);
        } else if ([state isEqualToString:@"2"]){
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"您当前有活动申请被驳回，请至我的活动查看。" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            block(NO);
        } else{
            block(YES);
        }
    }];
}
- (void)tapUserHeaderImageView:(NSString *)uid
{
    __weak typeof(self) weakSelf = self;
    SHGPersonalViewController * vc = [[SHGPersonalViewController alloc]init ];
    vc.userId = uid;
    [weakSelf.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc
{
    self.listTable.delegate = nil;
    self.listTable.dataSource = nil;
    [self.listTable removeFromSuperview];
    self.listTable = nil;
}
@end
