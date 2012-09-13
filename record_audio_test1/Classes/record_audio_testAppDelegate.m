//
//  record_audio_testAppDelegate.m
//  record_audio_test
//
//  Created by jake on 11/6/09.
//  Copyright Memento Security 2009. All rights reserved.
//

#import "record_audio_testAppDelegate.h"
#import "record_audio_testViewController.h"

@implementation record_audio_testAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
