//
//  UserInfoTableViewCell.h
//  9HugMoment
//

#import <UIKit/UIKit.h>

@class UserInfoTableViewCell;
@protocol UserInfoTableViewCellDelegate <NSObject>
- (void)didUserClickVoteButton:(UserInfoTableViewCell *)userInfoTableViewCell;
@end

@interface UserInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gpsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconCaretImageView;
@property (weak, nonatomic) IBOutlet UILabel *voteNumberLabel;
@property (weak, nonatomic) id<UserInfoTableViewCellDelegate> delegate;
@property (assign, nonatomic) BOOL isUserVoted;

- (IBAction)voteButtonAction:(id)sender;

@end
