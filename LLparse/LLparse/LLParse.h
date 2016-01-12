//
//  LLParse.h
//  LLparse
//
//  Created by silence on 16/1/11.
//  Copyright © 2016年 tianyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLParse : NSObject

@property (nonatomic,strong) NSMutableDictionary * allData;

+ (instancetype)parseData:(id)responseObject
            withParaments:(NSDictionary *)changeParaments;

-(id)objectForKey:(NSString *)key
            index:(NSIndexPath *)indexPath;


@end
