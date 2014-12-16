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
        [_thumbnailImageView.layer setMasksToBounds:YES];
        [_thumbnailImageView.layer setCornerRadius:HALF_OF(_thumbnailImageView.frame.size.width)];
    }
    return self;
}

- (void)setMessageWithMessage:(MessageObject *)message {
    _userNameLabel.text = message.fullName;
    NSString *numberOfVote = message.totalVotes;
    _numberCountsLabel.text = numberOfVote;
    [_attachment2ImageView sd_setImageWithURL:[NSURL URLWithString:message.attachement2] placeholderImage:[UIImage imageNamed:IMAGE_NAME_ATTACHMENT_2_DEFAULT] options:SDWebImageProgressiveDownload completed:NULL];
    if ([message.location isEqualToString:@""] || !message.location) {
        _locationLabel.text = @"Private";
    }else {
        _locationLabel.text = message.location;
    }
    
//    if (message.latitude==0 && message.longitude==0) {
//        _locationLabel.text = @"Private";
//    }
//    else{
//        [Utilities geocodeLocation:[[CLLocation alloc] initWithLatitude:message.latitude longitude:message.longitude] success:^(NSString *address, CLLocation *requestLocation) {
//            if (requestLocation.coordinate.latitude == message.latitude && requestLocation.coordinate.longitude==message.longitude) {
//                _locationLabel.text = address;
//            }
//        } failure:^(NSError *error) {
//            NSLog(@"%@",error);
//        }];
//    }
}

@end
