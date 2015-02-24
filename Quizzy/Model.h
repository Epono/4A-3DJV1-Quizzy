//
//  Model.h
//  Quizzy
//
//  Created by Lucas on 13/01/15.
//  Copyright (c) 2015 GSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameViewController.h"

@interface Model : NSObject

-(BOOL)getQuestion;
-(BOOL)setQuestionInCoreData:(NSMutableDictionary *)question;
-(BOOL)isConnected;
-(BOOL)setConnexion;
@property(nonatomic, retain) GameViewController *gameViewController;
@property IBOutlet UILabel * monLabel;

@end
