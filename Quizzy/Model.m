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
            //NSLog(@"%@", questions);
            
            
            /*
            for (NSMutableDictionary *question in questions) {
                NSLog(@"Q: %@", [question objectForKey:@"text"]);
                NSMutableArray* answers = [question objectForKey:@"answers"];
                for (NSMutableDictionary *answer in answers) {
                    int i = (int)[answer objectForKey:@"correct"];
                    if(i == 19) {
                        NSLog(@"RV: %@", [answer objectForKey:@"text"]);
                    } else {
                        NSLog(@"RF: %@", [answer objectForKey:@"text"]);
                    }
                }
            }
            */
           

            
            for (NSMutableDictionary *question in questions) {
                [self setQuestionInCoreData:question];
            }
            //Question* q = [self getQuestion];
            //NSLog(@"%@", q.description);
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
        int i = (int)[answer objectForKey:@"correct"];
        if(i == 19) {
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

    /*
    NSDictionary *question;
    
    NSString  * _monIdString;
    // int i = 0;
    // if(i == 0)
    // {
    //     _monId = 0;
    // }
    // i=i+1;
    
    
    
    // _monId= _monId +1;
    //_monIdString = _monId  ;
    //  [_monIdString integerValue];
    //  _monIdString = [_monIdString substringFromIndex:_monId];
    NSString * _questionLabel;
    NSString * _correctAnswer;
    NSString * _wrongAnswer1;
    NSString * _wrongAnswer2;
    NSString * _wrongAnswer3;
    
    
    NSArray * parsedFlux = [questionFlux componentsSeparatedByString:@";"];
    
    _questionLabel = [parsedFlux objectAtIndex:0 ];
    _correctAnswer = [parsedFlux objectAtIndex:1];
    _wrongAnswer1 = [parsedFlux objectAtIndex:2];
    _wrongAnswer2 = [parsedFlux objectAtIndex:3];
    _wrongAnswer3 = [parsedFlux objectAtIndex:4];
    _monIdString=@"0";
    
    // Faire l'assignation des objets du tableau en mes NSString
    NSLog(@"%@",_questionLabel);
    NSLog(@"%@",_correctAnswer);
    NSLog(@"%@",_wrongAnswer1);
    NSLog(@"%@",_wrongAnswer2);
    NSLog(@"%@",_wrongAnswer3);
    NSLog(@"%@",_monIdString);
    
    
    
    //_monIdString=@"1";
    
    
    //Sauvegarde dans le coreData
    
    AppDelegate * myAppDelegate = [[UIApplication sharedApplication ]delegate];
    
    NSManagedObjectContext * context = [myAppDelegate managedObjectContext];
    NSManagedObject * newQuestion;
    
    newQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"Questions" inManagedObjectContext:context];
    
    [newQuestion setValue:_questionLabel forKey:@"questionLabel"];
    [newQuestion setValue:_correctAnswer forKey:@"correctAnswer"];
    [newQuestion setValue:_wrongAnswer1 forKey:@"wrongAnswer1"];
    [newQuestion setValue:_wrongAnswer2 forKey:@"wrongAnswer2"];
    [newQuestion setValue:_wrongAnswer3 forKey:@"wrongAnswer3"];
    [newQuestion setValue:_monIdString forKey:@"id" ];
    
    NSError * error;
    [context save:&error];
    */
}



@end
