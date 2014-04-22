//
//  UsersViewController.h
//  GithubToGO
//
//  Created by Matthew Voss on 4/21/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BurgerProtocal.h"

@interface UsersViewController : UIViewController

@property (nonatomic, unsafe_unretained) id <BurgerProtocal> burgerDelegate;


@end
