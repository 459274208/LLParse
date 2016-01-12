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
    
    [self configTableView];
}
-(void)configTableView{
    
    _table = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds
                                         style:UITableViewStylePlain];
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    
    _maneger = [LLParseManager new];
    _page = 1;
    
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
        _page = 1;
    }else{
        _page++;
    }
    NSDictionary *paraments =@{@"currency":@"rmb",@"page":[NSNumber numberWithInteger:_page]};
    
    NSString * str =@"http://iappfree.candou.com:8080/free/applications/free?";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:paraments
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             //解析数据
             [_maneger parseData:responseObject with:paraments observe:@"applications^.^Count"];
             [_table reloadData];
             
             [_table.header endRefreshing];
             [_table.footer endRefreshing];
             
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
