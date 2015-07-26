//
//  SmilePaddingLabel.m
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/21/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmilePaddingLabel.h"

const CGFloat kPadding = 5;

@implementation SmilePaddingLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, kPadding, 0, -kPadding};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGSize)intrinsicContentSize
{
    CGSize parentSize = [super intrinsicContentSize];
    parentSize.width += 2*kPadding;
    return parentSize;
}

@end
