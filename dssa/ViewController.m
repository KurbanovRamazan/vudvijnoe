    //
//  ViewController.m
//  dssa
//
//  Created by 1 on 30.11.13.
//  Copyright (c) 2013 1. All rights reserved.
//
#define DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()


@end

@implementation ViewController
@synthesize dishsUrl;
@synthesize indexSelect;
@synthesize urlcik;
@dynamic number;
@synthesize delegate;
@synthesize i;
@synthesize urlString;
@synthesize xmlArray;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self loadPdf];
    
}
/*
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
}

-(UIPageViewControllerSpineLocation) pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    return UIPageViewControllerSpineLocationMin;
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    return self.myWebView;
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    return self.myWebView;
}
 */

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)myProgressTask {
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        HUD.progress = progress;
        usleep(50000);
    }
}




-(void)loadPdf {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Set determinate mode
	HUD.mode = MBProgressHUDModeDeterminate;
	
	HUD.delegate = self;
	// myProgressTask uses the HUD instance to update progress
	[HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];

    
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"ждите . . .";
    HUD.detailsLabelText = @"идет загрузка УМК";
    HUD.dimBackground = YES;

	// Set determinate mode
	
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSString *validURLString = urlString.cleanString;
        NSString *filePath = [DOCUMENTS stringByAppendingPathComponent:validURLString.lastPathComponent];
        NSData *pdfData = [NSData dataWithContentsOfFile:filePath];
        if (!pdfData) {
            pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:validURLString]];
            [pdfData writeToFile:filePath atomically:NO];
        }
        
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:fileURL]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HUD hide:YES];
            
    });
        
    });
    
    
//    urlString = [urlString substringToIndex:[urlString length] - 3];
//    
//    NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: urlString]];
//    
//    //Store the Data locally as PDF File
//    
//    NSString *resourceDocPath = [[NSString alloc] initWithString:[[[[NSBundle mainBundle]  resourcePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Documents"]];
//    
//    NSString *filePath = [resourceDocPath stringByAppendingPathComponent:@"myPDF.pdf"];
//    
//    [pdfData writeToFile:filePath atomically:YES];
//    
//    //Now create Request for the file that was saved in your documents folder
//    
//    NSURL *url = [NSURL fileURLWithPath:filePath];
//    
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//    
//    [myWebView setUserInteractionEnabled:YES];
//    
//    [myWebView setDelegate:self];
//
//    [myWebView loadRequest:requestObj];
//
    
}


@end
