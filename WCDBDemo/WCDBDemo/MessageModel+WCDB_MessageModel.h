//
//  MessageModel+WCDB_MessageModel.h
//  WCDBDemo
//
//  Created by 刘少华 on 2020/10/19.
//

#import "MessageModel.h"
#import <WCDB/WCDB.h>
NS_ASSUME_NONNULL_BEGIN

@interface MessageModel (WCDB_MessageModel)<WCTTableCoding>

//声明需要绑定到数据表的字段
WCDB_PROPERTY(messageid)
WCDB_PROPERTY(name)
WCDB_PROPERTY(title)
WCDB_PROPERTY(content)
WCDB_PROPERTY(num)




@end

NS_ASSUME_NONNULL_END
