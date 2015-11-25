//
//  SHGActionSignViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionSignViewController.h"
#import "SHGActionSignTableViewCell.h"
#import "SHGPersonalViewController.h"
#import "SHGActionManager.h"
#import "SHGActionTotalInViewController.h"

#define PRAISE_SEPWIDTH     10
#define PRAISE_RIGHTWIDTH     40
#define PRAISE_WIDTH 30.0f

@interface SHGActionSignViewController ()<UITableViewDataSource,UITableViewDelegate, SHGActionSignCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *titleBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionInLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionIntroduceLabel;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *footerBgImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *praiseScrollView;
@property (weak, nonatomic) IBOutlet UIView *praiseView;
@property (weak, nonatomic) IBOutlet UIButton *viewTotalButton;
@property (weak, nonatomic) IBOutlet UIButton *addPrasiseButton;
@property (weak, nonatomic) IBOutlet UIButton *addCommentButton;
@property (assign, nonatomic) CGFloat height;
@property (weak, nonatomic) IBOutlet UIImageView *firstLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondLineImageView;
@property (weak, nonatomic) IBOutlet UILabel *hadApply;

@end

@implementation SHGActionSignViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.height == 0) {
        UIImage *image = self.titleBgView.image;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 2.0f) resizingMode:UIImageResizingModeStretch];
        [self loadUI];
    }
}

- (void)refreshUI
{
    [self loadUI];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (CGFloat)heightForView
{
    return CGRectGetHeight(self.tableView.frame);
}

- (void)loadUI
{
    self.titleLabel.text = self.object.theme;
    self.actionPositionLabel.text = self.object.meetArea;
    self.actionTotalLabel.text = [NSString stringWithFormat:@"邀请%@人", self.object.meetNum];
    self.actionInLabel.text = [NSString stringWithFormat:@"已报名 %@人", self.object.attendNum];
    self.actionIntroduceLabel.text = self.object.detail;
    self.actionTimeLabel.text = [self.object.startTime stringByAppendingFormat:@"-%@",self.object.endTime];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.actionInLabel.text]] ;
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"F7514A"] range:NSMakeRange(3, noteStr.length-4 )];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"B4B4B4"] range:NSMakeRange(noteStr.length-1 , 1 )];
    [self.hadApply setAttributedText:noteStr];
    self.hadApply.attributedText = noteStr;


    CGSize size = self.viewTotalButton.imageView.image.size;
    [self.viewTotalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -size.width * 2, 0, size.width * 2)];
    [self.viewTotalButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.viewTotalButton.titleLabel.bounds.size.width, 0, -self.viewTotalButton.titleLabel.bounds.size.width)];
    //设置详情的高度
    size = [self.actionIntroduceLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.actionIntroduceLabel.frame), MAXFLOAT)];
    CGRect frame = self.actionIntroduceLabel.frame;
    frame.size.height = size.height + kObjectMargin;
    self.actionIntroduceLabel.frame = frame;
    //设置查看全部的高度
    frame = self.bottomView.frame;
    frame.origin.y = CGRectGetMaxY(self.actionIntroduceLabel.frame) + kObjectMargin;
    self.bottomView.frame = frame;
    //设置headerview的高度
    frame = self.headerView.frame;
    frame.size.height = CGRectGetMaxY(self.bottomView.frame);
    self.headerView.frame = frame;
    [self loadFooterUI];
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:self.footerView];
    //设置tableview和self.view的高度
    frame = self.tableView.frame;
    CGPoint point = CGPointMake(0.0f, CGRectGetMaxY(self.footerView.frame));
    frame.size.height = point.y;
    self.tableView.frame = frame;
    self.view.frame = frame;
    [self loadPraiseButtonState];
    [self loadCommentButtonState];

    if (self.finishBlock) {
        self.height = CGRectGetHeight(frame);
        self.finishBlock(self.height);
    }
    
    UIImage * img = [UIImage imageNamed:@"action_xuxian"];
    self.firstLineImageView.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0 , 1, 0, 1) resizingMode:UIImageResizingModeTile];
    self.secondLineImageView.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0 , 1, 0, 1) resizingMode:UIImageResizingModeTile];

}

- (void)loadPraiseButtonState
{
    //设置点赞的状态
    if ([self.object.isPraise isEqualToString:@"N"]) {
        [self.addPrasiseButton setImage:[UIImage imageNamed:@"home_weizan"] forState:UIControlStateNormal];
    } else{
        [self.addPrasiseButton setImage:[UIImage imageNamed:@"home_yizan"] forState:UIControlStateNormal];
    }
    [self.addPrasiseButton setTitle:self.object.praiseNum forState:UIControlStateNormal];
}

- (void)loadCommentButtonState
{
    [self.addCommentButton setTitle:self.object.commentNum forState:UIControlStateNormal];
}

