//
//  Item.h
//  JDSudoku
//
//  Created by James Dunay on 1/25/15.
//  Copyright (c) 2015 James Dunay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property(nonatomic, strong)NSNumber* actualValue;
@property(nonatomic, strong)NSString* displayValue;

+ (instancetype)itemWithDisplayValue:(NSString*)display andActualValue:(NSNumber*)value;

@end
