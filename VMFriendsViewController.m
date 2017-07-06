//
//  VMFriendsViewController.m
//  API_HW_Pupil01
//
//  Created by Torris on 7/2/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "VMFriendsViewController.h"
#import "VMServerManager.h"

#import "VMFriend.h"

@interface VMFriendsViewController ()


@end


@implementation VMFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Friends";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    
    [super configureCell:cell withIndexPath:indexPath];
    
}


#pragma mark - Help Methods


#pragma mark - API

- (void) getPersonsFromServerWithUserId:(NSNumber *)userID {
    
    __weak VMFriendsViewController* weakSelf = self;
    
    [[VMServerManager sharedManager]
     getFriendsFromServerWithUserId:userID
     offset:[self.personsArray count]
     count:personsInRequest
     onSuccess:^(NSArray *friends) {
         
         [weakSelf.personsArray addObjectsFromArray:friends];
         
         NSMutableArray* paths = [NSMutableArray array];
         
         for (int i = (int)weakSelf.personsArray.count - (int)friends.count; i < weakSelf.personsArray.count; i++) {
             
             [paths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }
         
         
         [weakSelf.tableView beginUpdates];
         
         [weakSelf.tableView insertRowsAtIndexPaths:paths
                                   withRowAnimation:UITableViewRowAnimationTop];
         
         [weakSelf.tableView endUpdates];
         
     }
     
     onError:^(NSError *error, NSInteger code) {
         
         NSLog(@"Error: %@, code: %ld", [error localizedDescription], code);
         
     }];
    
}


@end
