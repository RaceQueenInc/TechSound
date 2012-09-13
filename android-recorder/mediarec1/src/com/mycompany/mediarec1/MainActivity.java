package com.mycompany.mediarec1;
import java.io.*;
import android.app.*;
import android.os.*;
import android.view.*;
import android.widget.*;
import android.media.*;
import android.util.*;

public class MainActivity extends Activity {
	private TextView tvStatus;
	private Button btnRecorder;
	private Button btnPlay;
	private MediaRecorder objRecorder;
	private MediaPlayer mPlayer;
	private String record_path;
	@Override
	public void onCreate(Bundle savedInstanceState) {
		record_path = 	this.getString(R.string.app_rec_des);
		
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		clearRecord();
		initForm();
		initRecorder();

		btnRecorder.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				if(btnRecorder.getText()=="Record"){
					btnRecorder.setText("Stop");	
					startRecording();
				}else{
					btnRecorder.setText("Record");
					stopRecording();
					if(fileChecked())
						btnPlay.setEnabled(true);
				}
			}
         });


		btnPlay.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				if(btnPlay.getText()=="Play"){
					playRecorded();
					btnPlay.setText("Stop");
					btnRecorder.setEnabled(false);
				}else{
					stopRecorded();
					btnPlay.setText("Play");
					btnPlay.setEnabled(false);
					btnRecorder.setEnabled(true);
				}
			}
         });
	}
	public void initForm(){
		tvStatus = (TextView) findViewById(R.id.tvStatus);
		
		btnRecorder = (Button) findViewById(R.id.btnRecorder);
		
		btnPlay = (Button) findViewById(R.id.btnPlay);
		btnPlay.setEnabled(false);
		
		mPlayer = new MediaPlayer();
	}
	public void initRecorder(){
		objRecorder = new MediaRecorder();
		objRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
		objRecorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);
		objRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
		objRecorder.setOutputFile(record_path);
	}
	public void startRecording(){
		
		try {
			tvStatus.setText("Status: REC:RECORDING...");
			objRecorder.prepare();
			objRecorder.start();
		}catch(IllegalStateException i){
			tvStatus.setText("Status: REC:IllegalStateException...");
		}catch(IOException e){
			tvStatus.setText("Status: REC:IOException...");
		}	
	}
	public void stopRecording(){
		try{
			tvStatus.setText("Status: REC:STOPPED...");
			objRecorder.stop();
			objRecorder.reset();
			objRecorder.release();
		}catch(IllegalStateException i){
			tvStatus.setText("Status: REC:IllegalStateException...");
		}
		objRecorder=null;
		initRecorder();
	}
	public void playRecorded(){
		try {
			mPlayer.setDataSource(record_path);
			mPlayer.prepare();
			mPlayer.start();
			tvStatus.setText("Status: PLAY:PLAYING...");
		} catch (IOException e) {
			tvStatus.setText("Status: PLAY:IOException...");
		}
	}
	public void stopRecorded(){
		mPlayer.reset();
		mPlayer.release();
		mPlayer = null;
		mPlayer =new MediaPlayer();

	}
	public boolean fileChecked(){
		File f =new File(record_path);
		return f.exists();
	}
	public void clearRecord(){
		File f =new File(record_path);
		f.delete();
	}
}
