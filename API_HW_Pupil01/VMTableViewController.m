//
//  VMTableViewController.m
//  API_HW_Pupil01
//
//  Created by Torris on 6/20/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "VMTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "VMUserViewController.h"

#import "VMPerson.h"

@interface VMTableViewController ()

@end



@implementation VMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
    if (self.navigationController.viewControllers.count > 1) {
        
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"back to own page"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(actionBackToRoot:)];
        
        [self.navigationItem setRightBarButtonItem:item animated:YES];
    }

    
    
    self.personsArray = [NSMutableArray array];
    
    [self getPersonsFromServerWithUserId:self.userID];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API


- (void) getPersonsFromServerWithUserId:(NSNumber*) userID {
   
    
}

#pragma mark - Actions

- (void) actionBackToRoot:(UIBarButtonItem*) sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}




#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.personsArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    
    if (indexPath.row ==self.personsArray.count) {
        
        cell.textLabel.text = @"MORE USERS";
        cell.imageView.image = nil;
        
    } else {
       
        [self configureCell:cell withIndexPath:indexPath];
        
    }
    
    
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    
    VMPerson* person = [self.personsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName];
    
    cell.imageView.image = nil;
    
    __weak UITableViewCell* weakCell = cell;
    
    NSURLRequest* imageRequest = [NSURLRequest requestWithURL:person.imageURL];
    
    [cell.imageView setImageWithURLRequest:imageRequest
                          placeholderImage:nil
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                       
                                       weakCell.imageView.image = image;
                                       
                                       [weakCell layoutSubviews];
                                   }
     
                                   failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                       
                                   }];
}





#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.personsArray.count) {
        
        [self getPersonsFromServerWithUserId:self.userID];
        
    } else {
        
        VMUserViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VMUserViewController"];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        VMPerson* person = [self.personsArray objectAtIndex:indexPath.row];
        
        vc.userID = person.userID;
        
    }
    
    
}


@end
