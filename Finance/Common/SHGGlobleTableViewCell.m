//
//  SHGGlobleTableViewCell.m
//  Finance
//
//  Created by weiqiankun on 16/1/21.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGGlobleTableViewCell.h"
@interface SHGGlobleTableViewCell()

@property (strong, nonatomic) UIView *lineView;

@end

@implementation SHGGlobleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.textLabel.font = [UIFont systemFontOfSize:15.0f];
        self.textLabel.textColor = [UIColor colorWithHexString:@"161616"];

        [self.contentView addSubview:self.lineView];

        self.textLabel.sd_layout
        .leftSpaceToView(self.contentView, 15.0f)
        .topSpaceToView(self.contentView, 0.0f)
        .rightSpaceToView(self.contentView, 0.0f)
        .heightIs(54.0f);

        self.lineView.sd_layout
        .bottomSpaceToView(self.contentView, 0.0f)
        .leftSpaceToView(self.contentView, 16.0f)
        .rightSpaceToView(self.contentView, 0.0f)
        .heightIs(0.5f);
    }
    return self;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e6e7e8"];
    }
    return _lineView;
}

- (void)setModel:(SHGGlobleModel *)model
{
    _model = model;
    self.textLabel.text = model.text;

    //***********************高度自适应cell设置步骤************************

    [self setupAutoHeightWithBottomView:self.textLabel bottomMargin:0.0f];
}

@end



@implementation SHGGlobleModel

@end