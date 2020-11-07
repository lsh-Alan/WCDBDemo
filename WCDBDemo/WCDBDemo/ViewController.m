//
//  ViewController.m
//  WCDBDemo
//
//  Created by 刘少华 on 2020/10/19.
//

#import "ViewController.h"
#import "MessageManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MessageManager shareInstance] deleteAllDataWithTable:table1];

    for (NSInteger i = 0; i < 999; i ++) {
        BOOL res = [[MessageManager shareInstance] insertMessageModelWithTransaction];
    }
    
    NSArray *array = [[MessageManager shareInstance] getAllDataWithTable:table1];
    
    MessageModel *model = nil;
    if (array.count > 10) {
        model = array[10];
    }
    
    NSArray *array2 = [[MessageManager shareInstance] getAscendingData:model Limit:20 Table:table1];
    
 
}


@end
