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
        self.parameters["size"] = 30
    }
}
