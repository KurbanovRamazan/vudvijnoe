//
//  GeneralSupportClass.m
//  HomeFree
//
//  Created by Alximik on 15.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <sys/xattr.h>

#import "MainManager.h"

@implementation MainManager

@synthesize playLists;

static MainManager* sharedManager = NULL;
+(MainManager *)shared {
    if (!sharedManager || sharedManager == NULL) {
		sharedManager = [MainManager new];
	}
	return sharedManager;
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL*)URL {
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

@end

@implementation NSString (Utilities)

- (NSString*)loc {
    return NSLocalizedString(self, nil);
}

-(NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSScanner* scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            return result;
        }
    }
    return nil;
}

- (BOOL)containsString:(NSString*)substring {
    if (!substring) {return NO;}
    
    NSRange range = [self rangeOfString:substring];
    return range.location != NSNotFound;
}

- (BOOL)isValidEmail {
    NSString *regExpPattern = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    
    NSError *errorNext = NULL;
	NSRegularExpression *regexNext = [NSRegularExpression regularExpressionWithPattern:regExpPattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&errorNext];
	NSRange range = [regexNext rangeOfFirstMatchInString:self
                                                 options:NSMatchingReportCompletion
                                                   range:NSMakeRange(0, self.length)];
	return NSEqualRanges(range, NSMakeRange(0, self.length));
}

- (BOOL)isValidURL {
    NSString *regExpPattern = @"(?i)(?:(?:https?):\\/\\/)?(?:\\S+(?::\\S*)?@)?(?:(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,})))(?::\\d{2,5})?(?:\\/[^\\s]*)?";
    
    NSError *errorNext = NULL;
	NSRegularExpression *regexNext = [NSRegularExpression regularExpressionWithPattern:regExpPattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&errorNext];
	NSRange range = [regexNext rangeOfFirstMatchInString:self
                                                 options:NSMatchingReportCompletion
                                                   range:NSMakeRange(0, self.length)];
	return NSEqualRanges(range, NSMakeRange(0, self.length));
}

- (NSString*)cleanString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSURL*)url {
    return [NSURL URLWithString:self];
}

- (NSURL*)urlPath {
    return [NSURL fileURLWithPath:self];
}

- (UIImage*)image {
    return [UIImage imageNamed:self];
}

@end

@implementation NSDictionary(NSDictionaryUtilities)

- (NSString*)fileName {
    NSString *fileName = [NSString stringWithFormat:@"%@ - %@", self[@"artist"], self[@"title"]];
    return fileName.cleanString;
}

@end

@implementation NSObject (Values)

- (id)customValueForKey:(NSString*)key {
    return [self valueForKeyPath:[@"values." stringByAppendingString:key]];
}

- (void)showAlert:(NSString*)title textAlert:(NSString*)message {
//    BlockAlertView *alert = [BlockAlertView alertWithTitle:title message:message];
//    [alert setCancelButtonWithTitle:@"OK" block:^{ }];
//    [alert show];
}

@end

@implementation NSDate (DateUtilities)

- (NSDate*)startDay {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComps = [calendar components:(NSDayCalendarUnit|
                                                         NSMonthCalendarUnit|
                                                         NSYearCalendarUnit|
                                                         NSHourCalendarUnit|
                                                         NSMinuteCalendarUnit|
                                                         NSSecondCalendarUnit)
                                               fromDate:self];
    todayComps.hour = 0;
    todayComps.minute = 0;
    todayComps.second = 0;
    
    return [calendar dateFromComponents:todayComps];
}

- (NSDate*)endDay {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComps = [calendar components:(NSDayCalendarUnit|
                                                         NSMonthCalendarUnit|
                                                         NSYearCalendarUnit|
                                                         NSHourCalendarUnit|
                                                         NSMinuteCalendarUnit|
                                                         NSSecondCalendarUnit)
                                               fromDate:self];
    todayComps.hour = 23;
    todayComps.minute = 59;
    todayComps.second = 59;
    
    return [calendar dateFromComponents:todayComps];
}

@end

@implementation UIView (UIViewUtilities)
- (void)round {
    CALayer *layer = self.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 5.0f;
    layer.borderWidth = 0.0f;
}

- (void)roundWithBorder {
    CALayer *layer = self.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 5.0f;
    layer.borderWidth = 3.0f;
    layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)setAnimationAlpha:(CGFloat)value {
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	self.alpha = value;
	[UIView commitAnimations];
}

@end

@implementation NSData (NSDataUtilities)
- (id)JSONValue {
    return [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:nil];
}
@end

@implementation UIViewController (UIViewControllerStoryboard )
- (UINavigationController*)navController {
    return [[UINavigationController alloc] initWithRootViewController:self];
}

- (id)controllerFromName:(NSString*)controllerName {
    return [self.storyboard instantiateViewControllerWithIdentifier:controllerName];
}
@end

@implementation UIImage (BoxBlur)

/* blur the current image with a box blur algoritm */
- (UIImage*)blurImageWithBlur:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:blur] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    
    return returnImage;
    
    
    
//    if (blur < 0.f || blur > 1.f) {
//        blur = 0.5f;
//    }
//    int boxSize = (int)(blur * 40);
//    boxSize = boxSize - (boxSize % 2) + 1;
//    
//    CGImageRef img = self.CGImage;
//    vImage_Buffer inBuffer, outBuffer;
//    vImage_Error error;
//    void *pixelBuffer;
//    
//    //create vImage_Buffer with data from CGImageRef
//    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
//    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
//    
//    inBuffer.width = CGImageGetWidth(img);
//    inBuffer.height = CGImageGetHeight(img);
//    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
//    
//    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
//    
//    //create vImage_Buffer for output
//    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
//    
//    if(pixelBuffer == NULL)
//        NSLog(@"No pixelbuffer");
//    
//    outBuffer.data = pixelBuffer;
//    outBuffer.width = CGImageGetWidth(img);
//    outBuffer.height = CGImageGetHeight(img);
//    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
//    
//    // Create a third buffer for intermediate processing
//    /*void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
//     vImage_Buffer outBuffer2;
//     outBuffer2.data = pixelBuffer2;
//     outBuffer2.width = CGImageGetWidth(img);
//     outBuffer2.height = CGImageGetHeight(img);
//     outBuffer2.rowBytes = CGImageGetBytesPerRow(img);*/
//    
//    //perform convolution
//    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend)
//    ?: vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend)
//    ?: vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
//    
//    if (error) {
//        NSLog(@"error from convolution %ld", error);
//    }
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
//                                             outBuffer.width,
//                                             outBuffer.height,
//                                             8,
//                                             outBuffer.rowBytes,
//                                             colorSpace,
//                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
//    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
//    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
//    
//    //clean up
//    CGContextRelease(ctx);
//    CGColorSpaceRelease(colorSpace);
//    
//    free(pixelBuffer);
//    //free(pixelBuffer2);
//    
//    CFRelease(inBitmapData);
//    
//    CGImageRelease(imageRef);
//    
//    return returnImage;
}

@end
