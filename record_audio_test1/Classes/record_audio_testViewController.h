//
//  record_audio_testViewController.h
//  record_audio_test
//
//  Created by jake on 11/6/09.
//  Copyright Memento Security 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface record_audio_testViewController : UIViewController <AVAudioRecorderDelegate> {

	IBOutlet UIButton * btnStart;
	IBOutlet UIButton * btnPlay;
	IBOutlet UIActivityIndicatorView * actSpinner;
	BOOL toggle;
	
	//Variables setup for access in the class:
	NSURL * recordedTmpFile;
	AVAudioRecorder * recorder;
	NSError * error;
	
}

@property (nonatomic,retain)IBOutlet UIActivityIndicatorView * actSpinner;
@property (nonatomic,retain)IBOutlet UIButton * btnStart;
@property (nonatomic,retain)IBOutlet UIButton * btnPlay;

- (IBAction) start_button_pressed;
- (IBAction) play_button_pressed;
@end

