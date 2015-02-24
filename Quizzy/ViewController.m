//
//  ViewController.m
//  Quizzy
//
//  Created by Etudiant on 17/12/2014.
//  Copyright (c) 2014 GSL. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
#import <CoreData/CoreData.h>
#import "QuestionManagedObject.h"
#import "Reachability.h"
#import "AFNetworking.h"

@interface ViewController ()

@property(nonatomic)Model * monModele;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a
    
    _monModele = [[Model alloc]init];
    
    NSLog(@"%hhd",[_monModele setConnexion]);
    
    
}
    


@end
