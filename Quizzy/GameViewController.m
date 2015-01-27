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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titleLabel.text = @"Question";
    
    _questionLabel.text = @"Quel est la couleure du cheval d'Henry IV ?";
    
    [_button1 setTitle: @"Réponse A" forState: UIControlStateNormal];
    [_button2 setTitle: @"Réponse B" forState: UIControlStateNormal];
    [_button3 setTitle: @"Réponse C" forState: UIControlStateNormal];
    [_button4 setTitle: @"Réponse D" forState: UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startGame
{
    //Initialisation du timer de jeu
    
    //Récupération des questions
    
    //Envoie
    ;
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
