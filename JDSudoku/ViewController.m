//
//  ViewController.m
//  JDSudoku
//
//  Created by James Dunay on 1/23/15.
//  Copyright (c) 2015 James Dunay. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) NSArray* totalPossibleNumbers;
@property(nonatomic, strong) NSDictionary* possibleNumbersDict;

@property(nonatomic, strong) NSMutableArray* board;
@property(nonatomic, strong) NSMutableArray* availablePoints;
@property(nonatomic, strong) NSMutableArray* erroredLocations;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.totalPossibleNumbers = @[@1, @2, @3, @4, @5, @6, @7, @8, @9];
    self.possibleNumbersDict = @{@1 : @1, @2 : @2, @3 : @3, @5 : @5, @4 : @4, @6 : @6, @7 : @7, @8 : @8, @9 : @9};
    
    self.board = [NSMutableArray new];
    self.erroredLocations = [NSMutableArray new];
    self.availablePoints = [NSMutableArray new];
    
//    for (int row = 0; row < 10; row++) {
//        NSMutableArray* row = [NSMutableArray new];
//        [self.board addObject:row];
//    }

    
//    [self addColumnToBoard];
//    [self addColumnToBoard];
//    [self addColumnToBoard];
    
//    NSLog(@"Board : %@", self.board);
    
    /*
    NSArray* block = [self generateNewBlock];
//    ^^ Block is a full 4x8 column of the board
    
    NSArray* mirroredBlock = [self mirrorXAndY:block];
    NSMutableArray* board = [NSMutableArray new];
    [self addBlock:block atRow:0 andColumn:0 toBoard:board];
    [self addBlock:mirroredBlock atRow:1 andColumn:1 toBoard:board];
//  NSLog(@"board %@", board);
    */

//    [self beginMirrorApproach];
//    [self bruteForce];
    
    [self randomSelection];
}



-(void)bruteForce{
    for (int row = 0; row < 9; row++) {
        [self.board addObject:[@[@0,@0,@0,@0,@0,@0,@0,@0,@0] mutableCopy]];
    }
    
    for (int row = 0; row < 9; row++) {
        [self fillColumnAtIndex:row];
    }
    
    [self printBoard];
}



-(void)randomSelection{
    for (int row = 0; row < 9; row++) {
        [self.board addObject:[@[@0,@0,@0,@0,@0,@0,@0,@0,@0] mutableCopy]];
    }
    
    for (int row = 0; row < self.board.count; row++) {
        for (int column = 0; column < [self.board[row] count]; column++) {
            CGPoint position = CGPointMake(column, row);
            [self.availablePoints addObject:[NSValue valueWithCGPoint:position]];
        }
    }
    
    for (int row = 0; row < self.board.count; row++) {
        for (int column = 0; column < [self.board[row] count]; column++) {
            NSInteger randomIndex = [self selectRandomPoint];
            CGPoint randomPoint = [self.availablePoints[randomIndex] CGPointValue];
            [self generateNumberForPoint:randomPoint];
            [self.availablePoints removeObjectAtIndex:randomIndex];
        }
    }
    
    [self printBoard];

//    NSLog(@"%@", self.availablePoints);
    
    for (int i = 0; i < self.erroredLocations.count; i++) {
        
        NSValue* value = self.erroredLocations[i];
        CGPoint cellLocation = [self getCellLocationForPoint:[value CGPointValue]];
        [self redoCellAtLocation:cellLocation];
    }
    NSLog(@"-------------------------------------------");
    [self printBoard];
}


-(NSInteger)selectRandomPoint{
    return [self randomIndexWithMaxValue:self.availablePoints.count];
}


