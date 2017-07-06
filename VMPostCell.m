//
//  VMPostCell.m
//  API_HW_Pupil01
//
//  Created by Torris on 7/5/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "VMPostCell.h"

@implementation VMPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat) heightForText:(NSString*) text {
    
    CGFloat offset = 5.f;
    
    UIFont* font = [UIFont systemFontOfSize:17.f];
    
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName,nil];
    
    UIView* mainView = [[UIApplication sharedApplication] keyWindow];
    
    CGFloat mainViewWidth = CGRectGetWidth(mainView.bounds);
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(mainViewWidth - 2 * offset, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    return CGRectGetHeight(rect) + 2 * offset;
    
}






@end
