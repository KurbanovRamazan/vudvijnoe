//
//  MenegerTable.m
//  dssa
//
//  Created by 1 on 28.01.14.
//  Copyright (c) 2014 1. All rights reserved.
//

#import "MenegerTable.h"
#import "DocCell.h"
#import "ViewController.h"
@interface MenegerTable ()
@end

@implementation MenegerTable
@synthesize description;
@synthesize dishs;
@synthesize dishsArray;
@synthesize descriptionMutableString;
@synthesize currentDic;
@synthesize currentDicMuatableDictionary;
@synthesize currentElement;
@synthesize currentElementFac;
@synthesize currentElementString;
@synthesize facArray;
@synthesize facDescription;
@synthesize facDictionary;
@synthesize dishsUrl;
@synthesize currentElementUrl;
@synthesize descriptionUrl;
@synthesize currentDicUrl;
@synthesize indexSelect;
@synthesize ulrXmlArray;
@synthesize stringArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.MyTableView delegate];
    [self.MyTableView dataSource];
    [self.MyAlertView delegate];
    
    self.dishs = [NSMutableArray array];
    self.dishsArray = [NSMutableArray array];
    self.facArray =[NSMutableArray array];
    self.dishsUrl = [NSMutableArray array];
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"maneger" ofType:@"xml"];
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    
    NSXMLParser *rssParser = [[NSXMLParser alloc] initWithData:myData];
    rssParser.delegate = self;
    [rssParser parse];
    
    
    NSString *fak = [[NSBundle mainBundle] pathForResource:@"Fakylteti" ofType:@"xml"];
    NSData *myDataFac = [NSData dataWithContentsOfFile:fak];
    
    NSXMLParser *rssParserFac = [[NSXMLParser alloc] initWithData:myDataFac];
    rssParserFac.delegate = self;
    [rssParserFac parse];
    
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict  {
    
    self.currentElement = elementName;
    self.currentElementString = elementName;
    self.currentElementFac = elementName;
    self.currentElementUrl = elementName;
    
    
    if ([elementName isEqualToString:@"id"]) {
        self.currentDic = [NSMutableDictionary dictionaryWithCapacity:2];
    } else if ([elementName isEqualToString:@"name"]) {
        self.description = [NSMutableString string];
    }
    if ([elementName isEqualToString:@"id"]) {
        self.currentDicMuatableDictionary = [NSMutableDictionary dictionaryWithCapacity:2];
    } else if ([elementName isEqualToString:@"kyrs"]) {
        self.descriptionMutableString = [NSMutableString string];
    }
    
    if ([elementName isEqualToString:@"id"]) {
        self.facDictionary = [NSMutableDictionary dictionaryWithCapacity:3];
    } else if ([elementName isEqualToString:@"name1"]) {
        self.facDescription = [NSMutableString string];
    }
    if ([elementName isEqualToString:@"id"]) {
        self.currentDicUrl = [NSMutableDictionary dictionaryWithCapacity:2];
    } else if ([elementName isEqualToString:@"name"]) {
        self.descriptionUrl = [NSMutableString string];
        
        
    }
    
    
    
    
    //NSLog(@"%@", self.descriptionMutableString);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    
    if ([currentElement isEqualToString:@"name"]) {
        [description appendString:string];
    }
    
    if ([currentElementString isEqualToString:@"kyrs"]) {
        [descriptionMutableString appendString:string];
    }
    
    
    if ([currentElementFac isEqualToString:@"name1"]) {
        [facDescription appendString:string];
    }
    
    if ([currentElementUrl isEqualToString:@"url"]) {
        [descriptionUrl appendString:string];
    }
    // NSLog(@"%@", _facDescription);
}

- (void)parser2:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"%@", facDescription);
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"name"]) {
        [currentDic setObject:description forKey:@"name"];
        [dishs addObject:currentDic];
    }
    
    
    if ([elementName isEqualToString:@"kyrs"]) {
        [currentDicMuatableDictionary setObject:descriptionMutableString forKey:@"kyrs"];
        [dishsArray addObject:currentDicMuatableDictionary];
        
    }
    // NSLog(@"%@",_dishsArray);
    
    if ([elementName isEqualToString:@"name1"]) {
        [facDictionary setObject:facDescription forKey:@"name1"];
        [facArray addObject:facDictionary];
        
        //NSLog(@"%@",_facDescription);
        
    }
    
    if ([elementName isEqualToString:@"url"]) {
        [currentDicUrl setObject:descriptionUrl forKey:@"url"];
        [dishsUrl addObject:currentDicUrl];
        
        
    }
    
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.tableView reloadData];
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dishs count];
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DocCell";
    
    DocCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    
    NSDictionary *dic = [dishs objectAtIndex:indexPath.row];
    NSDictionary *dic2 = [dishsArray objectAtIndex:indexPath.row];
    NSDictionary *facDic = [facArray objectAtIndex:indexPath.row];
    // NSLog(@"%@",facDic);
    
    cell.mainLbl.text = [dic objectForKey:@"id"];
    cell.subLbl.text = [dic objectForKey:@"name"];
    cell.imageView.image = [UIImage imageNamed:@"me.png"];
    cell.fakyltet.text = [facDic objectForKey:@"name1"];
    cell.courceLbl.text = [dic2 objectForKey:@"kyrs"];
    return cell;
}

/*-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 
 UIAlertView *alertone = [[UIAlertView alloc]initWithTitle:@"Скачать" message:@"УМК" delegate:self cancelButtonTitle:@"НЕТ" otherButtonTitles:@"ДА", nil];
 [alertone show];
 
 }*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Скачать:" message:@"УМК" delegate:self cancelButtonTitle:@"НЕТ" otherButtonTitles:@"Да", nil];
    [alert show];
    
    NSLog(@" indexPath = %@",indexPath);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSIndexPath *indexPath = [self.MyTableView indexPathForSelectedRow];
    if (buttonIndex == 1)
    {
        
        ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DestinationController"];
        
        ulrXmlArray = [dishsUrl valueForKey:@"url"];
        
        viewController.urlString =   [ulrXmlArray objectAtIndex:indexPath.row];
        NSLog(@"urlString %@",viewController.urlString);
        [self.navigationController pushViewController:viewController animated:YES];
        [self.MyTableView deselectRowAtIndexPath:indexPath animated:YES];
        // тут переход на новый контроллер
        // идек заселекченой ячейки selectedRowIndex
        
    }
    else {
        [self.MyTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

/*
 -(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 //
 //    UIAlertView *alertone = [[UIAlertView alloc]initWithTitle:@"Скачать" message:@"УМК" delegate:self cancelButtonTitle:@"НЕТ" otherButtonTitles:@"ДА", nil];
 //    [alertone show];
 //
 if ([segue.identifier isEqualToString:@"DestinationController"]) {
 
 NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
 
 ViewController *viewController = segue.destinationViewController;
 
 ulrXmlArray = [dishsUrl valueForKey:@"url"];
 
 viewController.urlString =   [ulrXmlArray objectAtIndex:indexPath.row];
 }
 }
 */


@end
