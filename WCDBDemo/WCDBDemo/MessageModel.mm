//
//  MessageModel.m
//  WCDBDemo
//
//  Created by 刘少华 on 2020/10/19.
//

#import "MessageModel.h"
#import "MessageModel+WCDB_MessageModel.h"
@implementation MessageModel

//需要绑定到数据表的类
WCDB_IMPLEMENTATION(MessageModel)


//绑定到数据表的字段
WCDB_SYNTHESIZE(MessageModel, messageid)
WCDB_SYNTHESIZE(MessageModel, name)
WCDB_SYNTHESIZE(MessageModel, title)
WCDB_SYNTHESIZE(MessageModel, content)
WCDB_SYNTHESIZE(MessageModel, num)

//设置数据库表的主键
WCDB_PRIMARY_AUTO_INCREMENT(MessageModel, num)

@end
