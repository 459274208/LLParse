//
//  LXPParse.h
//  AXM
//
//  Created by 不要叫我小兰(*^__^*)  on 15/3/10.
//  Copyright (c) 2015年 lxp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#define _LXP_ChangeParament @"_LXP_ChangeParament"

//如有指教请联系邮箱tianyun1201@163.com 期待您的建议与改进，让我们把“懒人精神”发扬光大！

@interface LXPParse : NSObject
//地址解析
@property (nonatomic ,strong) id pathData;
//全部解析
@property (nonatomic ,strong) NSMutableDictionary *allData;

/**
 *解析网址专用方法-返回值为2个对象的数组,索引值为0的对象是"?"之前的网址,索引值为1的对象是参数（字典格式）
 *
 */
+(NSArray *)NetURLAnalysis:(NSString *)netURL changeParaments:(NSDictionary *)dic;

/**
 *  超级无敌省事儿庸人自扰深陷苦海心花怒放妈妈说方法名要长的请求加解析方法
 
 */
+(void)getNetMessageFrom:(NSString *)stringOfURL changeParaments:(NSDictionary *)dic  messageLocation:(NSString *)stringOfLocation success:(void(^)(LXPParse * parse))success failure:(void(^)(NSError *error))failure;

@end



@interface NSMutableDictionary (ParseData)
/**
 *  返回值为instancetype类型，是一个对象
 *
 *  @param indexPath 对应控件的位置,可填nil
 *  @param key       对应控件的名称,目标信息对应的key
 *  @param identify  对应数据中的特征值,可填nil
 *
 *  @return 返回值为instancetype类型，是一个对象
 */
- (instancetype)dataAtIndexPath:(NSIndexPath *)indexPath
                       withKey:(NSString *)key
                   identifySTR:(NSString *)identify;

/**
 *  返回值为NSDictionary类型，其中保存的是所有符合搜索条件的数据
 *
 *  @param key      数据名称,目标信息对应的key
 *  @param identify 对应数据中的特征值,可填nil
 *
 *  @return 返回值为NSDictionary类型，其中保存的是所有符合搜索条件的数据
 */

- (NSDictionary  *)datawithKey:(NSString *)key
            identifySTR:(NSString *)identify;


@end
