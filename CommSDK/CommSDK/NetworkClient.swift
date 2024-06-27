//
//  NetworkClient.swift
//  CommSDK
//
//  Created by dong jun park on 4/24/24.
//

import Foundation


public enum NetworkErrorCodeEnum: Int {
    case UNNKOWN = -1
    case SUCCESS
    case FAIL
}

public class NetworkError: Error {
    private var errorCode: NetworkErrorCodeEnum
    private var errorMessage: String?
    
    public func getErrorCode() -> Int {
        return errorCode.rawValue
    }
    
    public func getErrorMessage() -> String {
        if let errMsg = errorMessage, !errMsg.isEmpty {
            return errMsg
        }
        
        switch self.errorCode {
        case .UNNKOWN:
            return "unnkown"
        case .SUCCESS:
            return "success"
        case .FAIL:
            return "fail"
        }
    }
    
    public init(errorCode: NetworkErrorCodeEnum, errorMessage: String? = nil) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
}

public class NetworkClient {
    
    public init() {
        
    }
    
    public func doGet1(url: URL) async throws -> Data {

        print("\n************** requestUrl: \(url.absoluteString) **************")
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 5

        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
            
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("statusCode: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
            print("resultData: \(String(describing: String(data: data, encoding: .utf8)))\n")
        throw NetworkError(errorCode: NetworkErrorCodeEnum.FAIL)
        }
        print("errorcode: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
        print("resultData: \(String(describing: String(data: data, encoding: .utf8)))\n")
        return data
    }
    
    
    public func doPost1(url: URL, requestJsonData: Data) async throws -> Data {

        print("\n************** requestUrl: \(url.absoluteString) **************")
        print("requestData Json: \(String(data: requestJsonData, encoding:.utf8)!)")
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = requestJsonData
            
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("statusCode: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
            print("resultData: \(String(describing: String(data: data, encoding: .utf8)))\n")
            throw NetworkError(errorCode: NetworkErrorCodeEnum.FAIL)
        }
        print("errorcode: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
        print("resultData: \(String(describing: String(data: data, encoding: .utf8)))\n")
        return data
    }
    
//    private func handleNetworkResponse<T: Decodable>(_ data: Data?, error: Error?, decodingType: T.Type) -> Result<T, Error> {
//        if let error = error {
//            return .failure(error)
//        }
//        
//        guard let data = data, let decodedResponse = try? JSONDecoder().decode(decodingType, from: data) else {
//            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Decoding Error"]))
//        }
//        
//        return .success(decodedResponse)
//    }
//    
//    public func postRequest<T: Decodable, U: Encodable>(url: String, requestJsonData: U, decodingType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
//        
//        self.doPost(url: URL(string: url)!, requestJsonData: requestJsonData as! Data)
//            .subscribe { data, error in
//                let result = self.handleNetworkResponse(data, error: error, decodingType: decodingType)
//                completion(result)
//            }
//    }
//        
//    public func getRequest<T: Decodable, U: Encodable>(url: String, requestJsonData: U, decodingType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
//        
//        self.doGet(url: URL(string: url)!)
//            .subscribe { data, error in
//                let result = self.handleNetworkResponse(data, error: error, decodingType: decodingType)
//                completion(result)
//            }
//    }
//    
//    
//    public func doGet(url: URL) -> NetworkObservable<Data?, Error?> {
//        return NetworkObservable() { emitter in
//            DispatchQueue.global().async {
//                
//                print("\n\n")
//                print("requestUrl: \(url.absoluteString)")
////                print("requestData Json: \(String(data: requestJsonData, encoding:.utf8)!)")
//                
//                var request = URLRequest(url: url)
//
//                request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
//                request.httpMethod = "GET"
//                
//                
////                let (data, _) = try await URLSession.shared.data(from: url)
////                return try JSONDecoder().decode([Post].self, from: data)
//                
//                let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                    if let error = error {
//                        DispatchQueue.main.async { emitter(nil, error) }
//                        return
//                    }
//                    print("result: \(String(data: data!, encoding: .utf8)!)")
//                    
//                    if let data = data {
//                        DispatchQueue.main.async {
//                            emitter(data, nil)
//                        }
//                    } else {
//                        DispatchQueue.main.async { emitter(nil, error) }
//                        return
//                    }
//                }
//                
//                task.resume()
//            }
//            
//        }
//    }
    
    
    
    
//    public func doPost(url: URL, requestJsonData: Data) -> NetworkObservable<Data?, Error?> {
//        return NetworkObservable() { emitter in
//            DispatchQueue.global().async {
//                print("\n\n")
//                print("requestUrl: \(url.absoluteString)")
//                print("requestData Json: \(String(data: requestJsonData, encoding:.utf8)!)")
//                
//                var request = URLRequest(url: url)
//
//                request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
//                request.httpMethod = "POST"
//                request.httpBody = requestJsonData
//                
//                let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                    if let error = error {
//                        DispatchQueue.main.async { emitter(nil, error) }
//                        return
//                    }
//                    print("resultData: \(String(data: data!, encoding: .utf8)!)")
//                    
//                    if let data = data {
//                        DispatchQueue.main.async {
//                            emitter(data, nil)
//                        }
//                    } else {
//                        DispatchQueue.main.async { emitter(nil, error) }
//                        return
//                    }
//                }
//                task.resume()
//            }
//        }
//    }
}
