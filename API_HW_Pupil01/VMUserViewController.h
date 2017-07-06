//
//  VMUserViewController.h
//  API_HW_Pupil01
//
//  Created by Torris on 6/18/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString* const VMApiMethodNameGetFriends;
extern NSString* const VMApiMethodNameGetFollowers;


@interface VMUserViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (assign,nonatomic) NSNumber* userID;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateOfBirthLabel;


@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UILabel *countryLabel;




@end
