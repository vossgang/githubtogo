//
//  MCCollectionViewCell.h
//  GithubToGO
//
//  Created by Matthew Voss on 4/24/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UITextField *textFeild;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *ibTextFeild;
@end
