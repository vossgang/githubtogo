//
//  MVViewController.m
//  GithubToGO
//
//  Created by Matthew Voss on 4/22/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVViewController.h"

@interface MVViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURLRequest *urlrequest =[NSURLRequest requestWithURL:[NSURL URLWithString:_detailRepo.html_url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:600000];
    
    [_webView loadRequest:urlrequest];    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
