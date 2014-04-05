//
//  Singleton.m
//  dssa
//
//  Created by Muaviya on 01.04.14.
//  Copyright (c) 2014 1. All rights reserved.
//
#import "Singleton.h"

@implementation Singleton

@synthesize mutableFacultetSinglton;
@synthesize mutableAvtorSinglton;
@synthesize mutableSpecialnostSinglton;
@synthesize mutableKursSinglton;
@synthesize mutablePredmetSinglton;
@synthesize  mutableDateSinglton;
static Singleton * sharedSingleton;
+ (Singleton *)sharedSingleton
{
    static Singleton *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[Singleton alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedSingleton;
}
//+(Singleton *)sharedMySingleton {
//    if (!sharedSingleton) {
//		sharedSingleton = [Singleton new];
//	}
//	return sharedSingleton;
//}

@end