-(void)redoCellAtLocation:(CGPoint)cellLocation{
    //    ONLY WORKS WITH 3 not when you have 8
    int startingRowLocation = cellLocation.y * 3;
    int startingColumnLocation = cellLocation.x * 3;
    
    for (int row = startingRowLocation; row < startingRowLocation + 3; row++) {
        for (int column = startingColumnLocation; column < startingColumnLocation + 3; column++) {
                
            [self generateNumberForPoint:CGPointMake(column, row)];
                
                //           ^^ Check to see if column exists
                //                NSLog(@"Row %d", row);
                //                NSLog(@"Column %d", column);
                //                NSLog(@"Removing Number %@", self.board[row][column]);
                
//                [matches removeObjectForKey:self.board[row][column]];
        }
    }
}







-(void)generateNumberForPoint:(CGPoint)point{
    
    NSInteger row = point.y;
    NSInteger column = point.x;
    
    NSMutableDictionary* possibleMatches = [self.possibleNumbersDict mutableCopy];
    CGPoint cellLocation = [self getCellLocationForPoint:CGPointMake(column, row)];
    possibleMatches = [self removeExistingNumbersIn:possibleMatches forCell:cellLocation];
    possibleMatches = [self removeExistingNumbersIn:possibleMatches forRow:row];
    possibleMatches = [self removeExistingNumbersIn:possibleMatches forColumn:[self.board[row] count]];
    
    
    if (![possibleMatches allKeys].count) {
        NSLog(@"Miss");
        [self.erroredLocations addObject:[NSValue valueWithCGPoint:CGPointMake(column, row)]];
    }else{
        NSInteger randomIndex = [self randomIndexWithMaxValue:[possibleMatches allValues].count];
        [self.board[row] replaceObjectAtIndex:column withObject:[possibleMatches allValues][randomIndex]];
    }
}


-(void)addColumnToBoard{
    
    for (int row = 0; row < 9; row++) {
        NSMutableDictionary* possibleMatches = [self.possibleNumbersDict mutableCopy];
        NSInteger targetColumn = [self.board[row] count];
        CGPoint cellLocation = [self getCellLocationForPoint:CGPointMake(targetColumn, row)];
        possibleMatches = [self removeExistingNumbersIn:possibleMatches forCell:cellLocation];
        possibleMatches = [self removeExistingNumbersIn:possibleMatches forRow:row];
        possibleMatches = [self removeExistingNumbersIn:possibleMatches forColumn:[self.board[row] count]];
    
        NSInteger randomIndex = [self randomIndexWithMaxValue:[possibleMatches allValues].count];
        [self.board[row] addObject:[possibleMatches allValues][randomIndex]];
    }
}

-(CGPoint)getCellLocationForPoint:(CGPoint)itemIndex{
//    Check to make sure numbers are inside possible locations
    return CGPointMake((NSInteger)itemIndex.x/3, (NSInteger)itemIndex.y/3);
}






#pragma mark Helpers

-(NSMutableDictionary*)removeExistingNumbersIn:(NSMutableDictionary*)matches forRow:(NSInteger)row{
    for (int column = 0; column < [self.board[row] count]; column++) {
        [matches removeObjectForKey:self.board[row][column]];
    }
    return matches;
}

-(NSMutableDictionary*)removeExistingNumbersIn:(NSMutableDictionary*)matches forColumn:(NSInteger)column{
    for (int row = 0; row < self.board.count; row++) {
        if ([self.board[row] count] > column) {
//        ^^ If the row contains items, then it needs to be removed
            [matches removeObjectForKey:self.board[row][column]];
        }
    }
    return matches;
}


-(NSMutableDictionary*)removeExistingNumbersIn:(NSMutableDictionary*)matches forCell:(CGPoint)cellLocation{
//    ONLY WORKS WITH 3 not when you have 8
    int startingRowLocation = cellLocation.y * 3;
    int startingColumnLocation = cellLocation.x * 3;
    
    for (int row = startingRowLocation; row < startingRowLocation + 3; row++) {
        for (int column = startingColumnLocation; column < startingColumnLocation + 3; column++) {
            if ([self.board[row] count] > column) {
//           ^^ Check to see if column exists
//                NSLog(@"Row %d", row);
//                NSLog(@"Column %d", column);
//                NSLog(@"Removing Number %@", self.board[row][column]);
                
                [matches removeObjectForKey:self.board[row][column]];
            }
        }
    }
    
    return matches;
}

