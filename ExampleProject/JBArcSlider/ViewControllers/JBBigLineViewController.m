//
//  JBBigLineViewController.m
//  JBArcSlider
//
//  Created by Christian Bianciotto on 13/6/16.
//  Copyright (c) 2014 Bhavesh Patel. All rights reserved.
//

#import "JBBigLineViewController.h"
#import "JBArcSlider.h"

@interface JBBigLineViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgback;

@end

@implementation JBBigLineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sliderFrame = CGRectMake(0, 120, 320, 320);
    JBArcSlider* ArcSlider = [[JBArcSlider alloc] initWithFrame:sliderFrame];
    
    ArcSlider.lineWidth = 50;
    ArcSlider.labelFont = [UIFont fontWithName:@"GillSans-Light" size:16];
    ArcSlider.StartAngle = 40;
    ArcSlider.EndAngle = 320;
    NSArray* labels = @[@"A",@"B", @"C", @"D", @"E"];
    [ArcSlider setInnerMarkingLabels:labels];
    _imgback.hidden = true;
    [self.view addSubview:ArcSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
