//
//  TableViewController.m
//  dssa
//
//  Created by 1 on 30.11.13.
//  Copyright (c) 2013 1. All rights reserved.
//

#import "TableViewControllerFacultet.h"
#import "TableViewController.h"
#import "ViewController.h"
#import <Foundation/Foundation.h>
#import "SubMainTableViewController.h"

@interface TableViewControllerFacultet ()
    @property NSInteger indexSelect;
@end


@implementation TableViewControllerFacultet
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mutableArrayFakylteti = [[NSMutableArray alloc] init];

    [self.MyTableView delegate];
    [self.MyTableView dataSource];
    
    self.mutableArrayFakylteti = [Singleton sharedSingleton].mutableFacultetSinglton;
    self.title = @"Факультеты";
    
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
    
    return [self.mutableArrayFakylteti count];

}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DocCell";
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                                   reuseIdentifier:CellIdentifier];
    cell.detailTextLabel.text = self.mutableArrayFakylteti[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" indexPath = %@",indexPath);
    self.indexSelect = indexPath.row;
    SubMainTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DestinationController2"];
    controller.mutableArrayFakylteti= self.mutableArrayFakylteti  ;
 // controller.indexSelect = self.indexSelect;
    
    [self.navigationController pushViewController:controller animated:YES];
}


@end



