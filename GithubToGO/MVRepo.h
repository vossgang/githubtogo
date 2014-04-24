//
//  MVRepo.h
//  GithubToGO
//
//  Created by Matthew Voss on 4/22/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVRepo : NSObject

@property (nonatomic, strong) NSNumber *repo_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *repo_description;
@property (nonatomic, strong) NSString *html_url;
@property (nonatomic, strong) NSString *lastPushed;

@property (nonatomic, strong) NSString *ownerLogin;
@property (nonatomic ,strong) NSNumber *owner_id;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *ownerhtml_url;

-(id)initRepoWith:(NSDictionary *)dict;

@end
