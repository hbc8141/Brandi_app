//
//  ImageSearchRepo.swift
//  brandi
//
//  Created by User on 2022/03/08.
//

import Foundation
import Alamofire

struct ImageSearchRequest: ApiRequest {
    var method: RequestType = .get
    
    var path: String = ""
    
    var parameters: [String : Any] = [String: Any]()
    
    init(query: String) {
        self.parameters["query"] = query
        // 쿼리는 String 형식으로만 추가 가능하므로 숫자 대신 문자로 대입
        self.parameters["size"] = "30"
    }
}
