//
//  tosmiss_iphoneAppDelegate.h
//  tosmiss-iphone
//
//  Created by Justin Van Eaton on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tosmiss_iphoneViewController;

@interface tosmiss_iphoneAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet tosmiss_iphoneViewController *viewController;

@end
