//
//  KursTableViewController.m
//  dssa
//
//  Created by Muaviya on 02.04.14.
//  Copyright (c) 2014 1. All rights reserved.
//

#import "KursTableViewController.h"
#import "TableViewControllerFacultet.h"
#import "TableViewController.h"
#import "ViewController.h"
#import <Foundation/Foundation.h>
@interface KursTableViewController ()

@end

@implementation KursTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mutableArrayIzdaniaKyrs = [[NSMutableArray alloc] init];
    
    [self.MyTableView delegate];
    [self.MyTableView dataSource];
    
    self.mutableArrayIzdaniaKyrs = [Singleton sharedSingleton].mutableKursSinglton;
    self.title = @"Курс";
    
}
- (void)applicationWillTerminate:(UIApplication *)application
{
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.tableView reloadData];
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.mutableArrayIzdaniaKyrs count];
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DocCell";
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                                   reuseIdentifier:CellIdentifier];
    cell.detailTextLabel.text = self.mutableArrayIzdaniaKyrs[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" indexPath = %@",indexPath);
}


@end



