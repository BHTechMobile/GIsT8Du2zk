//
//  Constants.h
//  9HugMoment
//
//  Created by PhamHuuPhuong on 27/11/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#ifndef _HugMoment_Constants_h
#define _HugMoment_Constants_h

#pragma mark - ALl Pages
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

#pragma mark - KEYS
// KEYS
#define KEY_ID @"id"
#define KEY_AGENT_ID @"agentid"
#define KEY_TYPE @"type"
#define KEY_STYLE @"style"
#define KEY_NOTIFICATION @"notification"
#define KEY_KEY @"key"
#define KEY_CODE @"code"
#define KEY_LENGTH @"length"
#define KEY_THUMB @"thumb"
#define KEY_ATTACHEMENT_1 @"attachement1"
#define KEY_ATTACHEMENT_2 @"attachement2"
#define KEY_TEXT @"text"
#define KEY_USER_ID @"userid"
#define KEY_FRAME_ID @"frameid"
#define KEY_CATEGORY @"category"
#define KEY_GENERATED_DATE @"generateddate"
#define KEY_CREATE_DATED @"createdated"
#define KEY_SCHEDULED @"scheduled"
#define KEY_SENT_DATE @"sentdate"
#define KEY_RECEIVER_ID @"receiverid"
#define KEY_RECEIVER_DATE @"receiveddate"
#define KEY_READS @"reads"
#define KEY_FULL_NAME @"fullname"
#define KEY_S_ECHO @"sEcho"
#define KEY_I_TOTAL_RECORDS @"iTotalRecords"
#define KEY_I_TOTAL_DISPLAY_RECORDS @"iTotalDisplayRecords"
#define KEY_AA_DATA @"aaData"
//User setting key
#define KEY_USER_SETTING_LOGGED_IN_ID @"userSettingLoggedInID"
#define KEY_USER_SETTING_LOGGED_IN_TOKEN @"userSettingLoggedInToken"

#pragma mark - Services
// Services
#define URL_MESSAGE_GRCODE_BY_KEY @"http://ws.9hug.com/api/message/qrcode?key="

#pragma mark - Images Name
// Images Name
#define IMAGE_NAME_THUMB_PLACE_HOLDER @"icon_circle_gray"

#pragma mark - Identifier TableViewCell
// Identifier TableViewCell
#define IDENTIFIER_MOMENTS_MESSAGE_TABLE_VIEW_CELL @"identifierMomentsMessageTableViewCell"

#pragma mark - FBConnectViewController
/*FBConnectViewController*/
#define objectLogin @"objectlogin"
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBSession.h>
#import "UserData.h"
#import "FacebookManager.h"

#pragma mark - Categories
/*Categories*/
#import "UIView+Utils.h"
#import "UIAlertView+Helpers.h"
#import "MixEngine.h"
#import "NSString+Helpers.h"
#import "NSDictionary+Helpers.h"
#import "NSDate+Helpers.h"
#import "NSUserDefaults+Helpers.h"

#pragma mark - MixVideoViewController
/*MixVideoViewController*/
#define BG_COLOR_PROCESS_MIX_VIDEO [UIColor colorWithRed:224.0/255.0 green:100.0/255.0 blue:176.0/255.0 alpha:1.0]

#pragma mark - CaptureVideoViewController
/*CaptureVideoViewController*/
#define PointX 80
#define COLOR_PROCESS [UIColor colorWithRed:224.0/255.0 green:100.0/255.0 blue:176.0/255.0 alpha:1.0]
#define BG_COLOR_PROCESS [UIColor colorWithRed:43.0/255.0 green:42.0/255.0 blue:50.0/255.0 alpha:1.0]
#define KEY_DISTANCE @"key_distance"

#pragma mark - NavigationView
/*NavigationView*/
#define NAVIGATION_BAR_CUSTOM_DEFAULT_HEIGHT 44

#pragma mark - MomentsViewController
// MomentsViewController
#define HEIGHT_ROW_TABLE_VIEW_MOMENTS_VIEW_CONTROLLER 80
#define NUMBER_OF_SECTION_TABLE_VIEW_MOMENTS_VIEW_CONTROLLER 1

#pragma mark - MomentsMessageTableViewCell
// MomentsMessageTableViewCell
#define WIGHT_RESET_BUTTON_MOMENTS_MESSAGE_TABLE_VIEW_CELL 60
#define TIME_TO_SHOW_RESET_BUTTON 0.3

#endif
