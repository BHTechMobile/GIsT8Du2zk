//
//  CommentHeaderTableViewCell.m
//  9HugMoment
//
//  Created by PhamHuuPhuong on 6/12/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "CommentHeaderTableViewCell.h"

@implementation CommentHeaderTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [_addCommentButton addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)addComment:(UIButton *)btn{
    if (_delegate &&[_delegate respondsToSelector:@selector(clickedAddComment:)]) {
        [_delegate performSelector:@selector(clickedAddComment:) withObject:btn];
    }
}

- (IBAction)addCommentButtonAction:(id)sender {
    
}

@end
