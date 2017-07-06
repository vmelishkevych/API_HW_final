//
//  VMPost.m
//  API_HW_Pupil01
//
//  Created by Torris on 7/5/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "VMPost.h"

@implementation VMPost


- (id) initWithServerResponse:(NSDictionary*) responseObject

{
    self = [super init];
    if (self) {
        
        self.text = [responseObject objectForKey:@"text"];
        
        self.text = [self.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];

    }
    
    return self;
}


@end
