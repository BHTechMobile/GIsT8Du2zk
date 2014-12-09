//
//  PlayerViewTableViewCell.h
//  9HugMoment
//
//  Created by PhamHuuPhuong on 9/12/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *playerViewCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
