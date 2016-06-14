//
//  JBSnapToLabelsViewController.m
//  JBArcSlider
//
//  Created by Bhavesh Patel on 13/6/16.
//  Copyright (c) 2016 Bhavesh Patel. All rights reserved.
//

#import "JBSnapToLabelsViewController.h"
#import "JBArcSlider.h"

@interface JBSnapToLabelsViewController ()

@end

@implementation JBSnapToLabelsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CGRect sliderFrame = CGRectMake(60, 150, 200, 200);
    JBArcSlider* ArcSlider = [[JBArcSlider alloc] initWithFrame:sliderFrame];
    ArcSlider.StartAngle = 40;
    ArcSlider.EndAngle = 320;
    NSArray* labels = @[@"1", @"2", @"3", @"4", @"5"];
    [ArcSlider setInnerMarkingLabels:labels];
    [ArcSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    ArcSlider.snapToLabels = YES;
    
    [self.view addSubview:ArcSlider];
}

-(void)valueChanged:(JBArcSlider*)slider {
    //_lblValue.text = [NSString stringWithFormat:@"%.02f", slider.currentValue ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
