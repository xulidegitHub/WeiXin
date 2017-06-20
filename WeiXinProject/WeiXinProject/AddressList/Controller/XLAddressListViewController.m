

//
//  XLAddressListViewController.m
//  WeiXinProject
//
//  Created by 徐丽 on 17/4/26.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "XLAddressListViewController.h"
#import "AddressModel.h"
@interface XLAddressListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong)UITableView *addressTab;
@property (nonatomic,strong)AddressModel *model;
@property (nonatomic,strong)AddressSingleModel *singleModel;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSArray *indexArray;
@end

@implementation XLAddressListViewController
-(NSArray *)dataArray{
    if (!_dataArray) {
      _dataArray = @[
          @{
              @"sectionTitle":@"A",
              @"sectionList":@[
                      @{
                          @"imageName":@"1",
                          @"name":@"安阳",
  
                          },
                      @{
                          @"imageName":@"2",
                          @"name":@"安阳",
                          
                          },
                      @{
                          @"imageName":@"3",
                          @"name":@"安阳",
                          
                          },

                      ],
              },
          @{
              @"sectionTitle":@"B",
              @"sectionList":@[
                      @{
                          @"imageName":@"4",
                          @"name":@"安阳",
                          
                          },
                      @{
                          @"imageName":@"5",
                          @"name":@"安阳",
                          
                          },
                      @{
                          @"imageName":@"6",
                          @"name":@"安阳",
                          
                          },
                      

                      ],
              },
          @{
              @"sectionTitle":@"C",
              @"sectionList":@[
                      @{
                          @"imageName":@"1",
                          @"name":@"安阳",
                          
                          },
                      @{
                          @"imageName":@"2",
                          @"name":@"安阳",
                          
                          },
                      @{
                          @"imageName":@"3",
                          @"name":@"安阳",
                          
                          },
                      

                      ],
              
              },
          @{
              @"sectionTitle":@"D",
              @"sectionList":@[
                      @{
                          @"imageName":@"1",
                          @"name":@"安阳",
                          
                          },
                      @{
                          @"imageName":@"2",
                          @"name":@"安阳",
                          
                          },
                      @{
                          @"imageName":@"3",
                          @"name":@"安阳",
                          
                          },
                      
                      ],
              },
          @{
              @"sectionTitle":@"E",
              @"sectionList":@[
                      @{
                          @"imageName":@"1",
                          @"name":@"安阳",
                          
                          },
                      @{
                          @"imageName":@"2",
                          @"name":@"安阳",
                          
                          },
                      @{
                          @"imageName":@"3",
                          @"name":@"安阳",
                          
                          },
                      
                      ],
              },
          @{
              @"sectionTitle":@"F",
              @"sectionList":@[
                      @{
                          @"imageName":@"1",
                          @"name":@"安阳",
                          
                          },
                      @{
                          @"imageName":@"2",
                          @"name":@"安阳",
                          
                          },
                      @{
                          @"imageName":@"3",
                          @"name":@"安阳",
                          
                          },
                      

                      ],
              },
          @{
              @"sectionTitle":@"G",
              @"sectionList":@[
                      @{
                          @"imageName":@"1",
                          @"name":@"安阳",
                          
                          },
                      @{
                          @"imageName":@"2",
                          @"name":@"安阳",
                          
                          },
                      @{
                          @"imageName":@"3",
                          @"name":@"安阳",
                          
                          },
                      
                      ],
              }
          ];

    }
    return _dataArray;
}

-(NSArray*)indexArray{
    if (!_indexArray) {
        _indexArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H"];
    }
    return _indexArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通讯录";
    self.view.backgroundColor = [UIColor whiteColor];
    self.addressTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.addressTab.delegate = self;
    self.addressTab.dataSource = self;
    self.addressTab.sectionIndexColor =[UIColor redColor];
    [self.view addSubview:self.addressTab];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20,40)];
    [searchBar sizeToFit];
    [searchBar setPlaceholder:@"搜索"];
    [searchBar.layer setBorderWidth:0.5];
    [searchBar.layer setBorderColor:[UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1].CGColor];
    [searchBar setDelegate:self];
    [searchBar setKeyboardType:UIKeyboardTypeDefault];

    self.addressTab.tableHeaderView = searchBar;
    self.addressTab.tableHeaderView.backgroundColor = [UIColor redColor];
    self.addressTab.backgroundColor = [UIColor redColor];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}

//点击右侧索引的时候调用此方法,点击索引让其滚动到哪一组
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *singelDic = self.dataArray[section];
    NSArray *rowArrayCount = singelDic[@"sectionList"];
    return rowArrayCount.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = self.dataArray[indexPath.section][@"sectionList"][indexPath.row][@"name"];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.dataArray[indexPath.section][@"sectionList"][indexPath.row][@"imageName"]]];
    cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 40, 40); 
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //viewforHeader
    id label = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!label) {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14.5f]];
        [label setTextColor:[UIColor grayColor]];
        [label setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    }
    [label setText:[NSString stringWithFormat:@"  %@",self.dataArray[section][@"sectionTitle"]]];
    return label;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0;
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
