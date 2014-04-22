//
//  MVRepo.m
//  GithubToGO
//
//  Created by Matthew Voss on 4/22/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVRepo.h"

@implementation MVRepo

-(id)initRepoWith:(NSDictionary *)dictionary
{
    self = [super init];
 
    if (self) {
        NSNull *nothing = [NSNull new];
        
        _name = [dictionary objectForKey:@"name"] ? [dictionary objectForKey:@"name"] : @" ";
        _repo_id = [dictionary objectForKey:@"id"] ? [dictionary objectForKey:@"id"] : @"";
        
        if ([dictionary objectForKey:@"description"] == nothing) {
            _repo_description = @" ";
        } else {
            _repo_description = [dictionary objectForKey:@"description"];
        }
        
        _html_url = [dictionary objectForKey:@"html_url"] ? [dictionary objectForKey:@"html_url"] : @" ";
        
    }
    
    
    return self;
}

@end
