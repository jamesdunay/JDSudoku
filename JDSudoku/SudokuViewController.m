//
//  CorrectAnswer.m
//  JDSudoku
//
//  Created by James Dunay on 1/25/15.
//  Copyright (c) 2015 James Dunay. All rights reserved.
//

#import "SudokuViewController.h"
#import "Item.h"
#import "DigitSelector.h"
#import "Board.h"

@interface SudokuViewController()

@property(nonatomic, strong)DigitSelector* digitSelector;
@property(nonatomic, strong)Board* boardView;
@property(nonatomic)BOOL initialConstraintsSet;

@property(nonatomic, strong)NSMutableArray* digitConstraints;

@end

@implementation SudokuViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.digitConstraints = [[NSMutableArray alloc] init];

    self.boardView = [[Board alloc] init];
    self.boardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.boardView];
    
    self.digitSelector = [[DigitSelector alloc] init];
    self.digitSelector.translatesAutoresizingMaskIntoConstraints = NO;
    self.digitSelector.alpha = 0.f;
    [self.view addSubview:self.digitSelector];
    
    [self.view updateConstraintsIfNeeded];
    
    __weak typeof (self)wself = self;
    [self.boardView setOnTap:^(BOOL shouldOpen){
        [wself adjustDigitViewToDisplay:shouldOpen];
    }];
    
    [self.digitSelector setOnSelectDigit:^(NSInteger digit){
        wself.boardView.shouldBeMinimized = NO;
        [wself.boardView assignDigitToTile:digit];
        [wself adjustDigitViewToDisplay:NO];
        [wself.boardView adjustViewForTag:0];
    }];
}

#pragma Mark Autolayout ------

-(void)updateViewConstraints{
    if (!self.initialConstraintsSet) {
        self.initialConstraintsSet = YES;
        [self.view addConstraints:[self defaultConstraints]];
        [self.view addConstraints:self.digitConstraints];
    }
    [super updateViewConstraints];
}

-(NSArray*)defaultConstraints{
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[_digitSelector]-(>=0)-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_digitSelector)
                                      ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[_digitSelector]-(>=50)-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_digitSelector)
                                      ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.digitSelector
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    [self.digitConstraints addObject:[NSLayoutConstraint constraintWithItem:self.digitSelector
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.f
                                                                    constant:50.f
                                       ]];
    
    [self.digitConstraints addObject:[NSLayoutConstraint constraintWithItem:self.digitSelector
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.f
                                                                   constant:50.f
                                      ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_boardView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_boardView)
                                      ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_boardView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_boardView)
                                      ]];
    return [constraints copy];
}

#pragma Mark Animation Methods ------

-(void)adjustDigitViewToDisplay:(BOOL)shouldOpen{
    [self.digitConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint* constraint, NSUInteger idx, BOOL *stop) {
        constraint.constant = 175 * shouldOpen + 50;
        [UIView animateWithDuration:1.f
                              delay:0.f
             usingSpringWithDamping:85.f
              initialSpringVelocity:15.f
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [self.view layoutSubviews];
                             [self.digitSelector layoutSubviews];
                             self.digitSelector.alpha = shouldOpen;
                            } completion:nil];
    }];
}


@end
