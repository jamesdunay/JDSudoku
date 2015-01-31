//
//  Board.m
//  JDSudoku
//
//  Created by James Dunay on 1/26/15.
//  Copyright (c) 2015 James Dunay. All rights reserved.
//

#import "Board.h"
#import "BoardService.h"
#import "BoardTile.h"

@interface Board()

@property(nonatomic, strong)NSArray* boardData;
@property(nonatomic, strong)NSMutableArray* heightConstraints;
@property(nonatomic, strong)NSMutableArray* topConstraints;
@property(nonatomic)BOOL initialConstraintsSet;
@property(nonatomic)NSInteger selectedTileIndex;
@end

@implementation Board

-(id)init{
    self = [super init];
    if (self) {
        
        self.heightConstraints = [[NSMutableArray alloc] init];
        self.topConstraints = [[NSMutableArray alloc] init];
        self.shouldBeMinimized = YES;
        
        self.boardData = [[BoardService sharedInstance] createNewBoard];
        [self createViewsForItems];
        [self generateFilledAnswers:BoardDifficultyEasy];
//        ^^ Can be changed to Easy, Medium, or Hard
        [self fadeFromTileIndex:40 fadeIn:YES];
    }
    return self;
}

#pragma Mark Autolayout ------

-(void)layoutSubviews{
    [super layoutSubviews];
    if (!self.initialConstraintsSet) {
        self.initialConstraintsSet = YES;
        [self addConstraints:[self defaultConstraints]];
        [self addConstraints:self.topConstraints];
        [self addConstraints:self.heightConstraints];
    }
}

-(NSArray*)defaultConstraints{
    
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    [self.subviews enumerateObjectsUsingBlock:^(UILabel* label, NSUInteger idx, BOOL *stop) {
        
        NSInteger currentRow = idx/9;
        NSInteger itemInRow = idx % 9;
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:label
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.f
                                                             constant:(self.frame.size.width / 9) * itemInRow
                                ]];
        
        [self.topConstraints addObject:[NSLayoutConstraint constraintWithItem:label
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.f
                                                                     constant:(self.frame.size.height/9) * currentRow
                                        ]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:label
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.f
                                                             constant:(self.frame.size.width / 9)
                                ]];
        
        [self.heightConstraints addObject:[NSLayoutConstraint constraintWithItem:label
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.f
                                                                        constant:(self.frame.size.height / 9)
                                           ]];
    }];
    
    return [constraints copy];
}

#pragma Mark Display/Creation ------

-(void)createViewsForItems{
    [self.boardData enumerateObjectsUsingBlock:^(NSArray* array, NSUInteger idx, BOOL *stop) {
        [array enumerateObjectsUsingBlock:^(NSNumber* number, NSUInteger arrayIdx, BOOL *stop) {
            
            BoardTile* boardTile = [[BoardTile alloc] init];
            boardTile.translatesAutoresizingMaskIntoConstraints = NO;
            boardTile.alpha = 0;
            boardTile.tag = idx * 9 + arrayIdx;
            
            Item* item = [Item itemWithDisplayValue:@"?" andActualValue:number];
            [boardTile setItem:item];
            [self addSubview:boardTile];
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTile:)];
            [boardTile addGestureRecognizer:tap];
        }];
    }];
}

-(void)generateFilledAnswers:(NSInteger)difficultySetting{
//    ^^ Creates prefilled answers dependent on difficulty setting
    for (int cellIndex = 0; cellIndex < 9; cellIndex++) {
        for (int iteration = 0; iteration < difficultySetting; iteration++) {
            NSInteger randomTileIndex = [[BoardService  sharedInstance] indexOfRandomTileInCell:cellIndex];
            [(BoardTile*)self.subviews[randomTileIndex] showAnswer];
        }
    }
}

-(void)fadeFromTileIndex:(NSInteger)targetIndex fadeIn:(BOOL)fadeIn{
//    ^^ fades tiles in radial pattern from given index
    CGPoint tapLoaction = [self locationInBoardFromIndex:targetIndex];
    for (int row = 0; row < 8; row++) {
        for (int column = 0; column < 8; column++) {
            
            CGPoint upLeft = CGPointMake(tapLoaction.x - column, tapLoaction.y - row);
            CGPoint downLeft = CGPointMake(tapLoaction.x - column, tapLoaction.y + row);
            CGPoint upRight = CGPointMake(tapLoaction.x + column, tapLoaction.y - row);
            CGPoint downRight = CGPointMake(tapLoaction.x + column, tapLoaction.y + row);
            
            if ([self pointIsValid:upLeft]) {
                [self fadeItem:[self viewForPoint:upLeft] fromRow:row andColumn:column fadeIn:fadeIn];
            }
            
            if ([self pointIsValid:downLeft]) {
                [self fadeItem:[self viewForPoint:downLeft] fromRow:row andColumn:column fadeIn:fadeIn];
            }
            
            if ([self pointIsValid:upRight]) {
                [self fadeItem:[self viewForPoint:upRight] fromRow:row andColumn:column fadeIn:fadeIn];
            }
            
            if ([self pointIsValid:downRight]) {
                [self fadeItem:[self viewForPoint:downRight] fromRow:row andColumn:column fadeIn:fadeIn];
            }
        }
    }
}

