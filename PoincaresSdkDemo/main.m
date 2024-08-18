/**
 * @file main.m
 * @author wuliang (wuliang@poincares.com)
 * @brief
 * @version 0.1
 * @date 2024-07-12
 *
 * @copyright Copyright (c) 2024 @poincares.com
 *
 */

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
  NSString * appDelegateClassName;
  @autoreleasepool {
      // Setup code that might create autoreleased objects goes here.
      appDelegateClassName = NSStringFromClass([AppDelegate class]);
  }
  return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
