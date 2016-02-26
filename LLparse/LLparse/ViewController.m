//
//  ViewController.m
//  LLparse
//
//  Created by vnetoo on 16/1/5.
//  Copyright © 2016年 tianyun. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "LLParse.h"
#import "MJRefresh.h"
#import "LLParseManager.h"
#import "LLCell.h"
#import "UIKit+Category.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)LLParseManager *maneger;
@end

@implementation ViewController
{
    NSMutableArray  *_dataArr;
    NSInteger       _page;
    NSInteger       _count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self configTableView];
}
-(void)click_btn:(UIButton *)sender{
  
    [_table animationsOfcellAppear:sender.tag];
}
-(void)configTableView{
    
    for (int i = 0 ; i< 4 ; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(click_btn:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(i * 45, 20 , 40, 80);
        btn.tag = i;
        [btn setBackgroundColor:[UIColor orangeColor]];
        [self.view addSubview:btn];
    }
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100)
                                         style:UITableViewStylePlain];
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    
    _maneger = [LLParseManager new];
    _page = 0;
    
    [_table registerNib:[UINib nibWithNibName:@"LLCell" bundle:nil] forCellReuseIdentifier:@"identify"];
    
    __weak ViewController *vc = self;
    _table.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [vc refreshAction:YES];
    }];
    
    _table.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [vc refreshAction:NO];
    }];
    
    [_table.header beginRefreshing];
    
}
-(void)refreshAction:(BOOL)isRefresh{
    
    if (isRefresh) {
        //删除所有数据
        [_maneger removeAllData];
        _page = 0;
    }else{
        _page++;
    }
    NSDictionary *paraments =@{@"count":@10,@"start":[NSNumber numberWithInteger:_page]};
    //http://100.mcu.vnetoo.com:1088/query?count=10&start=0
    NSString * str =@"http://100.mcu.vnetoo.com:1088/query?";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:paraments
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             //解析数据
             [_maneger parseData:responseObject with:paraments observeProperty:@"data"];
             [_table reloadData];
             
             if (isRefresh) {
                 
                 [_table animationsOfcellAppear:Transition_Update];
             }else{
                 
                  [_table.footer endRefreshing];
                  [_table animationsOfcellAppear:Transition_Load];
             }
             
             [_table.header endRefreshing];
             
             
         }
         failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
             [_table.header endRefreshing];
             [_table.footer endRefreshing];
         }];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //返回cell数量
    return _maneger.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LLCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identify"];
 	//获取此cell的全部数据
    NSDictionary *dataDic = [_maneger objectForKey:nil index:indexPath];
    //配置cell
    [cell setCell:dataDic];
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
