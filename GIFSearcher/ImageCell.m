//
//  ImageCell.m
//  GIFSearcher
//
//  Created by Ivan on 12.06.16.
//  Copyright © 2016 i_sokolov. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

@synthesize cellPicture;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
