//
//  Utile.swift
//  brandi
//
//  Created by User on 2022/03/08.
//

import Foundation

class Utils: NSObject {
    
    // 날짜 포맷 변경
    // ISO Date Formatter을 yyyy/MM/dd HH:mm:SS로 변환
    func convertIsoToKrFormat(dateStr: String) -> String {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        // 변환 실패 시 기존의 날짜 포맷으로 반환
        guard let date:Date = formatter.date(from: dateStr) else { return dateStr }
        
        formatter.dateFormat = "yyyy/MM/dd HH:mm:SS"
        let convertDateStr:String = formatter.string(from: date)
        
        return convertDateStr
    }
}
