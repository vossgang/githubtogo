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

@property (nonatomic, unsafe_unretained) id<NetworkProtocal> delegate;

-(void)requestOAuthAccess:(void (^)())compeationBlock;

-(void)handleOAuthCallBackWith:(NSURL *)url;

-(void)downloadReposForUser:(NSString *)userName withcompletion:(void(^)(NSArray *repos))compleationBlock;

-(void)retrieveReposForCurrentUser:(void(^)(NSArray *repos))compleationBlock;

@end
