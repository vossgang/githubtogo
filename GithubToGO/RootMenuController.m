//
//  RootMenuController.m
//  GithubToGO
//
//  Created by Matthew Voss on 4/21/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "RootMenuController.h"
#import "ReposViewController.h"
#import "UsersViewController.h"
#import "SearchViewController.h"
#import "BurgerProtocal.h"

@interface RootMenuController () <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, BurgerProtocal>

@property (weak, nonatomic) IBOutlet UITableView        *tabelView;

@property (nonatomic, strong) NSArray                   *arrayOfViewControllers;

@property (nonatomic, strong) UIViewController          *topViewController;
@property (nonatomic, strong) UITapGestureRecognizer    *tapToClose;
@property (nonatomic) BOOL                              menuIsOpen;
@property (nonatomic) CGRect                            screenFrame;


@end

@implementation RootMenuController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _screenFrame = [[UIScreen mainScreen] bounds];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    
    
    ReposViewController *repoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Repos"];
    repoViewController.title = @"My Repos";
    repoViewController.burgerDelegate = self;
    
    UsersViewController *userViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Users"];
    userViewController.title = @"Following";
    userViewController.burgerDelegate = self;

    
    SearchViewController *searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];
    searchViewController.title   = @"Search";
    searchViewController.burgerDelegate = self;

    
    _arrayOfViewControllers = @[repoViewController, userViewController, searchViewController];
    
    _topViewController = [_arrayOfViewControllers objectAtIndex:0];
    
    
    [self addChildViewController:_topViewController];
//    repoViewController.view.frame = self.view.frame;
    
    [self.view addSubview:_topViewController.view];
    [_topViewController didMoveToParentViewController:self];
    
    
    [self setUpDragRecognizer];
    
    _tabelView.userInteractionEnabled = NO;
    
    // Do any additional setup after loading the view.
}

-(void)setUpDragRecognizer
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.maximumNumberOfTouches = 1;
    
    panRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:panRecognizer];
}

-(void)movePanel:(id)sender
{
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    
//    [[[pan view] layer] removeAllAnimations];
    
    CGPoint trasnlatedPoint = [pan translationInView:self.view];
//    CGPoint velocity = [pan velocityInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        if (trasnlatedPoint.x > 0) {
            _topViewController.view.center = CGPointMake(_topViewController.view.center.x + trasnlatedPoint.x, _topViewController.view.center.y);
            [pan setTranslation:CGPointZero inView:self.view];
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        if (_topViewController.view.frame.origin.x > (self.view.bounds.size.width / 3)) {
            [self openMenu];
        } else {
                [UIView animateWithDuration:.4 animations:^{
                    _topViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                }];
        }
    }
    
    
}

-(void)openMenu
{
    [UIView animateWithDuration:.4 animations:^{
        _topViewController.view.frame = CGRectMake(_topViewController.view.frame.size.width * .75, _topViewController.view.frame.origin.y, _topViewController.view.frame.size.width, _topViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            _tapToClose = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenu:)];
            [_topViewController.view addGestureRecognizer:_tapToClose];
            _tabelView.userInteractionEnabled = _menuIsOpen = YES;
            
        }
    }];

    
    
}

-(void)handleBurgerPressed
{
    
    if (_menuIsOpen) {
        [self closeMenu:nil];
    } else {
        [self openMenu];
    }
    
}


-(void)closeMenu:(id)sender
{
    [UIView animateWithDuration:.5 animations:^{
        
        _topViewController.view.frame = self.view.bounds;
        
    } completion:^(BOOL finished) {
        [_topViewController.view removeGestureRecognizer:_tapToClose];
        _tabelView.userInteractionEnabled = _menuIsOpen = NO;
    }];
    
}




-(void)switchToViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:.2 animations:^{
        
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        CGRect offScreen = _topViewController.view.frame;
        
        [_topViewController.view removeFromSuperview];
        
        [_topViewController removeFromParentViewController];
        
        _topViewController = _arrayOfViewControllers[indexPath.row];
        
        [self addChildViewController:_topViewController];
        
        _topViewController.view.frame = offScreen;
        
        [self.view addSubview:_topViewController.view];
        
        [_topViewController didMoveToParentViewController:self];
        
        [self closeMenu:nil];
        
    }];
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayOfViewControllers.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [_arrayOfViewControllers[indexPath.row] title];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self switchToViewControllerAtIndexPath:indexPath];
    
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



- (void)orientationChanged:(NSNotification *)notification
{
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    
    if (_menuIsOpen) {
        
        switch (deviceOrientation) {
            case UIDeviceOrientationPortrait:
            case UIDeviceOrientationFaceDown:
            case UIDeviceOrientationFaceUp:
            case UIDeviceOrientationPortraitUpsideDown:
                _topViewController.view.frame = CGRectMake(_screenFrame.size.width * .75, 0, _screenFrame.size.width, _screenFrame.size.height);
                break;
                
            case UIDeviceOrientationLandscapeRight:
            case UIDeviceOrientationLandscapeLeft:
                _topViewController.view.frame = CGRectMake(_screenFrame.size.width * .75, 0, _screenFrame.size.height, _screenFrame.size.width);
                break;
                
            default:
                NSLog(@"unknown orientaion");
                break;
        }
    } else {
        
        switch (deviceOrientation) {
            case UIDeviceOrientationPortrait:
            case UIDeviceOrientationFaceDown:
            case UIDeviceOrientationFaceUp:
            case UIDeviceOrientationPortraitUpsideDown:
                _topViewController.view.frame = CGRectMake(0, 0, _screenFrame.size.width, _screenFrame.size.height);
                break;
               
            case UIDeviceOrientationLandscapeRight:
            case UIDeviceOrientationLandscapeLeft:
                _topViewController.view.frame = CGRectMake(0, 0, _screenFrame.size.height, _screenFrame.size.width);
                break;
                
            default:
//                NSLog(@"unknown orientaion");
                break;
        }

    }

}

/*
typedef NS_ENUM(NSInteger, UIDeviceOrientation) {
    UIDeviceOrientationUnknown,
    UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
    UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
    UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
    UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
    UIDeviceOrientationFaceUp,              // Device oriented flat, face up
    UIDeviceOrientationFaceDown             // Device oriented flat, face down
};

*/


@end