#pragma Mark View Animations ------

-(void)fadeItem:(UIView*)view fromRow:(NSInteger)row andColumn:(NSInteger)column fadeIn:(BOOL)fadeIn{
    [UIView animateWithDuration:.3f
                          delay:(.1 * row) + (.1 * column)
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [view setAlpha:fadeIn];
                     } completion:nil];
}

-(void)adjustPositions{
//    ^^ Moves tiles while also scaling heights. Animations are not fired till the last index to lighten load on main thread.
    [self.heightConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint* constraint, NSUInteger idx, BOOL *stop) {
        constraint.constant = self.frame.size.width / (18 / (2 - self.shouldBeMinimized));
        if (idx == 80) {
            [UIView animateWithDuration:1.f
                                  delay:0.f
                 usingSpringWithDamping:85.f
                  initialSpringVelocity:15.f
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 [self layoutIfNeeded];
                             } completion:nil];
        }
    }];
    
    [self.topConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint* constraint, NSUInteger idx, BOOL *stop) {
        NSInteger currentRow = [self rowFromIndex:idx];
        constraint.constant = (self.frame.size.height/(18 / (2 - self.shouldBeMinimized))) * currentRow;
        if (idx == 80) {
            [UIView animateWithDuration:1.f
                                  delay:0.f
                 usingSpringWithDamping:85.f
                  initialSpringVelocity:15.f
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 [self layoutIfNeeded];
                             } completion:nil];
            }
    }];
}


-(void)adjustScaleForIndex:(NSInteger)index{
//    ^^ Used for tapping on a cell to give it some visual hierarchy
    CGPoint centerPoint = [self locationInBoardFromIndex:index];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0f / -400.f;
    
    [self.subviews enumerateObjectsUsingBlock:^(BoardTile* tile, NSUInteger idx, BOOL *stop) {
        NSInteger distanceFromPoint = [self getDistanceFrom:centerPoint withLocation:[self locationInBoardFromIndex:idx]];
        CGFloat zDepth = -distanceFromPoint * 200 * self.shouldBeMinimized;
        CGFloat dampening = 85.f;
        CGFloat velo = 25.f;
        CGFloat duration = 1.f;
        if (!self.shouldBeMinimized) {
            dampening = 1.f;
            velo = 1.f;
            duration = .25;
        }
        
        [UIView animateWithDuration:duration
                              delay:0.f
             usingSpringWithDamping:dampening
              initialSpringVelocity:velo
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             tile.label.layer.transform = CATransform3DTranslate(transform, 0, 0, zDepth);
                         } completion:nil];
    }];
}

-(void)adjustAlphaForIndex:(NSInteger)index{
    
    CGPoint centerPoint = [self locationInBoardFromIndex:index];
    [self.subviews enumerateObjectsUsingBlock:^(BoardTile* tile, NSUInteger idx, BOOL *stop) {
        NSInteger distanceFromPoint = [self getDistanceFrom:centerPoint withLocation:[self locationInBoardFromIndex:idx]];
        [UIView animateWithDuration:.2f
                              delay:0.f
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             tile.alpha = 1 - (((float)distanceFromPoint/9) * self.shouldBeMinimized);
                         } completion:nil];
    }];
}

#pragma Mark Helper Methods ------

-(BOOL)pointIsValid:(CGPoint)point{
//    ^^ Check to see if point is on board
    if (point.x > 8 || point.x < 0) return NO;
    if (point.y > 8 || point.y < 0) return NO;
    return YES;
}

-(CGFloat)getDistanceFrom:(CGPoint)pointOne withLocation:(CGPoint)pointTwo{
//    ^^ Returns distance between two points
    
    NSInteger xTileDistance = (pointOne.x) - (pointTwo.x);
    NSInteger yTileDistance = pointOne.y - pointTwo.y;
    
    if (xTileDistance < 0) xTileDistance = xTileDistance * -1;
    if (yTileDistance < 0) yTileDistance = yTileDistance * -1;
    
    CGFloat xTileDistanceSqu = pow(xTileDistance, 2);
    CGFloat yTileDistanceSqu = pow(yTileDistance, 2);
    
    return sqrt(xTileDistanceSqu + yTileDistanceSqu);
}

-(UIView*)viewForPoint:(CGPoint)point{
    NSInteger indexOfView = (point.y * 9) + point.x;
    return self.subviews[indexOfView];
}

-(CGPoint)locationInBoardFromIndex:(NSInteger)index{
    NSInteger currentRow = index/9;
    return CGPointMake(index - currentRow * 9, currentRow);
}

-(void)tappedTile:(UIGestureRecognizer*)sender{
    self.shouldBeMinimized = YES;
    [self adjustViewForTag:[[sender view]tag]];
    self.selectedTileIndex = [[sender view]tag];
    self.onTap(self.shouldBeMinimized);
}

-(void)adjustViewForTag:(NSInteger)tag{
    [self adjustPositions];
    [self adjustAlphaForIndex:tag];
    [self adjustScaleForIndex:tag];
}

-(NSInteger)rowFromIndex:(NSInteger)index{
    return index/9;
}

-(void)assignDigitToTile:(NSInteger)digit{
    BoardTile* tile = self.subviews[self.selectedTileIndex];
    [tile changeDisplayTo:digit];
}

@end
