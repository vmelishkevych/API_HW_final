//
//  VMToken.h
//  API_HW_Pupil01
//
//  Created by Torris on 6/26/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VMToken : NSObject

@property (strong, nonatomic) NSString* tokenString;
@property (strong, nonatomic) NSDate* expirationDate;
@property (strong, nonatomic) NSNumber* userID;


@end
