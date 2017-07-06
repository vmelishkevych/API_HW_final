//
//  VMLoginViewController.h
//  API_HW_Pupil01
//
//  Created by Torris on 6/26/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VMToken;



@interface VMLoginViewController : UIViewController

- (instancetype)initWithBlock:(void(^)(VMToken* token)) initBlock;


@end
