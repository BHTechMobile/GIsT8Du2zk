//
//  MomentsMessageTableViewCell.h
//  9HugMoment
//

#import <UIKit/UIKit.h>
#import "MessageObject.h"

@class MomentsMessageTableViewCell;

@protocol MomentsMessageTableViewCellDelegate <NSObject>
@optional
- (void)resetMessageAtCell:(MomentsMessageTableViewCell *)messageCell;

@end

@interface MomentsMessageTableViewCell : UITableViewCell {
    BOOL isShowResetButton;
}

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gpsIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberReadsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpaceDataViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSpaceDataViewConstraint;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (nonatomic, assign)id<MomentsMessageTableViewCellDelegate> delegate;

- (IBAction)resetAction:(id)sender;
- (void)setMessageWithMessage:(MessageObject *)message;

@end
