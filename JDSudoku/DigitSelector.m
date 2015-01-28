//
//  DigitSelector.m
//  JDSudoku
//
//  Created by James Dunay on 1/26/15.
//  Copyright (c) 2015 James Dunay. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DigitSelector.h"

@interface DigitSelector()

@property(nonatomic)BOOL initialConstraintsSet;

@property(nonatomic, strong)NSMutableArray* sizeConstraints;
@property(nonatomic, strong)NSMutableArray* topConstraints;
@property(nonatomic, strong)NSMutableArray* leftConstraints;

@property(nonatomic, strong)UIButton* one;
@property(nonatomic, strong)UIButton* two;
@property(nonatomic, strong)UIButton* three;
@property(nonatomic, strong)UIButton* four;
@property(nonatomic, strong)UIButton* five;
@property(nonatomic, strong)UIButton* six;
@property(nonatomic, strong)UIButton* seven;
@property(nonatomic, strong)UIButton* eight;
@property(nonatomic, strong)UIButton* nine;


@end

@implementation DigitSelector

-(id)init{
    self = [super init];
    if (self) {
        self.sizeConstraints = [[NSMutableArray alloc] init];
        self.topConstraints = [[NSMutableArray alloc] init];
        self.leftConstraints = [[NSMutableArray alloc] init];
        [self createButtons];
    }
    return self;
}

-(void)createButtons{
    
    self.one = [[UIButton alloc] init];
    [self addSubview:self.one];
    self.two = [[UIButton alloc] init];
    [self addSubview:self.two];
    self.three = [[UIButton alloc] init];
    [self addSubview:self.three];
    self.four = [[UIButton alloc] init];
    [self addSubview:self.four];
    self.five = [[UIButton alloc] init];
    [self addSubview:self.five];
    self.six = [[UIButton alloc] init];
    [self addSubview:self.six];
    self.seven = [[UIButton alloc] init];
    [self addSubview:self.seven];
    self.eight = [[UIButton alloc] init];
    [self addSubview:self.eight];
    self.nine = [[UIButton alloc] init];
    [self addSubview:self.nine];
    
    [self.subviews enumerateObjectsUsingBlock:^(UIButton* button, NSUInteger idx, BOOL *stop) {
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.tag = idx + 1;
        button.layer.borderWidth = 1.f;
        button.layer.borderColor = [[UIColor colorWithRed:237.f/255.f green:234.f/255.f blue:224.f/255.f alpha:.2f] CGColor];
        button.layer.cornerRadius = 20;
        [button setTitle:[NSString stringWithFormat:@"%ld", (idx+1)] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
        [button setTitleColor:[UIColor colorWithRed:237.f/255.f green:234.f/255.f blue:224.f/255.f alpha:1.f] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    }];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    if(!self.initialConstraintsSet){
        self.initialConstraintsSet = YES;
        [self addConstraints:[self defaultConstraints]];
    }else{
        [self.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
            [view.subviews enumerateObjectsUsingBlock:^(UILabel* label, NSUInteger idx, BOOL *stop) {
                label.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
            }];
        }];
    }
}


-(NSArray*)defaultConstraints{
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_one]-10-[_two(==_one)]-10-[_three(==_two)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_one, _two, _three)
                                      ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_four]-10-[_five(==_four)]-10-[_six(==_four)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_four, _five, _six)
                                      ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_seven]-10-[_eight(==_seven)]-10-[_nine(==_seven)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_seven, _eight, _nine)
                                      ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_one]-10-[_four(==_one)]-10-[_seven(==_one)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_one, _four, _seven)
                                      ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_two]-10-[_five(==_two)]-10-[_eight(==_two)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_two, _five, _eight)
                                      ]];

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_three]-10-[_six(==_three)]-10-[_nine(==_three)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_three, _six, _nine)
                                      ]];

    return constraints;
}

-(void)tappedButton:(id)sender{
    self.onSelectDigit([sender tag]);
}


@end