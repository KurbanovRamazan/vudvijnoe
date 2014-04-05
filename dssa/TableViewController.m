//
//  TableViewController.m
//  dssa
//
//  Created by 1 on 30.11.13.
//  Copyright (c) 2013 1. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewControllerFacultet.h"
#import "DocCell.h"
#import "ViewController.h"
#import "TBXML.h"
#import "TBXML+HTTP.h"
#import "AFXMLRequestOperation.h"
#import "AFNetworking.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ASIzdania.h"
#import "ASAvtori.h"
#import "ASPredmeti.h"
#import "ASFakylteti.h"
#import "ASSpecialnosti.h"
#import "ASObject.h"
#import "UIViewController+ECSlidingViewController.h"
#import "METransitions.h"


@interface TableViewController () {
    ASIzdania *izdania1 ;
    ASFakylteti* fakylteti1;
    ASAvtori* avtor1;
    ASSpecialnosti* specialnist;
    ASPredmeti* predmet;
}
@property (strong, nonatomic) NSEntityDescription *izdania;
@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;


@end


@implementation TableViewController
@synthesize indexSelect;
//
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize path, mutableArrayIzdaniaKyrs, mutableArrayIzdaniaURL;
@synthesize mutableArrayIzdaniaName,mutableArrayIzdaniaDate, mutableArrayAvtori, mutableArrayFakylteti, mutableArrayPredmeti, mutableArraySpecialnosti, mutableArrayIzdaniaId;
@synthesize izdania, urlStringIzdania, arrayWithURL, dictionaryWithURL;
//
@synthesize asIzdaniaArray,asAvtoriArray, asFakyltetiArray, asPredmetiArray, asSpecialnostiArray;

- (void)viewDidLoad
{
    mutableArrayIzdaniaName = [[NSMutableArray alloc] init];
    mutableArrayIzdaniaDate = [[NSMutableArray alloc] init];
    mutableArrayIzdaniaKyrs = [[NSMutableArray alloc] init];
    mutableArrayIzdaniaId = [[NSMutableArray alloc] init];
    mutableArrayAvtori = [[NSMutableArray alloc] init];
    mutableArrayFakylteti = [[NSMutableArray alloc] init];
    mutableArrayPredmeti= [[NSMutableArray alloc] init];
    mutableArraySpecialnosti = [[NSMutableArray alloc] init];
    arrayWithURL = [[NSMutableArray alloc] init];
    
    
    
    [super viewDidLoad];
    
    [self.MyTableView delegate];
    [self.MyTableView dataSource];
    [self.MyAlertView delegate];
    [self parserVersion];
    [self printAllObjects];
    [self addSinglton];
}

