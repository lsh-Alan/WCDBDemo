//
//  MessageManager.m
//  WCDBDemo
//
//  Created by 刘少华 on 2020/10/19.
//

#import "MessageManager.h"
#import "MessageModel+WCDB_MessageModel.h"
@interface MessageManager()
{
    WCTDatabase * database;
}
@end
#pragma mark - 表名
NSString *const table1 = @"table1";
NSString *const table2 = @"table2";
NSString *const table3 = @"table3";

@implementation MessageManager
+ (instancetype)shareInstance {
    static MessageManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[MessageManager alloc]init];
        [instance creatDatabase];
        
    });
    
    return instance;
}

+ (NSString *)wcdbFilePath{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbFilePath = [docDir stringByAppendingPathComponent:@"MessageModel.db"];
    return dbFilePath;
}
- (BOOL)creatDatabase {
    
    database = [[WCTDatabase alloc] initWithPath:[MessageManager wcdbFilePath]];
    NSData *password = [@"MyPassword1122323" dataUsingEncoding:NSASCIIStringEncoding];
    [database setCipherKey:password];
    //测试数据库是否能够打开
    if ([database canOpen]) {
        // WCDB大量使用延迟初始化（Lazy initialization）的方式管理对象，因此SQLite连接会在第一次被访问时被打开。开发者不需要手动打开数据库。
        // 先判断表是不是已经存在
        if ([database isOpened]) {
            //根据业务场景创建多张表
            if (![database isTableExists:table1]) {
                return [database createTableAndIndexesOfName:table1 withClass:MessageModel.class];
            }
            if (![database isTableExists:table2]) {
                return [database createTableAndIndexesOfName:table2 withClass:MessageModel.class];
            }
            if (![database isTableExists:table3]) {
                return [database createTableAndIndexesOfName:table3 withClass:MessageModel.class];
            }
        }
    }
    return NO;
}
#pragma mark - 增
- (BOOL)insertData:(MessageModel <WCTTableCoding>*)message Table:(NSString *)table
{
    if (message == nil) {
        return NO;
    }
    if (database == nil) {
        [self creatDatabase];
    }
    return [database insertObject:message into:table];
}
- (BOOL)insertDatas:(NSArray<MessageModel <WCTTableCoding>*> *)messages Table:(NSString *)table
{
    if (database == nil) {
        [self creatDatabase];
    }
    return [database insertObjects:messages into:table];
}
-(BOOL)insertMessageModel{
    
    //插入
    MessageModel *message = [[MessageModel alloc] init];
    message.isAutoIncrement = YES;
    message.title = @"Hello,WCDB";
    message.content = @"Hello, WCDB!";
    //message.num = 12;
    return  [database insertObject:(MessageModel <WCTTableCoding> *) message into:table1];
}
// WCTDatabase 事务操作，利用WCTTransaction
-(BOOL)insertMessageModelWithTransaction{
    
    
    BOOL ret = [database beginTransaction];
    ret = [self insertMessageModel];
    if (ret) {
        
        [database commitTransaction];
        
    }else
        
        [database rollbackTransaction];
    
    return ret;
}
// 另一种事务处理方法Block
-(BOOL)insertMessageModelWithBlock{
    
    BOOL commited  =  [database runTransaction:^BOOL{
        
        BOOL result = [self insertMessageModel];
        if (result) {
            
            return YES;
            
        }else
            return NO;
        
    } event:^(WCTTransactionEvent event) {
        
        NSLog(@"Event %d", event);
    }];
    return commited;
}

#pragma mark - 删
- (BOOL)deleteDataWithId:(NSString *)messageid Table:(NSString *)table {
    if (database == nil) {
        [self creatDatabase];
    }
    return [database deleteObjectsFromTable:table where:MessageModel.messageid == messageid];
}
- (BOOL)deleteAllDataWithTable:(NSString *)table{
    if (database == nil) {
        [self creatDatabase];
    }
    return [database deleteAllObjectsFromTable:table];
}
#pragma mark - 改
- (BOOL)updateData:(NSString *)content byId:(NSString *)messageid Table:(NSString *)table {
    if (database == nil) {
        [self creatDatabase];
    }
    MessageModel *message = [[MessageModel alloc] init];
    message.content = content;

    return [database updateRowsInTable:table onProperties:MessageModel.content withObject:message where:MessageModel.messageid == messageid];
}
- (BOOL)updateData:(MessageModel *)message Table:(NSString *)table
{
    if (database == nil) {
        [self creatDatabase];
    }
    return [database updateRowsInTable:table onProperties:MessageModel.AllProperties withObject:message where:MessageModel.messageid == message.messageid];
}

#pragma mark - 查
- (NSArray<MessageModel *> *)getAllDataWithTable:(NSString *)table {
    if (database == nil) {
        [self creatDatabase];
    }
    return [database getAllObjectsOfClass:MessageModel.class fromTable:table];
}

- (NSArray<MessageModel *> *)getAscendingData:(MessageModel *)message Limit:(NSInteger)limit  Table:(NSString *)table
{
    NSInteger num = 0;
    if (message) {
        num = message.num;
        NSArray<MessageModel *> *objects = [database getObjectsOfClass:MessageModel.class fromTable:table where:MessageModel.num >= num orderBy:MessageModel.num.order(WCTOrderedAscending) limit:limit];
        
        return objects;
    }else{
        //没有参照数据模型时默认从表的数据开始查找  升序
        NSArray<MessageModel *> *objects = [database getObjectsOfClass:MessageModel.class
                                                                            fromTable:table
                                                                              orderBy:MessageModel.num.order(WCTOrderedAscending)
                                                                                limit:limit
                                                                               offset:0];

        return objects;
    }
}

- (NSArray<MessageModel *> *)getDescendingData:(MessageModel *)message Limit:(NSInteger)limit  Table:(NSString *)table
{
    NSInteger num = 0;
    if (message) {
        num = message.num;
        NSArray<MessageModel *> *objects = [database getObjectsOfClass:MessageModel.class fromTable:table where:MessageModel.num <= num orderBy:MessageModel.num.order(WCTOrderedDescending) limit:limit];
        
        return objects;
    }else{
        //没有参照数据模型时默认从表的数据开始查找 降序
        NSArray<MessageModel *> *objects = [database getObjectsOfClass:MessageModel.class
                                                                            fromTable:table
                                                                              orderBy:MessageModel.num.order(WCTOrderedDescending)
                                                                                limit:limit
                                                                               offset:0];
        return objects;
    }
}


- (NSArray<MessageModel *> *)getData:(NSString *)messageid  Table:(NSString *)table{
    if (database == nil) {
        [self creatDatabase];
    }
    return [database getObjectsOfClass:MessageModel.class fromTable:table where:MessageModel.messageid == messageid];
}

@end
