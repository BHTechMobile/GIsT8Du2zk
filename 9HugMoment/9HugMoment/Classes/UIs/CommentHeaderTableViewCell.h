//
//  CommentHeaderTableViewCell.h
//  9HugMoment
//
//  Created by PhamHuuPhuong on 6/12/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentHeaderTableViewCellDelegate <NSObject>

- (void)clickedAddComment:(UIButton *)btnAddComment;

@end

@interface CommentHeaderTableViewCell : UITableViewCell

@property (nonatomic,assign) id<CommentHeaderTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *addCommentButton;
- (IBAction)addCommentButtonAction:(id)sender;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
