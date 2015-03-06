//
//  CustomCell.m
//  TestAFNetworking
//
//  Created by Etudiant on 23/01/2015.
//  Copyright (c) 2015 nope. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _playerImage = [[UIImageView alloc]init];
        _playerImage.frame = CGRectMake((self.frame.size.width - 60) / 2,
                                         0,
                                         60,
                                         60);
               [self addSubview:_playerImage];
        
        _playerName = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                             0,
                                                             self.frame.size.width - _playerImage.frame.origin.x,
                                                             30)];
        _playerName.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
                 [self addSubview:_playerName];
        
        _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                          CGRectGetMaxY(_playerName.frame),
                                                          self.frame.size.width - _playerImage.frame.origin.x,
                                                          30)];
        _scoreLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
       
        [self addSubview:_scoreLabel];

        
        
        _score = [[UILabel alloc]initWithFrame:CGRectMake(60,
                                                              CGRectGetMaxY(_playerName.frame),
                                                              self.frame.size.width - 100,
                                                              30)];
        _score.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        
        [self addSubview:_score];
        
        _date = [[UILabel alloc]initWithFrame:CGRectMake(100,
                                                         0,
                                                         self.frame.size.width - 100,
                                                         30)];
        
        _date.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        
        [self addSubview:_date];
        self.backgroundColor = [[UIColor alloc]initWithRed:0 green:0.2f blue:0.6f alpha:0.6];
    }
    return self;
}

-(void)awakeFromNib {
    // Initialization code
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    //Configure the view for the selected state
}


@end
