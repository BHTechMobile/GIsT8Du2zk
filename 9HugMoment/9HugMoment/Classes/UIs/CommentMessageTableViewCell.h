//
//  CommentMessageTableViewCell.h
//  9HugMoment
//
//  Created by PhamHuuPhuong on 6/12/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userCommentImage;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
