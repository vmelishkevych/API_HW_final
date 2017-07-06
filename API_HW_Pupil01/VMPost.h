//
//  VMPost.h
//  API_HW_Pupil01
//
//  Created by Torris on 7/5/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMPost : NSObject

@property (strong, nonatomic) NSString* text;


- (instancetype)initWithServerResponse:(NSDictionary*) responseObject;


@end
