//
//  ReposViewController.m
//  GithubToGO
//
//  Created by Matthew Voss on 4/21/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "ReposViewController.h"

@interface ReposViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ReposViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _titleLabel.text = self.title;
    

    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)burgerPressed:(id)sender
{
    [_burgerDelegate handleBurgerPressed];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
