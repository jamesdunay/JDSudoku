//
//  Element.h
//  JDSudoku
//
//  Created by James Dunay on 1/25/15.
//  Copyright (c) 2015 James Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface BoardTile : UIView
@property(nonatomic, strong)Item* item;
@property(nonatomic, strong)UILabel* label;

-(void)changeDisplayTo:(NSInteger)digit;
-(void)showAnswer;

@end
