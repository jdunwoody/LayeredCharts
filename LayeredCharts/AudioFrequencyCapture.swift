import Foundation
import AVFoundation

class AudioFrequencyCapture {
    var engine = AVAudioEngine()

    init() {
    }

    func initialiseAudio(completion: @escaping () -> Void) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)

            print("Audio initialised")
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }

        do {
            try audioSession.setActive(true)
        } catch {
            print("Unable to activate")
        }

        let inputNode = engine.inputNode
        let mainMixerNode = engine.mainMixerNode
        engine.connect(inputNode, to: mainMixerNode, format: inputNode.inputFormat(forBus: 0))

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputNode.inputFormat(forBus: 0)) { (buffer: AVAudioPCMBuffer, time: AVAudioTime) in

            //            var ddata: NSData
            //            buf = AudioBuffer(mNumberChannels: 1, mDataByteSize: numberOfFrames * UInt32(sizeof(Float32)), mData: &ddata)
            //            var audioBuffers = AudioBufferList(mNumberBuffers: 1, mBuffers: buf!)

            //            let ioData = buffer //UnsafeMutablePointer<AudioBufferList>
            //
            //            let abl = UnsafeMutableAudioBufferListPointer(ioData)
            //
            //            for buffer in abl {
            //                memset(buffer.mData, 0, Int(buffer.mDataByteSize))
            //            }
        }

        //        let analysisNode = engine.inputNode
        ////        let analysisNode = AnalysisNode()
        ////        let audioBus = AVAudioNodeBus()
        ////        let bufferSize = 8192 //AVAudioFrameCount()
        //        let format = analysisNode.outputFormat(forBus: 0) //:AVAudioFormat? = nil //AVAudioFormat()
        //        analysisNode.installTap(onBus: 0, bufferSize: 8192, format: format) { buffer, time in
        //            print("Tapped")
        //
        //        }
        //        engine.attach(analysisNode)

        //        audioSession.requestRecordPermission() { [unowned self] allowed in
        //            DispatchQueue.main.async {
        //                if allowed {
        //                    print("Recording ready")
        //                    completion()
        //                } else {
        //                    print("Unable to record")
        //                }
        //            }
        //        }
    }
}

class AnalysisNode: AVAudioNode {

}

//    func setupAudio() {
//        //        audioFileURL = Bundle.main.url(forResource: "Intro", withExtension: "mp4")
//
//        engine.attach(player)
//        engine.attach(rateEffect)
//        engine.connect(player, to: rateEffect, format: audioFormat)
//        engine.connect(rateEffect, to: engine.mainMixerNode, format: audioFormat)
//
//        engine.prepare()
//
//        do {
//            try engine.start()
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
//
//    func start() {
//        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
//
//        let settings = [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//            AVSampleRateKey: 12000,
//            AVNumberOfChannelsKey: 1,
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//        ]
//
//        do {
//            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
//            audioRecorder.delegate = self
//            audioRecorder.record()
//
//            recordButton.setTitle("Tap to Stop", for: .normal)
//        } catch {
//            finishRecording(success: false)
//        }
//    }
//}
