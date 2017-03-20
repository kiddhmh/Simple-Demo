//
//  Person+Associated.h
//  RuntimeDemo2
//
//  Created by daiyan on 16/6/17.
//  Copyright © 2016年 DaiYan. All rights reserved.
//

#import "Person.h"

typedef void(^CodingCallBack)();

@interface Person (Associated)

@property (nonatomic, strong) NSNumber *associatedBust;  // 胸围
@property (nonatomic, copy) CodingCallBack associatedCallBack; // 写代码

@end
