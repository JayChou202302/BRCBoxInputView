//
//  BRCRootTabBarViewController.m
//  BRCBoxInputView_OC
//
//  Created by sunzhixiong on 2024/8/8.
//

#import "BRCRootTabBarViewController.h"

@implementation BRCRootTabBarViewController

- (NSArray *)tabImageArray {
    return @[@"house",@"keyboard"];
}

- (NSArray *)tabTitleKeyArray {
    return @[@"key.main.tab.test.title", @"key.main.tab.test.example"];
}

- (NSArray *)controllerClassArray {
    return @[ @"BRCMainTestViewController", @"BRCBoxInputExampleViewController"];
}

@end
