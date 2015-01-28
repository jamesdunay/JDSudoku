//
//  JDSudokuTests.m
//  JDSudokuTests
//
//  Created by James Dunay on 1/23/15.
//  Copyright (c) 2015 James Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Item.h"
#import "BoardService.h"
#import "BoardTile.h"


@interface BoardTile()
-(void)changeDisplayTo:(NSInteger)digit;

@property(nonatomic, strong)UIView* indicator;

@end

@interface BoardService (Tests)
-(NSArray*)generateNewThreeByThree;
-(NSInteger)indexOfRandomTileInCell:(NSInteger)cellIndex;
-(NSArray*)createNewBoard;
@end

@interface JDSudokuTests : XCTestCase

@end

@implementation JDSudokuTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

#pragma Mark Item Model Tests ----------

- (void)testItemModelInitilization{
    Item* item = [Item itemWithDisplayValue:@"0" andActualValue:@0];
    XCTAssert([item.displayValue isEqualToString:@"0"], @"Pass");
    XCTAssert([item.actualValue isEqualToNumber:@0], @"Pass");
}


#pragma Mark Board Service Helper ----------

- (void)testThreeByThreeHasAllUniqueNumbers{
    NSArray* testCell = [[BoardService sharedInstance] generateNewThreeByThree];
    NSMutableSet* bag = [[NSMutableSet alloc] init];
    [bag addObjectsFromArray:testCell];
    XCTAssert(bag.count == testCell.count, @"Pass");
}

- (void)testRandomIndexInCellReturnsIndexInsideCell{
    NSRange rowOneRange = NSMakeRange(30, 3);
    NSRange rowTwoRange = NSMakeRange(39, 3);
    NSRange rowThreeRange = NSMakeRange(48, 3);
    NSInteger randomIndex = [[BoardService  sharedInstance] indexOfRandomTileInCell:4];
    NSLog(@"Random Index : %ld", randomIndex);
    XCTAssert(NSLocationInRange(randomIndex, rowOneRange) || NSLocationInRange(randomIndex, rowTwoRange) || NSLocationInRange(randomIndex, rowThreeRange), @"Pass");
}

#pragma Mark Board ----------

- (void)testCreateNewBoardReturnsTheCorrectNumberOfItems{
    NSArray* newBoard = [[BoardService sharedInstance] createNewBoard];
    NSInteger rows = newBoard.count;
    XCTAssert((rows * [newBoard[0] count]) == 81, @"Pass");
}

- (void)testBoardHasNoBlankTiles{
    NSArray* newBoard = [[BoardService sharedInstance] createNewBoard];
    XCTAssert(![newBoard containsObject:@0], @"Pass");
}

- (void)testBoardHas9Rows{
    NSArray* newBoard = [[BoardService sharedInstance] createNewBoard];
    XCTAssert(newBoard.count == 9, @"Pass");
}

- (void)testBoardHas9Columns{
    NSArray* newBoard = [[BoardService sharedInstance] createNewBoard];
    XCTAssert([newBoard[0] count] == 9, @"Pass");
}

#pragma Board Tile ----------

- (void)testTileHasValidLabel{
    BoardTile* tile = [[BoardTile alloc] init];
    XCTAssert(tile.label, @"Pass");
}

- (void)testTileHasValidIndicator{
    BoardTile* tile = [[BoardTile alloc] init];
    XCTAssert(tile.indicator, @"Pass");
}

- (void)testChangeDisplayCorrectlyChangesTileLabel{
    BoardTile* tile = [[BoardTile alloc] init];
    [tile changeDisplayTo:5];
    XCTAssert([tile.label.text isEqualToString:@"5"], @"Pass");
}




- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