-(void) addSinglton {

     [Singleton sharedSingleton].mutableFacultetSinglton = self.mutableArrayFakylteti;
     [Singleton sharedSingleton].mutableAvtorSinglton = self.mutableArrayAvtori;
     [Singleton sharedSingleton].mutableSpecialnostSinglton = self.mutableArraySpecialnosti;
     [Singleton sharedSingleton].mutableKursSinglton = self.mutableArrayIzdaniaKyrs;
     [Singleton sharedSingleton].mutablePredmetSinglton = self.mutableArrayPredmeti;
     [Singleton sharedSingleton].mutableDateSinglton = self.mutableArrayIzdaniaDate;
}
- (void)parserVersion {
    
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://umk.dginh.ru/xml/version.xml"]];
    NSString *result = [[NSString alloc] init];
    result = ( URLString != NULL ) ? @"Yes" : @"No";
    // NSLog(@"Internet connection availability : %@", result);
    
    if (URLString) {
        NSLog(@"Подключение есть идет сравнение");
        
        
        NSURL *myUrl = [NSURL URLWithString:@"http://umk.dginh.ru/xml/version.xml"];
        NSData *myData = [NSData dataWithContentsOfURL:myUrl];
        TBXML *sourceXML = [[TBXML alloc] initWithXMLData:myData error:nil];
        TBXMLElement *IzdaniaElement = sourceXML.rootXMLElement;
        TBXMLElement *IzdaniaVersion = [TBXML childElementNamed:@"version" parentElement:IzdaniaElement];
        NSString *Attribute = [TBXML valueOfAttributeNamed:@"id" forElement:IzdaniaVersion];
        
        NSMutableArray *mutA = [[NSMutableArray alloc] initWithObjects:@"16", nil];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        mutA = [defaults objectForKey:@"id"];
        
        if ([mutA isEqual:Attribute])
        {
            NSLog(@"Версии xml равны,обновлений не нужно");
            
            
        } else {
            
            NSLog(@"Сейчас начнется скачивание zip");
            
            //x[self remove];
            [self deleteDataBase];
            [self loadXmlZip];
            
            [defaults setObject:Attribute forKey:@"id"];
            [defaults synchronize];
            
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ОШИБКА:" message:@"Проверьте подключение к интернету" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];

        NSLog(@"Проверьте подключение к интернету");
        
    }
}

-(void)loadXmlZip {
    
    NSURL *urlSite = [NSURL URLWithString:@"http://umk.dginh.ru/xml/xml.zip"];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:urlSite options:0 error:&error];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,NSCachesDirectory);
    
    path = [paths objectAtIndex:0];
    NSString *zipPath = [path stringByAppendingPathComponent:@"xml.zip"];
    [data writeToFile:zipPath options:0 error:&error];
    
    
    ZipArchive *za = [[ZipArchive alloc] init];
    if ([za UnzipOpenFile: zipPath]) {
        BOOL ret = [za UnzipFileTo: path overWrite: YES];
        if (NO == ret){} [za UnzipCloseFile];
    }
    [self parsingXml];
}

-(void)parsingXml {
    
#pragma mark Izdania
    
    NSString *IzdaniaFilePath = [path stringByAppendingPathComponent:@"Izdania.xml"];
	NSData *IzdaniaXmlData = [NSData dataWithContentsOfFile:IzdaniaFilePath];
    NSString *Izdania = [[NSString alloc] initWithData:IzdaniaXmlData encoding:NSUTF8StringEncoding];
    
    
    TBXML *IzdaniaXml = [[TBXML alloc] initWithXMLString:Izdania error:nil];
    TBXMLElement *IzdaniaElement = IzdaniaXml.rootXMLElement;
    TBXMLElement *IzdaniaVersion = [TBXML childElementNamed:@"Izdania" parentElement:IzdaniaElement];
    
    do {
        if(IzdaniaVersion -> firstChild)
        {
            
            IzdaniaVersion = [TBXML nextSiblingNamed:@"Izdania" searchFromElement:IzdaniaVersion];
            
            NSString* atributeIdIzdania =           [[NSString alloc]init];
            NSString* atributeNameIzdania =         [[NSString alloc]init];
            NSString* atributeAvtorIdIzdania =      [[NSString alloc]init];
            NSString* atributeFakyltetIdIzdania =   [[NSString alloc]init];
            NSString* atributePredmetiIdIzdania =   [[NSString alloc]init];
            NSString* atributeKyrsIzdania =         [[NSString alloc]init];
            NSString* atributeDateIzdania =         [[NSString alloc]init];
            NSString* atributeUrlIzdania =          [[NSString alloc]init];
            
            
            TBXMLElement * IdIzdania = [TBXML childElementNamed:@"id" parentElement:IzdaniaVersion];
            TBXMLElement * NameIzdania = [TBXML childElementNamed:@"name" parentElement:IzdaniaVersion];
            TBXMLElement * AvtorIdIzdania = [TBXML childElementNamed:@"avtorId" parentElement:IzdaniaVersion];
            //NSLog(@"avtor---- %@",AvtorIdIzdania);
            TBXMLElement * FakyltetIdIzdania = [TBXML childElementNamed:@"fakyltetId" parentElement:IzdaniaVersion];
            TBXMLElement * PredmetiIdIzdania = [TBXML childElementNamed:@"predmetiId" parentElement:IzdaniaVersion];
            TBXMLElement * KyrsIzdania = [TBXML childElementNamed:@"kyrs" parentElement:IzdaniaVersion];
            TBXMLElement * DateIzdania = [TBXML childElementNamed:@"date" parentElement:IzdaniaVersion];
            TBXMLElement * UrlIzdania = [TBXML childElementNamed:@"url" parentElement:IzdaniaVersion];
            
            
            atributeIdIzdania = [TBXML attributeValue:IdIzdania];
            atributeNameIzdania = [TBXML attributeValue:NameIzdania];
            atributeAvtorIdIzdania = [TBXML attributeValue:AvtorIdIzdania];
            atributeFakyltetIdIzdania = [TBXML attributeValue:FakyltetIdIzdania];
            atributePredmetiIdIzdania = [TBXML attributeValue:PredmetiIdIzdania];
            atributeKyrsIzdania = [TBXML attributeValue:KyrsIzdania];
            atributeDateIzdania = [TBXML attributeValue:DateIzdania];
            atributeUrlIzdania = [TBXML attributeValue:UrlIzdania];
            
            
            
            izdania =
            [NSEntityDescription insertNewObjectForEntityForName:@"ASIzdania" inManagedObjectContext:[self managedObjectContext]];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            
            [fetchRequest setEntity:izdania];
            
            
            
            
            [izdania setValue:atributeNameIzdania forKey:@"atributeNameIzdania"];
            [izdania setValue:atributeIdIzdania forKey:@"atributeIdIzdania"];
            [izdania setValue:atributeAvtorIdIzdania forKey:@"atributeAvtorIdIzdania"];
            [izdania setValue:atributeFakyltetIdIzdania forKey:@"atributeFakyltetIdIzdania"];
            [izdania setValue:atributePredmetiIdIzdania forKey:@"atributePredmetiIdIzdania"];
            [izdania setValue:atributeKyrsIzdania forKey:@"atributeKyrsIzdania"];
            [izdania setValue:atributeDateIzdania forKey:@"atributeDateIzdania"];
            [izdania setValue:atributeUrlIzdania forKey:@"atributeUrlIzdania"];
            


            NSError* error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@" %@", [error localizedDescription]);
            }

            
            // NSLog(@"\nраспечатываем asIzdaniaUrl : %@", asIzdania.atributeUrlIzdania);
            
        }
    }
    while ((IzdaniaVersion  -> nextSibling));


    
