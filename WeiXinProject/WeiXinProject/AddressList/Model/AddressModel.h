//
//  AddressModel.h
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/19.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import <NetworkFrameWork/XLNetwork.h>
#import <UIKit/UIKit.h>
@class AddressSingleModel;
@interface AddressModel : XLNetworkModel
@property(nonatomic,strong) NSArray<AddressSingleModel*> *data;
+ (instancetype)modelByTest;
@end

@interface AddressSingleModel : XLNetworkModel
@property (nonatomic,copy) NSString *sectionTitle;
@property (nonatomic,strong)NSArray *sectionList;
@end
