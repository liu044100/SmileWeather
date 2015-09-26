//
//  SmileLineLayout.m
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/16/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileLineLayout.h"

@interface SmileLineLayout()
@property(nonatomic, assign) NSUInteger itemNum;
@end

@implementation SmileLineLayout
static CGFloat kItemWidth = 70.0;
static CGFloat kMinMargin = 8.0;
static NSInteger kItemNum = 4;

-(instancetype)initWithItemNum:(NSUInteger)itemNum{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = CGSizeMake(kItemWidth, 130.0);
        if (itemNum != 0) {
            self.itemNum = itemNum;
        } else {
            self.itemNum = kItemNum;
        }
        self.sectionInset = [self updateSectionInset];
    }
    return self;
}

-(UIEdgeInsets)updateSectionInset {
    CGFloat screenWidth = self.collectionView.bounds.size.width;
    self.minimumLineSpacing = (screenWidth - kItemWidth * kItemNum - 2 * kMinMargin)/(kItemNum - 1);
    CGFloat toleranceSpacing = screenWidth/12.0;
    if (self.minimumLineSpacing > toleranceSpacing) {
        self.minimumLineSpacing = toleranceSpacing;
    }
    CGFloat contentWidth = kItemWidth * _itemNum + (_itemNum - 1) * self.minimumLineSpacing;
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
