//
//  UIButton+EnlargeEdge.m
//  firstDemo
//
//  Created by changxicao on 15/9/14.
//  Copyright (c) 2015年 changxicao. All rights reserved.
//

#import "UIButton+EnlargeEdge.h"
#import <objc/runtime.h>

@implementation UIButton (EnlargeEdge)
static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;


- (void)setEnlargeEdge:(CGFloat) size
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}

//- (UIView*)hitTest:(CGPoint) point withEvent:(UIEvent*) event
//{
//    CGRect rect = [self enlargedRect];
//    if (CGRectEqualToRect(rect, self.bounds))
//    {
//        return [super hitTest:point withEvent:event];
//    }
//    return CGRectContainsPoint(rect, point) ? self : nil;
//}

@end


//加badge
@implementation UIButton (Badge)

- (void)setBadgeNumber:(NSString *)number
{
    SHGBadgeView *badgeView = nil;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[SHGBadgeView class]]) {
            badgeView = (SHGBadgeView *)view;
            break;
        }
    }
    if (!badgeView) {
        badgeView = [SHGBadgeView customBadgeWithString:number];
        CGPoint point = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMinY(self.bounds));
        badgeView.center = point;
        [self addSubview:badgeView];
    } else{
        [badgeView autoBadgeSizeWithString:number];
    }
}

- (void)removeBadgeNumber
{
    SHGBadgeView *badgeView = nil;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[SHGBadgeView class]]) {
            badgeView = (SHGBadgeView *)view;
            break;
        }
    }
    if (badgeView) {
        [badgeView removeFromSuperview];
    }
}
@end