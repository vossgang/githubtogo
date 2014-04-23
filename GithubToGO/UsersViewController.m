//
//  UsersViewController.m
//  GithubToGO
//
//  Created by Matthew Voss on 4/21/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "UsersViewController.h"
#import "MVAppDelegate.h"
#import "MVNetworkController.h"
#import "MVRepo.h"

@interface UsersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) MVAppDelegate           *appDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *repos;

@property (weak, nonatomic) MVNetworkController     *networkController;

@end

@implementation UsersViewController

- (IBAction)burgerPressed:(id)sender
{
    [_burgerDelegate handleBurgerPressed];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _repos = [NSMutableArray new];
    
    _appDelegate = [UIApplication sharedApplication].delegate;
    
    _appDelegate.networkController = [MVNetworkController new];
    
    _networkController = _appDelegate.networkController;
    
    
    _tableView.dataSource       = self;
    _tableView.delegate         = self;
    _titleLabel.text            = self.title;
    
    
    
    if (_networkController.accessToken) {
        [self assignReposToArrayAndReloadTable];
    } else {
        [_networkController requestOAuthAccess:^{
            [self assignReposToArrayAndReloadTable];
        }];
    }

    // Do any additional setup after loading the view.
}
-(void)assignReposToArrayAndReloadTable
{
    [_networkController retrieveReposForCurrentUser:^(NSArray *repos) {
        _repos = repos;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _repos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserRepoCell" forIndexPath:indexPath];
    
    MVRepo *thisRepo = _repos[indexPath.row];
    
    cell.textLabel.text = thisRepo.name;
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
