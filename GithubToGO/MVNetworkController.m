//
//  MVNetworkController.m
//  GithubToGO
//
//  Created by Matthew Voss on 4/22/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVNetworkController.h"

#define GITHUB_CLIENT_ID        @"7dc8537cd5f24ae3b57a"
#define GITHUB_CLIENT_SECRET    @"a59fbcb79c831ace4159bee68c45a21311471d71"
#define GITHUB_CALLBACK_URI     @"gitauth://gittogo_callback"
#define GITHUB_OAUTH_URL        @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@"

#define GITHUB_API_URL          @"https://api.github.com%@"


#define GITHUB_USER_SEARCH      @"https://api.github.com/users/%@/repos"


@implementation MVNetworkController


-(id)init
{
    self = [super init];
    
    if (self) {
        
        _accessToken =[[NSUserDefaults standardUserDefaults] objectForKey:@"OAuthToken"];
        
        if (!_accessToken) {
            NSLog(@"no access");
            [self requestOAuthAccess];
        }
    }
    return self;
}


-(void)requestOAuthAccess
{
    NSString *urlString = [NSString stringWithFormat:GITHUB_OAUTH_URL,GITHUB_CLIENT_ID,GITHUB_CALLBACK_URI,@"user,repo"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
    
}

-(void)handleOAuthCallBackWith:(NSURL *)url
{
    
    NSString *code = [self getCodeFromCallBack:url];
    
    NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@", GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET, code];
    
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postString length]];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
//    sessionConfig.HTTPAdditionalHeaders = 
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"error: %@", error.description);
        }
        [self convetResponseDataIntoToken:data];
        
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
    
    
    return _accessToken;

}


-(NSString *)getCodeFromCallBack:(NSURL *)callBackURL
{
    NSString *query = [callBackURL query];
    
    NSArray *components = [query componentsSeparatedByString:@"="];
    
    return [components lastObject];
    
}


-(NSArray *)downloadReposForUser:(NSString *)userName
{
    
    NSArray *json = [NSArray new];
    
        NSString *searchUrlString = [NSString stringWithFormat:GITHUB_USER_SEARCH, userName];
        NSURL *searchUrl = [NSURL URLWithString:searchUrlString];
        NSData *data = [NSData dataWithContentsOfURL:searchUrl];
        
        if (data) {
            NSError *error;
            json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
//            [self.delegate insertDownloadedArrayToController:json];

        }
    
    return json;
    
}



-(void)retrieveReposForCurrentUser
{
    NSURL *repoRequest = [NSURL URLWithString:[NSString stringWithFormat:GITHUB_API_URL, @"/user/repos"]];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:repoRequest];
    [request setValue:[NSString stringWithFormat:@"token %@", _accessToken] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *repoDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@", response.description);
        
        NSArray *jason = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", jason);
        
        _arrayOfUserRepos = jason;
        [_delegate finishedLoadingReposForUser];


    }];

    [repoDataTask resume];

    return;
}
@end

