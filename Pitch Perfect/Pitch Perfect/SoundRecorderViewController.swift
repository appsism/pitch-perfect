//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Ganesh Sadasivan on 3/29/15.
//  Copyright (c) 2015 Ganesh Sadasivan. All rights reserved.
//

import UIKit
import AVFoundation

class SoundRecorderViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var tapLabel: UILabel!
    var audioRecorder: AVAudioRecorder!
    
    var recordedAudio: RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        tapLabel.enabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Stop_TouchUpInside(sender: UIButton) {
        recordingInProgress.hidden=true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

    @IBAction func Record_TouchUpInside(sender: UIButton) {
       
        recordButton.enabled = false
        tapLabel.enabled = false
        recordingInProgress.hidden = false
        stopButton.hidden=false
        
        let projectDocumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ddMMMyy-HHmmss"
        
        let recordedFileName = dateFormatter.stringFromDate(currentDateTime) + ".wav"
        
        let pathArray = [projectDocumentDirectoryPath, recordedFileName]
        
        let recordedFilePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var recordingAudioSession = AVAudioSession.sharedInstance()
        recordingAudioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: recordedFilePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag){
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = audioRecorder.url
            recordedAudio.title = audioRecorder.url.lastPathComponent
        
            self.performSegueWithIdentifier("showRecordingsSegue", sender: recordedAudio)
        }
        else{
            recordButton.enabled = true
            tapLabel.enabled=true
            stopButton.hidden = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="showRecordingsSegue"){
            let soundPlayerVC: SoundPlayerViewController = segue.destinationViewController as SoundPlayerViewController
            
            let data = sender as RecordedAudio
            soundPlayerVC.receivedAudio = data
        }
    }
}

