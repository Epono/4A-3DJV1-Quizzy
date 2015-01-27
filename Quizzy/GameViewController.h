//
//  GameViewController.h
//  Quizzy
//
//  Created by Lucas on 15/01/15.
//  Copyright (c) 2015 GSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController

@property IBOutlet UILabel * titleLabel;
@property IBOutlet UILabel * questionLabel;

@property IBOutlet UIButton * button1;
@property IBOutlet UIButton * button2;
@property IBOutlet UIButton * button3;
@property IBOutlet UIButton * button4;

@property(nonatomic, retain) NSMutableArray *questionsArray;

@property(nonatomic, retain) IBOutlet UIProgressView *progress2;
@property(nonatomic, retain) IBOutlet UILabel *progressLabel;

@property(weak, nonatomic) IBOutlet UIButton *giveUpButton;
@property(weak, nonatomic) IBOutlet UIButton *skipButton;

@end
