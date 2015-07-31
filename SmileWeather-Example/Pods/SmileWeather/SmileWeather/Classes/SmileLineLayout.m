//
//  SmileLineLayout.m
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/16/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileLineLayout.h"

@implementation SmileLineLayout
static CGFloat kToleranceSpacing = 28.0;
static CGFloat kItemWidth = 70.0;
static CGFloat kMinMargin = 8.0;
static NSInteger kItemNum = 4;


-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = CGSizeMake(kItemWidth, 130.0);
        self.sectionInset = [self updateSectionInset];
    }
    
    return self;
}

-(UIEdgeInsets)updateSectionInset {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.minimumLineSpacing = (screenWidth - kItemWidth * kItemNum - 2 * kMinMargin)/(kItemNum - 1);
    
    if (self.minimumLineSpacing > kToleranceSpacing) {
        self.minimumLineSpacing = kToleranceSpacing;
    }
    
    CGFloat contentWidth = kItemWidth * kItemNum + (kItemNum - 1) * self.minimumLineSpacing;
    
    UIEdgeInsets insets;
    if (screenWidth > contentWidth) {
        CGFloat buffer = (screenWidth - contentWidth)/2.0;
        insets = UIEdgeInsetsMake(0, buffer, 0, 0);
    } else {
        insets = UIEdgeInsetsMake(0, kMinMargin, 0, 0);
    }
    return insets;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    self.sectionInset = [self updateSectionInset];
    
    return YES;
}


@end
