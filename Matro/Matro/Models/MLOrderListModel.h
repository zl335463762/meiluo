//
//  MLOrderListModel.h
//  Matro
//
//  Created by 黄裕华 on 16/5/3.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLOrderListModel : NSObject


@property (nonatomic,copy)NSString *HWGSJ;
@property (nonatomic,copy)NSString *JLBH;
@property (nonatomic,copy)NSString *DHDBH;
@property (nonatomic,copy)NSString *DDLY;
@property (nonatomic,assign)float DDJE;
@property (nonatomic,copy)NSString *DHR;
@property (nonatomic,copy)NSString *SHRMC;
@property (nonatomic,copy)NSString *SHRADDRESS;
@property (nonatomic,copy)NSString *SHRMPHONE;
@property (nonatomic,copy)NSString *SHRPHONE;
@property (nonatomic,copy) NSArray *PRODUCTLIST;
/**
 *  付款方式
 */
@property (nonatomic,strong)NSNumber *FKFS;
/**
 *   付款方式名称
 */
@property (nonatomic,copy)NSString *FKFSMC;
/**
 *  付款情况
 */
@property (nonatomic,copy)NSString *FKQK;
/**
 *  付款情况名称
 */
@property (nonatomic,copy)NSString *FKQKMC;
/**
 *  订货人日期
 */
@property (nonatomic,copy)NSString *DHRQ;
/**
 *  订单支付时间
 */
@property (nonatomic,copy)NSString *DDZFSJ;
/**
 *  支付截止时间
 */
@property (nonatomic,copy)NSString *DZFJZSJ;
@property (nonatomic,copy)NSString *DZFSYSJ;
/**
 *  订单状态
 */
@property (nonatomic,copy)NSString *STATUS;
/**
 *  订单状态名称
 */
@property (nonatomic,copy)NSString *STATUSMC;
/**
 *  订单类型
 */
@property (nonatomic,copy)NSString *DDLX;
/**
 *  销售数量
 */
@property (nonatomic,copy)NSString *XSSL;
/**
 *  销售金额
 */
@property (nonatomic,assign)float XSJE;
/**
 *  配送方式
 */
@property (nonatomic,copy)NSString *PSFS;
/**
 *  配送方式名称
 */
@property (nonatomic,copy)NSString *PSFSMC;
/**
 *  配送金额
 */
@property (nonatomic,assign)float PSJE;
/**
 *  总价
 */
@property (nonatomic,assign)float TOTLEJE;
/**
 *  发票抬头
 */
@property (nonatomic,copy)NSString *FPTT;
/**
 *  发票内容
 */
@property (nonatomic,copy)NSString *FPNR;
/**
 *  配送单记号
 */
@property (nonatomic,copy)NSString *PSDJH;
/**
 *  快递接口代码
 */
@property (nonatomic,copy)NSString *KDJKDM;
/**
 *  用户订单状态
 */
@property (nonatomic,copy)NSString *YHSTATUS;
/**
 *  缺货标记
 */
@property (nonatomic,copy)NSString *QHBJ;
/**
 *  显示标记
 */
@property (nonatomic,copy)NSString *DISPLAY;
/**
 *  分店编号
 */
@property (nonatomic,copy)NSString *FDBH;
/**
 *  评价数量
 */
@property (nonatomic,copy)NSString *PJCOUNT;
@property (nonatomic,copy)NSString *TGJLBH;
/**
 *  评价数量
 */
@property (nonatomic,copy)NSString *ZCSP;
@property (nonatomic,copy)NSString *CANRETURN;
@property (nonatomic,copy)NSString *WLXXLIST;
@property (nonatomic,copy)NSString *DHDFKFS;


@property (nonatomic,assign)BOOL isMore;
@property (nonatomic,assign)BOOL isOpen;



@end
