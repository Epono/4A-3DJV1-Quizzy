//
//  Model.h
//  Quizzy
//
//  Created by Lucas on 13/01/15.
//  Copyright (c) 2015 GSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameViewController.h"
#import "QuestionManagedObject.h"
#import "Question.h"

@interface Model : NSObject

-(Question*)getQuestion;
-(BOOL)setQuestionInCoreData:(NSMutableDictionary *)question;
-(BOOL)setScoreInCoreData:(NSNumber *)score;
-(BOOL)isConnected;
-(BOOL)setConnexion;
-(NSArray*)getScore;
@property(nonatomic, retain) GameViewController *gameViewController;
@property IBOutlet UILabel * monLabel;

@end
