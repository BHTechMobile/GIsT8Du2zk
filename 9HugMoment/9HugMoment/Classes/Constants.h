//
//  Constants.h
//  9HugMoment
//
//  Created by PhamHuuPhuong on 27/11/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#ifndef _HugMoment_Constants_h
#define _HugMoment_Constants_h

/*All Page*/
#import "Utilities.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define APP_SCREEN_HEIGHT [[UIScreen mainScreen] applicationFrame].size.height
/*CaptureVideoViewController*/

#define PointX 80
#define COLOR_PROCESS [UIColor colorWithRed:224.0/255.0 green:100.0/255.0 blue:176.0/255.0 alpha:1.0]
#define BG_COLOR_PROCESS [UIColor colorWithRed:43.0/255.0 green:42.0/255.0 blue:50.0/255.0 alpha:1.0]
#define KEY_DISTANCE @"key_distance"

#endif
