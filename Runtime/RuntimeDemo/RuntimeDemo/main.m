//
//  main.m
//  RuntimeDemo
//
//  Created by daiyan on 16/6/16.
//  Copyright © 2016年 DaiYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

// 自定义一个方法
void sayFunction (id self, SEL _cmd, id some){
    NSLog(@"%@岁的%@说:%@", object_getIvar(self, class_getInstanceVariable([self class], "_age")),[self valueForKey:@"name"],some);
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        //动态创建对象 创建一个Person继承自NSObject类
        Class Person = objc_allocateClassPair([NSObject class], "Person", 0);
        
        //为该类添加NSString *_name成员变量
        class_addIvar(Person, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
        //为该类添加int _age成员变量
        class_addIvar(Person, "_age", sizeof(int), sizeof(int), @encode(int));
        
        //注册方法名为say的方法
        SEL s = sel_registerName("say");
        //为该类增加名为say的方法
        class_addMethod(Person, s, (IMP)sayFunction, "v@:@");
        
        //注册该类
        objc_registerClassPair(Person);
        
        //创建一个类的实例
        id personInstance = [[Person alloc] init];
        
        //KVC 动态改变 对象personInstance中的实例变量
        [personInstance setValue:@"苍老师" forKey:@"name"];
        
        //从类中获取成员变量Ivar
        Ivar ageIvar = class_getInstanceVariable(Person, "_age");
        //为personInstance的成员变量赋值
        object_setIvar(personInstance, ageIvar, @18);
        
        //调用 personInstance 对象中的s方法选择器对于的方法
        //objc_msgSend(personInstance, s, @"大家好!")  //这样写也可以
        ((void (*)(id, SEL, id))objc_msgSend)(personInstance, s, @"大家好");
        
        personInstance = nil; //当Person类或者它的子类的实例还存在，则不能调用objc_disposeClassPair这个方法；因此这里要先销毁实例对象后才能销毁类；
        
        //销毁类
        objc_disposeClassPair(Person);
    }
    return 0;
}
