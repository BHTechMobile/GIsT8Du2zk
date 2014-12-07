//
//  MomentsMessageTableViewCell.m
//  9HugMoment
//

#import "MomentsMessageTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MomentsMessageTableViewCell

#pragma mark - MomentsMessageTableViewCell management

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] objectAtIndex:0];
        UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
        rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [rightRecognizer setNumberOfTouchesRequired:1];
        
        //add the gestureRecognizer
        [self addGestureRecognizer:rightRecognizer];
        
        UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
        leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [leftRecognizer setNumberOfTouchesRequired:1];
        
        [self addGestureRecognizer:leftRecognizer];
        isShowResetButton = NO;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageWithMessage:(MessageObject *)message {
    [self hideResetButton];
    _userNameLabel.text = message.fullName;
    _numberReadsLabel.text = (![message.reads isEqualToString:@""])?message.reads:@"0";
    
    NSString *imgURL = [NSString stringWithFormat:@"%@%@",URL_MESSAGE_GRCODE_BY_KEY,message.key];
    [_thumbnailImageView setImageWithURL:[NSURL URLWithString:imgURL]
                        placeholderImage:[UIImage imageNamed:IMAGE_NAME_THUMB_PLACE_HOLDER]
                                 options:SDWebImageProgressiveDownload
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if(error.code == 404){
            NSLog(@"Error: Image not found");
        }
    }];
    
}

#pragma mark - Actions

- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self hideResetButton];
}

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self showResetButton];
}

- (IBAction)resetAction:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(resetMessageAtCell:)]){
        [self.delegate resetMessageAtCell:self];
    }
}

#pragma mark - Custom Methods

- (void)hideResetButton
{
    if (isShowResetButton) {
        [UIView animateWithDuration:TIME_TO_SHOW_RESET_BUTTON animations:^{
            _leftSpaceDataViewConstraint.constant = _rightSpaceDataViewConstraint.constant = 0;
        }completion:^(BOOL finished){
            isShowResetButton = NO;
        }];
    }
}

- (void)showResetButton
{
    if (!isShowResetButton) {
        [UIView animateWithDuration:TIME_TO_SHOW_RESET_BUTTON animations:^{
            _leftSpaceDataViewConstraint.constant = -WIGHT_RESET_BUTTON_MOMENTS_MESSAGE_TABLE_VIEW_CELL;
            _rightSpaceDataViewConstraint.constant = WIGHT_RESET_BUTTON_MOMENTS_MESSAGE_TABLE_VIEW_CELL;
        }completion:^(BOOL finished){
            isShowResetButton = YES;
        }];
    }
}

@end
