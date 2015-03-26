//
//  ViewController.m
//  Drone
//
//  Created by Lasha Efremidze on 2/28/15.
//  Copyright (c) 2015 Lasha Efremidze. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UISwitch *switchView;
@property (nonatomic, weak) IBOutlet UISlider *rollSlider;
@property (nonatomic, weak) IBOutlet UISlider *pitchSlider;

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.switchView sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark -

- (IBAction)valueChanged:(UISwitch *)switchView
{
    if (switchView.isOn) {
        [self startDeviceMotionUpdates];
    } else {
        [self stopDeviceMotionUpdates];
    }
}

#pragma mark -

- (CMMotionManager *)motionManager
{
    if (!_motionManager) {
        _motionManager = ((^{
            CMMotionManager *motionManager = [CMMotionManager new];
            motionManager.deviceMotionUpdateInterval = 0.1f;
            return motionManager;
        })());
    }
    return _motionManager;
}

- (void)startDeviceMotionUpdates
{
    __weak typeof(self) weakSelf = self;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        typeof(self) self = weakSelf;
        
        if (error) {
            [self stopDeviceMotionUpdates];
        } else {
            [self deviceMotionDidUpdate:motion];
        }
    }];
}

- (void)stopDeviceMotionUpdates
{
    [self.motionManager stopDeviceMotionUpdates];
}

- (void)deviceMotionDidUpdate:(CMDeviceMotion *)deviceMotion
{
    CGFloat roll = -deviceMotion.attitude.roll;
    CGFloat pitch = -deviceMotion.attitude.pitch;
    self.rollSlider.value = roll;
    self.pitchSlider.value = pitch;
    NSLog(@"roll %f pitch %f", roll, pitch);
}

@end
