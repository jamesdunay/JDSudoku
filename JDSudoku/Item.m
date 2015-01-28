//
//  Item.m
//  JDSudoku
//
//  Created by James Dunay on 1/25/15.
//  Copyright (c) 2015 James Dunay. All rights reserved.
//

#import "Item.h"

@implementation Item

+ (instancetype)itemWithDisplayValue:(NSString*)display andActualValue:(NSNumber*)value{
    Item* item = [[Item alloc] init];
    item.displayValue = display;
    item.actualValue = value;
    return item;    
}
 
@end
