//
//  UserStore.swift
//  watchConDemo
//
//  Created by 김태성 on 5/13/24.
//

import Foundation
import Firebase

class UserStore: ObservableObject {
    @Published var userForRankingInfo: [UserForRankingInfo] = []
    @Published var uuid: String = "qweqwe"
    @Published var nickName: String = "아무닉네임"
    @Published var mySpentTime: Int = 10
    @Published var myWeekTime: [Int] = []
    @Published var weekHistoryForChart: [WeekHistoryForChart] = [
        WeekHistoryForChart(datOfTheWeek: "월", spentTime: 0),
        WeekHistoryForChart(datOfTheWeek: "화", spentTime: 0),
        WeekHistoryForChart(datOfTheWeek: "수", spentTime: 0),
        WeekHistoryForChart(datOfTheWeek: "목", spentTime: 0),
        WeekHistoryForChart(datOfTheWeek: "금", spentTime: 0),
        WeekHistoryForChart(datOfTheWeek: "토", spentTime: 0),
        WeekHistoryForChart(datOfTheWeek: "일", spentTime: 0)
    ]
    @Published var dayCompareForChart: [DayCompareForChart] = [
        DayCompareForChart(status: "대학생", time: 12600),
        DayCompareForChart(status: "나", time: 10)
    ]
    
    init() {
        fetchMyData()
        uuid = getDeviceUUID()
    }
    
    let db = Firestore.firestore()
    
    func fetchMyData() {
        let docRef = db.collection("Users").document(uuid)
        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
//                    self.uuid = data["uuid"] as? String ?? ""
                    self.nickName = data["nickName"] as? String ?? ""
                    self.mySpentTime = data["spentTime"] as? Int ?? 10
                    self.myWeekTime = data["history"] as? [Int] ?? [100, 100, 100, 100, 100, 100, 100]
                    
                    for i in 0...6 {
                        self.weekHistoryForChart[i].spentTime = self.myWeekTime[i]
                    }
                    
                    self.dayCompareForChart[1].time = data["spentTime"] as? Int ?? 10
                }
            }
        }
    }
    
    func fetchRankingData() {
        db.collection("Users")
            .getDocuments { (snapshot, error) in
                self.userForRankingInfo.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
//                        let id: String = document.documentID
                        
                        let docData = document.data()
                        let nickName: String = docData["nickName"] as? String ?? ""
                        let spentTime: Int = docData["spentTime"] as? Int ?? 0
                        let uuid: String = docData["uuid"] as? String ?? ""
                        let isStudying: Bool = docData["isStudying"] as? Bool ?? false
                        
                        print("\(nickName), \(spentTime), \(uuid)")
                        
                        let param: UserForRankingInfo = UserForRankingInfo(uuid: uuid, nickName: nickName, spentTime: spentTime, isStuding: isStudying)
                        
                        self.userForRankingInfo.append(param)
                    }
                }
            }
    }
    
    func startFocus() {
        
    }
    
    func updateUserTime() {
        db.collection("Users").document(self.uuid).setData([
            "uuid": self.uuid,
            "nickName": "강물잉어",
            "spentTime": 34732,
            "history": [100, 180, 100, 0, 0, 0, 0],
            "isStudying": false
        ])
    }
    
    func getDeviceUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
}
