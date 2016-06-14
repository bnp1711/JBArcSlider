//
//  JBBasicViewController.m
//  JBArcSlider
//
//  Created by Bhavesh Patel on 13/6/16.
//  Copyright (c) 2016 Bhavesh Patel. All rights reserved.
//

#import "JBBasicViewController.h"
#import "JBArcSlider.h"

@interface JBBasicViewController ()

@end

@implementation JBBasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect sliderFrame = CGRectMake(60, 150, 200, 200);
    JBArcSlider* ArcSlider = [[JBArcSlider alloc] initWithFrame:sliderFrame];
    [ArcSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    ArcSlider.StartAngle = 40;
    ArcSlider.EndAngle = 320;
    ArcSlider.maximumValue = 100;
    [self.view addSubview:ArcSlider];
}

-(void)valueChanged:(JBArcSlider*)slider {
    _valueLabel.text = [NSString stringWithFormat:@"%.00f", slider.currentValue ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
