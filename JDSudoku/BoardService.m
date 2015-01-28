//
//  BoardService.m
//  JDSudoku
//
//  Created by James Dunay on 1/25/15.
//  Copyright (c) 2015 James Dunay. All rights reserved.
//

#import "BoardService.h"

static BoardService* sBoardService = nil;

@interface BoardService()
@property(nonatomic, strong)NSArray* totalPossibleNumbers;
@end

@implementation BoardService

+(void)initialize{
    sBoardService = [[BoardService alloc] init];
        sBoardService.totalPossibleNumbers = @[@1, @2, @3, @4, @5, @6, @7, @8, @9];
}

+(BoardService*)sharedInstance{
    return sBoardService;
}

#pragma Mark Initial Setup ------

-(NSArray*)createNewBoard{
//    ^^ MAIN SUDOKU ALGORITHM -------------------
//    ^^ Generates 1 unique cell
//    ^^ Uses cell to rotate and place rows (3x1) and columns (1x3) into adjacent positions
    
    NSMutableArray* board = [[NSMutableArray alloc] init];
    for (int row = 0; row < 9; row++) {
        [board addObject:[@[@0,@0,@0,@0,@0,@0,@0,@0,@0] mutableCopy]];
    }
    
    NSArray* block = [self generateNewThreeByThree];
    for (int blockRow = 0; blockRow < 3; blockRow++) {
        for (int blockColumn = 0; blockColumn < 3; blockColumn++) {
            NSNumber* item = block[blockRow][blockColumn];
            for (int cellRow = 0; cellRow < 3; cellRow++) {
                for (int cellColumn = 0; cellColumn < 3; cellColumn++) {
                    
                    NSInteger rowOffset = cellColumn + blockRow - 1;
                    //                    ^^ Adjust offset for every cell column
                    if (rowOffset < 0) rowOffset = 2;
                    if (rowOffset > 2) rowOffset = 0;
                    
                    NSInteger columnOffset = cellRow + blockColumn - 1;
                    //                    ^^ Adjust offset for every cell row
                    if (columnOffset < 0) columnOffset = 2;
                    if (columnOffset > 2) columnOffset = 0;
                    
                    [board[cellRow * 3 + rowOffset] replaceObjectAtIndex:cellColumn*3 + columnOffset withObject:item];
                }
            }
        }
    }
    
    [self printBoard:board];
    return board;
}

#pragma Mark Helper Methods ------

-(NSArray*)generateNewThreeByThree{
//    ^^ Create a unique 3x3 grid
    NSMutableArray* newThreeByThree = [@[[NSMutableArray new], [NSMutableArray new], [NSMutableArray new]] mutableCopy];
    NSMutableArray* copyOfFull = [self.totalPossibleNumbers mutableCopy];
    for (int row = 0; row < 3; row++) {
        for (int column = 0; column < 3; column++) {
            NSInteger randomIndex = [self randomIndexWithMaxValue:copyOfFull.count];
            [newThreeByThree[column] addObject:copyOfFull[randomIndex]];
            [copyOfFull removeObjectAtIndex:randomIndex];
        }
    }
    return [newThreeByThree copy];
}

-(NSInteger)randomIndexWithMaxValue:(NSInteger)maxValue{
    return arc4random() % maxValue;
}

-(void)printBoard:(NSArray*)board{
    for (NSArray* array in board) {
        NSMutableString* lineToPrint = [@"" mutableCopy];
        for (NSNumber* number in array) {
            [lineToPrint appendString:[NSString stringWithFormat:@"%@ | ", number]];
        }
        NSLog(@"%@", lineToPrint);
        NSLog(@" ");
    }
}

-(NSInteger)indexOfRandomTileInCell:(NSInteger)cellIndex{
//    ^^ The same index can be selected more than once, resulting in slightly varying results for each run
    NSInteger randomTileIndexInCell = arc4random() % 9;
    NSInteger randomTileRowIndex = randomTileIndexInCell/3;
    NSInteger randomTileColumnIndex = randomTileIndexInCell % 3;
    NSInteger indexOfRandomTile = (randomTileRowIndex * 9) + randomTileColumnIndex;
        
    NSInteger startingCellRow = (cellIndex/3) * 3;
    NSInteger startingCellColumn = (cellIndex % 3);
    NSInteger indexOfCellInBoard = (startingCellRow * 9) + (startingCellColumn * 3);

    return indexOfRandomTile + indexOfCellInBoard;
}


@end
