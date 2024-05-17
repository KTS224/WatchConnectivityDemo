//
//  UserForRankingInfo.swift
//  watchConDemo
//
//  Created by 김태성 on 5/13/24.
//

import Foundation

struct UserForRankingInfo: Identifiable, Hashable {
    let id = UUID()
    var uuid: String
    var nickName: String
    var spentTime: Int
    var isStuding: Bool
}
