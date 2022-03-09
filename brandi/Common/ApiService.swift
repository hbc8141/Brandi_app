//
//  ApiService.swift
//  brandi
//
//  Created by User on 2022/03/08.
//

import Alamofire
import RxCocoa
import RxSwift

public enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
}

protocol ApiRequest {
    var method:RequestType { get }
    var path:String { get }
    var parameters:[String: Any] { get }
}

enum APIType {
    case geocode, general
}

extension ApiRequest {
    func request(with baseURL: URL) -> URLRequest {
        guard var components:URLComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            fatalError("URL 컴포넌트 생성 실패")
        }

        // GET 형식일 경우 쿼리 추가
        if self.method == .get {
            components.queryItems = self.parameters.map {
                URLQueryItem(name: String($0), value: $1 as? String ?? "")
            }
        }

        guard let url:URL = components.url else {
            fatalError("URL 가져오기 실패")
        }
        
        let request : URLRequest = {
            var request = URLRequest(url: url)
            request.httpMethod = self.method.rawValue
            request.headers = HTTPHeaders(["Authorization": Utils.shared.KAKAO_API_KEY])
            
            // GET이 아닐 경우 Serialization 후 body에 추가
            if self.method != .get {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: self.parameters, options: .sortedKeys)
                } catch {}
            }

            return request
        }()
        
        return request
    }
}

class ApiService {
    // 기본 URL
    private let baseURL:URL = URL(string: "https://dapi.kakao.com/v2/search/image")!
    
    func request<T: Codable>(apiRequest: ApiRequest) -> Observable<T> {
        return Observable.create { (observer:AnyObserver) in
            let request:URLRequest = apiRequest.request(with: self.baseURL)

            let dataRequest = AF.request(request).responseData { (response:AFDataResponse<Data>) in
                switch response.result {
                    case .success(let data):
                        do {
                            let model:T = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(model)
                        } catch let error {
                            print(error)
                            observer.onError(error)
                        }
                        break
                    case .failure(let error):
                        print(error)
                        observer.onError(error)
                        break
                }

                observer.onCompleted()
            }
            
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
}
