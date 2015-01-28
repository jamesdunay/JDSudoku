//
//  Board.h
//  JDSudoku
//
//  Created by James Dunay on 1/26/15.
//  Copyright (c) 2015 James Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BoardDifficulty){
    BoardDifficultyHard = 1,
    BoardDifficultyMedium = 2,
    BoardDifficultyEasy = 3
};

typedef void(^OnTap)(BOOL shouldOpen);

@interface Board : UIView
@property(nonatomic, copy)OnTap onTap;
@property(nonatomic)BOOL shouldBeMinimized;

-(void)adjustViewForTag:(NSInteger)tag;
-(void)assignDigitToTile:(NSInteger)digit;

@end
