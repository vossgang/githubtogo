//
//  MVNetworkController.m
//  GithubToGO
//
//  Created by Matthew Voss on 4/22/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVNetworkController.h"
#import "MVRepo.h"

#define GITHUB_CLIENT_ID        @"7dc8537cd5f24ae3b57a"
#define GITHUB_CLIENT_SECRET    @"a59fbcb79c831ace4159bee68c45a21311471d71"
#define GITHUB_CALLBACK_URI     @"gitauth://gittogo_callback"
#define GITHUB_OAUTH_URL        @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@"

#define GITHUB_API_URL          @"https://api.github.com%@"


#define GITHUB_USER_SEARCH      @"https://api.github.com/users/%@/repos"

@interface MVNetworkController()

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) void (^completedAccess)();

@end


@implementation MVNetworkController


-(id)init
{
    self = [super init];
    
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        config.allowsCellularAccess = YES;
        
        
        _accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"OAuthToken"];
        
        if (!_accessToken) {
            NSLog(@"no access");
        } else {
            [_urlSession.configuration setHTTPAdditionalHeaders:@{@"Authorization": [NSString stringWithFormat:@"token %@", _accessToken]}];
            NSLog(@"%@",_accessToken);
        }
        _urlSession  = [NSURLSession sessionWithConfiguration:config];

    }
    return self;
}


-(void)requestOAuthAccess:(void (^)())compeationBlock
{
    NSString *urlString = [NSString stringWithFormat:GITHUB_OAUTH_URL,GITHUB_CLIENT_ID,GITHUB_CALLBACK_URI,@"user,repo"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    _completedAccess = compeationBlock;
    
    
}

-(void)handleOAuthCallBackWith:(NSURL *)url
{
    
    NSString *code = [self getCodeFromCallBack:url];
    
    NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@", GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET, code];
    
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postString length]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"error: %@", error.description);
        }
        [self convetResponseDataIntoToken:data];
        _completedAccess();
        
    }];
    
    [postDataTask resume];
}


-(NSString *)convetResponseDataIntoToken:(NSData *)data
{
    NSString *tokenResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSArray *tokenComponites = [tokenResponse componentsSeparatedByString:@"&"];
    
    NSString *accessTokenWithCode = [tokenComponites firstObject];
    
    NSArray *accessTokenArray = [accessTokenWithCode componentsSeparatedByString:@"="];
        
    _accessToken = [accessTokenArray lastObject];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"OAuthToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%@", _accessToken);
    
    _urlSession.configuration.HTTPAdditionalHeaders = @{@"Authorization": [NSString stringWithFormat:@"token %@", _accessToken]};
    
    return _accessToken;

}


-(NSString *)getCodeFromCallBack:(NSURL *)callBackURL
{
    NSString *query = [callBackURL query];
    
    NSArray *components = [query componentsSeparatedByString:@"="];
    
    return [components lastObject];
    
}


-(void)downloadReposForUser:(NSString *)userName withcompletion:(void(^)(NSArray *repos))completionBlock
{
    
    NSString *searchUrlString = [NSString stringWithFormat:GITHUB_USER_SEARCH, userName];
    NSURL *searchUrl = [NSURL URLWithString:searchUrlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:searchUrl];
    [request setValue:[NSString stringWithFormat:@"token %@", _accessToken] forHTTPHeaderField:@"Authorization"];

    
    NSURLSessionDataTask *downloadRepos = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *tempArray = [NSMutableArray new];
        [JSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MVRepo *repo = [[MVRepo alloc] initRepoWith:obj];
            [tempArray addObject:repo];
            
        }];
        
        completionBlock(tempArray);
        
    }];
    
    [downloadRepos resume];
    
}



-(void)retrieveReposForCurrentUser:(void(^)(NSArray *repos))completionBlock
{
    
//    dispatch_queue_t   downloadQueue = dispatch_queue_create("com.MATT.VOSS.downloadQueue", NULL);
//    
//    dispatch_async(downloadQueue, ^{
//        
//    //code goes here
//    
//    });

//code for GCD queues

    
    NSURL *repoRequest = [NSURL URLWithString:[NSString stringWithFormat:GITHUB_API_URL, @"/user/repos"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:repoRequest];
    
    
    
    [request setValue:[NSString stringWithFormat:@"token %@", _accessToken] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *repoDataTask = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *tempArray = [NSMutableArray new];
        [JSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MVRepo *repo = [[MVRepo alloc] initRepoWith:obj];
            [tempArray addObject:repo];
            
        }];
        
        
        completionBlock(tempArray);


    }];

    [repoDataTask resume];
}
@end

