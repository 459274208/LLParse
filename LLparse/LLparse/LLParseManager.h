//
//  LLParseManager.h
//  LLparse
//
//  Created by vnetoo on 16/1/12.
//  Copyright © 2016年 tianyun. All rights reserved.
//
 
#import <Foundation/Foundation.h>

@interface LLParseManager : NSObject 
/**
 返回想统计的cell的行数
 */
@property(nonatomic,assign)NSInteger count;
/**
 保存每一次解析的数据
 */
@property(nonatomic,strong)NSMutableArray *dataArr;
/**
 解析一个json数据
 responseObject     网络请求下来的数据
 changeParaments    请求的参数
 */
- (void)parseData:(id)responseObject
             with:(NSDictionary *)changeParaments
  observeProperty:(NSString *)key;
/**
 
 该方法返回的数据取决于传入的参数：
 1.如果key存在，index为nil       返回一个数组，包含所有相同key的value（比如返回一个通讯录里面所有的name）
 2.如果key存在，index也存在       返回一个具体的对象，数据为该位置，key值所对应的value（比如返回一个通讯录中第五名的phone number）
 3.如果key为nil，index存在       返回一个字典，包含所有该位置的数据 （比如返回一个通讯录中第五名的name / phone number /address...）
 4.key 和 index 都为nil         你给我去死
 PS：该方法在解析过程中保留了数组的成员数量，可以直接取用(用法为，调用该方法，穿入key值为你想要知道的数组名称后面接上^.^)
 EX:[parse objectForKey:@"applications^.^Count" index:nil];
 意为：取出applications数组的成员数量，这个数据可以返回给tableView 等UI控件的代理方法
 */
-(id)objectForKey:(NSString *)key
            index:(NSIndexPath *)indexPath;

/**
 删除所有数据
 */
-(void)removeAllData;
@end
