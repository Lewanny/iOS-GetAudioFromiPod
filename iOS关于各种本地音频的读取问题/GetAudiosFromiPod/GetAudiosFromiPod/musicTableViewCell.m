//
//  musicTableViewCell.m
//  BlueToothText
//
//  Created by 李宏远 on 16/3/22.
//  Copyright © 2016年 李宏远. All rights reserved.
//

#import "musicTableViewCell.h"

@interface musicTableViewCell ()


@end

@implementation musicTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.labelMusic = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.contentView.bounds.size.width, 20)];
        [self.contentView addSubview:self.labelMusic];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
