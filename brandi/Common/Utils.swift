//
//  Utile.swift
//  brandi
//
//  Created by User on 2022/03/08.
//

import Foundation

class Utils: NSObject {

    // 여러 클래스에서 해당 클래스를 사용하기 위해 싱글톤 패턴으로 변경
    static let shared:Utils = Utils()

    // Kakao API 키
    let KAKAO_API_KEY:String = Bundle.main.object(forInfoDictionaryKey: "KAKAO_IMAGE_API_KEY") as? String ?? ""
    
    // 날짜 포맷 변경
    // ISO Date Formatter을 yyyy/MM/dd HH:mm:SS로 변환
    func convertIsoToKrFormat(dateStr: String) -> String {
        let formatter:DateFormatter = DateFormatter()
        
        // ISO 8601 포맷
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        
        // Date형식으로 변환
        guard let date:Date = formatter.date(from: dateStr) else {
            // 변환 실패 시 기존의 날짜 포맷으로 반환
            return dateStr
        }
        
        // 연도/월/일 시:분:초 로 포맷 변경
        formatter.dateFormat = "yyyy/MM/dd HH:mm:SS"

        // 지정된 포맷으로 재변경
        let convertDateStr:String = formatter.string(from: date)
        
        return convertDateStr
    }
}
