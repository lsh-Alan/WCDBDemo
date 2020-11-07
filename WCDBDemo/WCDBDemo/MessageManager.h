//
//  MessageManager.h
//  WCDBDemo
//
//  Created by 刘少华 on 2020/10/19.
//

#import <Foundation/Foundation.h>
//#import "MessageModel.h"
@class MessageModel;
NS_ASSUME_NONNULL_BEGIN

extern NSString *const table1;
extern NSString *const table2;
extern NSString *const table3;

@interface MessageManager : NSObject

+ (instancetype)shareInstance;
/// 获取数据库路径
+ (NSString *)wcdbFilePath;
/// 创建数据库的操作
- (BOOL)creatDatabase;

//增  插入单个数据
- (BOOL)insertData:(MessageModel *)message Table:(NSString *)table;
//增  插入多个数据
- (BOOL)insertDatas:(NSArray<MessageModel *> *)messages Table:(NSString *)table;

//删除数据
- (BOOL)deleteDataWithId:(NSString *)messageid Table:(NSString *)table;
//删除表中所有的数据
- (BOOL)deleteAllDataWithTable:(NSString *)table;

//更新表中单个数据单个字段
- (BOOL)updateData:(NSString *)content byId:(NSString *)messageid Table:(NSString *)table;
//更新表中数据
- (BOOL)updateData:(MessageModel *)message Table:(NSString *)table;
 
//查询表中所有的数据
- (NSArray<MessageModel *> *)getAllDataWithTable:(NSString *)table;
//查询表中符合条件的数据
- (NSArray<MessageModel *> *)getData:(NSString *)messageid  Table:(NSString *)table;
//查询表中按升序一定数量的数据
- (NSArray<MessageModel *> *)getAscendingData:(MessageModel *)message Limit:(NSInteger)limit  Table:(NSString *)table;
//查询表中按降序一定数量的数据
- (NSArray<MessageModel *> *)getDescendingData:(MessageModel *)message Limit:(NSInteger)limit  Table:(NSString *)table;

///插入假数据
-(BOOL)insertMessageModelWithTransaction;

@end

NS_ASSUME_NONNULL_END
