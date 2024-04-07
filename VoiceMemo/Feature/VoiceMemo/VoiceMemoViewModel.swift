//
//  VoiceMemoViewModel.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/8/24.
//

import AVFoundation

class VoiceMemoViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isDisplayingDeletingAlert: Bool
    @Published var isDisplayingAlert: Bool
    @Published var alertMessage: String
    
//    음성메모 녹음 프로퍼티
    var audioRecorder: AVAudioRecorder?
    @Published var isRecording: Bool
    
//    음성메모 재생프로퍼티
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool
    @Published var isPaused: Bool
    @Published var playedTime: TimeInterval
    private var progressTimer: Timer?
    
//    음성메모 파일
    var recordFiles: [URL]
    @Published var selectedRecordFile: URL?
    
    init(isDisplayingDeletingAlert: Bool = false,
         isDisplayingAlert: Bool = false,
         alertMessage: String = "",
         isRecording: Bool = false,
         isPlaying: Bool = false,
         isPaused: Bool = false,
         playedTime: TimeInterval = 0,
         recordFiles: [URL] = []
    ) {
        self.isDisplayingDeletingAlert = isDisplayingDeletingAlert
        self.isDisplayingAlert = isDisplayingAlert
        self.alertMessage = alertMessage
        self.isRecording = isRecording
        self.isPlaying = isPlaying
        self.isPaused = isPaused
        self.playedTime = playedTime
        self.recordFiles = recordFiles
    }
}

extension VoiceMemoViewModel {
    func voiceRecordCellTapped(_ recordFile: URL) {
        if selectedRecordFile != recordFile {
            stopPlaying()
            selectedRecordFile = recordFile
        }
    }
    
    func removeBtnTapped() {
        setIsDisplayingDeletingAlert(true)
    }
    
    func removeSelectedVoiceRecord() {
        guard let fileToRemove = selectedRecordFile,
              let indexToRemove = recordFiles.firstIndex(of: fileToRemove) else {
            displayAlert(message: "선택된 음성메모 파일을 찾을 수 없습니다.")
            return
        }
        
        do  {
            try FileManager.default.removeItem(at: fileToRemove)
            recordFiles.remove(at: indexToRemove)
            selectedRecordFile = nil
            stopPlaying()
            displayAlert(message: "선택된 음성메모 파일을 성공적으로 삭제했습니다.")
        } catch {
            displayAlert(message: "선택된 음성메모 삭제 중 오류가 발생했습니다.")
        }
    }
    
    private func setIsDisplayingDeletingAlert(_ isDisplaying: Bool) {
        isDisplayingDeletingAlert = isDisplaying
    }
    
    private func setErrorAlertMessage(_ message: String) {
        alertMessage = message
    }
    
    private func setIsDisplayingErrorAlert(_ isDisplaying: Bool) {
        isDisplayingAlert = isDisplaying
    }
    
    private func displayAlert(message: String) {
        setErrorAlertMessage(message)
        setIsDisplayingErrorAlert(true)
    }
}

// MARK: - 음성메모 녹음
extension VoiceMemoViewModel {
    func recordBtnTapped() {
        selectedRecordFile = nil
        
        if isPlaying {
            stopPlaying()
            startRecording()
        } else if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("새로운 녹음 \(recordFiles.count + 1)")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            self.isRecording = true
        } catch {
            displayAlert(message: "음성메모 녹음 중 오류가 발생했습니다.")
        }
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        self.recordFiles.append(self.audioRecorder!.url)
        self.isRecording = false
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

// MARK: - 음성메모 재생
extension VoiceMemoViewModel {
    func startPlaying(recordingURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            self.isPlaying = true
            self.isPaused = false
            self.progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.updateCurrentTime()
            }
        } catch {
            displayAlert(message: "음성 메모 재생 중 오류가 발생했습니다.")
        }
    }
    
    private func updateCurrentTime() {
      self.playedTime = audioPlayer?.currentTime ?? 0
    }
    
    private func stopPlaying() {
        audioPlayer?.stop()
        playedTime = 0
        self.progressTimer?.invalidate()
        self.isPlaying = false
        self.isPaused = false
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
        self.isPaused = true
    }
    
    func resumePlaying() {
        audioPlayer?.play()
        self.isPaused = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isPlaying = false
        self.isPaused = false
    }
    
    func getFileInfo(for url: URL) -> (Date?, TimeInterval?) {
        let fileManager = FileManager.default
        var creationDate: Date?
        var duration: TimeInterval?
        
        do {
            let fileAttributes = try fileManager.attributesOfItem(atPath: url.path)
            creationDate = fileAttributes[.creationDate] as? Date
        } catch {
            displayAlert(message: "선택된 음성메모 파일 정보를 불러올 수 없습니다.")
        }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            duration = audioPlayer.duration
        } catch {
            displayAlert(message: "선택된 음성메모 파일의 재생 시간을 불러올 수 없습니다.")
        }
        
        return (creationDate, duration)
    }
}
