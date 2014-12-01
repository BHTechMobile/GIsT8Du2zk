//
//  CaptureVideoViewController.h
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "PBJVision.h"

#import "PBJVision.h"
#import "PBJVisionUtilities.h"
#import "NavigationView.h"
#import <GLKit/GLKit.h>

@interface CaptureVideoViewController : UIViewController<PBJVisionDelegate,UIAlertViewDelegate,NavigationCustomViewDelegate>{
    NSArray * changeFrameButtons;
    int _currentFrame;
    BOOL _isRecording;
    AVCaptureVideoPreviewLayer *_previewLayer;
    GLKViewController *_effectsViewController;
    NSInteger _startCount;
    int _imgIndex;
    UIImageView *_cursorImageView;
    UIView *_viewCurrentProgress;
    NSMutableArray *_arrayViewSpeacators;
    NavigationView *navigationView;
}

- (void)showAlertResumVideo;

@property(nonatomic,strong) NSString *userToken;

@property(nonatomic,strong) NSString *mKey;
@property(nonatomic,assign) NSInteger count;
@property(nonatomic,assign) NSInteger duration;
@property(nonatomic,strong) NSTimer* timer;
@property(nonatomic,strong) NSTimer* timerCursor;
@property(nonatomic,strong) NSString* capturePath;

@property (weak, nonatomic) IBOutlet UIView *navigationCustomView;
@property (weak, nonatomic) IBOutlet UIButton *touchMixVideoButton;
@property (weak, nonatomic) IBOutlet UIScrollView *selectFrameScrollView;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeCapturedButton;
@property (weak, nonatomic) IBOutlet UIButton *doneCaptureButton;
@property (weak, nonatomic) IBOutlet UIImageView *imvFrame;
@property (weak, nonatomic) IBOutlet UIImageView *imvCapture;
@property (weak, nonatomic) IBOutlet UIView *recordPercent;
@property (weak, nonatomic) IBOutlet UIImageView *imvAnimationFrame;
@property (weak, nonatomic) IBOutlet UILabel *lblTutorial;
@property (weak, nonatomic) IBOutlet UIButton *touchDoneCapture;

@end
