//
//  VMCommunity.h
//  API_HW_Pupil01
//
//  Created by Torris on 6/20/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMCommunity : NSObject

@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSString* type;
@property (strong,nonatomic) NSURL* imageURL;

@property (assign,nonatomic) NSNumber* groupId;

- (instancetype)initWithServerResponse:(NSDictionary*) responseObject;



@end
