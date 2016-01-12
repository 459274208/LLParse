//
//  LLCell.m
//  LLparse
//
//  Created by vnetoo on 16/1/12.
//  Copyright © 2016年 tianyun. All rights reserved.
//

#import "LLCell.h"
@interface LLCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *balabala;

@end
@implementation LLCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setCell:(NSDictionary *)info{
    
    //info[@"iconUrl"]  这里面的key 就是从服务器获得的数据的key值
    NSURL *url = [NSURL URLWithString:info[@"iconUrl"]];
    [_image setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];
    
    _title.text = info[@"name"];
    _balabala.text = info[@"description"];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
