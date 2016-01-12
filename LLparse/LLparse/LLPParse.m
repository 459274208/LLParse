//
//  LLParse.m
//  LLparse
//
//  Created by silence on 16/1/11.
//  Copyright © 2016年 tianyun. All rights reserved.
//

#import "LLParse.h"
@interface LLParse ()

@property (nonatomic,strong) NSMutableString *rootKey;
@property (nonatomic,strong) NSMutableArray *responseObjectArr;
@property (nonatomic,strong) NSDictionary *changeParaments;


@end
@implementation LLParse
+ (instancetype)parseData:(id)responseObject
            withParaments:(NSDictionary *)changeParaments{
    
    LLParse *parse = [LLParse new];
    parse.allData = [NSMutableDictionary new];
    parse.rootKey = [NSMutableString new];
    parse.changeParaments = changeParaments;
    
    for (id obj in [parse.changeParaments allValues]) {
        if ([obj isKindOfClass:[NSString class]]) {
            
            [parse.rootKey appendString:@"&"];
            [parse.rootKey appendString:obj];
        }else{
            
            [parse.rootKey appendString:@"&"];
            [parse.rootKey appendString:[obj stringValue]];
        }
    }
    [parse.allData setValue:responseObject forKey:parse.rootKey];
    
    NSInteger count = 0;
    while (parse.allData.count != count) {
        
        count = parse.allData.count;
        for (NSString * key in [parse.allData allKeys]) {
            
            if ([[parse.allData objectForKey:key] isKindOfClass:[NSDictionary class]]) {//调用字典解析方法
                
                if (((NSDictionary *)parse.allData[key]).count == 1) {count *= 7;}
                
                [parse.allData setValuesForKeysWithDictionary:[parse parseDic:parse.allData[key] withKey:key]];
                [parse.allData removeObjectForKey:key];
            }
            else if ([parse.allData [key] isKindOfClass:[NSArray class]]) {//调用数组解析方法
                
                if (((NSArray *)parse.allData[key]).count == 1) { count *= 7;}
                
                [parse.allData setValuesForKeysWithDictionary:[parse parseArr:parse.allData[key] withKey:key]];
                [parse.allData removeObjectForKey:key];
            }
        }
    }
    [parse.responseObjectArr addObject:parse.allData];
    return parse;
}
//字典解析
- (NSMutableDictionary *) parseDic:(NSDictionary *)dic
                           withKey:(NSString *)key{
    
    NSMutableDictionary *transDic = [NSMutableDictionary new];
    
    for (NSString *string  in [dic allKeys]) {
        
        NSMutableString *newKey = [NSMutableString stringWithFormat:@",%@,%@",key,string];
        
        if ([newKey hasPrefix:@","]) {
            
            [transDic setValue:[dic objectForKey:string] forKey:[newKey substringFromIndex:[newKey rangeOfString:_rootKey].location]];
        }
        
    }
    return transDic;
}

//数组解析
- (NSMutableDictionary *) parseArr:(NSArray *)arr
                           withKey:(NSString *)key{
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (id obj in arr) {
        
        NSString *newKey = [NSString stringWithFormat:@"@%@,[_%lu_]",key,(unsigned long)[arr indexOfObject:obj]];
        [dic setValue:obj forKey:newKey];
    }
    
    [dic setValue:[NSNumber numberWithInteger: arr.count] forKey:[NSString stringWithFormat:@"%@^.^Count",key]];
    
    return dic;
}
#pragma mark 获取数据
-(id)objectForKey:(NSString *)key
            index:(NSIndexPath *)indexPath{

    if (indexPath) {//返回某一位置的全部信息（比如第一个cell上的所有数据）
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        NSString *wantedSection = [NSString stringWithFormat:@"[_%ld_]",(long)indexPath.section];
        NSString *wantedRow = [NSString stringWithFormat:@"[_%ld_]",indexPath.row];
        
        for (NSString * dataKey in _allData.allKeys) {
            
            NSRange sectionRange = [dataKey rangeOfString:wantedSection];
            if(sectionRange.length || indexPath.section == 0){
                
                NSRange rowRange = [dataKey rangeOfString:wantedRow];
                if (rowRange.length && (rowRange.location > sectionRange.location||indexPath.section == 0) )
                {
                    
                    NSRange pointRange = [dataKey rangeOfString:@"," options:NSBackwardsSearch];
                    [dic setObject:_allData[dataKey] forKey:[dataKey substringFromIndex:pointRange.location + 1]];
                }
            }
        }
        
        if (key) {
            return dic[key];
        }else{
            return dic;
        }
    }
    if (key) {//返回拥有某一类全部数据的数组（比如通讯录tableView中所有的人名，有顺序）
        
        if ([key hasSuffix:@"^.^Count"]) {
            
            for (NSString * dataKey in _allData.allKeys) {
                if ([dataKey hasSuffix:key]) {
                    
                    return _allData[dataKey];
                }
            }
        }
        
        NSMutableArray *arr = [NSMutableArray new];
        NSMutableString *wantedKey;

        for (NSString * dataKey in _allData.allKeys) {
                
            if ([dataKey hasSuffix:key]) {//获取alldata中的key值模板
                wantedKey = [NSMutableString stringWithString:dataKey];
            }
        }
        
        NSRange range = [wantedKey rangeOfString:@",[_"];
        range.location += 3;
        range.length = 1;
        for (int i = 0; 1 ; i++) {

            [wantedKey deleteCharactersInRange:range];
            [wantedKey insertString:[NSString stringWithFormat:@"%d",i] atIndex:range.location];
            if (!_allData[wantedKey])  break;
            [arr addObject:_allData[wantedKey]];
        }
        
        return arr;
    }
    
    return nil;
}
@end
