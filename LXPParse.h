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

@property (nonatomic ,strong) id pathData; //地址解析

@property (nonatomic ,strong) NSMutableDictionary *allData;//全部解析



//解析网址专用方法-返回值为2个对象的数组,索引值为0的对象是"?"之前的网址,索引值为1的对象是参数（字典格式）

+(NSArray *)NetURLAnalysis:(NSString *)netURL changeParaments:(NSDictionary *)dic;//网址分析


//超级无敌省事儿庸人自扰深陷苦海心花怒放妈妈说方法名要长的请求加解析方法
+(void)getNetMessageFrom:(NSString *)stringOfURL changeParaments:(NSDictionary *)dic  messageLocation:(NSString *)stringOfLocation success:(void(^)(LXPParse * parse))success failure:(void(^)(NSError *error))failure;



@end

@interface NSMutableDictionary (ParseData)

-(instancetype)dataAtIndexPath:(NSIndexPath *)indexPath//cell所在位置，可填nil
                       withKey:(NSString *)key//目标信息对应的key
                   identifySTR:(NSString *)identify;//在信息所在路径中的特殊key，可填nil


@end
