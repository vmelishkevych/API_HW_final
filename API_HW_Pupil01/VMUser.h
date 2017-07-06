//
//  VMUser.h
//  API_HW_Pupil01
//
//  Created by Torris on 6/16/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VMPerson.h"


@interface VMUser : VMPerson

@property (strong,nonatomic) NSString* gender;
@property (strong,nonatomic) NSString* bdate;
@property (strong,nonatomic) NSString* country;
@property (strong,nonatomic) NSString* city;

- (instancetype)initWithServerResponse:(NSDictionary*) responseObject;

@end
