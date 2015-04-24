//
//  LXPParse.m
//  AXM
//
//  Created by 不要叫我小兰(*^__^*)  on 15/3/10.
//  Copyright (c) 2015年 lxp. All rights reserved.
//
#import "LXPParse.h"
#import "AFNetworking.h"

@implementation LXPParse

{
    NSMutableArray *_data;
}
//请求
//如果需要解析网址中的全部信息,你只需要将网络地址传进来即可, messageLocation 处填nil
//如果需要解析网址中某一位置的数据 ,你需要将messageLocation参数传入,格式如下：
//@"@applications,[0],@categoryId" -- 这个参数的意思是 取字典中key为applications的对象（经软件解析，看到这个对像是个数组),再取该对象对象中的第0个对象（是个字典），再取这个字典中key为categoryId的对象
//参数messageLocation是一个字符串;
//字典的key以@开头(@key) ;
//数组用中括号括起来（[index]);
//路径用“,”分割

//changeParaments : 如果请求网址中变量在‘？’之后，使用@{@"parament":@"object"}
//                  如果请求网址中变量在‘？’之前，使用@{@"_LXP_ChangeParament":@"object"}
+ (void)getNetMessageFrom:(NSString *)stringOfURL changeParaments:(NSDictionary *)dic  messageLocation:(NSString *)stringOfLocation success:(void(^)(LXPParse * parse))success failure:(void(^)(NSError *error))failure;{
    //网址分析
    NSArray *arr = [NSArray new];
    if ([stringOfURL rangeOfString:@"?"].location != NSNotFound) {
        
        arr = [NSArray arrayWithArray: [self NetURLAnalysis:stringOfURL changeParaments:dic]];
    }else{
        arr = @[stringOfURL,@""];
    }
 
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:arr[0] parameters:arr[1] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (stringOfLocation == nil) {
            //如果 不输入数据地址，就进行全部解析
            success([[LXPParse new]  parse:responseObject]);
            
        }else{
            //如果 输入数据地址， 就进行部分解析
            success([LXPParse  parse:responseObject andMessageURL:stringOfLocation]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error:%@",error);
        
    }];
}

/* 地址分析*/
+ (NSArray *)NetURLAnalysis:(NSString *)netURL changeParaments:(NSDictionary *)dic{
    
    NSString *url;
    NSMutableDictionary *paramentsDic;
    
    if ([netURL rangeOfString:@"?"].location != NSNotFound) {
        
        url = [netURL substringToIndex:[netURL rangeOfString:@"?"].location+1];
        NSString *paraments = [netURL substringFromIndex:[netURL rangeOfString:@"?"].location+1];
        NSArray *paramentsArr = [paraments componentsSeparatedByString:@"&"];
        paramentsDic = [NSMutableDictionary new];
        for (NSString *string in paramentsArr) {
            if ( 0 == string.length ) {
                continue;
            }
            NSString * key = [string substringToIndex:[string rangeOfString:@"="].location];
            
            if ([string hasSuffix:@"="]) {
                [paramentsDic setValue:nil forKey:key];
            }else{
                NSString * value = [string substringFromIndex:[string rangeOfString:@"="].location+1];
                
                [paramentsDic setValue:value forKey:key];
            }
            //没有参数的key直接略过，经测试不影响获取结果
        }
        
    }
    NSMutableArray *arr = [NSMutableArray new];
    
    for (NSString *key  in [dic allKeys]) {
        if ([key isEqualToString:_LXP_ChangeParament]) {
           
            url = [netURL stringByReplacingOccurrencesOfString:_LXP_ChangeParament withString:[dic objectForKey:key]];
        }
        //将变化的参数替换
        [paramentsDic setValue:[dic objectForKey:key] forKey:key];
        
    }
    
    [arr addObject:url];
    [arr addObject:paramentsDic];

    return arr;
}

//分析数据位置、调用解析方法
+ (instancetype)parse:(id)data andMessageURL:(NSString *)MessageURL{
    
    LXPParse *parse = [LXPParse new];
    parse.pathData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *URLArr = [MessageURL componentsSeparatedByString:@","];
    
    for (NSString *string in URLArr) {
        
        if ([string hasSuffix:@"]"]) {
            
            parse.pathData = [self parseArr:parse.pathData RUL:string];
            
        }else if ([string hasPrefix:@"@"]){
            
            parse.pathData = [self parseDic:parse.pathData RUL:string];
            
        }
        
    }
    return  parse;
}

//解析
+ (instancetype )parseArr:(NSArray * )data RUL:(NSString *)url {
    
    
    NSString *string = [url substringWithRange:NSMakeRange([url rangeOfString:@"["].location+1, url.length-2-[url rangeOfString:@"["].location)];
    
    return  data[[string intValue]];
}

+ (instancetype)parseDic:(NSDictionary * )data RUL:(NSString *)url {
    
    
    return  [data objectForKey:[url substringFromIndex:1] ];
}

