//
//  SpecialnostTableViewController.m
//  dssa
//
//  Created by Muaviya on 02.04.14.
//  Copyright (c) 2014 1. All rights reserved.
//

#import "SpecialnostTableViewController.h"
#import "TableViewControllerFacultet.h"
#import "TableViewController.h"
#import "ViewController.h"
#import <Foundation/Foundation.h>
@interface SpecialnostTableViewController ()

@end

@implementation SpecialnostTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mutableArraySpecialnosti = [[NSMutableArray alloc] init];
    
    [self.MyTableView delegate];
    [self.MyTableView dataSource];
    
    self.mutableArraySpecialnosti = [Singleton sharedSingleton].mutableSpecialnostSinglton;
    self.title = @"Специальность";
    
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
    
    return [self.mutableArraySpecialnosti count];
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DocCell";
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                                   reuseIdentifier:CellIdentifier];
    cell.textLabel.textColor =  [UIColor blackColor] ;
    cell.textLabel.text = self.mutableArraySpecialnosti[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" indexPath = %@",indexPath);
}


@end



