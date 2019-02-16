//
//  RecordSoundsViewControllerr.swift
//  PitchPerfect
//
//  Created by Ahmed Alsamani on 30/10/2018.
//  Copyright © 2018 Ahmed Alsamani. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController ,AVAudioRecorderDelegate{
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLable: UILabel!
    @IBOutlet weak var recoredButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton(isRecord: false)
    }
    
    // MARK: - Audio Recorder
    
    @IBAction func recordAudio(_ sender: Any) {
        setupButton(isRecord: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: - Stop Audio Recorder
    
    @IBAction func stopRecording(_ sender: Any) {
        setupButton(isRecord: false)
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: - Audio Recorder UI Setup
    
    func setupButton(isRecord: Bool) {
        stopRecordingButton.isEnabled = isRecord
        recoredButton.isEnabled = !isRecord
        if isRecord {
            recordingLable.text = "Recording in Prossing"
        }else{
            recordingLable.text = "Tap to Rercord"
        }
    }
    // MARK: - Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
                performSegue(withIdentifier: "StopRecording", sender: audioRecorder.url)
        }else{
                print("recording was not successful")
        }
        
    }   
    
    // MARK: - segue to PlaySoundsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StopRecording" {
            let  playSoundsVC = segue.destination as! PlaySoundsViewController
            let recoredAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recoredAudioURL
        }
    }
    
}