-(NSInteger)randomIndexWithMaxValue:(NSInteger)maxValue{
// maxValue Cannot be 0
    if (maxValue) {
        return arc4random() % maxValue;
    }else{
        return 0;
    }
}


/*
 
 
 2, 7, 6,
 8, 3, 5,
 9, 4, 1,

 
 
*/
    
    
    
    
    
    
    
    
    
    
    
    
    
    















    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
-(void)beginMirrorApproach{
    
    NSArray* blockSegment = [self generateNewBlock];
    NSArray* mirroredBlockSegment = [self mirrorXAndY:blockSegment];
    NSArray* topBlankBlockSegment = [self createBlankBlock];
    NSArray* bottomBlankBlockSegment = [self createBlankBlock];
    
    self.board = [self createBoardWithBlockSegmentsRows:@[@[blockSegment, topBlankBlockSegment], @[bottomBlankBlockSegment, mirroredBlockSegment]]];
    
    [self insertCrosshairs];
    
    [self fillColumnAtIndex:0];
    [self fillColumnAtIndex:1];
    [self fillColumnAtIndex:2];
//    [self fillColumnAtIndex:3];
    
    
//    NSLog(@"Board : %@", self.board);
}
    
    
    

# pragma Mark Initial Block --------


-(NSArray*)generateNewBlock{
    NSMutableArray* threeByThree = [[self generateNewThreeByThree] mutableCopy];
    NSMutableArray* threeByFour = [self addRowToBlock:threeByThree];
    NSMutableArray* fourByFour = [self addColumnToBlock:threeByFour];
    
    return fourByFour;
}

-(NSArray*)generateNewThreeByThree{
    NSMutableArray* newThreeByThree = [@[[NSMutableArray new], [NSMutableArray new], [NSMutableArray new]] mutableCopy];
    NSMutableArray* copyOfFull = [self.totalPossibleNumbers mutableCopy];
    for (int column = 0; column < 3; column++) {
        for (int row = 0; row < 3; row++) {
            NSInteger randomIndex = [self randomIndexWithMaxValue:copyOfFull.count];
            [newThreeByThree[column] addObject:copyOfFull[randomIndex]];
            [copyOfFull removeObjectAtIndex:randomIndex];
        }
    }
    
    return [newThreeByThree copy];
}


-(NSArray*)createBlankBlock{
    NSMutableArray* blankBlock = [NSMutableArray new];
    for (int row = 0; row < 4; row++) {
        [blankBlock addObject:[@[@0, @0, @0, @0] mutableCopy]];
    }
    return blankBlock;
}

# pragma Mark Row and Column --------

-(NSMutableArray*)addRowToBlock:(NSMutableArray*)currentBlock{
    NSMutableArray* newRow = [NSMutableArray new];
    for (int column = 0; column < [currentBlock[0] count]; column++) {
        NSMutableArray* availableNumbers = [self targetColumnIndex:column andGetAvailableNumbersWithBlock:currentBlock];
        NSInteger randomIndex = [self randomIndexWithMaxValue:availableNumbers.count];
        [newRow addObject:availableNumbers[randomIndex]];
    }
    [currentBlock addObject:newRow];
    return [currentBlock copy];
}

-(NSMutableArray*)addColumnToBlock:(NSMutableArray*)currentBlock{
    // ^^ target each row and add an acceptable item to it.
    for (int row = 0; row < currentBlock.count; row++) {
        NSMutableArray* availableNumbersInRow = [self targetRowIndex:row andGetAvailableNumbersWithBlock:currentBlock];
        NSInteger randomIndex = [self randomIndexWithMaxValue:availableNumbersInRow.count];
        [currentBlock[row] addObject:availableNumbersInRow[randomIndex]];
    }
    return [currentBlock copy];
}



