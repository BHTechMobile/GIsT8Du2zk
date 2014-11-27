//
//  NavigationView.m
//  9HugMoment
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "NavigationView.h"

@implementation NavigationView

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] objectAtIndex:0];
    CGFloat widthProfileView = [[UIScreen mainScreen] bounds].size.width;
    CGRect profileViewFrame = CGRectMake(0, 0, widthProfileView, NAVIGATION_BAR_CUSTOM_DEFAULT_HEIGHT);
    self.frame = profileViewFrame;
    [self initStyle];
    return self;
}

#pragma mark - Customs Methods

- (void)initStyle{

}


#pragma mark - Control Button

- (IBAction)backNvgButtonAction:(id)sender {
    [self.delegate backNvgAction];
}

- (IBAction)twitterNvgButtonAction:(id)sender {
    [self.delegate twitterNvgAction];
}

- (IBAction)facebookNvgButtonAction:(id)sender {
    [self.delegate facebookNvgAction];
}

- (IBAction)ggPlusNvgButtonAction:(id)sender {
    [self.delegate ggPlusNvgAction];
}
@end
