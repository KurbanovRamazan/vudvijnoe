//
//  Singleton.h
//  dssa
//
//  Created by Muaviya on 01.04.14.
//  Copyright (c) 2014 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject {
    NSMutableArray *mutableFacultetSinglton;
    NSMutableArray *mutableAvtorSinglton;
    NSMutableArray *mutableSpecialnostSinglton;
    NSMutableArray *mutableKursSinglton;
    NSMutableArray *mutablePredmetSinglton;
    NSMutableArray *mutableDateSinglton;
}
@property (nonatomic,retain) NSMutableArray *mutableFacultetSinglton;
@property (nonatomic,retain) NSMutableArray *mutableAvtorSinglton;
@property (nonatomic,retain) NSMutableArray *mutableSpecialnostSinglton;
@property (nonatomic,retain) NSMutableArray *mutableKursSinglton;
@property (nonatomic,retain) NSMutableArray *mutablePredmetSinglton;
@property (nonatomic,retain) NSMutableArray *mutableDateSinglton;
+(Singleton *)sharedSingleton;


@end
