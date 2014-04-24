//
//  MCCollectionViewCell.m
//  GithubToGO
//
//  Created by Matthew Voss on 4/24/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MCCollectionViewCell.h"

@implementation MCCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.cellImageView  = [[UIImageView alloc] initWithFrame:frame];
        self.textFeild      = [[UITextField alloc] initWithFrame:frame];
        
        [self.contentView addSubview:_cellImageView];
        [self.contentView addSubview:_textFeild];
        
        self.textFeild.textAlignment = NSTextAlignmentCenter;
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
