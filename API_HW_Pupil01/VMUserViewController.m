//
//  VMUserViewController.m
//  API_HW_Pupil01
//
//  Created by Torris on 6/18/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "VMUserViewController.h"
#import "VMUser.h"
#import "VMServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "VMPostCell.h"
#import "VMPost.h"

#import "VMFriendsViewController.h"
#import "VMFollowersViewController.h"
#import "VMSubscriptionsViewController.h"



@interface VMUserViewController ()

@property (strong,nonatomic) NSMutableArray* postsArray;

@property (assign, nonatomic) BOOL firstAppearance;
@property (strong,nonatomic) VMUser* user;

@end

@implementation VMUserViewController

static NSInteger postsInRequest = 20;

static NSString* cityKeyName = @"city";
static NSString* countryKeyName = @"country";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"User";
    
    
    if (self.navigationController.viewControllers.count > 1) {
        
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"back to own page"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(actionBackToRoot:)];
        
        [self.navigationItem setRightBarButtonItem:item animated:YES];
    }
    

    
    
    self.postsArray = [NSMutableArray array];
    
    
    if (self.userID) {
        
        [self getUserFromServerWithUserId:self.userID];
        
        [self getPostsFromServerWithUserId:self.userID];
        
        self.firstAppearance = NO;
        
    } else {
        
        self.firstAppearance = YES;
    }
    
    
    
    
}


- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    if (self.firstAppearance) {
   
        self.firstAppearance = NO;
        
        [self authorizeUser];

    }
        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [self.user removeObserver:self
                   forKeyPath:cityKeyName
                      context:nil];

    [self.user removeObserver:self
                   forKeyPath:countryKeyName
                      context:nil];

    
    
}

#pragma mark - KVO

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:cityKeyName]) {
        
        
        [self refreshInfo];
    }

    if ([keyPath isEqualToString:countryKeyName]) {
        
        [self refreshInfo];
    }

    
    
    
}



#pragma mark - API

- (void) getImageFromServer {
    
    [self.userImage setImageWithURL:self.user.imageURL];
    
    
}


-(void) authorizeUser {
    
    __weak VMUserViewController* weakSelf = self;
    
    [[VMServerManager sharedManager]
     authorizeUser:^(NSNumber *userID) {
         
         weakSelf.userID = userID;
         
         if (weakSelf.userID) {
             
             [weakSelf getUserFromServerWithUserId:weakSelf.userID];
             
             [weakSelf getPostsFromServerWithUserId:weakSelf.userID];
         }
         
         
    }];

    
}


- (void) getUserFromServerWithUserId:(NSNumber*) userID {
    
    __weak VMUserViewController* weakSelf = self;
    
    [[VMServerManager sharedManager] getUserFromServerWithId:userID
                                                   onSuccess:^(VMUser *user) {
                                                       
                                                       weakSelf.user = user;
                                                       
                                                       
                                                       
                                                       [weakSelf.user addObserver:weakSelf forKeyPath:cityKeyName
                                                                      options:NSKeyValueObservingOptionNew
                                                                      context:nil];

                                                       [weakSelf.user addObserver:weakSelf forKeyPath:countryKeyName
                                                                          options:NSKeyValueObservingOptionNew
                                                                          context:nil];

                                                       [weakSelf getImageFromServer];
                                                       
                                                       [weakSelf refreshInfo];
                                                       
                                                       
                                                       
                                                   }
                                                     onError:^(NSError *error, NSInteger statusCode) {
                                                         
                                                         
                                                         NSLog(@"error: %@, status code: %ld", [error localizedDescription], statusCode);
                                                         
                                                     }];
    
    
    
}


- (void) getPostsFromServerWithUserId:(NSNumber*) userID {
    
    __weak VMUserViewController* weakSelf = self;
    
    [[VMServerManager sharedManager]
     getUserWall:userID
     withOffset:[self.postsArray count]
     count:postsInRequest
     onSuccess:^(NSArray *posts) {
         
         [weakSelf.postsArray addObjectsFromArray:posts];
         
         NSMutableArray* newPaths = [NSMutableArray array];
         
         for (int i = (int)[weakSelf.postsArray count] - (int)[posts count]; i < [weakSelf.postsArray count]; i++) {
             
             [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }
         
         
         [self.tableView beginUpdates];
         
         [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
         
         [self.tableView endUpdates];
         
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
     }];
    
}






#pragma mark - Help methods


- (void) refreshInfo {
    
    self.firstNameLabel.text = self.user.firstName;
    self.lastNameLabel.text = self.user.lastName;
    self.dateOfBirthLabel.text = self.user.bdate;
    self.genderLabel.text = self.user.gender;
    self.cityLabel.text = self.user.city;
    self.countryLabel.text = self.user.country;
    
    [self.tableView reloadData];
 
    
}

#pragma mark - Actions

- (void) actionBackToRoot:(UIBarButtonItem*) sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}



#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Segue_Followers"]) {
        
        VMFollowersViewController* vc = segue.destinationViewController;
        
        vc.userID  = self.user.userID;
        
    }
    
    if ([segue.identifier isEqualToString:@"Segue_Friends"]) {
        
        VMFriendsViewController* vc = segue.destinationViewController;
        
        vc.userID  = self.user.userID;
        
    }

    
    
    
    if ([segue.identifier isEqualToString:@"Segue_Subscriptions"]) {
        
        VMSubscriptionsViewController* vc = segue.destinationViewController;
        
       vc.userID  = self.user.userID;
        

    }


}


#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return @"Wall";
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return  [self.postsArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == [self.postsArray count]) {
        
        static NSString* identifier = @"Cell";
        
        UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.textLabel.text = @"LOAD MORE POSTS";
        cell.imageView.image = nil;
        
        return cell;
        
    } else {
        
        static NSString* identifier = @"PostCell";
        
        VMPostCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
        
        VMPost* post = [self.postsArray objectAtIndex:indexPath.row];
        
        cell.postTextLabel.text = post.text;
        
        return cell;
        
    }
    
    return nil;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.postsArray count]) {
        
        return 44.f;
        
        
    } else {
        
        VMPost* post = [self.postsArray objectAtIndex:indexPath.row];
        
        return [VMPostCell heightForText:post.text];
        
        
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return (indexPath.row == [self.postsArray count]) ? YES : NO;
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.postsArray count]) {
        
        [self getPostsFromServerWithUserId:self.userID];
        
    }
    
}







@end
