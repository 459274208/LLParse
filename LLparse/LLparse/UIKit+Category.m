//
//  UIKit+Category.m
//  vlive
//
//  Created by vnetoo on 16/2/18.
//  Copyright © 2016年 vnetoo. All rights reserved.
//

#import "UIKit+Category.h"

@implementation UITableView (My_TableView)
-(void)animationsOfcellAppear:(Transition)transition{
    
    
    if (transition < 2) {
        
       [self cellTransition_Appear:transition];
    }else{
        
       [self cellTransition_Update:transition];
    }
    
}
- (void)cellTransition_Appear:(Transition)transition{
    
    //将cell 全部放在左边
    __block CGFloat origin_x ;
    NSArray *arr = [self visibleCells];
    int i = 0;
    for (UITableViewCell *cell in arr) {
        
        i++;
        origin_x = cell.center.x;
        
        if (transition == Transition_Left) {
            
            cell.center = CGPointMake(cell.center.x - cell.frame.size.width / [arr count] * i / 2 ,
                                      cell.center.y);
        }else{
            cell.center = CGPointMake(cell.center.x + cell.frame.size.width / [arr count] * i ,
                                      cell.center.y);
        }
    }
        
    for (UITableViewCell *cell in arr) {
        
        [UIView animateWithDuration:0.7
                              delay:0.1
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.3
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             cell.center = CGPointMake(origin_x,cell.center.y);
                         }
                         completion:^(BOOL finished) {
            
                         }
         ];
    }

}
- (void)cellTransition_Update:(NSInteger)transition{
    
    NSArray *arr = [self visibleCells];
    
    if (transition == Transition_Update) {
        
        for (UITableViewCell *cell in arr) {
            
            [UIView transitionWithView:cell duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
        }
        
    }else{
        
        __block unsigned long i = 50;
        __block CGFloat center_y = 0;
        
        UITableViewCell *current_cell;
        UITableViewCell *front_cell;
        
        if (transition < 50) {
           
            for (UITableViewCell *cell in arr) {
                
                cell.center = CGPointMake(cell.center.x, cell.center.y  + [arr indexOfObject:cell] * cell.frame.size.height);
            }
            
            
        }else if(transition >50){
            
            i = transition;
            i ==Transition_Load ?i = 51 :i;
            front_cell  = arr[i - 51];
            current_cell  = arr[i - 50];
            center_y = front_cell.center.y + front_cell.frame.size.height / 2 + current_cell.frame.size.height / 2;
            
        }

        [UIView animateWithDuration:0.2
                              delay:0.0
             usingSpringWithDamping:0.4
              initialSpringVelocity:0.3
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                            
                             current_cell.center = CGPointMake(current_cell.center.x,center_y);
                         }
                         completion:^(BOOL finished) {
                             
                             i++;
                             if (i - 50 < [arr count]) {
                                 [self cellTransition_Update:i];
                                 
                             }else{
                                 return ;
                             }
                         }
         ];
    
    }
    
}
@end
