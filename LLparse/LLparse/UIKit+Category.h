//
//  UIKit+Category.h
//  vlive
//
//  Created by vnetoo on 16/2/18.
//  Copyright © 2016年 vnetoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,Transition){
    
    Transition_Left = 0,
    Transition_Right,
    Transition_Update,
    Transition_Load
};
@interface UITableView (My_TableView)

-(void)animationsOfcellAppear:(Transition)transition;


@end
