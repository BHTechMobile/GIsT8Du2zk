//
//  CommentHeaderTableViewCell.h
//  9HugMoment
//
//  Created by PhamHuuPhuong on 6/12/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *addCommentButton;
- (IBAction)addCommentButtonAction:(id)sender;
@end