- (id)init{
    if (self = [super init]) {
        _data = [NSMutableArray new];
    }
    
    return self;
}



#pragma mark - 全部解析

- (instancetype)parse:(id)data{
    data = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    LXPParse * result=[LXPParse new];
    result.allData = [NSMutableDictionary new];
    [result.allData setValue:data forKey:@"begin"];
    NSInteger count = 0;
    
    while (result.allData.count != count) {
        count = result.allData.count;
        for (NSString * key in [result.allData allKeys]) {
          
            
            //判断是什么类型
            if ([[result.allData objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                //调用字典解析方法
                
                if (((NSDictionary *)[result.allData objectForKey:key]).count == 1) {
                    count ++;
                    //1.2版本更新，修复了字典套字典，并且只有一对key-value时不完全解析的bug
                }
                [result.allData setValuesForKeysWithDictionary:[self parseDic:[result.allData objectForKey:key] withKey:key]];
                
                [result.allData removeObjectForKey:key];
                
            }
            
            else if ([[result.allData objectForKey:key] isKindOfClass:[NSArray class]]) {
                if (((NSArray *)[result.allData objectForKey:key]).count == 1) {
                    count ++;
                    //1.2版本更新，修复了字典套字典，并且只有一对key-value时不完全解析的bug
                }
                [result.allData setValuesForKeysWithDictionary:[self parseArr:[result.allData objectForKey:key] withKey:key]];
       
                //将解析之前的字典删除
                [result.allData removeObjectForKey:key];
                
            }
           
            
        }
    }
    
    return result;
    
}

//字典解析
- (NSMutableDictionary *) parseDic:(NSDictionary *)dic
                           withKey:(NSString *)key{

    NSMutableDictionary *transDic = [NSMutableDictionary new];
    
    for (NSString *string  in [dic allKeys]) {
        
        NSMutableString *newKey = [NSMutableString stringWithFormat:@"@%@,@%@",key,string];
        
        if ([newKey hasPrefix:@"@"]) {
            
            [transDic setValue:[dic objectForKey:string] forKey:[newKey substringFromIndex:[newKey rangeOfString:@"@begin"].location]];
        }
        
    }
    return transDic;
}

//数组解析
- (NSMutableDictionary *) parseArr:(NSArray *)arr
                           withKey:(NSString *)key{
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (id object in arr) {
        if ([object isKindOfClass:[NSDictionary class]]) {

            NSString *newKey = [NSString stringWithFormat:@"@%@,[%lu]",key,(unsigned long)[arr indexOfObject:object]];
            [dic setValue:object forKey:newKey];
            
        }else{
        
        [dic setValue:object forKey:[NSString stringWithFormat:@"@%@,[%lu]",key,(unsigned long)[arr indexOfObject:object]]];
        }
    }
    [dic setValue:[NSNumber numberWithInteger: arr.count] forKey:[NSString stringWithFormat:@"%@_Count",key]];
    return dic;
}

@end
#pragma mark - getData
@implementation NSMutableDictionary (ParseData)
//取值
-(instancetype)dataAtIndexPath:(NSIndexPath *)indexPath
                       withKey:(NSString *)key
                   identifySTR:(NSString *)identify;
{
    id data ;
    for (NSString *keyOfAllData in [self allKeys]) {
        
        NSRange rangeOfSection = [keyOfAllData rangeOfString:[NSString stringWithFormat:@"[%ld]",indexPath.section]];
        NSRange rangeOfRow = [keyOfAllData rangeOfString:[NSString stringWithFormat:@"[%ld]",indexPath.row]options:NSBackwardsSearch];
        
        if ([keyOfAllData hasSuffix:key] == NO)
        {   //满足第一个条件
            continue;
        }
        
        if (identify != nil && [keyOfAllData rangeOfString:identify].location == NSNotFound)
        {   //满足两个条件
            continue;
        }
        
        if ([keyOfAllData componentsSeparatedByString:@"["].count > 2) {
            //在key中右两个定位数字的时候才会判断section
            if (rangeOfSection.location > rangeOfRow.location)
            {
                //满足三个条件section
                continue;
            }
        }
        
        if (indexPath !=nil && rangeOfRow.location == NSNotFound  )
        {   //满足四个条件row
            continue;
        }
        //满足！
        data = [self objectForKey:keyOfAllData];

    }
    
    return data;
    
}


- (NSDictionary * )datawithKey:(NSString *)key
               identifySTR:(NSString *)identify;
{
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    for (NSString *keyOfAllData in [self allKeys]) {
        

        if ([keyOfAllData hasSuffix:key] == NO)
        {   //满足第一个条件
            continue;
        }
        
        if (identify != nil && [keyOfAllData rangeOfString:identify].location == NSNotFound)
        {   //满足两个条件
            continue;
        }
        
        //满足！
        [dic setValue:[self objectForKey:keyOfAllData] forKey:keyOfAllData];
        
    }
    
    return dic;
    
}

@end
