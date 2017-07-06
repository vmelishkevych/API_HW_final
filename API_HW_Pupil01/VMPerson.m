//
//  VMPerson.m
//  API_HW_Pupil01
//
//  Created by Torris on 6/30/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "VMPerson.h"

@implementation VMPerson

- (instancetype)initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        self.userID = [responseObject objectForKey:@"uid"];
        
        [self assignPhotoFromResponse:responseObject];
    }
    
    return self;
}

- (void) assignPhotoFromResponse:(NSDictionary*) responseObject {
    
    NSString* imageURLString = [responseObject objectForKey:@"photo_50"];
    
    self.imageURL = [NSURL URLWithString:imageURLString];

    
}


@end
