//
//  VMPerson.h
//  API_HW_Pupil01
//
//  Created by Torris on 6/30/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMPerson : NSObject


@property (strong,nonatomic) NSString* firstName;
@property (strong,nonatomic) NSString* lastName;
@property (assign,nonatomic) NSNumber* userID;

@property (strong,nonatomic) NSURL* imageURL;


- (instancetype)initWithServerResponse:(NSDictionary*) responseObject;



@end
