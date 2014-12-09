//
//  UserInfoTableViewCell.h
//  9HugMoment
//
//  Created by PhamHuuPhuong on 9/12/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageUser;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;
- (IBAction)voteButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
