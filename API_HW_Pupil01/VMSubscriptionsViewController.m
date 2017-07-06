//
//  VMSubscriptionsViewController.m
//  API_HW_Pupil01
//
//  Created by Torris on 6/20/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "VMSubscriptionsViewController.h"
#import "VMServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "VMUserViewController.h"

#import "VMCommunity.h"
#import "VMSubscriptor.h"
#import "VMSubscriptionsGroup.h"

@interface VMSubscriptionsViewController ()

@property (strong,nonatomic) NSArray* subscriptionsArray;

@end




@implementation VMSubscriptionsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Subscriptions";
    
    
    if (self.navigationController.viewControllers.count > 1) {
        
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"back to own page"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(actionBackToRoot:)];
        
        [self.navigationItem setRightBarButtonItem:item animated:YES];
    }
    

    
    
    
    self.subscriptionsArray = [NSArray array];
    
    [self getSubscriptionsFromServerWithUserId:self.userID];
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Help Methods


#pragma mark - API


- (void) getSubscriptionsFromServerWithUserId:(NSNumber *)userID {
    
    __weak VMSubscriptionsViewController* weakSelf = self;
    
    [[VMServerManager sharedManager]
     getSubscriptionsFromServerWithUserId:userID
     onSuccess:^(NSArray *subscriptions) {
         
         weakSelf.subscriptionsArray = subscriptions;
         
         [weakSelf.tableView reloadData];
         
     }
     
     onError:^(NSError *error, NSInteger code) {
         
         NSLog(@"Error: %@, code: %ld", [error localizedDescription], code);
         
     }];
    
}

#pragma mark - Actions

- (void) actionBackToRoot:(UIBarButtonItem*) sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}





#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.subscriptionsArray.count;
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    VMSubscriptionsGroup* group = [self.subscriptionsArray objectAtIndex:section];
    
    return group.subscriptionsName;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    VMSubscriptionsGroup* group = [self.subscriptionsArray objectAtIndex:section];
    
    return group.subscriptionsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    
    VMSubscriptionsGroup* group = [self.subscriptionsArray objectAtIndex:indexPath.section];
    
    if (indexPath.section == 0) {
        
        
        VMCommunity* community = [group.subscriptionsArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = community.name;
        cell.detailTextLabel.text = community.type;
        cell.imageView.image = nil;
        
        
        __weak UITableViewCell* weakCell = cell;
        
        NSURLRequest* imageRequest = [NSURLRequest requestWithURL:community.imageURL];
        
        [cell.imageView setImageWithURLRequest:imageRequest
                              placeholderImage:nil
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           
                                           weakCell.imageView.image = image;
                                           
                                           [weakCell layoutSubviews];
                                       }
         
                                       failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                           
                                       }];
        

        
        
    } else {
        
        VMSubscriptor* subscriptor = [group.subscriptionsArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", subscriptor.firstName, subscriptor.lastName];
        
        cell.imageView.image = nil;
        
        __weak UITableViewCell* weakCell = cell;
        
        NSURLRequest* imageRequest = [NSURLRequest requestWithURL:subscriptor.imageURL];
        
        [cell.imageView setImageWithURLRequest:imageRequest
                              placeholderImage:nil
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           
                                           weakCell.imageView.image = image;
                                           
                                           [weakCell layoutSubviews];
                                       }
         
                                       failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                           
                                       }];
        
        
    }
    
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return (indexPath.section == 0) ? NO : YES;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {

        VMUserViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VMUserViewController"];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
        VMSubscriptionsGroup* group = [self.subscriptionsArray objectAtIndex:indexPath.section];
        
        VMSubscriptor* subscriptor = [group.subscriptionsArray objectAtIndex:indexPath.row];
        
        vc.userID = subscriptor.userID;
        
    }
    
    
}

@end
