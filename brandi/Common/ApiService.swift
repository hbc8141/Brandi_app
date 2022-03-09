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
            fatalError("Unable to create URL compoenents")
        }

        if self.method == .get {
            components.queryItems = self.parameters.map {
                URLQueryItem(name: String($0), value: $1 as? String ?? "")
            }
        }

        guard let url:URL = components.url else {
            fatalError("Could not get url")
        }
        
        let request : URLRequest = {
            var request = URLRequest(url: url)
            request.httpMethod = self.method.rawValue
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("application/json", forHTTPHeaderField: "accept")
            request.headers = HTTPHeaders(["Authorization": "KakaoAK fcdf5e9b8d6a2ae3c54a1920dce8c10b"])
            
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
    private let baseURL:URL = URL(string: "https://dapi.kakao.com/v2/search/image")!
    
    func request<T: Codable>(apiRequest: ApiRequest) -> Observable<T> {
        return Observable.create { (observer:AnyObserver) in
            let request:URLRequest = apiRequest.request(with: self.baseURL)
            print(request.url?.absoluteString)
            let dataRequest = AF.request(request).responseData { (response:AFDataResponse<Data>) in
                switch response.result {
                    case .success(let data):
                        do {
                            print(String(data: data, encoding: String.Encoding.utf8))
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
