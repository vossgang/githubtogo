//
//  MVNetworkController.h
//  GithubToGO
//
//  Created by Matthew Voss on 4/22/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVNetworkController : NSObject

@property (nonatomic, strong) NSString *accessToken;

-(void)requestOAuthAccess;

-(void)handleOAuthCallBackWith:(NSURL *)url;

-(NSArray *)downloadReposForUser:(NSString *)userName;

@end