- (void)loadFooterUI
{
    UIImage *image = self.footerBgImageView.image;
    self.footerBgImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 35.0f, 9.0f, 11.0f) resizingMode:UIImageResizingModeStretch];
    [self.praiseScrollView removeAllSubviews];
    CGRect praiseRect = self.praiseView.frame;
    CGFloat praiseWidth = 0;
    if ([self.object.praiseNum integerValue] > 0){
        NSArray *array = self.object.praiseList;
        for (NSInteger i = 0; i < array.count; i++) {
            praiseOBj *obj = [array objectAtIndex:i];
            praiseWidth = PRAISE_WIDTH;
            CGRect rect = CGRectMake((praiseWidth + PRAISE_SEPWIDTH) * i , (CGRectGetHeight(praiseRect) - praiseWidth) / 2.0f, praiseWidth, praiseWidth);
            UIImageView *head = [[UIImageView alloc] initWithFrame:rect];
            head.tag = [obj.puserid integerValue];
            [head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,obj.ppotname]] placeholderImage:[UIImage imageNamed:@"default_head"]];
            head.userInteractionEnabled = YES;
            DDTapGestureRecognizer *recognizer = [[DDTapGestureRecognizer alloc] initWithTarget:self action:@selector(moveToUserCenter:)];
            [head addGestureRecognizer:recognizer];
            [self.praiseScrollView addSubview:head];
        }
        [self.praiseScrollView setContentSize:CGSizeMake(array.count * (praiseWidth + PRAISE_SEPWIDTH), CGRectGetHeight(self.praiseScrollView.frame))];
    }
}

- (void)moveToUserCenter:(UITapGestureRecognizer *)recognizer
{
    SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] init];
    controller.userId = [NSString stringWithFormat:@"%ld",(long)recognizer.view.tag];
    [self.superController.navigationController pushViewController:controller animated:YES];
}

#pragma mark ------查看全部
- (IBAction)viewTotalParticipant:(id)sender
{
    __weak typeof(self) weakSelf = self;
    SHGActionTotalInViewController *controller = [[SHGActionTotalInViewController alloc] init];
    controller.attendList = self.object.attendList;
    controller.publisher = self.object.publisher;
    controller.block = ^{
        [weakSelf.tableView reloadData];
    };
    [self.superController.navigationController pushViewController:controller animated:YES];
}

#pragma mark ------点赞
- (IBAction)addPraiseClick:(id)sender
{
    __weak typeof(self)weakSelf = self;
    if ([self.object.isPraise isEqualToString:@"N"]) {
        [[SHGActionManager shareActionManager] addPraiseWithObject:self.object finishBlock:^(BOOL success) {
            [weakSelf loadPraiseButtonState];
            [weakSelf loadFooterUI];
            [weakSelf didChangePraiseState:weakSelf.object isPraise:YES];
        }];
    } else{
        [[SHGActionManager shareActionManager] deletePraiseWithObject:self.object finishBlock:^(BOOL success) {
            [weakSelf loadPraiseButtonState];
            [weakSelf loadFooterUI];
            [weakSelf didChangePraiseState:weakSelf.object isPraise:NO];
        }];
    }
}

- (void)didChangePraiseState:(SHGActionObject *)object isPraise:(BOOL)isPraise
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangePraiseState:isPraise:)]) {
        [self.delegate didChangePraiseState:object isPraise:isPraise];
    }
}

- (NSInteger)numberOfAttend
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSInteger count = self.object.attendList.count;
    for (SHGActionAttendObject *object in self.object.attendList){
        if ([object.uid isEqualToString:uid]) {
            count--;
            [self.object.attendList removeObject:object];
            break;
        }
    }
    count = count > 3 ? 3: count;
    return count;
}

#pragma mark ------tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfAttend];
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SHGActionSignTableViewCell";
    SHGActionSignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGActionSignTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    [cell loadCellWithObject:[self.object.attendList objectAtIndex:indexPath.row] publisher:self.object.publisher];
    NSInteger count = [self numberOfAttend];
    if (indexPath.row ==  count - 1)
    {
        [cell loadLastCellLineImage];
    }
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kActionSignCellHeight;
}

#pragma mark ------signDelegate
- (void)meetAttend:(SHGActionAttendObject *)object clickCommitButton:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    [[SHGActionManager shareActionManager] userCheckOtherState:object option:@"1" reason:nil finishBlock:^(BOOL success) {
        [weakSelf.tableView reloadData];
    }];
}

- (void)meetAttend:(SHGActionAttendObject *)object clickRejectButton:(UIButton *)button reason:(NSString *)reason
{
    __weak typeof(self) weakSelf = self;
    [[SHGActionManager shareActionManager] userCheckOtherState:object option:@"0" reason:reason finishBlock:^(BOOL success) {
        [weakSelf.tableView reloadData];
    }];
}
@end
