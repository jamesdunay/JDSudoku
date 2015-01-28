//
//  Element.m
//  JDSudoku
//
//  Created by James Dunay on 1/25/15.
//  Copyright (c) 2015 James Dunay. All rights reserved.
//

#import "BoardTile.h"

@interface BoardTile()

@property(nonatomic, strong)UIView* indicator;
@property(nonatomic, strong)UIColor* wrongColor;
@property(nonatomic, strong)UIColor* correctColor;
@property(nonatomic, strong)UIColor* defaultColor;
@end

@implementation BoardTile

-(id)init{
    self = [super init];
    if (self){
        self.item = [[Item alloc] init];

        self.wrongColor = [UIColor colorWithRed:226.f/255.f green:99.f/255.f blue:86.f/255.f alpha:1.f];
        self.correctColor = [UIColor colorWithRed:139.f/255.f green:198.f/255.f blue:86.f/255.f alpha:1.f];
        self.defaultColor = [UIColor colorWithRed:237.f/255.f green:234.f/255.f blue:224.f/255.f alpha:1.f];
        
        self.label = [[UILabel alloc] init];
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.clipsToBounds = NO;
        self.label.textColor = [UIColor colorWithRed:116.f/255.f green:112.f/255.f blue:101.f/255.f alpha:1.f];
        [self addSubview:self.label];
        
        self.indicator = [[UIView alloc] init];
        self.indicator.translatesAutoresizingMaskIntoConstraints = NO;
        self.indicator.alpha = 0.f;
        [self addSubview:self.indicator];
        
        self.clipsToBounds = NO;
    }
    return self;
}

#pragma Mark Autolayout ------

-(void)layoutSubviews{
    [super layoutSubviews];
    [self addConstraints:[self defaultConstraints]];
}

-(NSArray*)defaultConstraints{
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_label]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_label)
                                      ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_label]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_label)
                                      ]];
    
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.indicator
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.f
                                                         constant:5.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.indicator
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.f
                                                         constant:-5.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.indicator
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.indicator
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:1.f
                            ]];
    
    return [constraints copy];
}

#pragma Mark Setters ------

-(void)setItem:(Item *)item{
    _item = item;
    self.label.text = item.displayValue;
}

#pragma Mark Helper Methods ------

-(void)changeDisplayTo:(NSInteger)digit{
    
    self.label.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
    
    if (digit == [self.item.actualValue integerValue]) {
        self.indicator.backgroundColor = self.correctColor;
        self.label.textColor = self.defaultColor;
    }else{
        self.indicator.backgroundColor = self.wrongColor;
        self.label.textColor = self.wrongColor;
    }
    
    self.indicator.alpha = 1.f;
    self.label.alpha = 1.f;
    
    self.label.text = [NSString stringWithFormat:@"%ld", digit];
    self.item.displayValue = [NSString stringWithFormat:@"%ld", digit];
}

-(void)showAnswer{
    [self changeDisplayTo:[self.item.actualValue integerValue]];
}

@end




