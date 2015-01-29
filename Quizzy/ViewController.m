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
#import "Question.h"
#import "Reachability.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    //Initialisation de l'interface
    _gameTitle.text=@"Quizzy";
    
    NSArray *tableauDeCheminIphone = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cheminDuRepertoireDocument = [tableauDeCheminIphone objectAtIndex:0];
    NSString *cheminGlobal = [cheminDuRepertoireDocument stringByAppendingString:@"/questions.json"];
    
    if([self isConnected])
    {
        NSLog(@"connecte");
        dispatch_queue_t queue = dispatch_queue_create("queue asynchrone", NULL);
        dispatch_async(queue, ^{
            NSURL *url = [NSURL URLWithString:@"http://195.154.117.238/battlequiz/flux.php?action=quiz"];
            NSData *data = [NSData dataWithContentsOfURL:url];
            [data writeToFile:cheminGlobal atomically:YES];
        });
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://195.154.117.238/battlequiz/flux.php?action=quiz" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSMutableDictionary *dict = (NSMutableDictionary *)responseObject;
            
            _gameViewController.questionsArray = [dict objectForKey:@"questions"];
            NSLog(@"%@", _gameViewController.questionsArray);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    else
    {
        NSLog(@"non connecte");
        NSError *error;
        NSString *jsonString = [NSString stringWithContentsOfFile:cheminGlobal encoding:NSUTF8StringEncoding error:&error];
    }

    
    /*
    
    id appdelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appdelegate managedObjectContext];
    
    //Lancement de la requête pour récupérer les questions
    self.jsonQuestions = [[NSMutableString alloc] initWithUTF8String:""];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://195.154.117.238/battlequiz/flux.php?action=quiz"]];
    request.HTTPMethod = @"POST";
    [request setValue:@"UVTVIdLgjILqOhCY2yiq0p2eKj8W7ZyNJcKulXTq" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setValue:@"a0egq79FWFd2orj7lcj4gkTfQvxcpoLUhY6kNREY" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];*/
}
/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    self.jsonQuestions = [[NSMutableString alloc] initWithUTF8String:""];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"Succeeded! Received %lu bytes of data to append",(unsigned long)[data length]);
    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.jsonQuestions length]);
    
    NSError *myError = nil;
    //Sérialisation du flux de question
    NSDictionary *questions = [NSJSONSerialization JSONObjectWithData:[self.jsonQuestions dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&myError];
    
    for(id question in [questions objectForKey:@"result"])
    {
        Question *newQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"Questions" inManagedObjectContext:self.managedObjectContext];
        [newQuestion setQuestionLabel:[question objectForKey:@"question"]];
        [newQuestion setCorrectAnswer:[question objectForKey:@"correctAnswer"]];
        [newQuestion setWrongAnswer1:[question objectForKey:@"wrongAnswer1"]];
        [newQuestion setWrongAnswer2:[question objectForKey:@"wrongAnswer2"]];
        [newQuestion setWrongAnswer3:[question objectForKey:@"wrongAnswer3"]];
        
        [self.managedObjectContext save:&myError];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}*/

@end
