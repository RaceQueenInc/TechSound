//
//  VoiceRecordAppDelegate.h
//  VoiceRecord
//
//  Created by Prince on 23/03/2012.
//  Copyright codingcluster 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VoiceRecordViewController;

@interface VoiceRecordAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    VoiceRecordViewController *viewController;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet VoiceRecordViewController *viewController;

-(void)createDefaultFile;

@end

