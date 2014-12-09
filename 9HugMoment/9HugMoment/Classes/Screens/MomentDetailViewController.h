//
//  MomentDetailViewController.h
//  9HugMoment
//

#import <UIKit/UIKit.h>
#import "DownloadVideoView.h"
#import "PlayerView.h"
#import "EnterMessageView.h"
#import "MomentsDetailsModel.h"

@interface MomentDetailViewController : UIViewController<DownloadVideoDelegate,EnterMessageDelegate,UITableViewDataSource,UITableViewDelegate, MomentsDetailsModelDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *momentSegmentController;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *addVideoButton;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (strong, nonatomic) IBOutlet UIView *extendView;
@property (strong, nonatomic) IBOutlet UIView *playerView;
@property(nonatomic,strong) PlayerView* videoPlayer;
@property (weak, nonatomic) EnterMessageView *enterMessageView;
@property (weak, nonatomic) NSLayoutConstraint *topPosition;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (nonatomic, strong) NSURL *capturePath;
@property (nonatomic, strong) NSString *userLabel;
@property (nonatomic, strong) NSString *countVote;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;
@property (weak, nonatomic) IBOutlet UITableView *messageContentTableView;

- (IBAction)addVideoButtonAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)momentSegmentControllerAction:(id)sender;
- (IBAction)voteButtonAction:(id)sender;

@end
