//
//  BoardService.h
//  JDSudoku
//
//  Created by James Dunay on 1/25/15.
//  Copyright (c) 2015 James Dunay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoardService : NSObject

+(BoardService*)sharedInstance;
-(NSArray*)createNewBoard;
-(NSInteger)indexOfRandomTileInCell:(NSInteger)cellIndex;

@end
