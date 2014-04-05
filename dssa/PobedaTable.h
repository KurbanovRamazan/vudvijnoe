//
//  PobedaTable.h
//  dssa
//
//  Created by 1 on 29.01.14.
//  Copyright (c) 2014 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PobedaTable : UITableViewController <NSXMLParserDelegate , UIAlertViewDelegate , UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *dishsArray;
@property (nonatomic, retain) NSArray *ulrXmlArray;
@property (nonatomic, retain) NSString *stringArray;

@property (nonatomic, retain) NSString * currentElementString;
@property (nonatomic, retain) NSMutableString *descriptionMutableString;
@property (nonatomic, retain) NSMutableDictionary *currentDicMuatableDictionary;

@property (strong, nonatomic) IBOutlet UITableView *MyTableView;
@property (strong, nonatomic) IBOutlet UIAlertView *MyAlertView;

@property NSInteger indexSelect;


@property (nonatomic, retain) NSMutableDictionary *facDictionary;
@property (nonatomic, retain) NSMutableString *facDescription;
@property (nonatomic, retain) NSString * currentElementFac;


@property (nonatomic, retain) NSMutableArray *dishs;
@property (nonatomic, retain) NSMutableArray *facArray;
@property (nonatomic, retain) NSString * currentElement;
@property (nonatomic, retain) NSMutableString *description;
@property (nonatomic, retain) NSMutableDictionary *currentDic;

@property (nonatomic, retain) NSMutableArray *dishsUrl;
@property (nonatomic, retain) NSString * currentElementUrl;
@property (nonatomic, retain) NSMutableString *descriptionUrl;
@property (nonatomic, retain) NSMutableDictionary *currentDicUrl;


@end
