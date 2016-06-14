//
//  JBDoubleArcViewController.m
//  JBArcSlider
//
//  Created by Bhavesh Patel on 13/6/16.
//  Copyright (c) 2016 Bhavesh Patel. All rights reserved.
//

#import "JBDoubleArcViewController.h"
#import "JBArcSlider.h"

@interface JBDoubleArcViewController ()

@end

@implementation JBDoubleArcViewController

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
    
    CGRect sliderFrame = CGRectMake(60, 150, 200, 300);
    JBArcSlider* ArcSlider = [[JBArcSlider alloc] initWithFrame:sliderFrame];
    ArcSlider.handleType = ArcSliderHandleTypeDoubleArcWithOpenCenter;
    ArcSlider.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    ArcSlider.StartAngle = 40;
    ArcSlider.EndAngle = 320;
    [self.view addSubview:ArcSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
