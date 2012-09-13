//
//  VoiceRecordViewController.m
//  VoiceRecord
//
//  Created by Prince on 23/03/2012.
//  Copyright codingcluster 2012. All rights reserved.
//

#import "VoiceRecordViewController.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation VoiceRecordViewController

@synthesize mediaPath, currentTimeLabel;

int isAudioRecord = 0;
	NSError *err = nil;

- (void)viewWillAppear:(BOOL)animated {
    
	audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    
	if(err) {
        
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
    
	[audioSession setActive:YES error:&err];
	
   
    btnStartRecord.hidden = FALSE;
    btnPlay.hidden = FALSE;
    btnStopRecord.hidden = TRUE;
    btnPauseRecord.hidden = TRUE;
    btnResumeRecord.hidden = TRUE;
    currentTimeLabel.hidden = TRUE;
    
}

- (void)viewDidLoad {
    
	[super viewDidLoad];
    self.title = @"Voice Recorder";

    // setup clock
	currentTimeUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                             target:self selector:@selector(updateAudioDisplay)
                             userInfo:NULL repeats:YES];
    
}

//To start voice recording
- (IBAction) startRecording {
	
    isAudioRecord = 1;
    currentTimeLabel.hidden = FALSE;
    btnStartRecord.hidden = TRUE;
    btnPlay.hidden = TRUE;
    btnStopRecord.hidden = FALSE;
    btnPauseRecord.hidden = FALSE ;
    btnResumeRecord.hidden = TRUE;
    
 
	// We can use kAudioFormatAppleIMA4 (4:1 compression) or kAudioFormatLinearPCM for nocompression
	[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];

	// We can use 44100, 32000, 24000, 16000 or 12000 depending on sound quality
	[recordSetting setValue:[NSNumber numberWithFloat:32000.0] forKey:AVSampleRateKey];
	
	// We can use 2(if using additional h/w) or 1 (iPhone only has one microphone)
	[recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
	
    recordSetting = [[NSMutableDictionary alloc] init];
    
   NSError *error;
   
    if (![[NSFileManager defaultManager] fileExistsAtPath:mediaPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:mediaPath withIntermediateDirectories:NO attributes:nil error:&error];
   }

   
   mediaPath = [[NSString stringWithFormat:@"%@/myVoice.caf", DOCUMENTS_FOLDER] retain];
   NSURL *url = [NSURL fileURLWithPath:mediaPath];
   err = nil;
   NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
   
   if(audioData) {
        
	  NSFileManager *fm = [NSFileManager defaultManager];
	  [fm removeItemAtPath:[url path] error:&err];
       
   }
	
   err = nil;
   recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
	
   if(!recorder){
       
      NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
      UIAlertView *alert =
      [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: [err localizedDescription]
								  delegate: nil cancelButtonTitle:@"OK"
						          otherButtonTitles:nil];
       [alert show];
       [alert release];
       return;
   }
    
   //prepare to record
   [recorder setDelegate:self];
   [recorder prepareToRecord];
   recorder.meteringEnabled = YES;
   
   BOOL audioHWAvailable = audioSession.inputIsAvailable;
   
   if (! audioHWAvailable) {
    
        UIAlertView *cantRecordAlert = [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: @"Audio input hardware not available"
								  delegate: nil cancelButtonTitle:@"OK"
						          otherButtonTitles:nil];
        [cantRecordAlert show];
        [cantRecordAlert release]; 
        return;
   }
    
	// start recording
	[recorder record];
    
}

- (IBAction)playRecording

{
	if(!mediaPath)
		mediaPath = [[NSString stringWithFormat:@"%@/myVoiceDefault.caf", DOCUMENTS_FOLDER] retain];
	
	//NSLog(@"Playing sound from Path: %@",recorderFilePath);
	
	if(soundID)	{
        
		AudioServicesDisposeSystemSoundID(soundID);
        
	}
	
	//Get a URL for the sound file
	NSURL *filePath = [NSURL fileURLWithPath:mediaPath isDirectory:NO];
	
	//Use audio sevices to create the sound
	AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
	
	//Use audio services to play the sound
	AudioServicesPlaySystemSound(soundID);
    
}

- (void) updateAudioDisplay {
    
    double currentTime = recorder.currentTime;
	
    if (recorder == nil) {
 
        currentTimeLabel.text = @"";
	
    } else if (!recorder.isRecording) {
        
        currentTimeLabel.text = [NSString stringWithFormat: @"Recording  %02d:%02d",
								 (int) currentTime/60,
								 (int) currentTime%60];
        
    } else {
        
		currentTimeLabel.text = [NSString stringWithFormat: @"Recording %02d:%02d",
								 (int) currentTime/60,
								 (int) currentTime%60];		
		[recorder updateMeters];
        
	}
    
}


//To stop the voice recording.
- (IBAction) stopRecording {
    
	[recorder stop];
    currentTimeLabel.hidden = TRUE;
    btnStartRecord.hidden = FALSE;
    btnPlay.hidden = FALSE;
    btnStopRecord.hidden = TRUE;
    btnPauseRecord.hidden = TRUE ;
    btnResumeRecord.hidden = TRUE;
    isAudioRecord = 0;
    
}

// To pause the voice recording.
- (IBAction) pauseRecording {
	
    [recorder pause];
    [self updateAudioDisplay];
    btnStartRecord.hidden = TRUE;
    btnResumeRecord.hidden = FALSE;
    btnPlay.hidden = FALSE;
    btnStopRecord.hidden = TRUE;
    btnPauseRecord.hidden = TRUE;
    
}

// To resume the audio from pause
- (IBAction) resumeRecording {
	
    [recorder record];
    btnStartRecord.hidden = TRUE;
    btnPlay.hidden = TRUE;
    btnStopRecord.hidden = FALSE;
    btnPauseRecord.hidden = FALSE;
    btnResumeRecord.hidden = TRUE;
    
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    
    [super dealloc];
}


@end
