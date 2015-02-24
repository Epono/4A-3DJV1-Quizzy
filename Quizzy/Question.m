//
//  Question.m
//  Quizzy
//
//  Created by dev2 on 24/02/2015.
//  Copyright (c) 2015 GSL. All rights reserved.
//

#import "Question.h"

@implementation Question

- (id) init {
    self = [super init];
    return self;
}

- (id) initWithQuestionManagedObject:(QuestionManagedObject*) questionManagedObject {
    self = [super init];
    
    self.questionLabel = [questionManagedObject valueForKey:@"questionLabel"];
    self.correctAnswer = [questionManagedObject valueForKey:@"correctAnswer"];
    self.wrongAnswer1 = [questionManagedObject valueForKey:@"wrongAnswer1"];
    self.wrongAnswer2 = [questionManagedObject valueForKey:@"wrongAnswer2"];
    self.wrongAnswer3 =  [questionManagedObject valueForKey:@"wrongAnswer3"];
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"\nQuestion : %@\nRéponses : \n  - %@ (vraie)\n  - %@ (fausse)\n  - %@ (fausse)\n  - %@ (fausse)\n", self.questionLabel, self.correctAnswer, self.wrongAnswer1, self.wrongAnswer2, self.wrongAnswer3];
}

@end
