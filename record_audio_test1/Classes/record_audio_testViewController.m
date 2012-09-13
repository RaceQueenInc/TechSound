//
//  record_audio_testViewController.m
//  record_audio_test
//
//  Created by jake on 11/6/09.
//  Copyright Memento Security 2009. All rights reserved.
//

#import "record_audio_testViewController.h"

@implementation record_audio_testViewController
@synthesize actSpinner, btnStart, btnPlay;



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Start the toggle in true mode.
	toggle = YES;
	btnPlay.hidden = YES;

	//Instanciate an instance of the AVAudioSession object.
	AVAudioSession * audioSession = [AVAudioSession sharedInstance];
	//Setup the audioSession for playback and record. 
	//We could just use record and then switch it to playback leter, but
	//since we are going to do both lets set it up once.
	[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
	//Activate the session
	[audioSession setActive:YES error: &error];
	
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)  start_button_pressed{

	if(toggle)
	{
		toggle = NO;
		[actSpinner startAnimating];
		[btnStart setTitle:@"Stop Recording" forState: UIControlStateNormal ];	
		btnPlay.enabled = toggle;
		btnPlay.hidden = !toggle;
		
		//Begin the recording session.
		//Error handling removed.  Please add to your own code.
				
		//Setup the dictionary object with all the recording settings that this 
		//Recording sessoin will use
		//Its not clear to me which of these are required and which are the bare minimum.
		//This is a good resource: http://www.totodotnet.net/tag/avaudiorecorder/
		NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
		[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
		[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
		[recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
		
		//Now that we have our settings we are going to instanciate an instance of our recorder instance.
		//Generate a temp file for use by the recording.
		//This sample was one I found online and seems to be a good choice for making a tmp file that
		//will not overwrite an existing one.
		//I know this is a mess of collapsed things into 1 call.  I can break it out if need be.
		recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
		NSLog(@"Using File called: %@",recordedTmpFile);
		//Setup the recorder to use this file and record to it.
		recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];
		//Use the recorder to start the recording.
		//Im not sure why we set the delegate to self yet.  
		//Found this in antother example, but Im fuzzy on this still.
		[recorder setDelegate:self];
		//We call this to start the recording process and initialize 
		//the subsstems so that when we actually say "record" it starts right away.
		[recorder prepareToRecord];
		//Start the actual Recording
		[recorder record];
		//There is an optional method for doing the recording for a limited time see 
		//[recorder recordForDuration:(NSTimeInterval) 10]
		
	}
	else
	{
		toggle = YES;
		[actSpinner stopAnimating];
		[btnStart setTitle:@"Start Recording" forState:UIControlStateNormal ];
		btnPlay.enabled = toggle;
		btnPlay.hidden = !toggle;
		
		NSLog(@"Using File called: %@",recordedTmpFile);
		//Stop the recorder.
		[recorder stop];
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

-(IBAction) play_button_pressed{

	//The play button was pressed... 
	//Setup the AVAudioPlayer to play the file that we just recorded.
	AVAudioPlayer * avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedTmpFile error:&error];
	[avPlayer prepareToPlay];
	[avPlayer play];
	
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	//Clean up the temp file.
	NSFileManager * fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:[recordedTmpFile path] error:&error];
	//Call the dealloc on the remaining objects.
	[recorder dealloc];
	recorder = nil;
	recordedTmpFile = nil;
}


- (void)dealloc {
	[super dealloc];
}

@end
