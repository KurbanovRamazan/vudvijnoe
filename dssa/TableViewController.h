//
//  TableViewController.h
//  dssa
//
//  Created by 1 on 30.11.13.
//  Copyright (c) 2013 1. All rights reserved.
//

#define DOCUMENTS NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,NSCachesDirectory)

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "TBXML.h"
#import "ZipArchive.h"
#import "ASIzdania.h"
#import "ASAvtori.h"
#import "ASFakylteti.h"
#import "ASPredmeti.h"
#import "ASSpecialnosti.h"


@interface TableViewController : UITableViewController <NSXMLParserDelegate ,UIAlertViewDelegate, UISearchBarDelegate , UITableViewDataSource, UITableViewDelegate> {
    
    ASIzdania *asIzdania;
    ASAvtori *asAvtori;
    ASFakylteti *asFakylteti;
    ASPredmeti *asPredmeti;
    ASSpecialnosti *asSpecialnosti;
}


@property (strong, nonatomic) NSString *path;

-(void)loadRecords:(NSString *)records;
-(void)traverseElement:(TBXMLElement *)element;

- (IBAction)updateButton:(id)sender;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (readonly, strong, nonatomic) NSArray *asIzdaniaArray ;
@property (readonly, strong, nonatomic) NSArray *asAvtoriArray;
@property (readonly, strong, nonatomic) NSArray *asFakyltetiArray;
@property (readonly, strong, nonatomic) NSArray *asPredmetiArray;
@property (readonly, strong, nonatomic) NSArray *asSpecialnostiArray;



- (IBAction)menuButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *MyTableView;
@property (strong, nonatomic) IBOutlet UIAlertView *MyAlertView;

@property NSInteger indexSelect;

@property (strong, nonatomic) NSArray *arrayAsIzdania;
@property (strong, nonatomic) NSArray *ulrXmlArray;
@property (strong, nonatomic) NSMutableArray *mutableArrayIzdaniaName;
@property (strong, nonatomic) NSMutableArray *mutableArrayIzdaniaId;
@property (strong, nonatomic) NSMutableArray *mutableArrayIzdaniaDate;
@property (strong, nonatomic) NSMutableArray *mutableArrayIzdaniaKyrs;
@property (strong, nonatomic) NSMutableArray *mutableArrayIzdaniaURL;
@property (strong, nonatomic) NSMutableArray *mutableArrayFakylteti;
@property (strong, nonatomic) NSMutableArray *mutableArrayAvtori;
@property (strong, nonatomic) NSMutableArray *mutableArrayPredmeti;
@property (strong, nonatomic) NSMutableArray *mutableArraySpecialnosti;

@property (strong, nonatomic) NSString *urlStringIzdania;
@property (strong, nonatomic) NSMutableArray  *arrayWithURL;
@property (strong, nonatomic) NSMutableDictionary  *dictionaryWithURL;
- (IBAction)menuButtonTapped:(id)sender;
@end
