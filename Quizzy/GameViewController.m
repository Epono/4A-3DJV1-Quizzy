//
//  GameViewController.m
//  Quizzy
//
//  Created by Lucas on 15/01/15.
//  Copyright (c) 2015 GSL. All rights reserved.
//

#import "GameViewController.h"
#import "Model.h"
//va degager
#import "AppDelegate.h"

@interface GameViewController ()

@property(nonatomic)Model * monModele;

//va degager
@property AppDelegate * myAppDelegate;

@end

@implementation GameViewController

float timeRemaining;
NSTimer* progressTimer;
int score;
int currentQuestionsCount;
int currentCorrectAnswerIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _button1.tag = 0;
    [_button1 addTarget:self
                 action:@selector(answerQuestionWithAnswer:)
       forControlEvents:UIControlEventTouchUpInside];
    
    _button2.tag = 1;
    [_button2 addTarget:self
                 action:@selector(answerQuestionWithAnswer:)
       forControlEvents:UIControlEventTouchUpInside];

    _button3.tag = 2;
    [_button3 addTarget:self
                 action:@selector(answerQuestionWithAnswer:)
       forControlEvents:UIControlEventTouchUpInside];
    
    _button4.tag = 3;
    [_button4 addTarget:self
                 action:@selector(answerQuestionWithAnswer:)
       forControlEvents:UIControlEventTouchUpInside];
    
    _titleLabel.text = @"Question 1 :";
    _progressLabel.text = @"Il reste 180 secondes !";
    
    [_giveUpButton addTarget:self
                      action:@selector(giveUp)
            forControlEvents:UIControlEventTouchUpInside];
    
    [_skipButton addTarget:self
                    action:@selector(skipQuestion)
          forControlEvents:UIControlEventTouchUpInside];
    
    [self startGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startGame {
    // Initialisation du timer de jeu
    timeRemaining = 1;
    
    progressTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1f
                                                     target: self
                                                   selector: @selector(updateTimer)
                                                   userInfo: nil
                                                    repeats: YES];
    
    currentQuestionsCount = 1;
    score = 0;
    
    [self displayNextQuestion];
}

// Update le timer de temps restant
-(void) updateTimer {
    if(timeRemaining <= 0) {
        [progressTimer invalidate];
        //TODO: Fin la partie, afficher le score et renvoyer au menu principal
    }
    else {
        timeRemaining -= ((float)1/(float)180);
        int roundedTimeRemaining = roundf(timeRemaining * 180);
        _progressLabel.text = [[@"Il reste " stringByAppendingString:[NSString stringWithFormat:@"%d", roundedTimeRemaining]] stringByAppendingString:@" secondes !"];
        _progress2.progressTintColor = [UIColor colorWithRed:1 - timeRemaining green:0 blue:timeRemaining alpha:1];
        _progress2.progress = timeRemaining;
    }
}

// A appeller en fournissant l'id de la question et de la réponse, gère le score(affiche un message si la réponse est bonne ou pas ?)
-(void) answerQuestionWithAnswer:(id)sender {
     UIButton *clicked = (UIButton *) sender;
    
    int answerId = (int) clicked.tag;
    
    //Maj du score et affichage d'un message si réponse bonne/pas bonne
    if(answerId == currentCorrectAnswerIndex) {
        //TODO: Afficher un ptit bandeau pour dire que la réponse est la bonne
        NSLog(@"Bonne réponse !");
        score++;
    }
    else {
        //TODO: Afficher un ptit bandeau pour dire que la réponse est fausse, et indiquer la bonne
        NSLog(@"Mauvaise réponse !");
        score--;
    }
    
    currentQuestionsCount++;
    
    [self displayNextQuestion];
}

