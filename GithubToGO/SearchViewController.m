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

@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

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
    
    
    _searchBar.delegate         = self;
    _tableView.dataSource       = self;
    _tableView.delegate         = self;
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
    [self searchGithubfor:searchBar.text];
    [searchBar resignFirstResponder];

}


-(void)searchGithubfor:(NSString *)user
{
    
    [_networkController downloadReposForUser:user withcompletion:^(NSArray *repos) {
        
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                _repos = repos;
                [_tableView reloadData];
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _repos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    
    MVRepo *thisRepo = _repos[indexPath.row];
    
    cell.textLabel.text = thisRepo.name;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = _tableView.indexPathForSelectedRow;
    
    if ([segue.identifier isEqualToString:@"detailView"]) {
        MVViewController *detail = segue.destinationViewController;
        detail.detailRepo = [_repos objectAtIndex:path.row];
       
    }
    
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
