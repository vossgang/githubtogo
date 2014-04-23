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

@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, NetworkProtocal>

@property (weak, nonatomic) IBOutlet UILabel        *titleLabel;

@property (weak, nonatomic) IBOutlet UISearchBar    *searchBar;
@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (weak, nonatomic) MVAppDelegate           *appDelegate;

@property (weak, nonatomic) MVNetworkController     *networkController;

@property (nonatomic,strong) NSArray                *repos;

@end

@implementation SearchViewController

- (IBAction)burgerPressed:(id)sender {
    [_burgerDelegate handleBurgerPressed];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _appDelegate = [UIApplication sharedApplication].delegate;
    
    _appDelegate.networkController = [MVNetworkController new];
    
    _networkController = _appDelegate.networkController;
    
    
    _searchBar.delegate = self;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _titleLabel.text = self.title;
    
    _networkController.delegate = self;
    
    [_networkController retrieveReposForCurrentUser];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchGithubfor:searchBar.text];
    [searchBar resignFirstResponder];

}


-(void)searchGithubfor:(NSString *)search
{
    
   _repos = [[_networkController downloadReposForUser:search] mutableCopy];
    
    [_tableView reloadData];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    for (UISearchBar *search in self.view.subviews) {
        if (_searchBar == search && [_searchBar isFirstResponder]) {
            [self searchBarSearchButtonClicked:search];
        }
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _repos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    
    MVRepo *thisRepo = [[MVRepo alloc]initRepoWith:_repos[indexPath.row]];
    
    
    
    cell.textLabel.text = thisRepo.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVViewController *thisRepo = [MVViewController new];
    
    thisRepo.detailRepo = [[MVRepo alloc]initRepoWith:_repos[indexPath.row]];
    
    thisRepo.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:thisRepo animated:YES completion:nil];

    
}


-(void)finishedLoadingReposForUser
{
    
    _repos = _networkController.arrayOfUserRepos;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];

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