#pragma mark Avtori
    
    NSString *AvtoriFilePath = [path stringByAppendingPathComponent:@"Avtori.xml"];
	NSData *AvtoriXmlData = [NSData dataWithContentsOfFile:AvtoriFilePath];
    NSString *Avtori = [[NSString alloc] initWithData:AvtoriXmlData encoding:NSUTF8StringEncoding];
    
    TBXML *AvtoriXml = [[TBXML alloc] initWithXMLString:Avtori error:nil];
    TBXMLElement *AvtoriElement = AvtoriXml.rootXMLElement;
    TBXMLElement *AvtoriVersion = [TBXML childElementNamed:@"Avtori" parentElement:AvtoriElement];
    
    do {
        if(AvtoriVersion -> firstChild)
        {
            
            AvtoriVersion = [TBXML nextSiblingNamed:@"Avtori" searchFromElement:AvtoriVersion];
            
            NSString* atributeIdAvtori = [[NSString alloc]init];
            NSString* atributeNameAvtori = [[NSString alloc]init];
            
            TBXMLElement * IdAvtori = [TBXML childElementNamed:@"id" parentElement:AvtoriVersion];
            TBXMLElement * AvtoriName = [TBXML childElementNamed:@"name" parentElement:AvtoriVersion];
            
            atributeIdAvtori = [TBXML attributeValue:IdAvtori];
            atributeNameAvtori = [TBXML attributeValue:AvtoriName];
            
            NSManagedObject* avtori =
            [NSEntityDescription insertNewObjectForEntityForName:@"ASAvtori"
                                          inManagedObjectContext:[self managedObjectContext]];
            
            
            [avtori setValue:atributeIdAvtori forKey:@"atributeIdAvtori"];
            [avtori setValue:atributeNameAvtori forKey:@"atributeNameAvtori"];
            
            //NSLog(@" распечатываеем avtori =  %@", avtori);
            
            
            NSError* error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@" %@", [error localizedDescription]);
            }
        }
    }
    while ((AvtoriVersion  -> nextSibling));
    
    
    
