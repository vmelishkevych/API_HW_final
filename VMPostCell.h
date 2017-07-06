//
//  VMPostCell.h
//  API_HW_Pupil01
//
//  Created by Torris on 7/5/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VMPostCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel* postTextLabel;

+ (CGFloat) heightForText:(NSString*) text;


@end
