//
//  Question.h
//  Quizzy
//
//  Created by dev2 on 24/02/2015.
//  Copyright (c) 2015 GSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionManagedObject.h"


@interface Question : NSObject

@property(nonatomic, strong) NSString *correctAnswer, *questionLabel, *wrongAnswer1, *wrongAnswer2, *wrongAnswer3;

- (id) init;
- (id) initWithQuestionManagedObject:(QuestionManagedObject*) questionManagedObject;
- (NSString *)description;
@end
