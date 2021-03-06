//
//  SHGBusinessCommentTableViewCell.m
//  Finance
//
//  Created by changxicao on 16/4/14.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessCommentTableViewCell.h"

@interface SHGBusinessCommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (assign, nonatomic) SHGBusinessCommentType commentType;

@end

@implementation SHGBusinessCommentTableViewCell

- (void)awakeFromNib
{
}

- (void)loadUIWithObj:(SHGBusinessCommentObject *)object commentType:(SHGBusinessCommentType)type
{
    self.commentType = type;
    CGRect frame = CGRectZero;
    switch (type) {
        case SHGBusinessCommentTypeFirst:
            frame = CGRectMake(CELLRIGHT_COMMENT_WIDTH,kCommentTopMargin, SCREENWIDTH - kPhotoViewLeftMargin - kPhotoViewRightMargin - CELLRIGHT_COMMENT_WIDTH, 0.0f);

            break;
        case SHGBusinessCommentTypeNormal:
            frame = CGRectMake(CELLRIGHT_COMMENT_WIDTH,0.0f, SCREENWIDTH - kPhotoViewLeftMargin - kPhotoViewRightMargin - CELLRIGHT_COMMENT_WIDTH, 0.0f);
            break;
        default:
            frame = CGRectMake(CELLRIGHT_COMMENT_WIDTH,0.0f, SCREENWIDTH - kPhotoViewLeftMargin - kPhotoViewRightMargin - CELLRIGHT_COMMENT_WIDTH, 0.0f);
            break;
    }
    UILabel *replyLabel = [[UILabel alloc] initWithFrame:frame];
    replyLabel.numberOfLines = 0;
    replyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    replyLabel.font = [UIFont systemFontOfSize:14.0f];
    replyLabel.userInteractionEnabled = YES;
    replyLabel.textAlignment = NSTextAlignmentLeft;
    NSString *text = @"";

    NSMutableAttributedString *str;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.backgroundColor = [UIColor clearColor];
    rightButton.backgroundColor = [UIColor clearColor];
    [leftButton setBackgroundImage:[UIImage imageWithColor:BTN_SELECT_BACK_COLOR andSize:CGSizeMake(40, 40)] forState:UIControlStateHighlighted];
    [rightButton setBackgroundImage:[UIImage imageWithColor:BTN_SELECT_BACK_COLOR andSize:CGSizeMake(40, 40)] forState:UIControlStateHighlighted];
    leftButton.tag = self.index;
    rightButton.tag = self.index;
    if (IsStrEmpty(object.commentOtherName)){
        text = [NSString stringWithFormat:@"%@:x%@",object.commentUserName,object.commentDetail];

        CGSize cSize = [[NSString stringWithFormat:@"%@:",object.commentUserName] sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];
        [leftButton setFrame:CGRectMake(0, 0, cSize.width, cSize.height)];
        [leftButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [leftButton setTitle:[NSString stringWithFormat:@"%@:",object.commentUserName] forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor colorWithHexString:@"4277B2"] forState:UIControlStateNormal];
        [leftButton.titleLabel setFont:replyLabel.font];
        [replyLabel addSubview:leftButton];
        str = [[NSMutableAttributedString alloc] initWithString:text];

        [str addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0,object.commentUserName.length + 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"3C3C3C"] range:NSMakeRange(object.commentUserName.length + 2,str.length - object.commentUserName.length - 2)];
    } else{
        text = [NSString stringWithFormat:@"%@回复%@:x%@",object.commentUserName, object.commentOtherName, object.commentDetail];
        CGSize cSize = [object.commentUserName sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];
        [leftButton setFrame:CGRectMake(0, 0, cSize.width, cSize.height)];
        [leftButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [leftButton setTitle:object.commentUserName forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor colorWithHexString:@"4277B2"] forState:UIControlStateNormal];
        [leftButton.titleLabel setFont:replyLabel.font];
        [replyLabel addSubview:leftButton];

        NSString *leftText = [NSString stringWithFormat:@"回复"];
        CGSize leftSize = [leftText sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];
        CGSize rSize = [[NSString stringWithFormat:@"%@:",object.commentOtherName] sizeForFont:replyLabel.font constrainedToSize:CGSizeMake(200, 15) lineBreakMode:replyLabel.lineBreakMode];

        [rightButton setFrame:CGRectMake(leftSize.width + cSize.width, 0, rSize.width, rSize.height)];
        [rightButton setTitle:[NSString stringWithFormat:@"%@:",object.commentOtherName] forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorWithHexString:@"4277B2"] forState:UIControlStateNormal];
        [rightButton.titleLabel setFont:replyLabel.font];
        [rightButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [replyLabel addSubview:rightButton];


        str = [[NSMutableAttributedString alloc] initWithString:text];

        [str addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0, object.commentUserName.length)];

        [str addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(object.commentUserName.length + 2,object.commentOtherName.length + 2)];

        NSRange range = NSMakeRange(object.commentUserName.length + 2,1 + object.commentOtherName.length +1);
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"3C3C3C"] range:NSMakeRange(range.location + range.length,str.length - range.length - range.location)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"3C3C3C"] range:NSMakeRange(object.commentUserName.length, 2)];
    }
    [leftButton addTarget:self action:@selector(leftUserClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(rightUserClick:) forControlEvents:UIControlEventTouchUpInside];
    [str addAttribute:NSFontAttributeName value:replyLabel.font range:NSMakeRange(0, text.length)];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:3];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];

    replyLabel.attributedText = str;

    CGRect replyRect = replyLabel.frame;
    CGSize size = [replyLabel sizeThatFits:CGSizeMake(SCREENWIDTH - kPhotoViewRightMargin - kPhotoViewLeftMargin - CELLRIGHT_COMMENT_WIDTH, CGFLOAT_MAX)];
    NSLog(@"%f",size.height);
    replyRect.size = size;
    replyLabel.frame = replyRect;
    [self.bgView addSubview:replyLabel];

}

- (void)leftUserClick:(UIButton *)sender
{
    [self.delegate leftUserClick:self.index];
}

- (void)rightUserClick:(UIButton *)sender
{
    [self.delegate rightUserClick:self.index];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