-(void)insertCrosshairs{
    NSMutableArray* adjustedBoard = self.board;
    for (int row = 0; row < self.board.count; row++) {
        if (row == self.board.count/2) {
//           ^^ Add full blank row
            [adjustedBoard insertObject:[@[@0,@0,@0,@0,@0,@0,@0,@0] mutableCopy] atIndex:row];
//           ^^ Blank row only has 8 objects because one will be inserted when the column runs
        }
        for (int column = 0; column < self.board.count; column++) {
            if (column == [self.board[row] count]/2) {
//           ^^ Insert blank object
                [adjustedBoard[row] insertObject:@0 atIndex:column];
            }
        }
    }
    self.board = adjustedBoard;
}


# pragma Mark Mirrored Segment --------

-(NSArray*)mirrorXAndY:(NSArray*)segment{
    NSMutableArray* rotatedSegment = (NSMutableArray*)CFBridgingRelease(CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFPropertyListRef)segment, kCFPropertyListMutableContainers));
//   ^^ Create deep copy
    NSInteger maxIndexInRows = [rotatedSegment count] - 1;
    NSInteger maxIndexInColumns = [rotatedSegment[0] count] - 1;
    for (int row = 0; row < rotatedSegment.count; row++){
        for (int column = 0; column < [rotatedSegment[row] count]/2; column++){
            NSNumber* savedItem = rotatedSegment[row][column];
            rotatedSegment[row][column] = rotatedSegment[maxIndexInRows-row][maxIndexInColumns - column];;
            rotatedSegment[maxIndexInRows-row][maxIndexInColumns - column] = savedItem;
        }
    }

    return [rotatedSegment copy];
}


# pragma Mark Board --------


-(NSMutableArray*)createBoardWithBlockSegmentsRows:(NSArray*)boardSegments{
    //  ensure that board segment has 4 arrays, each array needs 16 objects
    
    NSMutableArray* newBoard = [NSMutableArray new];
    for (int row = 0; row < boardSegments.count; row++) {
        NSInteger startingIndexOffset = newBoard.count * row;
//       ^^ Set startingPoint for target row
        [newBoard addObjectsFromArray:boardSegments[row][0]];
//       ^^ Add first board
        for (NSInteger newBoardRow = startingIndexOffset; newBoardRow < newBoard.count; newBoardRow++) {
//       ^^ Loop through second column in row, add each array to existing row in newBoard
            [newBoard[newBoardRow] addObjectsFromArray:boardSegments[row][1][newBoardRow - startingIndexOffset]];
        }
    }
    
    return newBoard;
}

// 3, 4, 7, 2, 6, 8, 2, (1), (5)

-(void)fillColumnAtIndex:(NSInteger)column{
    
    NSInteger redoCount = 50;
    
    for (int row = 0; row < self.board.count; row++) {
        NSLog(@"Row : %d", row);
        if ([self.board[row][column] isEqualToNumber:@0]) {

            NSMutableDictionary* possibleMatches = [self.possibleNumbersDict mutableCopy];
            CGPoint cellLocation = [self getCellLocationForPoint:CGPointMake(column, row)];
            possibleMatches = [self removeExistingNumbersIn:possibleMatches forRow:row];
            possibleMatches = [self removeExistingNumbersIn:possibleMatches forColumn:column];
            possibleMatches = [self removeExistingNumbersIn:possibleMatches forCell:cellLocation];
            //           ^^ Remove all unuseable numbers
            
            if (![possibleMatches allKeys].count) {
                
                if ( redoCount) {
                    row--;
                    redoCount--;
                }else{
                    [self adjustRowAtIndex:row];
                    row--;
                }
            }else{
                NSInteger randomIndex = [self randomIndexWithMaxValue:[possibleMatches allValues].count];
                [self.board[row] replaceObjectAtIndex:column withObject:[possibleMatches allValues][randomIndex]];
            }
        }
        NSLog(@"---------------");
    }
}






