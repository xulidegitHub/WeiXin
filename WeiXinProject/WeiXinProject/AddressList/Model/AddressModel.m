//
//  AddressModel.m
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/19.
//  Copyright © 2017年 徐丽. All rights reserved.
//
#import "AddressModel.h"
#import <Mantle.h>
@implementation AddressModel
+ (instancetype)modelByTest{
    NSDictionary *addressDataDic = @{
                                  @"data":@[
                                          @{
                                              @"sectionTitle":@"A",
                                              @"sectionList":@[
                                                      @"安阳",
                                                      @"安徽",
                                                      @"按下",
                                                      ],
                                              },
                                          @{
                                              @"sectionTitle":@"B",
                                              @"sectionList":@[
                                                      @"bkd",
                                                      @"bdk",
                                                      @"bdgg",
                                                      @"biirp"
                                                      ],
                                              },
                                          @{
                                              @"sectionTitle":@"C",
                                              @"sectionList":@[
                                                      @"cgd",
                                                      @"cgkr",
                                                      @"crof",
                                                      @"ct4if"
                                                      ],
                                              
                                              },
                                          @{
                                              @"sectionTitle":@"D",
                                              @"sectionList":@[
                                                      @"deid",
                                                      @"deif",
                                                      @"dgfr",
                                                      ],
                                              },
                                          @{
                                              @"sectionTitle":@"E",
                                              @"sectionList":@[
                                                      @"eftg",
                                                      @"edkg",
                                                      @"efrig",
                                                      @"edrif"
                                                      ],
                                              },
                                          @{
                                              @"sectionTitle":@"F",
                                              @"sectionList":@[
                                                      @"eftg",
                                                      @"edkg",
                                                      @"efrig",
                                                      @"edrif"
                                                      ],
                                              },
                                          @{
                                              @"sectionTitle":@"G",
                                              @"sectionList":@[
                                                      @"eftg",
                                                      @"edkg",
                                                      @"efrig",
                                                      @"edrif"
                                                      ],
                                              }
                                          ],
                                  
                                  
                                  };
    NSError *error;
    return [MTLJSONAdapter modelOfClass:[AddressModel class] fromJSONDictionary:addressDataDic error:&error];
}
@end
