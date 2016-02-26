//
//  LLParseManager.m
//  LLparse
//
//  Created by vnetoo on 16/1/12.
//  Copyright © 2016年 tianyun. All rights reserved.
//

#import "LLParseManager.h"
#import "LLParse.h"
@interface LLParseManager()
//每次请求数据的组数
@property(nonatomic,assign)NSInteger incremental;

@end
@implementation LLParseManager

- (void)parseData:(id)responseObject
             with:(NSDictionary *)changeParaments
          observe:(NSString *)key
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
        _incremental = 1;
    }
    
    LLParse *parse = [LLParse parseData:responseObject withParaments:changeParaments];
    NSInteger number =  [[parse objectForKey:key index:nil] integerValue];
    
    if(!_dataArr.count){
        
        _incremental = number;
    }
    _count += number;
    [_dataArr addObject:parse];
    
    
}
-(id)objectForKey:(NSString *)key
            index:(NSIndexPath *)indexPath{
    
    NSInteger relativeRow = indexPath.row < _incremental ? indexPath.row : indexPath.row%_incremental;
    NSIndexPath *path = [NSIndexPath indexPathForRow:relativeRow inSection:indexPath.section];
    
    return [_dataArr[indexPath.row /_incremental] objectForKey:nil index:path];;
}
-(void)removeAllData{
    
    [_dataArr removeAllObjects];
    _count = 0;
}
@end
