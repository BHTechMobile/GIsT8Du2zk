//
//  UserInfoTableViewCell.m
//  9HugMoment
//
//  Created by PhamHuuPhuong on 9/12/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@implementation UserInfoTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (IBAction)voteButtonAction:(id)sender {
}

@end
