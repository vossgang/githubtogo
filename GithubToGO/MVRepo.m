//
//  MVRepo.m
//  GithubToGO
//
//  Created by Matthew Voss on 4/22/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVRepo.h"

@interface MVRepo ()

@property (nonatomic, strong) NSURL *avatarURL;

@end

@implementation MVRepo

-(id)initRepoWithRepoDictionary:(NSDictionary *)dictionary
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
        _html_url   = [dictionary objectForKey:@"html_url"] ? [dictionary objectForKey:@"html_url"] : @" ";
        _lastPushed = [dictionary objectForKey:@"pushed_at"] ? [dictionary objectForKey:@"pushed_at"]: @" ";
        
        NSDictionary *owner = [dictionary objectForKey:@"owner"] ? [dictionary objectForKey:@"owner"]: @"";
        
        if (owner) {
            _ownerLogin = [owner objectForKey:@"login"] ? [owner objectForKey:@"login"]: @" ";
            _owner_id = [owner objectForKey:@"id"] ? [owner objectForKey:@"id"]: @" ";
            _avatar_urlPath = [owner objectForKey:@"avatar_url"] ? [owner objectForKey:@"avatar_url"]: @" ";
            _ownerhtml_url = [owner objectForKey:@"html_url"] ? [owner objectForKey:@"html_url"]: @" ";
        }
    }
    
    
    return self;
}

-(id)initRepoWithUserDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        _ownerLogin = [dictionary objectForKey:@"login"] ? [dictionary objectForKey:@"login"]: @" ";
        _avatar_urlPath = [dictionary objectForKey:@"avatar_url"] ? [dictionary objectForKey:@"avatar_url"]: @" ";
        _html_url   = [dictionary objectForKey:@"html_url"] ? [dictionary objectForKey:@"html_url"] : @" ";
        _owner_id = [dictionary objectForKey:@"id"] ? [dictionary objectForKey:@"id"]: @" ";
    
    }
    return self;
}


-(NSURL *)avatarURL
{
    return [NSURL URLWithString:_avatar_urlPath];
}

-(void)cancelAvatarDownload
{
    if (!_imageDownloadOp.isExecuting) {
        [_imageDownloadOp cancel];
    }
}

-(void)downloadAvatarOnQueue:(NSOperationQueue *)queue WithCompletionBlock:(void(^)())completion
{
    _imageDownloadOp = [NSBlockOperation  blockOperationWithBlock:^{
        NSData *imageData = [NSData dataWithContentsOfURL:self.avatarURL];
        
        _avatarImage = [UIImage imageWithData:imageData];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:completion];
    }];
    
    [queue addOperation:self.imageDownloadOp];
}

-(void)downloadAvatarWithCompletionBlock:(void(^)())completion
{
    [self downloadAvatarOnQueue:[NSOperationQueue new] WithCompletionBlock:completion];
}

@end
