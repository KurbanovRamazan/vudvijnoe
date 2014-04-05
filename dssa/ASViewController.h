//
//  ASViewController.h
//  Parser
//
//  Created by 1 on 11.02.14.
//  Copyright (c) 2014 1. All rights reserved.
//

#define DOCUMENTS NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,NSCachesDirectory)


#import <UIKit/UIKit.h>
#import "TBXML.h"
#import "ZipArchive.h"
#import "zip.h"
#import "unzip.h"

@interface ASViewController : UIViewController <NSXMLParserDelegate>
@property (strong, nonatomic) NSMutableArray *rssNews;
@property (strong, nonatomic) NSMutableArray * numbers;
@property (strong, nonatomic) NSString *path;

-(void)loadRecords:(NSString *)records;
-(void)traverseElement:(TBXMLElement *)element;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
