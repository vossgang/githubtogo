//
//  MVNetworkController.h
//  GithubToGO
//
//  Created by Matthew Voss on 4/22/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkProtocal.h"

@interface MVNetworkController : NSObject

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSArray *arrayOfUserRepos;

@property (nonatomic, unsafe_unretained) id<NetworkProtocal> delegate;

-(void)requestOAuthAccess;

-(void)handleOAuthCallBackWith:(NSURL *)url;

-(NSArray *)downloadReposForUser:(NSString *)userName;

-(void)retrieveReposForCurrentUser;

@end
