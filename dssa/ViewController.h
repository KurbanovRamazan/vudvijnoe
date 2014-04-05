//
//  ViewController.h
//  dssa
//
//  Created by 1 on 30.11.13.
//  Copyright (c) 2013 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ViewController : UIViewController <MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) IBOutlet UIWebView *myWebView;

@property (nonatomic, retain) NSMutableArray *dishsUrl;
@property (nonatomic) NSInteger indexSelect;

@property (nonatomic) NSArray *urlcik;
@property (nonatomic) NSArray *number;
@property (nonatomic) NSArray *urlArray;
@property (nonatomic) NSArray *xmlArray;

-(void) loadPdf;

-(void) myProgressTask;

@property (nonatomic) NSString *urlString;
@property (nonatomic, weak) id delegate;
@property int i;
@end
