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

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *messageContentTableView;

@property (nonatomic,strong) PlayerView* videoPlayer;
@property (weak, nonatomic) NSLayoutConstraint *topPosition;

@property (nonatomic, strong) NSURL *capturePath;
@property (nonatomic, strong) NSString *userLabel;
@property (nonatomic, strong) NSString *countVote;
@property (nonatomic, strong) MessageObject *messageObject;

- (IBAction)backButtonAction:(id)sender;

@end
