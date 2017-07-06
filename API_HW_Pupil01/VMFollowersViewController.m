//
//  VMFollowersViewController.m
//  API_HW_Pupil01
//
//  Created by Torris on 7/2/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "VMFollowersViewController.h"
#import "VMServerManager.h"

#import "VMFollower.h"

@interface VMFollowersViewController ()

@end

@implementation VMFollowersViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Followers";
    
    
    
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
    
    __weak VMFollowersViewController* weakSelf = self;
    
    [[VMServerManager sharedManager]
     getFollowersFromServerWithUserId:userID
     offset:[self.personsArray count]
     count:personsInRequest
     onSuccess:^(NSArray *followers) {
         
         [weakSelf.personsArray addObjectsFromArray:followers];
         
         NSMutableArray* paths = [NSMutableArray array];
         
         for (int i = (int)weakSelf.personsArray.count - (int)followers.count; i < weakSelf.personsArray.count; i++) {
             
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
