


//
//  FriendsListModel.m
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/16.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "FriendsListModel.h"
#import "AFNetworking/AFNetworking.h"
@implementation FriendsListModel
+(instancetype)modelByTest{
    NSDictionary *dataDic = @{
                              @"page":@{
                                          @"totalCount":@"234",
                                          @"totalPageCount":@"sdf",
                                          @"pageSize":@"sd",
                                          @"currentPageNo":@"ds",
                                          @"dataList":@[
                                                  @{
                                                      @"iconName":@"icon0",
                                                      @"iconTitle":@"xuli",
                                                      @"content":@"结束对话方式开发德雷克斯勒地方和 i 为合肥市看到你发舒服很多款式大方经典三色入惊魂甫定上课啦诶人绝代风华你们上课嘞人家快递发货你们索科洛夫就那么帅呆了快；饿的房间开门，说啦；看附近村民 v",
                                                      @"picListCount":@(6),
                                                      @"picList":@[
                                                              @"pic0",
                                                              @"pic1",
                                                              @"pic2",
                                                              @"pic3",
                                                              @"pic1",
                                                              @"pic0",
                                                              @"pic0",
                                                              @"pic1",
                                                              
                                                             ],
                                                      },
                                                  @{
                                                      @"iconName":@"icon0",
                                                      @"iconTitle":@"xuli",
                                                      @"content":@"结束对话方式开发德雷克斯勒地方和 i 为合肥市看到你发舒服很多款式大方经典三色入惊魂甫定上课啦诶人绝代风华你们上课嘞人家快递发货你们索科洛夫就那么帅呆了快；饿的房间开门，说啦；看附近村民 v",
                                                      @"picListCount":@(6),
                                                      @"picList":@[
                                                              @"pic0",
                                                              @"pic1",
                                                              @"pic2",
                                                              @"pic3",
                                                              @"pic1",
                                                              @"pic0",
                                                              @"pic0",
                                                              @"pic1",
                                                              @"pic2",
                                                              
                                                              ],
                                                      },
                                                  @{
                                                      @"iconName":@"icon0",
                                                      @"iconTitle":@"xuli",
                                                      @"content":@"结束对话方式开发德雷克斯勒地方和 i 为合肥市看到你发舒服很多款式大方经典三色入惊魂甫定上课啦诶人绝代风华你们上课嘞人家快递发货你们索科洛夫就那么帅呆了快；饿的房间开门，说啦；看附近村民 v",
                                                      @"picListCount":@(6),
                                                      @"picList":@[
                                                              @"pic0",
                                                              @"pic1",
                                                              @"pic2",
                                                              @"pic3",
                                                              @"pic1",
                                                              @"pic0",
                                                              @"pic1",
                                                
                                                              
                                                              ],
                                                      },


                                                  @{
                                                      @"iconName":@"icon1",
                                                      @"iconTitle":@"dsjf",
                                                      @"content":@"说快点放假啊深刻的肌肤抗衰老；看见富含柠檬酸快乐；福建卡那霉素快乐；看附近那么小，做了；是看附近农村模型，滴漏式咖啡机女春模型，代理商；发 i 加快农村 v 模型，啦；对佛教款女春吗，心都碎了；福建看模型，说啦；分开就没事了；福建高考出 v 没电了；fk",
                                                      @"picListCount":@(6),
                                                      @"picList":@[
                                                              @"pic0",
                                                              @"pic1",
                                                              @"pic2",
                                                              @"pic3",
                                                              @"pic0",
                                                          
                                                              ],
                                                      },
                                                  @{
                                                      @"iconName":@"icon2",
                                                      @"iconTitle":@"woshiwudi",
                                                      @"content":@"看电视福建看书的房间历历可见福建看啦啦啦啦啦啦反反复复反反复复反反复复纠结福建斤斤计较斤斤计较斤斤计较对空射击佛IE哦啊就是看到了送 i 人附近的亏损累累哦乳房更加好看的伶伶俐俐如果附近",
                                                      @"picListCount":@(6),
                                                      @"picList":@[
                                                              @"pic0",
                                                              @"pic1",
                                                              @"pic2",
                                                              @"pic3",
                                                              @"pic0",
                                                              @"pic0",
                                                              ],
                                                      },
                                                  @{
                                                      @"iconName":@"icon3",
                                                      @"iconTitle":@"疯疯子",
                                                      @"content":@"看得十分饥饿乳房就是看到泪如翻江倒海考试类如今很多烦恼是看累哦如今富含单宁酸可累哦如对佛教烧烤类软件疯狂的路上；诶哦软件疯狂的买烧烤类如今富含的柠檬酸快乐软件开发的柠檬水，快乐惹家",
                                                      @"picListCount":@(6),
                                                      @"picList":@[
                                                              @"pic0",
                                                              @"pic1",
                                                              @"pic2",
                                                              @"pic3",
                                                              @"pic0",
                                                              @"pic0",
                                                              ],
                                                      },
                                                  @{
                                                      @"iconName":@"icon4",
                                                      @"iconTitle":@"jkfds",
                                                      @"content":@"jsdkal;dfjknmx,s.akledfjnms,al;dkjfnms,akldjfnmcx,zlkdsejrhdfnms,klfserfgvdsfgvcxfsdretfgd",
                                                      @"picListCount":@(4),
                                                      @"picList":@[
                                                              @"pic0",
                                                              @"pic1",
                                                              @"pic2",
                                                              @"pic3",
                                                            
                                                              ],
                                                      },
                                                  @{
                                                      @"iconName":@"icon0",
                                                      @"iconTitle":@"diyige",
                                                      @"content":@"离开家饭店拿什么来开发机构和女每次都是看了富含就能买烧烤类福建和柠檬酸快乐福建呢 对佛教款充满女性",
                                                      @"picListCount":@(6),
                                                      @"picList":@[
                                                              @"pic0",
                                                              @"pic1",
                                                              @"pic2",
                                                            
                                                              ],
                                                      },
                                                  @{
                                                      @"iconName":@"icon1",
                                                      @"iconTitle":@"dslkf",
                                                      @"content":@"dkksl;a双卡双待家饭店烧烤i俄方将开始啦饿哦绝代风华能买烧烤啦诶如今很多烦恼是马卡罗夫回家拿什么克拉额外i偶然风华绝代脑神经科泪如对富含就能烧烤咯诶入豆腐和妓女",
                                                      @"picListCount":@(1),
                                                      @"picList":@[
                                                              @"pic0",
                                                              @"pic1",
                                                              ],
                                                      },
                                                  @{
                                                      @"iconName":@"icon1",
                                                      @"iconTitle":@"dskf",
                                                      @"content":@"离开对方巨大烧烤啦福建看韩国柠檬酸快乐福建河南省煤矿立即返回 v 出版 ",
                                                      @"picListCount":@(0),
                                                      @"picList":@[
                                                              @"pic0",

                                                              ],
                                                      },
                                                  @{
                                                      @"iconName":@"icon2",
                                                      @"iconTitle":@"zheshishenme",
                                                      @"content":@"打开就撒了未经任何地方柠檬酸快乐软件可恢复都能烧烤类福建和柠檬酸快乐万家灯火烦恼是看了就让很多烦恼不睡觉快乐的话就能明显是看了我 i 绝代风华能买上两口IE如肺结核的柠檬酸快乐；哦额日u股份计划的柠檬酸，啦；开发机构和你们地方，说啦；看附近",
                                                      @"picListCount":@(0),
                                                      @"picList":@[
                                                              

                                                              ],
                                                      },
                                                  ],

                                          },
                        
                          
                              
                                          };


    NSError *error;
    FriendsListModel *model = [MTLJSONAdapter modelOfClass:[FriendsListModel class] fromJSONDictionary:dataDic                                                                                                               error:&error];
    return model;
}
+(NSValueTransformer*)pageJSONTransformer{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PageModel class]];
}

@end

@implementation PageModel
+(NSValueTransformer*)dataListJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[singleFriendMessageModel class]];
}
@end

@implementation singleFriendMessageModel

@end
