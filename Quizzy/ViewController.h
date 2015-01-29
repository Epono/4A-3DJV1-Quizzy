//
//  ViewController.h
//  Quizzy
//
//  Created by Etudiant on 17/12/2014.
//  Copyright (c) 2014 GSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
@interface ViewController : UIViewController

@property(nonatomic, retain) IBOutlet UILabel *gameTitle;
@property(nonatomic, retain) GameViewController *gameViewController;
@end