// A appeller pour afficher la question suivante  (après avoir répondu à une question)
-(void) displayNextQuestion {
    Question* question;
    /********************************** Recuperer les bonnes valeurs **********************/
    question = [self getQuestion];
    /**************************************************************************************/
    
    // Recuperer une question
    // question = [model getQuestion];
    
    //Mélanger les réponses
    int randomNumber = arc4random() % 4; // 0, 1, 2, 3
    currentCorrectAnswerIndex = randomNumber;
    
    NSString* answerA;
    NSString* answerB;
    NSString* answerC;
    NSString* answerD;
    
    switch (randomNumber) {
        case 0:
            answerA = question.correctAnswer;
            
            answerB = question.wrongAnswer1;
            answerC = question.wrongAnswer2;
            answerD = question.wrongAnswer3;
            break;
        case 1:
            answerB = question.correctAnswer;
            
            answerA = question.wrongAnswer1;
            answerC = question.wrongAnswer2;
            answerD = question.wrongAnswer3;
            break;
        case 2:
            answerC = question.correctAnswer;
            
            answerA = question.wrongAnswer1;
            answerB = question.wrongAnswer2;
            answerD = question.wrongAnswer3;
            break;
        case 3:
            answerD = question.correctAnswer;
            
            answerA = question.wrongAnswer1;
            answerB = question.wrongAnswer2;
            answerC = question.wrongAnswer3;
            break;
    }

    _titleLabel.text = [[@"Question " stringByAppendingString:[NSString stringWithFormat:@"%d", currentQuestionsCount]] stringByAppendingString:@" :"];
    
    _questionLabel.text = question.questionLabel;
    
    [_button1 setTitle: [@"A) " stringByAppendingString:answerA] forState: UIControlStateNormal];
    [_button2 setTitle: [@"B) " stringByAppendingString:answerB] forState: UIControlStateNormal];
    [_button3 setTitle: [@"C) " stringByAppendingString:answerC] forState: UIControlStateNormal];
    [_button4 setTitle: [@"D) " stringByAppendingString:answerD] forState: UIControlStateNormal];
}

// Passe la question courante (malus ?) affiche la question suivante
-(void) skipQuestion {
    // Eventuellement, calculer un malus au score
    //TODO: dire "bouh"
    
    currentQuestionsCount++;
    [self displayNextQuestion];
}

// Abandon
-(void)giveUp {
    //TODO: demander confirmation
    
    //TODO: Arreter tout (timers, etc)
    [progressTimer invalidate];
    
    //TODO: Sauvegarder score
    
    //TODO: Retour au menu principal
}

/****************************************************************** Va degager, test*******************************************************************************/
-(Question*)getQuestion
{
    AppDelegate * myAppDelegate = [[UIApplication sharedApplication ]delegate];
    NSManagedObjectContext * context = [myAppDelegate managedObjectContext];
    
    // get count of entities
    NSFetchRequest *myRequest = [[NSFetchRequest alloc] init];
    [myRequest setEntity: [NSEntityDescription entityForName:@"Questions" inManagedObjectContext:context]];
    NSError *error = nil;
    NSUInteger myEntityCount = [context countForFetchRequest:myRequest error:&error];
    
    //
    // add another fetch request that fetches all entities for myEntityName -- you fill in the details
    // if you don't trigger faults or access properties this should not be too expensive
    //
    NSFetchRequest* allRequest = [[NSFetchRequest alloc]init];
    [allRequest setEntity: [NSEntityDescription entityForName:@"Questions" inManagedObjectContext:context]];
    [allRequest setPredicate:nil];
    [allRequest setReturnsObjectsAsFaults:NO];
    NSError * allRequestError;
    NSArray *myEntities = [context executeFetchRequest:allRequest error:&allRequestError];
    
    //
    // sample with replacement, i.e. you may get duplicates
    //
    int randomNumber = arc4random() % myEntityCount;
    QuestionManagedObject* questionManagedObjectRandom = [myEntities objectAtIndex:randomNumber];
    Question* questionRandom = [[Question alloc] initWithQuestionManagedObject:questionManagedObjectRandom];
    return questionRandom;
    
    
    /*
     NSEntityDescription * newQuestion = [NSEntityDescription entityForName:@"Questions" inManagedObjectContext:context];
     NSFetchRequest * request = [[NSFetchRequest alloc]init];
     [request setEntity:newQuestion];
     
     NSString * monIdDeTest = @"0";
     
     NSPredicate * query = [NSPredicate predicateWithFormat:@"id = %@", monIdDeTest];
     [request setPredicate:query];
     NSError * error;
     NSArray * tableauResult = [context executeFetchRequest:request error:&error];
     if([tableauResult count]>0)
     {
     NSManagedObjectContext * monObjetTrouve = [tableauResult objectAtIndex:1];
     NSLog(@"La question est : %@ ",[monObjetTrouve valueForKey:@"questionLabel"]);
     NSLog(@"Réponse 1 : %@", [monObjetTrouve valueForKey:@"correctAnswer"]);
     NSLog(@"Réponse 2 : %@", [monObjetTrouve valueForKey:@"wrongAnswer1"]);
     NSLog(@"Réponse 3 : %@", [monObjetTrouve valueForKey:@"wrongAnswer2"]);
     NSLog(@"Réponse 4 : %@", [monObjetTrouve valueForKey:@"wrongAnswer3"]);
     }
     else
     {
     NSLog(@"Pas de questions");
     }*/
    
    //return nil;
}
/************************************************************************************************************************************************************************************/

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
