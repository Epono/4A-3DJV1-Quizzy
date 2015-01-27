//
//  Question.h
//  Quizzy
//
//  Created by SebastienGlr on 16/01/15.
//  Copyright (c) 2015 GSL. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Question : NSManagedObject

@property(nonatomic, strong) NSString *correctAnswer, *questionLabel, *wrongAnswer1, *wrongAnswer2, *wrongAnswer3;

@end
