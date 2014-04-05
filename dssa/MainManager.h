//
//  GeneralSupportClass.h
//  HomeFree
//
//  Created by Alximik on 15.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainManager : NSObject <UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *playLists;

+ (MainManager*)shared;

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL*)URL;

@end


@interface NSString (Utilities)
- (NSString*)loc;
- (NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end;
- (BOOL)containsString:(NSString*)substring;
- (BOOL)isValidEmail;
- (BOOL)isValidURL;
- (NSString*)cleanString;
- (NSURL*)url;
- (NSURL*)urlPath;
- (UIImage*)image;
@end

@interface NSDictionary (NSDictionaryUtilities)
- (NSString*)fileName;
@end

@interface NSObject (Values)
- (void)showAlert:(NSString*)title textAlert:(NSString*)message;
@end

@interface NSDate (DateUtilities)
- (NSDate*)startDay;
- (NSDate*)endDay;
@end

@interface UIView (UIViewUtilities)
- (void)round;
- (void)roundWithBorder;
- (void)setAnimationAlpha:(CGFloat)value;
@end

@interface NSData (NSDataUtilities)
- (id)JSONValue;
@end

@interface UIViewController (UIViewControllerStoryboard)
- (UINavigationController*)navController;
- (id)controllerFromName:(NSString*)controllerName;
@end

@interface UIImage (BoxBlur)
- (UIImage*)blurImageWithBlur:(CGFloat)blur;
@end