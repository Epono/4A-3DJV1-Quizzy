//
//  Model.m
//  Quizzy
//
//  Created by Lucas on 13/01/15.
//  Copyright (c) 2015 GSL. All rights reserved.
//


#import "Model.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "QuestionManagedObject.h"
#import "Question.h"
#import "Score.h"

@interface Model ()
//@property (nonatomic, strong) NSMutableString *jsonQuestions;
@property AppDelegate * myAppDelegate;
@property NSUInteger monId;

@end

@implementation Model

-(BOOL)isConnected
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.ipcrea.com"];
    NetworkStatus remoteStatus = [reachability currentReachabilityStatus];
    
    if(remoteStatus == NotReachable)
        return FALSE;
    
    if(remoteStatus == ReachableViaWWAN)
        return TRUE;
    
    if(remoteStatus == ReachableViaWiFi)
        return TRUE;
    
    return FALSE;
}


-(BOOL)setConnexion
{
    BOOL connexionResult = false;
    
    _gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    //Initialisation de l'interface
    _monLabel.text=@"Quizzy";
    
    NSArray *tableauDeCheminIphone = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cheminDuRepertoireDocument = [tableauDeCheminIphone objectAtIndex:0];
    NSString *cheminGlobal = [cheminDuRepertoireDocument stringByAppendingString:@"/questions.json"];
    
    if([self isConnected])
    {
        NSLog(@"connecte");
        connexionResult = true;
        dispatch_queue_t queue = dispatch_queue_create("queue asynchrone", NULL);
        dispatch_async(queue, ^{
            NSURL *url = [NSURL URLWithString:@"http://195.154.117.238/battlequiz/flux.php?action=quiz"];
            NSData *data = [NSData dataWithContentsOfURL:url];
            [data writeToFile:cheminGlobal atomically:YES];
            //Sert a quoi ?
        });
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://195.154.117.238/battlequiz/flux.php?action=quiz" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSMutableDictionary *jsonResponse = (NSMutableDictionary *)responseObject;
            NSMutableArray *questions = (NSMutableArray *)[jsonResponse objectForKey:@"questions"];
            
            _gameViewController.questionsArray = questions;
          
           

            
            for (NSMutableDictionary *question in questions) {
                [self setQuestionInCoreData:question];
            }
           
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    else
    {
        NSLog(@"non connecte");
        NSError *error;
        NSString *jsonString = [NSString stringWithContentsOfFile:cheminGlobal encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"%@", jsonString);
    }
    return connexionResult;
}

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
    
    
    
}

-(BOOL)setQuestionInCoreData:(NSMutableDictionary *)question
{
    //Sauvegarde dans le coreData
    
    AppDelegate * myAppDelegate = [[UIApplication sharedApplication ]delegate];
    
    NSManagedObjectContext * context = [myAppDelegate managedObjectContext];
    NSManagedObject * newQuestion;
    
    newQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"Questions" inManagedObjectContext:context];
    
    //NSLog(@"Q: %@", [question objectForKey:@"text"]);
    [newQuestion setValue:[question objectForKey:@"text"] forKey:@"questionLabel"];
    
    NSMutableArray* answers = [question objectForKey:@"answers"];
    int j = 1;
    
    for (NSMutableDictionary *answer in answers) {
        int i =[[answer objectForKey:@"correct"]integerValue];
        if(i == 1) {
            [newQuestion setValue:[answer objectForKey:@"text"] forKey:@"correctAnswer"];
            //NSLog(@"RV: %@", [answer objectForKey:@"text"]);
        } else {
            [newQuestion setValue:[answer objectForKey:@"text"] forKey:[@"wrongAnswer" stringByAppendingString:[NSString stringWithFormat:@"%d", j]]];
            j++;
            //NSLog(@"RF: %@", [answer objectForKey:@"text"]);
        }
    }
    
    NSError * error;
    [context save:&error];
    
    return true;

    }

-(BOOL)setScoreInCoreData:(NSNumber*)score
{
    NSDate * date = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    //NSLog(@"%t",);
    
    
    NSNumber * myScore = score;
    NSString * namePlayer = @"Lucas";
    AppDelegate * myAppDelegate = [[UIApplication sharedApplication ]delegate];
    
    NSManagedObjectContext * context = [myAppDelegate managedObjectContext];
    NSManagedObject * newScore;
    
    newScore = [NSEntityDescription insertNewObjectForEntityForName:@"HistoryScore" inManagedObjectContext:context];
    [newScore setValue:myScore forKey:@"score"];
    [newScore setValue:namePlayer forKey:@"playerName" ];
    [newScore setValue:date forKey:@"date"];
    
    return true;
}

-(NSArray *)getScore
{
    AppDelegate * myAppDelegate = [[UIApplication sharedApplication ]delegate];
    NSManagedObjectContext * context = [myAppDelegate managedObjectContext];
    
    // get count of entities
    NSFetchRequest *myRequest = [[NSFetchRequest alloc] init];
    [myRequest setEntity: [NSEntityDescription entityForName:@"HistoryScore" inManagedObjectContext:context]];
    NSError *error = nil;
    NSUInteger myEntityCount = [context countForFetchRequest:myRequest error:&error];
    
    //
    // add another fetch request that fetches all entities for myEntityName -- you fill in the details
    // if you don't trigger faults or access properties this should not be too expensive
    //
    NSFetchRequest* allRequest = [[NSFetchRequest alloc]init];
    [allRequest setEntity: [NSEntityDescription entityForName:@"HistoryScore" inManagedObjectContext:context]];
    [allRequest setPredicate:nil];
    [allRequest setReturnsObjectsAsFaults:NO];
    NSError * allRequestError;
    NSArray *myEntities = [context executeFetchRequest:allRequest error:&allRequestError];
    NSArray * myProperEntities;
    for( int i = 0; i < myEntityCount;i++)
    {
        ScoreManagedObject* scoreManagedObjectList = [myEntities objectAtIndex:i];
        Score* scoreList = [[Score alloc] initWithScoreManagedObject:scoreManagedObjectList];
        //Faire l'ajout dans la liste
        [myProperEntities arrayByAddingObject:scoreList];
    
    
    }
    return myProperEntities;
}



@end
