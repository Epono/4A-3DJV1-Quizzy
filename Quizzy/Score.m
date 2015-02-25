//
//  Score.m
//  Quizzy
//
//  Created by Lucas on 24/02/15.
//  Copyright (c) 2015 GSL. All rights reserved.
//

#import "Score.h"

@implementation Score

- (id) init {
    self = [super init];
    return self;
}

- (id) initWithScoreManagedObject:(ScoreManagedObject*) scoreManagedObject {
    self = [super init];
    
    self.score = [scoreManagedObject valueForKey:@"score"];
    self.playerName = [scoreManagedObject valueForKey:@"playerName"];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm dd/MM/yyyy"];
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    self.date = [formatter stringFromDate:[scoreManagedObject valueForKey:@"date"]];
    NSLog(@"%@",self.date);
    NSLog(@"%@",self.playerName);

    
    return self;
}

//- (NSString *)description {
//    return [NSString stringWithFormat: @"\nScore : %@\nPlayerName : \n%@ date", self.score, self.playerName, self.date];
//}

-(NSString *)getPlayerName
{
    NSLog(@"%@", self.playerName);
    return self.playerName;
}

-(NSString *)getScore
{
    
    NSString * scoreString = [self.score stringValue];
    NSLog(@"%@",scoreString);
    return scoreString;
}

-(NSString *)getDate
{
    NSLog(@"%@", self.date);
        return self.date;
}

@end
