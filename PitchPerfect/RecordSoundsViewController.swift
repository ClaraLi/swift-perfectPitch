//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Jingci Li on 10/23/15.
//  Copyright © 2015 Clara Li. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var RecordInProgress: UILabel!
    @IBOutlet weak var StopButton: UIButton!
    @IBOutlet weak var RecordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    @IBAction func Record(sender: AnyObject) {
        self.RecordInProgress.text = "Record in progress"
        StopButton.hidden = false
        RecordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            print("error exist")
            RecordButton.enabled = true
            StopButton.hidden = true
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    @IBAction func Stop(sender: AnyObject) {

        audioRecorder.stop()
        audioRecorder.pause()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        self.RecordInProgress.text = "Tap to record"
        StopButton.hidden = true
        RecordButton.enabled = true    }

}

