//
//  YYGHUser.m
//  iOS-Startup-Optimize-Demo
//
//  Created by keke on 2018/8/28.
//  Copyright © 2018年 kekeyezi. All rights reserved.
//

#import "YYGHUser.h"
#import "YYModel.h"

@implementation YYGHUser
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"userID" : @"id",
             @"avatarURL" : @"avatar_url",
             @"gravatarID" : @"gravatar_id",
             @"htmlURL" : @"html_url",
             @"followersURL" : @"followers_url",
             @"followingURL" : @"following_url",
             @"gistsURL" : @"gists_url",
             @"starredURL" : @"starred_url",
             @"subscriptionsURL" : @"subscriptions_url",
             @"organizationsURL" : @"organizations_url",
             @"reposURL" : @"repos_url",
             @"eventsURL" : @"events_url",
             @"receivedEventsURL" : @"received_events_url",
             @"siteAdmin" : @"site_admin",
             @"publicRepos" : @"public_repos",
             @"publicGists" : @"public_gists",
             @"createdAt" : @"created_at",
             @"updatedAt" : @"updated_at",
             };
}
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; }
@end
