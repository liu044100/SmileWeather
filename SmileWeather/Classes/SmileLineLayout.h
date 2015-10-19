//
//  SmileLineLayout.h
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/16/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmileLineLayout : UICollectionViewFlowLayout

-(instancetype)initWithItemNum:(NSUInteger)itemNum;
-(UIEdgeInsets)updateSectionInset;
@end
