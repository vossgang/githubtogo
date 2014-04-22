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

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ReposViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _titleLabel.text = self.title;
    
    [self configureView];

    // Do any additional setup after loading the view.
}




- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailRepo) {
        
        NSData *webViewData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.detailRepo valueForKey:@"html_url"]]];
        
        [_webView loadData:webViewData
                  MIMEType:nil
          textEncodingName:nil
                   baseURL:nil];
                
    }
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
