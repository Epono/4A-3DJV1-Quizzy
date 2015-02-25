//
//  ScoreManagedObject.h
//  Quizzy
//
//  Created by Lucas on 24/02/15.
//  Copyright (c) 2015 GSL. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ScoreManagedObject : NSManagedObject

@property(nonatomic,strong) NSDate * date;
@property(nonatomic,strong) NSNumber * score;
@property(nonatomic,strong) NSString * playerName;

@end
