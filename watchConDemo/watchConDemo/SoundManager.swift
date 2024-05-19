//
//  SoundManager.swift
//  watchConDemo
//
//  Created by 김태성 on 4/11/24.
//

//import SwiftUI
//import AVFoundation
//
//class SoundSetting: ObservableObject {
//    static let instance = SoundSetting()
//    var player: AVAudioPlayer?
//    
//    enum SoundOption: String {
//        case Click
//        case Knock
//    }
//    
//    func playSound(sound: SoundOption) {
//        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else {
//            print("\(sound.rawValue).mp3")
//            return }
//        
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.play()
//            print("PLAYED")
//        } catch let error {
//            print("재생 오류: \(error.localizedDescription)")
//        }
//    }
//}
//
//// MARK: - 소리 테스트를 위한 화면
//struct SoundTestView: View {
//    private let soundManager = SoundSetting.instance
//    
//    var body: some View {
//        VStack {
//            Button {
//                soundManager.playSound(sound: .Click)
//                print("Click")
//            } label: {
//                Text("Click")
//            }
//            
//            Button {
//                soundManager.playSound(sound: .Knock)
//                print("Knock")
//            } label: {
//                Text("Knock")
//            }
//        }
//    }
//}
