//
//  ScoresViewController.m
//  Quizzy
//
//  Created by Lucas on 15/01/15.
//  Copyright (c) 2015 GSL. All rights reserved.
//

#import "ScoresViewController.h"
#import "Model.h"
#import "CustomCell.h"
@interface ScoresViewController ()

@property (nonatomic) Model * model;

@end

@implementation ScoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scoreTitle.text = @"Score";
    _playerNameTitle.text = @"Joueur";
    _model = [[Model alloc]init];
    
    _mesDonnesArray = [_model getScore];
    
    _maListeTbv = [[UITableView alloc] init];
    _maListeTbv.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 150);
    _maListeTbv.delegate = self;
    _maListeTbv.dataSource = self;
    _maListeTbv.rowHeight = 60;
    _maListeTbv.separatorColor = [[UIColor alloc]initWithRed:0 green:0.7f blue:0.7f alpha:1];
    [self.view addSubview:_maListeTbv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//ICI LE TABLE VIEW
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [_mesDonnesArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellId = @"uniqueIdentifier";
    
    CustomCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    Score* currentScore = [_mesDonnesArray objectAtIndex:indexPath.row];
    
    if(!cell) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        
    }
    
    cell.playerName.text = currentScore.playerName;
    cell.scoreLabel.text = @"Score :";
    cell.score.text = [currentScore.score stringValue];
    
    //s'affiche pas
    cell.date.text = currentScore.date;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
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
