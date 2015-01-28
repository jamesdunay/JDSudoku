//
//  DigitSelector.h
//  JDSudoku
//
//  Created by James Dunay on 1/26/15.
//  Copyright (c) 2015 James Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OnSelectDigit)(NSInteger digit);

@interface DigitSelector : UIView

@property(nonatomic, copy)OnSelectDigit onSelectDigit;

@end
