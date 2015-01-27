//
//  Model.m
//  Quizzy
//
//  Created by Lucas on 13/01/15.
//  Copyright (c) 2015 GSL. All rights reserved.
//

#import "Model.h"
#import "AppDelegate.h"

@interface Model ()
//@property (nonatomic, strong) NSMutableString *jsonQuestions;
@end

@implementation Model

/*
 -(void)connexion
{
self.jsonQuestions = [[NSMutableString alloc] initWithUTF8String:""];
NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.parse.com/1/functions/Quizzy"]];
request.HTTPMethod = @"POST";
[request setValue:@"UVTVIdLgjILqOhCY2yiq0p2eKj8W7ZyNJcKulXTq" forHTTPHeaderField:@"X-Parse-Application-Id"];
[request setValue:@"a0egq79FWFd2orj7lcj4gkTfQvxcpoLUhY6kNREY" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
[request setValue:@" application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
[[NSURLConnection alloc] initWithRequest:request delegate:self];
// Do any additional setup after loading the view, typically from a nib.
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    self.jsonQuestions = [[NSMutableString alloc] initWithUTF8String:""];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"Succeeded! Received %lu bytes of data to append",(unsigned long)[data length]);
    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(newStr);
    [self.jsonQuestions appendString:newStr];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.jsonQuestions length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSLog(@"BeforeJSON");
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[self.jsonQuestions dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&myError];
    
    NSLog(@"AfterJSON");
    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
        
        
    }
    _s1.text = [[[res objectForKey:@"result"]objectAtIndex:0]objectForKey:@"question"];
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
        
        
    }
    nombreQuestion = (NSInteger) [[res objectForKey:@"result"] count];
    
}
*/


-(BOOL)getQuestion
{
    AppDelegate * myAppDelegate = [[UIApplication sharedApplication ]delegate];
    NSManagedObjectContext * context = [myAppDelegate managedObjectContext];
    NSEntityDescription * newQuestion = [NSEntityDescription entityForName:@"Questions" inManagedObjectContext:context];
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    [request setEntity:newQuestion];
    
    NSString * monIdDeTest = 0;
    
    NSPredicate * query = [NSPredicate predicateWithFormat:@"id = %", monIdDeTest];
    [request setPredicate:query];
    NSError * error;
    NSArray * tableauResult = [context executeFetchRequest:request error:&error];
    if([tableauResult count]>0)
    {
        NSManagedObjectContext * monObjetTrouve = [tableauResult objectAtIndex:0];
        NSLog(@"La question est : %@ ",[monObjetTrouve valueForKey:@"questionLabel"]);
        NSLog(@"Réponse 1 : %@", [monObjetTrouve valueForKey:@"correctAnswer"]);
        NSLog(@"Réponse 2 : %@", [monObjetTrouve valueForKey:@"wrongAnswer1"]);
        NSLog(@"Réponse 3 : %@", [monObjetTrouve valueForKey:@"wrongAnswer2"]);
        NSLog(@"Réponse 4 : %@", [monObjetTrouve valueForKey:@"wrongAnswer3"]);
    }
    else
    {
        NSLog(@"Pas de questions");
    }
    
    return true;
}

-(BOOL)setQuestionInCoreData:(NSString *)questionFlux
{
    
    NSString * _questionLabel;
    NSString * _correctAnswer;
    NSString * _wrongAnswer1;
    NSString * _wrongAnswer2;
    NSString * _wrongAnswer3;
    
    
    NSArray * parsedFlux = [questionFlux componentsSeparatedByString:@";"];
    
    _questionLabel = [parsedFlux objectAtIndex:0 ];
    NSLog(@"%@",_questionLabel);
    
    
    
    
    
    
    //Sauvegarde dans le coreData
    
    AppDelegate * myAppDelegate = [[UIApplication sharedApplication ]delegate];
    
    NSManagedObjectContext * context = [myAppDelegate managedObjectContext ];
    NSManagedObject * newQuestion;
    
        newQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"Questions" inManagedObjectContext:context];
    
        [newQuestion setValue:_questionLabel forKey:@"questionLabel"];
        [newQuestion setValue:_correctAnswer forKey:@"correctAnswer"];
        [newQuestion setValue:_wrongAnswer1 forKey:@"wrongAnswer1"];
        [newQuestion setValue:_wrongAnswer2 forKey:@"wrongAnswer2"];
        [newQuestion setValue:_wrongAnswer3 forKey:@"wrongAnswer3"];
        
        NSError * error;
        [context save:&error];
    
    return true;
}



@end