#pragma mark Fakylteti
    
    NSString *FakyltetiFilePath = [path stringByAppendingPathComponent:@"Fakylteti.xml"];
	NSData *FakyltetiXmlData = [NSData dataWithContentsOfFile:FakyltetiFilePath];
    NSString *Fakylteti = [[NSString alloc] initWithData:FakyltetiXmlData encoding:NSUTF8StringEncoding];
    
    TBXML *FakyltetiXml = [[TBXML alloc] initWithXMLString:Fakylteti error:nil];
    TBXMLElement *FakyltetiElement = FakyltetiXml.rootXMLElement;
    TBXMLElement *FakyltetiVersion = [TBXML childElementNamed:@"Fakylteti" parentElement:FakyltetiElement];
    
    do {
        if(FakyltetiVersion -> firstChild)
        {
            
            FakyltetiVersion = [TBXML nextSiblingNamed:@"Fakylteti" searchFromElement:FakyltetiVersion];
            
            NSString* atributeIdFakylteti = [[NSString alloc]init];
            NSString* atributeNameFakylteti = [[NSString alloc]init];
            
            TBXMLElement * IdFakylteti = [TBXML childElementNamed:@"id" parentElement:FakyltetiVersion];
            TBXMLElement * NameFakylteti = [TBXML childElementNamed:@"name" parentElement:FakyltetiVersion];
            
            atributeIdFakylteti = [TBXML attributeValue:IdFakylteti];
            atributeNameFakylteti = [TBXML attributeValue:NameFakylteti];
            
            
            NSManagedObject* fakylteti =
            [NSEntityDescription insertNewObjectForEntityForName:@"ASFakylteti"
             
                                          inManagedObjectContext:[self managedObjectContext]];
            
            [fakylteti setValue:atributeIdFakylteti forKey:@"atributeIdFakylteti"];
            [fakylteti setValue:atributeNameFakylteti forKey:@"atributeNameFakylteti"];
            
            NSError* error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@" %@", [error localizedDescription]);
            }
            
            //  NSLog(@" \n распечатываем ASFakylteti : %@", asFakylteti);
            
        }
    }
    while ((FakyltetiVersion  -> nextSibling));
    
    
#pragma mark Predmeti
    
    NSString *PredmetiFilePath = [path stringByAppendingPathComponent:@"Predmeti.xml"];
	NSData *PredmetiXmlData = [NSData dataWithContentsOfFile:PredmetiFilePath];
    NSString *Predmeti = [[NSString alloc] initWithData:PredmetiXmlData encoding:NSUTF8StringEncoding];
    
    TBXML *PredmetiXml = [[TBXML alloc] initWithXMLString:Predmeti error:nil];
    TBXMLElement *PredmetiElement = PredmetiXml.rootXMLElement;
    TBXMLElement *PredmetiVersion = [TBXML childElementNamed:@"Predmeti" parentElement:PredmetiElement];
    
    do {
        if(PredmetiVersion -> firstChild)
        {
            
            PredmetiVersion = [TBXML nextSiblingNamed:@"Predmeti" searchFromElement:PredmetiVersion];
            
            NSString* atributeIdPredmeti = [[NSString alloc]init];
            NSString* atributeNamePredmeti = [[NSString alloc]init];
            
            TBXMLElement * IdPredmeti = [TBXML childElementNamed:@"id" parentElement:PredmetiVersion];
            TBXMLElement * NamePredmeti = [TBXML childElementNamed:@"name" parentElement:PredmetiVersion];
            
            atributeIdPredmeti = [TBXML attributeValue:IdPredmeti];
            atributeNamePredmeti = [TBXML attributeValue:NamePredmeti];
            
            
            NSManagedObject* predmeti =
            [NSEntityDescription insertNewObjectForEntityForName:@"ASPredmeti"
             
                                          inManagedObjectContext:[self managedObjectContext]];
            
            [predmeti setValue:atributeIdPredmeti forKey:@"atributeIdPredmeti"];
            [predmeti setValue:atributeNamePredmeti forKey:@"atributeNamePredmeti"];
            
            NSError* error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@" %@", [error localizedDescription]);
            }
            
            //   NSLog(@" \n распечатываем ASPredmeti : %@", asPredmeti);
            
        }
    }
    while ((PredmetiVersion  -> nextSibling));
    
    
    
