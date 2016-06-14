//
//  JBTwoSlidersAutoLayoutViewController.m
//  JBArcSlider
//
//  Created by Bhavesh Patel on 13/6/16.
//  Copyright (c) 2016 Bhavesh Patel. All rights reserved.
//

#import "JBTwoSlidersAutoLayoutViewController.h"
#import "JBArcSlider.h"

@interface JBTwoSlidersAutoLayoutViewController ()

@property (nonatomic, strong) NSMutableArray *myConstraints;
@property (nonatomic, strong) JBArcSlider *topSlider;
@property (nonatomic, strong) JBArcSlider *bottomSlider;

@end

@implementation JBTwoSlidersAutoLayoutViewController

-(void) updateViewConstraints
{
    if (!self.myConstraints)
    {
        self.myConstraints = [[NSMutableArray alloc] init];
        
        NSDictionary *views = @{@"topSlider":self.topSlider,
                                @"bottomSlider":self.bottomSlider,
                                @"topGuide" : self.topLayoutGuide};
        
        [self.myConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topGuide]-[topSlider]-[bottomSlider(100)]-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:views]];
        [self.myConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[topSlider]-50-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:views]];
        [self.myConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[bottomSlider]-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:views]];
        
        [self.view addConstraints:self.myConstraints];
    }
    [super updateViewConstraints];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.topSlider = [[JBArcSlider alloc] init];
    self.topSlider.translatesAutoresizingMaskIntoConstraints = NO;
    self.topSlider.handleType = ArcSliderHandleTypeDoubleArcWithOpenCenter;
    self.topSlider.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    self.topSlider.StartAngle = 40;
    self.topSlider.EndAngle = 320;
    [self.view addSubview:self.topSlider];
    
    self.bottomSlider = [[JBArcSlider alloc] init];
    self.bottomSlider.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomSlider.handleType = ArcSliderHandleTypeDoubleArcWithOpenCenter;
    self.bottomSlider.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    self.bottomSlider.StartAngle = 40;
    self.bottomSlider.EndAngle = 320;
    [self.view addSubview:self.bottomSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
