//
//  VMCommunity.m
//  API_HW_Pupil01
//
//  Created by Torris on 6/20/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "VMCommunity.h"

@implementation VMCommunity


- (instancetype)initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        self.name = [responseObject objectForKey:@"name"];
        self.type = [responseObject objectForKey:@"type"];
        
        NSString* imageURLString = [responseObject objectForKey:@"photo_50"];
        self.imageURL = [NSURL URLWithString:imageURLString];
        
        self.groupId = [responseObject objectForKey:@"gid"];
        
        
    }
    return self;
}





@end