#pragma mark Specialnosti
    
    NSString *SpecialnostiFilePath = [path stringByAppendingPathComponent:@"Specialnosti.xml"];
	NSData *SpecialnostiXmlData = [NSData dataWithContentsOfFile:SpecialnostiFilePath];
    NSString *Specialnosti = [[NSString alloc] initWithData:SpecialnostiXmlData encoding:NSUTF8StringEncoding];
    
    TBXML *SpecialnostiXml = [[TBXML alloc] initWithXMLString:Specialnosti error:nil];
    TBXMLElement *SpecialnostiElement = SpecialnostiXml.rootXMLElement;
    TBXMLElement *SpecialnostiVersion = [TBXML childElementNamed:@"Specialnosti" parentElement:SpecialnostiElement];
    
    do {
        if(SpecialnostiVersion -> firstChild)
        {
            
            SpecialnostiVersion = [TBXML nextSiblingNamed:@"Specialnosti" searchFromElement:SpecialnostiVersion];
            
            
            
            NSString* atributeIdSpecialnosti = [[NSString alloc]init];
            NSString* atributeNameSpecialnosti = [[NSString alloc]init];
            
            
            TBXMLElement * IdSpecialnosti = [TBXML childElementNamed:@"id" parentElement:SpecialnostiVersion];
            TBXMLElement * NameSpecialnosti = [TBXML childElementNamed:@"name" parentElement:SpecialnostiVersion];
            
            
            atributeIdSpecialnosti   = [TBXML attributeValue:IdSpecialnosti];
            atributeNameSpecialnosti = [TBXML attributeValue:NameSpecialnosti];
            
            
            NSManagedObject* specialnosti =
            [NSEntityDescription insertNewObjectForEntityForName:@"ASSpecialnosti"
             
                                          inManagedObjectContext:[self managedObjectContext]];
            
            [specialnosti setValue:atributeIdSpecialnosti forKey:@"atributeIdSpecialnosti"];
            [specialnosti setValue:atributeNameSpecialnosti forKey:@"atributeNameSpecialnosti"];
            
            //NSLog(@" распечатываеем specialnosti =  %@", specialnosti);
            
            NSError* error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@" %@", [error localizedDescription]);
            }
            
            //      NSLog(@" \n распечатываем ASSpecialnosti : %@", asSpecialnosti);
        }
    }
    while ((SpecialnostiVersion  -> nextSibling));
}

#pragma mark - allObject

- (NSArray*) allObjects {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"ASObject"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}


