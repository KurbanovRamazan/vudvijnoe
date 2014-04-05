//
//  ASViewController.m
//  Parser
//
//  Created by 1 on 11.02.14.
//  Copyright (c) 2014 1. All rights reserved.
//

#import "ASViewController.h"
#import "ETLoginInfoXMLParser.h"
#import "ETLoginInfo.h"
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

@interface ASViewController ()

@property (strong, nonatomic) NSString *idAttribute;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSManagedObject *izdania;

@end


@implementation ASViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize path;
@synthesize izdania;

@synthesize numbers;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self parserVersion];
    [self loadXmlZip];
//    NSFileManager* filemanager = [NSFileManager defaultManager];
//    if ([filemanager fileExistsAtPath:@"/Users/kurbanovramazan/Desktop/Av.xml"])
//    {
//        NSLog(@"YES file exist");
//    } else NSLog(@"NO file does not exist");
//    
//    [filemanager removeItemAtPath:@"/Users/kurbanovramazan/Desktop/Av.xml" error:nil];
//    //[filemanager removeItemAtPath:@"/Users/kurbanovramazan/Desktop/1/Av.xml" error:nil];
    //[self remove];
    //[self loadXml];
    //[self loadXmlVersion];
}


-(void)remove {
    
   NSFileManager* filemanager = [NSFileManager defaultManager];
   if ([filemanager fileExistsAtPath:@"/Users/kurbanovramazan/Library/Application Support/iPhone Simulator/7.0/Applications/ABE7AECB-2F86-410D-BBA9-2B786249C532/Library/Caches/xml.zip"])
      {
           NSLog(@"YES Файлы найдены");
       } else NSLog(@"NO Файлы для удаления не найдены");
    
    [filemanager removeItemAtPath:@"/Users/kurbanovramazan/Library/Application Support/iPhone Simulator/7.0/Applications/ABE7AECB-2F86-410D-BBA9-2B786249C532/Library/Caches/Avtori.xml" error:nil];
    [filemanager removeItemAtPath:@"/Users/kurbanovramazan/Library/Application Support/iPhone Simulator/7.0/Applications/ABE7AECB-2F86-410D-BBA9-2B786249C532/Library/Caches/Fakylteti.xml" error:nil];
    [filemanager removeItemAtPath:@"/Users/kurbanovramazan/Library/Application Support/iPhone Simulator/7.0/Applications/ABE7AECB-2F86-410D-BBA9-2B786249C532/Library/Caches/Izdania.xml" error:nil];
    [filemanager removeItemAtPath:@"/Users/kurbanovramazan/Library/Application Support/iPhone Simulator/7.0/Applications/ABE7AECB-2F86-410D-BBA9-2B786249C532/Library/Caches/Predmeti.xml" error:nil];
    [filemanager removeItemAtPath:@"/Users/kurbanovramazan/Library/Application Support/iPhone Simulator/7.0/Applications/ABE7AECB-2F86-410D-BBA9-2B786249C532/Library/Caches/Specialnosti.xml" error:nil];
    [filemanager removeItemAtPath:@"/Users/kurbanovramazan/Library/Application Support/iPhone Simulator/7.0/Applications/ABE7AECB-2F86-410D-BBA9-2B786249C532/Library/Caches/xml.zip" error:nil];
    //[filemanager ]
}

- (void)parserVersion {
    
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
            
        //[self remove];
        [self loadXmlZip];
            
        [defaults setObject:Attribute forKey:@"id"];
        [defaults synchronize];
        NSLog(@"mut %@",mutA);
            
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
    
     NSString* atributeIdIzdania = [[NSString alloc]init];
     NSString* atributeNameIzdania = [[NSString alloc]init];
     NSString* atributeAvtorIdIzdania = [[NSString alloc]init];
     NSString* atributeFakyltetIdIzdania = [[NSString alloc]init];
     NSString* atributePredmetiIdIzdania = [[NSString alloc]init];
     NSString* atributeKyrsIzdania =  [[NSString alloc]init];
     NSString* atributeDateIzdania = [[NSString alloc]init];
     NSString* atributeUrlIzdania =  [[NSString alloc]init];
    
     
     TBXMLElement * IdIzdania = [TBXML childElementNamed:@"id" parentElement:IzdaniaVersion];
     TBXMLElement * NameIzdania = [TBXML childElementNamed:@"name" parentElement:IzdaniaVersion];
     TBXMLElement * AvtorIdIzdania = [TBXML childElementNamed:@"avtorId" parentElement:IzdaniaVersion];
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
    

            NSManagedObjectContext *context = [self managedObjectContext];
            ASIzdania *asIzdania = [NSEntityDescription
                                              insertNewObjectForEntityForName:@"ASIzdania"
                                              inManagedObjectContext:context];
           
            asIzdania.atributeIdIzdania     = atributeIdIzdania;
            asIzdania.atributeNameIzdania  = atributeNameIzdania;
            asIzdania.atributeAvtorIdIzdania     = atributeAvtorIdIzdania;
            asIzdania.atributeFakyltetIdIzdania = atributeFakyltetIdIzdania;
            asIzdania.atributePredmetiIdIzdania = atributePredmetiIdIzdania;
            asIzdania.atributeKyrsIzdania = atributeKyrsIzdania;
            asIzdania.atributeDateIzdania = atributeDateIzdania;
            asIzdania.atributeUrlIzdania = atributeUrlIzdania;


            NSLog(@"\nраспечатываем asIzdania : %@", asIzdania);
            

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
          
              NSManagedObjectContext *context = [self managedObjectContext];
              ASAvtori *asAvtori = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"ASAvtori"
                                      inManagedObjectContext:context];
              
              asAvtori.atributeIdAvtori     = atributeIdAvtori;
              asAvtori.atributeNameAvtori  = atributeNameAvtori;
              

              NSLog(@" \n распечатываем ASAvtori: %@", asAvtori);
              
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
            
            
            NSManagedObjectContext *context = [self managedObjectContext];
            ASFakylteti *asFakylteti = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"ASFakylteti"
                                  inManagedObjectContext:context];
            
            asFakylteti.atributeIdFakylteti     = atributeIdFakylteti;
            asFakylteti.atributeNameFakylteti  = atributeNameFakylteti;
            
            
            NSLog(@" \n распечатываем ASFakylteti : %@", asFakylteti);
            
            
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
            
            
            NSManagedObjectContext *context = [self managedObjectContext];
            ASPredmeti *asPredmeti = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"ASPredmeti"
                                        inManagedObjectContext:context];
            
            asPredmeti.atributeIdPredmeti     = atributeIdPredmeti;
            asPredmeti.atributeNamePredmeti  = atributeNamePredmeti;
            
            
            NSLog(@" \n распечатываем ASPredmeti : %@", asPredmeti);
            
            
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
            
            
            atributeIdSpecialnosti = [TBXML attributeValue:IdSpecialnosti];
            atributeNameSpecialnosti = [TBXML attributeValue:NameSpecialnosti];
            
            NSManagedObjectContext *context = [self managedObjectContext];
            ASSpecialnosti *asSpecialnosti = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"ASSpecialnosti"
                                      inManagedObjectContext:context];
            
            asSpecialnosti.atributeIdSpecialnosti     = atributeIdSpecialnosti;
            asSpecialnosti.atributeNameSpecialnosti  = atributeNameSpecialnosti;
            
            
            NSLog(@" \n распечатываем ASSpecialnosti : %@", asSpecialnosti);
            
        }
    }
    while ((SpecialnostiVersion  -> nextSibling));
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
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
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


@end
