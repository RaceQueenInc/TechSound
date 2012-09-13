//
//  VoiceRecordViewController.h
//  VoiceRecord
//
//  Created by Prince on 23/03/2012.
//  Copyright codingcluster 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface VoiceRecordViewController : UIViewController <AVAudioRecorderDelegate> {
    
	
	NSString *mediaPath;
	NSTimer *currentTimeUpdateTimer;
    UILabel *currentTimeLabel;
    SystemSoundID soundID;
	AVAudioRecorder *recorder;
    NSMutableDictionary *recordSetting;

    
    IBOutlet UIButton *btnStartRecord;
    IBOutlet UIButton *btnStopRecord;
    IBOutlet UIButton *btnPauseRecord;
    IBOutlet UIButton *btnResumeRecord;
    IBOutlet UIButton *btnPlay;
    
    AVAudioSession *audioSession;

}


@property (nonatomic, retain)IBOutlet NSString * mediaPath;
@property (nonatomic ,retain)IBOutlet UILabel *currentTimeLabel;


- (IBAction) startRecording;
- (IBAction) stopRecording;
- (IBAction) pauseRecording;
- (IBAction) resumeRecording;
- (IBAction) playRecording;

@end