- (void) printAllObjects {
    
    NSArray* allObjects = [self allObjects];
    
    for (id object in allObjects) {
        
        if ([object isKindOfClass:[ASIzdania class]]) {
            
            izdania1 = (ASIzdania*) object;
            
            [mutableArrayIzdaniaName addObject:izdania1.atributeNameIzdania];
            [mutableArrayIzdaniaKyrs addObject:izdania1.atributeKyrsIzdania];
            [mutableArrayIzdaniaDate addObject:izdania1.atributeDateIzdania];
            [mutableArrayIzdaniaId addObject:izdania1.atributeIdIzdania];
            urlStringIzdania = [NSString stringWithString:izdania1.atributeUrlIzdania];
            
           [arrayWithURL addObject:izdania1.atributeUrlIzdania];
        }
        if ([object isKindOfClass:[ASAvtori class]]) {
            
            avtor1 = (ASAvtori*) object;
            [mutableArrayAvtori addObject:avtor1.atributeNameAvtori];
        }
        if ([object isKindOfClass:[ASSpecialnosti class]]) {
            
            specialnist = (ASSpecialnosti*) object;
            [mutableArraySpecialnosti addObject:specialnist.atributeNameSpecialnosti];
        }
        if ([object isKindOfClass:[ASPredmeti class]]) {
            
            predmet = (ASPredmeti*) object;
            [mutableArrayPredmeti addObject:predmet.atributeNamePredmeti];
        }
        else if ([object isKindOfClass:[ASFakylteti class]]) {
            
            fakylteti1 = (ASFakylteti*) object;
            [mutableArrayFakylteti addObject:fakylteti1.atributeNameFakylteti];
            
        }
    }
}
- (void) deleteDataBase {
    
    NSArray* allObjects = [self allObjects];
    //NSLog(@"вызвали allObjects %@",allObjects);

    
    for (id object in allObjects) {
        [self.managedObjectContext deleteObject:object];
    }
   // [self.managedObjectContext save:nil];
   // NSLog(@"вызвали deleteAllObjects");
    NSLog(@"object %@",allObjects);
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (IBAction)updateButton:(id)sender {
    [self parserVersion];

}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ModelData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Parser.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
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

- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;
    
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transitions.dynamicTransition action:@selector(handlePanGesture:)];
    
    return _dynamicTransitionPanGesture;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    if (mutableArrayFakylteti.count <= mutableArrayIzdaniaKyrs.count ) {
        return  [mutableArrayFakylteti count];
    }
    if (mutableArrayFakylteti.count <= mutableArrayIzdaniaName.count ) {
        return  [mutableArrayFakylteti count];
    }
    if (mutableArrayIzdaniaKyrs.count <= mutableArrayIzdaniaName.count) {
        return [mutableArrayIzdaniaKyrs count];
    }
    if (mutableArrayIzdaniaName.count <= mutableArrayIzdaniaKyrs.count ) {
        return  [mutableArrayIzdaniaName count];
    }
    if (mutableArrayIzdaniaName.count <= mutableArrayFakylteti.count ) {
        return  [mutableArrayIzdaniaName count];
    }
    if (mutableArrayIzdaniaKyrs.count <= mutableArrayFakylteti.count ) {
        return  [mutableArrayIzdaniaKyrs count];
    }
    
    return YES;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super viewWillAppear:YES];
    static NSString *CellIdentifier = @"DocCell";
    
    DocCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.subLbl.text = [mutableArrayIzdaniaName objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"me.png"];
    cell.fakyltet.text =  [mutableArrayFakylteti objectAtIndex:indexPath.row];
    cell.courceLbl.text = [mutableArrayIzdaniaKyrs objectAtIndex:indexPath.row];
    
    
    return cell;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // hack to get selectedBackgroundView's presentation layer to update after rotation.
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Выберите действие:"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Отмена"
                                          otherButtonTitles:@"Скачать", @"Добавить в Мои полки", nil];
    
    [alert show];
    
    NSLog(@" indexPath = %@",indexPath);
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.selectedBackgroundView.layer removeAllAnimations];
    
    NSDictionary *transitionData = self.transitions.all[indexPath.row];
    id<ECSlidingViewControllerDelegate> transition = transitionData[@"transition"];
    if (transition == (id)[NSNull null]) {
        self.slidingViewController.delegate = nil;
    } else {
        self.slidingViewController.delegate = transition;
    }
    
    NSString *transitionName = transitionData[@"name"];
    if ([transitionName isEqualToString:METransitionNameDynamic]) {
        self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
        self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
        [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
        [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    } else {
        self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
        self.slidingViewController.customAnchoredGestures = @[];
        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSIndexPath *indexPath = [self.MyTableView indexPathForSelectedRow];
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"НЕТ"])
    {
        NSLog(@"НЕТ was selected.");
        [self.MyTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if([title isEqualToString:@"Скачать"])
    {
        ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DestinationController"];
        viewController.urlString = [arrayWithURL objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
        [self.MyTableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
    }
    else if([title isEqualToString:@"Button 3"])
    {
        NSLog(@"Button 3 was selected.");
        [self.MyTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

@end





