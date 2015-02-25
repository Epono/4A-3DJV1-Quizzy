//
//  ScoresViewController.h
//  Quizzy
//
//  Created by Lucas on 15/01/15.
//  Copyright (c) 2015 GSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Score.h"
#import "ScoreManagedObject.h"


@interface ScoresViewController : UIViewController

@property IBOutlet UILabel * scoreTitle;
@property IBOutlet UILabel * playerNameTitle;
@property (nonatomic,strong) Score * score;
@property (nonatomic,strong) ScoreManagedObject * scoreManagedObject;


//-(NSArray)
@end
