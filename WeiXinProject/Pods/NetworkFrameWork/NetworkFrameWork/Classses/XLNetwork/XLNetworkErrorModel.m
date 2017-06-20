//
//  XLNetworkErrorModel.m
//  Pods
//
//  Created by 徐丽 on 2017/6/8.
//
//

#import "XLNetworkErrorModel.h"
static NSString * const LFDNetworkErrorCodeNetworkMessage = @"网络连接失败，请稍后重试";//@"网络错误";
static NSString * const LFDNetworkErrorCodeResponseFormatMessage = @"服务异常，请一会再试";//@"返回数据格式错误";
@implementation XLNetworkErrorModel
- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message error:(NSError *)error
{
    self = [super init];
    _code = code;
    if (message) {
        _message = [message copy];
    } else{
        _message = [self codeStateTranslate:code];
    }
    _error = [error copy];
    
    return self;
}

-(NSString *)codeStateTranslate:(LFDNetworkErrorCode)code {
    switch (_code) {
        case LFDNetworkErrorCodeNetwork :
            return @"您的网络状态不给力";//@"网络错误";
            
        case LFDNetworkErrorCodeResponseFormat:
            return @"服务异常，请一会再试";//@"返回数据格式错误";
            
            break;
        case LFDNetworkSuccessCodeNoError:
            return @"成功";
            break;
        case LFDNetworkFailCode:
            return @"失败";
            break;
        case LFDNetworkCodeSYSTEMEXCEPTION:
            return @"系统异常";
            break;
        case LFDNetworkCodeCALLSERVICEEXCEPTION:
            return @"调用服务失败";
            break;
        case LFDNetworkCodePARAMATERSISNULL:
            return @"参数为空";
            break;
        case LFDNetworkCodeRESULTSETISNULL:
            return @"查询结果为空";
            break;
        case LFDNetworkCodePARAMPARSEEXCEPTION:
            return @"参数解析异常";
            break;
        case  LFDNetworkCodeINSTANTIATIONEXCEPTION:
            return @"反射类实例化失败";
            break;
            
        case LFDNetworkCodeILLEGALACCESSEXCEPTION:
            return @"反射类非法接入";
            break;
            
        case  LFDNetworkCodeFORMATDATAEXCEPTION:
            return @"格式化数据异常";
            break;
        case LFDNetworkCodeCONFIGEXCEPTION:
            return @"配置异常";
            break;
        case LFDNetworkCodePWDNOTEQUALEXCEPTION:
            return @"新密码与确认密码不一致";
            break;
        case LFDNetworkCodePWDEQUALEXCEPTION:
            return @"原密码与新密码相同";
            break;
            
        case LFDNetworkCodeSAVEPRODUCTFAIL:
            return @"保存项目失败";
            break;
            
        case LFDNetworkCodeSAVECONTRACTFAIL:
            return @"批量保存合同失败";
            break;
        case LFDNetworkCodeUPDATEPRODUCTSTATEFAIL :
            return @"修改产品状态失败";
            break;
        case  LFDNetworkCodeDISASSEMBLY_NO_REASONABLE:
            return @"拆包不合理";
            break;
            
        case LFDNetworkCodeINSERT_PROJECT_CONTRACT_FAIL:
            return @"插入项目合同关系失败";
            break;
        case LFDNetworkCodeUPDATE_PROJECT_AUDIT_TIME:
            return @"更新项目合同关系信息失败";
            break;
        case LFDNetworkCodeDELETE_PROJECT_CONTRACT_FAIL:
            return @"删除项目合同失败";
            break;
        case LFDNetworkCodeUPDATE_PROJECT_FAIL:
            return @"更新项目失败";
            break;
        case LFDNetworkCodeUPDATE_PROJECT_CONTRACT_FAIL:
            return @"更新项目合同失败";
            break;
        case LFDNetworkCodePROJECT_SAVE_EXCEPTION :
            return @"保存项目异常";
            break;
        case LFDNetworkCodePROJECT_UPDATE_EXCEPTION :
            return @"修改产品异常";
            //        case LFDNetworkCodePROJECT_AUDIT_EXCEPTION  :
            //            return @"审核产品异常";
            //            break;
        case LFDNetworkCodePROJECT_DESC_FAIL:
            return @"批量插入项目描述失败";
            break;
        case LFDNetworkCodePROJECT_REPAYMENTPLAN_FAIL:
            return @"批量插入项目计划失败";
            break;
        case LFDNetworkCodePROJECT_AUDIT_LOG_FAIL:
            return @"项目审核记录失败";
            break;
        case LFDNetworkCodePRODUCT_STATE_UPDATE_EXCEPTION:
            return @"修改产品状态异常";
            break;
        case LFDNetworkCodePROJECT_AUDIT_LOG_BATCH_INSERT_FAIL :
            return @"批量保存项目审核记录失败";
            break;
        case LFDNetworkCodePROJECT_CODE_INCREAMENT_FAIL :
            return @"批量保存产品失败";
            break;
        case LFDNetworkCodePRODUCT_CODE_INCREAMENT_FAIL:
            return @"批量保存项目失败";
            break;
        case LFDNetworkCodeORDER_NON_EXIT :
            return @"订单不存在";
            break;
        case LFDNetworkCodeTokenTimeOut:   //token过期
            return @"长时间未登录，请重新登录";
            break;
        case LFDNetworkCodeORDER_SAATE_CANOT_CHANGE :
            return @"订单状态不可更改";
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"出错啦，将这个代码发给我们吧(%ld)", (long)code];
}




+ (instancetype)modelWithCode:(NSInteger)code message:(NSString *)message error:(NSError *)error
{
    return [[self alloc] initWithCode:code message:message error:error];
}

+ (instancetype)modelNetworkError:(NSError *)error
{
    return [[self alloc] initWithCode:LFDNetworkErrorCodeNetwork message:LFDNetworkErrorCodeNetworkMessage error:error];
}

+ (instancetype)modelResponseFormatError:(NSError *)error
{
    return [[self alloc] initWithCode:LFDNetworkErrorCodeResponseFormat message:LFDNetworkErrorCodeResponseFormatMessage error:error];
}


@end
