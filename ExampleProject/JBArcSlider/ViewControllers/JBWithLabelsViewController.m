//
//  JBWithLabelsViewController.m
//  JBArcSlider
//
//  Created by Bhavesh Patel on 13/6/16.
//  Copyright (c) 2016 Bhavesh Patel. All rights reserved.
//

#import "JBWithLabelsViewController.h"
#import "JBArcSlider.h"

@interface JBWithLabelsViewController ()

@end

@implementation JBWithLabelsViewController

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
    NSArray* labels = @[@"Beetle", @"Cow", @"Donkey", @"Eagle", @"Ant"];
    [ArcSlider setInnerMarkingLabels:labels];
    [self.view addSubview:ArcSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
