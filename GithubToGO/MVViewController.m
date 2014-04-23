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
    
    [self configureView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView
{
    // Update the user interface for the detail item.
    NSURL *detailWebURL = [NSURL URLWithString:_detailRepo.html_url];
    
    NSData *detailWebData = [NSData dataWithContentsOfURL:detailWebURL];
    
    if (detailWebData) {
        NSLog(@"data");
    }
    
    NSString *detailWebString = [[NSString alloc] initWithData:detailWebData encoding:NSUTF8StringEncoding];
    
    [_webView loadHTMLString:detailWebString baseURL:nil];
    
}

@end
