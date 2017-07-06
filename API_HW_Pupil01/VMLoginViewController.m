//
//  VMLoginViewController.m
//  API_HW_Pupil01
//
//  Created by Torris on 6/26/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "VMLoginViewController.h"
#import "VMToken.h"
#import "VMServerManager.h"

@interface VMLoginViewController () <UIWebViewDelegate>

@property (copy, nonatomic) void(^initBlock)(VMToken* token);
@property (weak,nonatomic) UIWebView* webView;

@end



@implementation VMLoginViewController


- (instancetype)initWithBlock:(void(^)(VMToken* token)) initBlock
{
    self = [super init];
    if (self) {
        
        self.initBlock = initBlock;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Login";
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(actionCancel:)];
    
    self.navigationItem.rightBarButtonItem = item;
    
    
    CGRect rect = self.view.bounds;
    
    rect.origin = CGPointZero;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:rect];
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    [self.view addSubview:webView];
    
    self.webView = webView;
    
    self.webView.delegate = self;
    
    
    
    NSString* urlString = @"https://oauth.vk.com/authorize?"
                            "client_id=6085263&"
                            "display=mobile&"
                            "redirect_uri=https://oauth.vk.com/blank.html&"
                            "scope=139286&" // + 2 + 4 + 16 + 131072 + 8192
                            "response_type=token&"
                            "v=5.65&"
                            "state=123456&"
                            "revoke=1";
    
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    
    self.webView.delegate = nil;
    
}



#pragma mark - Actions



- (void) actionCancel:(UIBarButtonItem*) sender {
    
    
    if (self.initBlock) {
        
        self.initBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
};


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString* urlString = [request.URL absoluteString];
    
    if ([urlString hasPrefix:@"https://oauth.vk.com/blank.html#access_token="]) {
        
        VMToken* token = [[VMToken alloc] init];
        
        NSArray* fragments = [urlString componentsSeparatedByString:@"#"];
        
        
        NSString* fragment = [fragments lastObject];
        
        NSArray* pairs = [fragment componentsSeparatedByString:@"&"];
        
        
        
        for (NSString* pair in pairs) {
            
            NSArray* values = [pair componentsSeparatedByString:@"="];
            
            if (values.count == 2) {
                
                NSString* key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    
                    token.tokenString = [values lastObject];
                    
                } else if ([key isEqualToString:@"expires_in"]) {
                    
                    NSString* intervalString = [values lastObject];
                    
                    NSTimeInterval interval = [intervalString doubleValue];
                    
                    NSDate* expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                    
                    token.expirationDate = expirationDate;
                    
                } else if ([key isEqualToString:@"user_id"]) {
                    
                    NSInteger userIdInt = [[values lastObject] intValue];
                    
                    NSNumber* userIdVal = [NSNumber numberWithInteger:userIdInt];

                    token.userID = userIdVal;
                }
            }
        }
        
        
        self.webView.delegate = nil;
        
        if (self.initBlock) {
            
            self.initBlock(token);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return NO;
        
    }
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {

    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
