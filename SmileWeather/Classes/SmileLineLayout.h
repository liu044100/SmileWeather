//
//  SmileLineLayout.h
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/16/15.
//  Copyright (c) 2015 rain. All rights reserved.
//
#if TARGET_OS_IOS

#import <UIKit/UIKit.h>
@interface SmileLineLayout : UICollectionViewFlowLayout
@property(nonatomic, assign) NSUInteger itemNum;
-(instancetype)initWithItemNum:(NSUInteger)itemNum;
-(UIEdgeInsets)updateSectionInset;
@end

#endif