-(void)adjustRowAtIndex:(NSInteger)row{
    
    NSLog(@"REDO");
    
    for (int column = 0; column < [self.board[row] count]; column++) {
        
        if (![self.board[row][column] isEqualToNumber:@0]) {
            
            //       ^^ No adjustments needed if target has existing number
            NSMutableDictionary* possibleMatches = [self.possibleNumbersDict mutableCopy];
            CGPoint cellLocation = [self getCellLocationForPoint:CGPointMake(column, row)];
            possibleMatches = [self removeExistingNumbersIn:possibleMatches forRow:row];
            possibleMatches = [self removeExistingNumbersIn:possibleMatches forColumn:column];
//            possibleMatches = [self removeExistingNumbersIn:possibleMatches forCell:cellLocation];
            
            //           ^^ Remove all unuseable numbers
            
            if (![possibleMatches allKeys].count) {
                    [self.board[row] replaceObjectAtIndex:column withObject:@"^"];
            }else{
                NSInteger randomIndex = [self randomIndexWithMaxValue:[possibleMatches allValues].count];
                [self.board[row] replaceObjectAtIndex:column withObject:[possibleMatches allValues][randomIndex]];
            }
        }
    }
}















-(NSMutableArray*)targetRowIndex:(NSInteger)rowIndex andGetAvailableNumbersWithBlock:(NSArray*)currentBlock{
    
    NSMutableDictionary* copyOfFull = [self.possibleNumbersDict mutableCopy];
    for (int column = 0; column < [currentBlock[rowIndex] count]; column++) {
        //      ^^ Remove all placed numbers in row index
        [copyOfFull removeObjectForKey:currentBlock[rowIndex][column]];
    }
    
    for (int row = 0; row < currentBlock.count; row++) {
        //      ^^ Need to remove items as they are added in the new column
        if (rowIndex - row >= 0) {
            NSInteger indexOfColumnUnderConstruction = [currentBlock[row] count] - 1;
            [copyOfFull removeObjectForKey:currentBlock[row][indexOfColumnUnderConstruction]];
        }else break;
    }
    
    return [[copyOfFull allValues] mutableCopy];
}


-(NSMutableArray*)targetColumnIndex:(NSInteger)columnIndex andGetAvailableNumbersWithBlock:(NSArray*)currentBlock{
    
    NSMutableDictionary* copyOfFull = [self.possibleNumbersDict mutableCopy];
    for (int row = 0; row < currentBlock.count; row++) {
        [copyOfFull removeObjectForKey:currentBlock[row][columnIndex]];
    }
    return [[copyOfFull allValues] mutableCopy];
}


-(void)addBlock:(NSArray*)block atRow:(NSInteger)row andColumn:(NSInteger)column toBoard:(NSMutableArray*)board{
//    ^^ this only is working if adding 1 row away.. if you want to add something at row 100, it wont work
//    if (board.count -1 < row || !board.count) {
//        [board addObject:[@[] mutableCopy]];
//    }
//    
//    if ([board[row] count] -1 < column || ![board[row] count]) {
//        [board[row] addObject:@[]];
//    }
    
    [board addObjectsFromArray:block];
}

-(void)addUndefinedBlockAtRow:(NSInteger)row andColumn:(NSInteger)column toBoard:(NSMutableArray*)board{
    NSArray* blank = @[@[],@[],@[],@[],];
    
}


-(void)printBoard{
    for (NSArray* array in self.board) {
        NSMutableString* lineToPrint = [@"" mutableCopy];
        for (NSNumber* number in array) {
            [lineToPrint appendString:[NSString stringWithFormat:@"%@ | ", number]];
        }
        NSLog(@"%@", lineToPrint);
        NSLog(@" ");
    }
}



@end
