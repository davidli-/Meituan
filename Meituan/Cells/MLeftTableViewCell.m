//
//  MLeftTableViewCell.m
//  Meituan
//
//  Created by Macmafia on 2019/4/3.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "MLeftTableViewCell.h"

@implementation MLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //其他自定义设置 如控件布局
    }
    return self;
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
    [super setSelected:selected animated:NO];
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor colorWithWhite:0 alpha:0.1];
}

@end
