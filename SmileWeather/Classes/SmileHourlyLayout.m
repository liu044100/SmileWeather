//
//  SmileHourlyLayout.m
//  Pods
//
//  Created by ryu-ushin on 7/29/15.
//
//

#import "SmileHourlyLayout.h"

@implementation SmileHourlyLayout
static CGFloat kToleranceSpacing_min = 10.0;
static CGFloat kToleranceSpacing_max = 28.0;
static CGFloat kItemWidth = 70.0;
static CGFloat kMinMargin = 8.0;
static NSInteger kItemNum = 4;


-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = CGSizeMake(68, 98);
        self.sectionInset = [self updateSectionInset];
    }
    
    return self;
}

-(UIEdgeInsets)updateSectionInset {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat spacing = (screenWidth - kItemWidth * kItemNum - 2 * kMinMargin)/(kItemNum - 1);
    
    if (spacing > kToleranceSpacing_max) {
        spacing = kToleranceSpacing_max;
    }
    
    if (spacing < kToleranceSpacing_min) {
        spacing = kToleranceSpacing_min;
    }

    
    CGFloat contentWidth = kItemWidth * kItemNum + (kItemNum - 1) * spacing;
    
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
