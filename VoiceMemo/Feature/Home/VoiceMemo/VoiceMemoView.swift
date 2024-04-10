//
//  VoiceMemoView.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/5/24.
//

import SwiftUI

struct VoiceMemoView: View {
    @StateObject private var voiceMemoViewModel = VoiceMemoViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                TitleView()
                
                if voiceMemoViewModel.recordingFiles.isEmpty {
                    AnnouncementView()
                } else {
                    VoiceMemoListView(voiceMemoViewModel: voiceMemoViewModel)
                        .padding(.top, 15)
                }
                
                Spacer()
            }
            
            RecordButtonView(voiceMemoViewModel: voiceMemoViewModel)
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "선택된 음성메모를 삭제하시겠습니까?",
            isPresented: $voiceMemoViewModel.isDisplayingDeletingAlert
        ) {
            Button(role: .destructive) {
                voiceMemoViewModel.removeSelectedVoiceMemo()
            } label: {
                Text("삭제")
            }
            
            Button(role: .cancel) {
                
            } label: {
                Text("취소")
            }
        }
        .alert(voiceMemoViewModel.errorMessage,
               isPresented: $voiceMemoViewModel.isDisplayingErrorAlert) {
            Button(role: .cancel) {
                
            } label: {
                Text("확인")
            }
        }
    }
}

// MARK: - Title View
private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("음성메모")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color.customBlack)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

// MARK: - Voice Memo Annoucement View
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Rectangle()
                .fill(Color.customCoolGray)
                .frame(height: 1)
            
            Spacer()
              .frame(height: 180)
            
            Image("pencil")
                .renderingMode(.template)
            Text("\"음성메모가 존재하지 않습니다.\"")
            Text("\"하단의 녹음 버튼을 눌러 음성메모를 시작해보세요!\"")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundStyle(Color.customGray2)
    }
}


// MARK: - Voice Memo List View
private struct VoiceMemoListView: View {
    @ObservedObject private var voiceMemoViewModel: VoiceMemoViewModel
    
    init(voiceMemoViewModel: VoiceMemoViewModel) {
        self.voiceMemoViewModel = voiceMemoViewModel
    }
    
    fileprivate var body: some View {
        ScrollView(.vertical) {
            VStack {
                Rectangle()
                    .fill(Color.customGray2)
                    .frame(height: 1)
                
                ForEach(voiceMemoViewModel.recordingFiles, id: \.self) { recordingFile in
                    VoiceMemoCellView(voiceMemoViewModel: voiceMemoViewModel, recordingFile: recordingFile)
                }
            }
        }
    }
}

// MARK: - Voice Memo Cell View
private struct VoiceMemoCellView: View {
    @ObservedObject private var voiceMemoViewModel: VoiceMemoViewModel
    private var recordingFile: URL
    private var creationDate: Date?
    private var duration: TimeInterval?
    private var progressBarValue: Float {
      if voiceMemoViewModel.selectedRecordingFile == recordingFile
          && (voiceMemoViewModel.isPlaying || voiceMemoViewModel.isPaused) {
        return Float(voiceMemoViewModel.playedTime) / Float(duration ?? 1)
      } else {
        return 0
      }
    }
    
    fileprivate init(voiceMemoViewModel: VoiceMemoViewModel, recordingFile: URL) {
        self.voiceMemoViewModel = voiceMemoViewModel
        self.recordingFile = recordingFile
        (self.creationDate, self.duration) = voiceMemoViewModel.getFileInfo(for: recordingFile)
    }
    
    fileprivate var body: some View {
        VStack {
            Button {
                voiceMemoViewModel.voieceMemoCellTapped(recordingFile)
            } label: {
                VStack {
                    HStack {
                        Text(recordingFile.lastPathComponent)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.customBlack)
                        
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        if let creationDate = creationDate {
                          Text(creationDate.formattedVoiceMemoDate)
                            .font(.system(size: 14))
                            .foregroundColor(.customIconGray)
                        }
                        
                        Spacer()
                        
                        if voiceMemoViewModel.selectedRecordingFile != recordingFile,
                           let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.customIconGray)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            if voiceMemoViewModel.selectedRecordingFile == recordingFile {
                VStack {
                    ProgressBar(progress: progressBarValue)
                        .frame(height: 2)
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        Text(voiceMemoViewModel.playedTime.formattedTimeInterval)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(Color.customIconGray)
                        
                        Spacer()
                        
                        if let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(Color.customIconGray)
                        }
                    }
                    
                    Spacer()
                        .frame(width: 10)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            if voiceMemoViewModel.isPaused {
                                voiceMemoViewModel.resumePlaying()
                            } else {
                                voiceMemoViewModel.startPlaying(recordingURL: recordingFile)
                            }
                        } label: {
                            Image("play")
                                .renderingMode(.template)
                                .foregroundStyle(Color.customBlack)
                        }
                        
                        Spacer()
                            .frame(width: 10)
                        
                        Button {
                            if voiceMemoViewModel.isPlaying {
                                voiceMemoViewModel.pausePlaying()
                            }
                        } label: {
                            Image("pause")
                                .renderingMode(.template)
                                .foregroundStyle(Color.customBlack)
                        }
                        
                        Spacer()
                        
                        Button {
                            voiceMemoViewModel.removeBtnTapped()
                        } label: {
                            Image("trash")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color.customBlack)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Rectangle()
                .fill(Color.customGray2)
                .frame(height: 1)
        }
    }
}

// MARK: - Progress Bar
private struct ProgressBar: View {
    private var progress: Float
    
    fileprivate init(progress: Float) {
        self.progress = progress
    }
    
    fileprivate var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.customGray2)
                
                Rectangle()
                    .fill(Color.customGreen)
                    .frame(width: CGFloat(self.progress) * geometry.size.width)
            }
        }
    }
}

// MARK: - Record Button View
private struct RecordButtonView: View {
    @ObservedObject private var voiceMemoViewModel: VoiceMemoViewModel
    
    fileprivate init(voiceMemoViewModel: VoiceMemoViewModel) {
        self.voiceMemoViewModel = voiceMemoViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    voiceMemoViewModel.recordBtnTapped()
                } label: {
                    if voiceMemoViewModel.isRecording {
                        Image("mic_recording")
                    } else {
                        Image("mic")
                    }
                }
            }
        }
    }
}

#Preview {
    VoiceMemoView()
}
