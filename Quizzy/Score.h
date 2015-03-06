//
//  Score.h
//  Quizzy
//
//  Created by Lucas on 24/02/15.
//  Copyright (c) 2015 GSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreManagedObject.h"

@interface Score : NSObject

@property(nonatomic,strong) NSString * date;
@property(nonatomic,strong) NSNumber * score;
@property(nonatomic,strong) NSString * playerName;

- (id) init;
- (id) initWithScoreManagedObject:(ScoreManagedObject*) scoreManagedObject;
- (NSString *)getPlayerName;
- (NSString *)getScore;
- (NSString *)getDate;
- (NSString *)description;


@end
