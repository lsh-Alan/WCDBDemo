//
//  MessageModel.h
//  WCDBDemo
//
//  Created by 刘少华 on 2020/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSObject

@property (nonatomic, copy) NSString * messageid;

@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * content;

@property (nonatomic, assign) NSInteger num;




@end

NS_ASSUME_NONNULL_END
