//
//  UITextViewWorkaround.m
//  Cautios-App
//
//  Created by Ajay Sridhar on 11/10/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextViewWorkaround.h"
#import  <objc/runtime.h>

@implementation UITextViewWorkaround : NSObject
+ (void)executeWorkaround {
    if (@available(iOS 13.2, *)) {
    }
    else {
        const char *className = "_UITextLayoutView";
        Class cls = objc_getClass(className);
        if (cls == nil) {
            cls = objc_allocateClassPair([UIView class], className, 0);
            objc_registerClassPair(cls);
#if DEBUG
            printf("added %s dynamically\n", className);
#endif
        }
    }
}
@end
