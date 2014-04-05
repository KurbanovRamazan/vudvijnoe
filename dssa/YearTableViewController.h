//
//  YearTableViewController.h
//  dssa
//
//  Created by Muaviya on 03.04.14.
//  Copyright (c) 2014 1. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YearTableViewController : UITableViewController<NSXMLParserDelegate ,UIAlertViewDelegate, UISearchBarDelegate , UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *MyTableView;

@property (strong, nonatomic) NSArray *arrayAsIzdania;
@property (strong, nonatomic) NSArray *urlXmlArray;
@property (strong, nonatomic) NSMutableArray *mutableArrayIzdaniaName;
@property (strong, nonatomic) NSMutableArray *mutableArrayIzdaniaDate;
@property (strong, nonatomic) NSMutableArray *mutableArrayIzdaniaKyrs;
@property (strong, nonatomic) NSMutableArray *mutableArrayIzdaniaURL;
@property (strong, nonatomic) NSMutableArray *mutableArrayFakylteti;
@property (strong, nonatomic) NSMutableArray *mutableArrayAvtori;
@property (strong, nonatomic) NSMutableArray *mutableArrayPredmeti;
@property (strong, nonatomic) NSMutableArray *mutableArraySpecialnosti;


@end
