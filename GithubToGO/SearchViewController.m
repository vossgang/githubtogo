//
//  SearchViewController.m
//  GithubToGO
//
//  Created by Matthew Voss on 4/21/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "SearchViewController.h"
#import "MVAppDelegate.h"
#import "MVViewController.h"
#import "NetworkProtocal.h"
#import "MVRepo.h"
#import "MCCollectionViewCell.h"

@interface SearchViewController () <UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel        *titleLabel;
@property (weak, nonatomic) IBOutlet UISearchBar    *searchBar;
@property (weak, nonatomic) MVAppDelegate           *appDelegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) MVNetworkController     *networkController;
@property (nonatomic,strong) NSArray                *repos;
@property (nonatomic, strong) NSOperationQueue      *downloadImageQueue;
@property (nonatomic, strong) NSTimer               *reloadTimer;

@end

@implementation SearchViewController

- (IBAction)burgerPressed:(id)sender
{
    [_burgerDelegate handleBurgerPressed];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _downloadImageQueue             = [NSOperationQueue new];
    _appDelegate                    = [UIApplication sharedApplication].delegate;
    _appDelegate.networkController  = [MVNetworkController new];
    _networkController              = _appDelegate.networkController;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _searchBar.delegate         = self;
    _collectionView.dataSource  = self;
    _collectionView.delegate    = self;
    _titleLabel.text            = self.title;
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _repos = nil;
    [self searchGithubfor:searchBar.text];
    [searchBar resignFirstResponder];
    [_collectionView reloadData];
}

-(void)searchGithubfor:(NSString *)user
{
    [_networkController downloadReposForUser:user withcompletion:^(NSArray *repos) {
        
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                _repos = repos;
                [_collectionView reloadData];
            }];
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UISearchBar *search in self.view.subviews) {
        if (_searchBar == search && [_searchBar isFirstResponder]) {
            [self searchBarSearchButtonClicked:search];
        }
    }
}

#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _repos.count;
}


-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVRepo *currentRepo = _repos[indexPath.row];
    if (!currentRepo.avatarImage) {
        [currentRepo cancelAvatarDownload];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MCCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"SeachCell" forIndexPath:indexPath];
    
    MVRepo *thisRepo = _repos[indexPath.row];

    cell.backgroundColor = [UIColor blueColor];
    
    if (thisRepo.avatarImage) {
        cell.imageView.image = thisRepo.avatarImage;
        [cell.ibTextFeild setHidden:YES];
    } else {
        cell.imageView.image = nil;
        [cell.ibTextFeild  setHidden:NO];
        cell.ibTextFeild.text = thisRepo.ownerLogin;
        [thisRepo downloadAvatarOnQueue:_downloadImageQueue WithCompletionBlock:^{
            [cell.ibTextFeild setHidden:YES];
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
    }
    
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path =[_collectionView indexPathForCell:sender];
    
    if ([segue.identifier isEqualToString:@"DetailView"]) {
        MVViewController *detail = segue.destinationViewController;
        detail.detailRepo = [_repos objectAtIndex:path.row];
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _repos.count;
}

@end

//when this use to be a tableview

/*
 -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 NSString *identifier = @"SeachCell";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
 
 MVRepo *thisRepo = _repos[indexPath.row];
 
 cell.textLabel.text = thisRepo.ownerLogin;
 
 if (thisRepo.avatarImage) {
 cell.imageView.image = thisRepo.avatarImage;
 } else {
 cell.imageView.image = nil;
 [thisRepo downloadAvatarOnQueue:_downloadImageQueue WithCompletionBlock:^{
 [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
 }];
 }
 
 return cell;
 } */