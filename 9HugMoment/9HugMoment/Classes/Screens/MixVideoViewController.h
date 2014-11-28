//
//  MixVideoViewController.h
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationView.h"
@interface MixVideoViewController : UIViewController<MPMediaPickerControllerDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate,GPUImageMovieDelegate,NavigationCustomViewDelegate>{
    NSArray * changeFrameButtons;
    GPUImageMovie *movieFile;
    GPUImageMovie *filterMovie;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageMovieWriter *movieWriter;
    AVAudioPlayer * _audioPlayer;
    BOOL _isPlaying;
    NSString *_currentFilterClassString;
    NavigationView *_navigationView;
}

- (IBAction)publicVideoButtonAction:(id)sender;
@property (nonatomic, strong) NSString *mKey;
@property (nonatomic, strong) NSURL *capturePath;
@property (nonatomic, strong) UIImage* imgFrame;
@property (nonatomic) CGFloat duration;
@property(nonatomic,assign) NSInteger indexFrame;

@property(nonatomic,strong) MPMediaItem* audioItem;
@property(nonatomic,strong) NSURL* exportUrl;
@property(nonatomic,assign) BOOL mixed;
@property(nonatomic,strong) NSString* message;
//@property (weak, nonatomic) EnterMessageView *enterMessageView;
//@property (weak, nonatomic) ScheduleView *scheduleView;
@property (weak, nonatomic) NSLayoutConstraint *topPosition;

@property (weak, nonatomic) IBOutlet UIButton *touchPublicVideoButton;
@property (weak, nonatomic) IBOutlet UIView *navigationCustomView;
@property (strong, nonatomic) IBOutlet GPUImageView *playerView;
@property (weak, nonatomic) IBOutlet UIImageView *imvFrame;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIScrollView *selectFrameScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *videoFilterScrollView;
@property (weak, nonatomic) IBOutlet UIButton *notificationButton;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIImageView *imvPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnFrames;
@property (weak, nonatomic) IBOutlet UIButton *btnVideoFilters;

@end
