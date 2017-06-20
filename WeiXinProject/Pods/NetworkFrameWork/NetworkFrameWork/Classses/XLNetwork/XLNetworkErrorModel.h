//
//  XLNetworkErrorModel.h
//  Pods
//
//  Created by 徐丽 on 2017/6/8.
//
//

#import <Foundation/Foundation.h>
#import "XLNetwork.h"

typedef NS_ENUM(NSInteger, LFDNetworkErrorCode) {
    LFDNetworkErrorCodeNoError = 0,
    LFDNetworkErrorCodeNetwork = 1,         // 网络错误，详见NSError
    LFDNetworkErrorCodeResponseFormat = 2,  // 返回数据格式错误
    
    LFDNetworkSuccessCodeNoError = 200,      //成功
    LFDNetworkFailCode = 300,                //失败
    LFDNetworkCodeSYSTEMEXCEPTION = 1000,    //系统异常
    LFDNetworkCodeTokenTimeOut = 1014, //token过期
    LFDNetworkCodeCALLSERVICEEXCEPTION = 1101,   //调用服务失败
    LFDNetworkCodePARAMATERSISNULL = 2000,      //参数为空
    LFDNetworkCodeRESULTSETISNULL = 2001,       //查询结果集为空
    LFDNetworkCodePARAMPARSEEXCEPTION = 2002,   //参数解析异常
    LFDNetworkCodeCLASSNOTFOUNDEXCEPTION=2003,  //类名找不到
    LFDNetworkCodeINSTANTIATIONEXCEPTION = 2004,  //反射类实例化失败
    LFDNetworkCodeILLEGALACCESSEXCEPTION =2005,   //反射类非法接入
    LFDNetworkCodeFORMATDATAEXCEPTION = 2006,     //格式化数据异常
    LFDNetworkCodeCONFIGEXCEPTION = 2007,         //配置异常
    LFDNetworkCodePWDNOTEQUALEXCEPTION = 4000,    //新密码与确认密码不一致
    LFDNetworkCodePWDEQUALEXCEPTION = 4001,     //原密码与新密码相同
    LFDNetworkCodeSAVEPRODUCTFAIL = 7000,       //保存项目失败
    LFDNetworkCodeSAVECONTRACTFAIL = 70001,     //批量保存合同失败
    LFDNetworkCodeUPDATEPRODUCTSTATEFAIL = 7002, // 修改产品状态失败
    LFDNetworkCodeDISASSEMBLY_NO_REASONABLE =7003,  //拆包不合理
    LFDNetworkCodeINSERT_PROJECT_CONTRACT_FAIL = 7004,  //插入项目合同关系信息失败
    LFDNetworkCodeUPDATE_PROJECT_AUDIT_TIME = 7005,   //更新项目发布时间失败
    LFDNetworkCodeDELETE_PROJECT_CONTRACT_FAIL = 7006,  //删除项目合同失败
    LFDNetworkCodeUPDATE_PROJECT_FAIL = 7007,      //更新项目失败
    LFDNetworkCodeUPDATE_PROJECT_CONTRACT_FAIL = 7008,  //更新项目合同失败
    LFDNetworkCodePROJECT_SAVE_EXCEPTION = 7009,     //保存项目异常
    LFDNetworkCodePROJECT_UPDATE_EXCEPTION = 7010,   //修改产品异常
    LFDNetworkCodePROJECT_AUDIT_EXCEPTION = 7010,   //审核产品异常
    LFDNetworkCodePROJECT_DESC_FAIL = 7011,      //批量插入项目描述失败
    LFDNetworkCodePROJECT_REPAYMENTPLAN_FAIL = 7012,  //批量插入项目计划失败
    LFDNetworkCodePROJECT_AUDIT_LOG_FAIL = 7013,     //项目审核记录失败
    LFDNetworkCodePRODUCT_STATE_UPDATE_EXCEPTION = 7014,  // 修改产品状态异常
    LFDNetworkCodePROJECT_AUDIT_LOG_BATCH_INSERT_FAIL = 7015,  //批量保存项目审核记录失败
    LFDNetworkCodePROJECT_CODE_INCREAMENT_FAIL = 7016,      //批量保存产品失败
    LFDNetworkCodePRODUCT_CODE_INCREAMENT_FAIL = 7017,    //批量保存项目失败
    //订单相关
    LFDNetworkCodeORDER_NON_EXIT = 3001,  //订单不存在
    LFDNetworkCodeORDER_SAATE_CANOT_CHANGE = 3002,  //订单状态不可更改
    
};
@interface XLNetworkErrorModel : XLNetworkModel
@property (nonatomic, assign, readonly) NSInteger code;
@property (nonatomic, readonly, copy) NSString *message;
@property (nonatomic, readonly, copy) NSError *error;

- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message error:(NSError *)error;

+ (instancetype)modelWithCode:(NSInteger)code message:(NSString *)message error:(NSError *)error;
+ (instancetype)modelNetworkError:(NSError *)error;
+ (instancetype)modelResponseFormatError:(NSError *)error;

@end
