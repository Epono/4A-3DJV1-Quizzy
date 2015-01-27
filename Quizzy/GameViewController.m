//
//  GameViewController.m
//  Quizzy
//
//  Created by Lucas on 15/01/15.
//  Copyright (c) 2015 GSL. All rights reserved.
//

#import "GameViewController.h"
#import "Model.h"

@interface GameViewController ()

@property(nonatomic)Model * monModele;

@end

@implementation GameViewController

float timeRemaining;
NSTimer* progressTimer;
int score;
int currentQuestionsCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Arrivée sur l'écran des questions !");
    
    // Do any additional setup after loading the view.
    
    /********************************** Ca va degager *************************************/
    _questionLabel.text = @"Quelle est la couleur du cheval blanc de Henry IV ?";
    
    [_button1 setTitle: @"A) Blanc" forState: UIControlStateNormal];
    [_button2 setTitle: @"B) Chaussette" forState: UIControlStateNormal];
    [_button3 setTitle: @"C) 42" forState: UIControlStateNormal];
    [_button4 setTitle: @"D) Réponse D" forState: UIControlStateNormal];
    /**************************************************************************************/
    
    _titleLabel.text = @"Question 1 :";
    _progressLabel.text = @"Il reste 180 secondes !";
    
    [self startGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startGame {
    // Initialisation du timer de jeu
    timeRemaining = 1;          // La valeur max d'une UIProgressView c'est 1
    
    progressTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1f
                                                     target: self
                                                   selector: @selector(updateTimer)
                                                   userInfo: nil
                                                    repeats: YES];
    
    currentQuestionsCount = 1;
    score = 0;
    
    
    //Récupération des questions
    // Soit dans le coreData si y'en a plein, soit en réseau si y'en a plus trop
    
    // Affiche
}

// Update le timer de temps restant
-(void) updateTimer {
    if(timeRemaining <= 0) {
        [progressTimer invalidate];
        // Fin la partie, afficher le score et renvoyer au menu principal
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
-(void) answerQuestionWithAnswer:(int)answerId {
    // Indique si la réposne est bonne ou laquelle est la bonne
    
    //Maj du score et affichage d'un message si réponse bonne/pas bonne
    if(answerId == 0) {
        // Afficher un ptit bandeau pour dire que la réponse est la bonne
        score++;
    }
    else {
        // Afficher un ptit bandeau pour dire que la réponse est fausse, et indiquer la bonne
        score--;
    }
    
    currentQuestionsCount++;
    
    // Affiche question suivante
    [self displayNextQuestion];
}

// A appeller pour afficher la question suivante  (après avoir répondu à une question)
-(void) displayNextQuestion {
    // Va chercher une réponse aléatoirement et l'affiche
    
    /********************************** Recuperer les bonnes valeurs **********************/
    NSString* text = @"Il est quelle heure ?";
    NSString* answerA = @"gjdg";
    NSString* answerB = @"gjdg";
    NSString* answerC = @"gjdg";
    NSString* answerD = @"gjdg";
    /**************************************************************************************/

    _titleLabel.text = [[@"Question " stringByAppendingString:[NSString stringWithFormat:@"%d", currentQuestionsCount]] stringByAppendingString:@" :"];
    
    _questionLabel.text = text;
    
    [_button1 setTitle: [@"A) " stringByAppendingString:answerA] forState: UIControlStateNormal];
    [_button2 setTitle: [@"B) " stringByAppendingString:answerB] forState: UIControlStateNormal];
    [_button3 setTitle: [@"C) " stringByAppendingString:answerC] forState: UIControlStateNormal];
    [_button4 setTitle: [@"D) " stringByAppendingString:answerD] forState: UIControlStateNormal];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
