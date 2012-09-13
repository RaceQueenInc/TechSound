//
//  record_audio_testAppDelegate.h
//  record_audio_test
//
//  Created by jake on 11/6/09.
//  Copyright Memento Security 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class record_audio_testViewController;

@interface record_audio_testAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    record_audio_testViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet record_audio_testViewController *viewController;

@end

