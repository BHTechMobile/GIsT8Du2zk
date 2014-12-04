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

#define SYSTEM_PASSWORD @"Gfix0hVBUCNPf9wyKGiQ"
#define UPLOAD_VIDEO @"http://ws.9hug.com/api/message/update"
#define URL_GET_FOLLOW_ENDPOINT @"http://ws.9hug.com/api/client/login"

#import <AFNetworking.h>

#import "BaseServices.h"

#import "Utilities.h"
#import "AppDelegate.h"
#import "NavigationView.h"
#import <MBProgressHUD.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <GPUImage.h>

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIView+AutoLayout.h"

#import "UIView+Utils.h"
#import "UIAlertView+Helpers.h"
#import "UIView+AutoLayout.h"
#import "NSString+Helpers.h"

#define PUSH_CAPTURE_VIDEOVIEWCONTROLLER @"pushCaptureVideoViewController"
#define PRESENT_TRENDING @"trending"

#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define APP_SCREEN_HEIGHT [[UIScreen mainScreen] applicationFrame].size.height

#define IS_IPHONE (([[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location ==  NSNotFound)?FALSE:TRUE)
#define IS_HEIGHT_GTE_480 (([[UIScreen mainScreen ] bounds].size.height < 568)?TRUE:FALSE)
#define IS_IPHONE_4 (IS_IPHONE && IS_HEIGHT_GTE_480)
//320
#define IS_HEIGHT_GTE_568 (([[UIScreen mainScreen ] bounds].size.height >= 500)?TRUE:FALSE)
#define IS_IPHONE_5 (IS_IPHONE && IS_HEIGHT_GTE_568)
//375
#define IS_HEIGHT_GTE_667 (([[UIScreen mainScreen ] bounds].size.height >= 600)?TRUE:FALSE)
#define IS_IPHONE_6 (IS_IPHONE && IS_HEIGHT_GTE_667)
//414
#define IS_HEIGHT_GTE_736 (([[UIScreen mainScreen ] bounds].size.height >= 700)?TRUE:FALSE)
#define IS_IPHONE_6_PLUS (IS_IPHONE && IS_HEIGHT_GTE_736)
/*FBConnectViewController*/

#define objectLogin @"objectlogin"
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBSession.h>
#import "UserData.h"
#import "FacebookManager.h"

/*Categories*/
#import "UIView+Utils.h"
#import "UIAlertView+Helpers.h"
#import "MixEngine.h"
#import "NSString+Helpers.h"

/*MixVideoViewController*/

#define BG_COLOR_PROCESS_MIX_VIDEO [UIColor colorWithRed:224.0/255.0 green:100.0/255.0 blue:176.0/255.0 alpha:1.0]

/*CaptureVideoViewController*/

#define PointX 80
#define COLOR_PROCESS [UIColor colorWithRed:224.0/255.0 green:100.0/255.0 blue:176.0/255.0 alpha:1.0]
#define BG_COLOR_PROCESS [UIColor colorWithRed:43.0/255.0 green:42.0/255.0 blue:50.0/255.0 alpha:1.0]
#define KEY_DISTANCE @"key_distance"

/*NavigationView*/

#define NAVIGATION_BAR_CUSTOM_DEFAULT_HEIGHT 44

#endif
