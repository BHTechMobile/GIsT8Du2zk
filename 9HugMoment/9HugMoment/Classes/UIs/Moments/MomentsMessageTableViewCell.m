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
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageWithMessage:(MessageObject *)message {
    _userNameLabel.text = message.fullName;
    _numberReadsLabel.text = (![message.reads isEqualToString:@""])?message.reads:@"0";
    
    [_attachment2ImageView setImageWithURL:[NSURL URLWithString:message.attachement2]
                        placeholderImage:[UIImage imageNamed:IMAGE_NAME_ATTACHMENT_2_DEFAULT]
                                 options:SDWebImageProgressiveDownload
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                   if(error){
                                       NSLog(@"Error: Image not found");
                                   }
                               }];
    
    NSString *thumbnailURL = [NSString stringWithFormat:@"%@%@",URL_MESSAGE_GRCODE_BY_KEY,message.key];
    [_thumbnailImageView setImageWithURL:[NSURL URLWithString:thumbnailURL]
                        placeholderImage:[UIImage imageNamed:IMAGE_NAME_THUMB_PLACE_HOLDER]
                                 options:SDWebImageProgressiveDownload
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if(error){
            NSLog(@"Error: Image not found");
        }
    }];
}

@end
