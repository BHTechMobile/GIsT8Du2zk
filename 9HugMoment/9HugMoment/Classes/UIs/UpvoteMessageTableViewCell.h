//
//  UpvoteMessageTableViewCell.h
//  9HugMoment
//
//  Created by PhamHuuPhuong on 6/12/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpvoteMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *userVoteScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *userVoteImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
