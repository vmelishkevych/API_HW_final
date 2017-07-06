//
//  VMTableViewController.h
//  API_HW_Pupil01
//
//  Created by Torris on 6/20/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSInteger personsInRequest = 20;

@interface VMTableViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray* personsArray;
@property (strong,nonatomic) NSNumber* userID;

- (void) getPersonsFromServerWithUserId:(NSNumber*) userID;

- (void)configureCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath;

@end
