//
//  ApiWorker.swift
//  MovieApp
//
//  Created by Чебупелина on 01.08.2023.
//

import Foundation

protocol ApiWorkerProtocol {
    func get(url: URL, parameters: [MethodParams]) -> NetworkRequest
    func post(url: URL, parameters: [MethodParams]) -> NetworkRequest
    func update(url: URL, parameters: [MethodParams]) -> NetworkRequest
    func put(url: URL, parameters: [MethodParams]) -> NetworkRequest
    func delete(url: URL, parameters: [MethodParams]) -> NetworkRequest
}

class ApiWorker: ApiWorkerProtocol {
    static let shared = ApiWorker()
    private init() {}
    
    func get(url: URL, parameters: [MethodParams] = []) -> NetworkRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return NetworkRequest(request: request, parameters: parameters)
    }
    
    func post(url: URL, parameters: [MethodParams] = []) -> NetworkRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return NetworkRequest(request: request, parameters: parameters)
    }
    
    func update(url: URL, parameters: [MethodParams] = []) -> NetworkRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "UPDATE"
        return NetworkRequest(request: request, parameters: parameters)
    }
    
    func put(url: URL, parameters: [MethodParams] = []) -> NetworkRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        return NetworkRequest(request: request, parameters: parameters)
    }
    
    func delete(url: URL, parameters: [MethodParams] = []) -> NetworkRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return NetworkRequest(request: request, parameters: parameters)
    }
}


class NetworkRequest {
    typealias HTTPHeaders      = [String: String]
    typealias FormData         = [String: String]
    typealias UrlEncodedParams = [String: String]
    typealias JSON             = Encodable
    typealias ResponseCompletion = (LoadingResponse) -> ()

    private var headers: HTTPHeaders
    private var contentType = ""
    private var parameters: [MethodParams]
    private var request: URLRequest
    private var completion: ResponseCompletion
    private var allowsRedirect: Bool

    fileprivate init(request: URLRequest, parameters: [MethodParams] = []) {
        self.request = request
        self.parameters = parameters
        self.headers = [:]
        self.allowsRedirect = true
        self.completion = { _ in }
    }

    /// Установка параметров как form-data
    /// При наличии других методов установки параметров,
    /// сработает последний
    func setFormData(_ params: FormData) -> NetworkRequest {
        let method = request.httpMethod
        let contentType = try? self.request.setMultipartFormData(params, encoding: .utf8)
        
        request.httpMethod = method
        if contentType != nil {
            self.contentType = contentType!
        }
        return self
    }

    /// Установка параметров как x-www-form-urlencoded
    /// При наличии других методов установки параметров,
    /// сработает последний
    func setURLEncodedParams(_ params: UrlEncodedParams) -> NetworkRequest {
        let method = request.httpMethod
        try? self.request.setURLEncodedParams(params)
        request.httpMethod = method
        contentType = "application/x-www-form-urlencoded"
        return self
    }

    /// Установка httpBody как json
    /// При наличии других методов установки параметров,
    /// сработает последний
    func setJSONBody(json: JSON) -> NetworkRequest {
        self.request.setJSONBody(json: json)
        self.contentType = "application/json"
        return self
    }

    /// Сетевой запрос
    ///
    /// Возвращает URLSessionDataTask, чтобы при необходимости
    /// можно было бы отменить запрос
    func request(delegateQueue: OperationQueue? = nil, completion: @escaping ResponseCompletion) -> URLSessionDataTask? {
        configureRequest(&self.request)
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = headers
        
        let redirectManager = SessionRedirectManager(oldRequest: self.request, allowsRedirect: allowsRedirect)
        
        let task = URLSession(configuration: sessionConfig, delegate: redirectManager, delegateQueue: delegateQueue).dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if data == nil {
                    completion(.failure(.dataIsNil))
                    return
                }
                
                if error != nil {
                    completion(.failure(.unknownError))
                    return
                }
                
                let statusCode = (response as! HTTPURLResponse).statusCode
                guard 200...299 ~= statusCode else {
                    completion(.failure(LoadingError.error(by: statusCode)))
                    return
                }
                completion(.success(data!))
            }
        }
        task.resume()
        return task
    }

    private func configureRequest(_ request: inout URLRequest) {
        for parameter in parameters {
            switch parameter {
            case .headers(let headers):
                self.headers = headers
                if !self.contentType.isEmpty && !self.headers.keys.contains("Content-Type") {
                    self.headers["Content-Type"] = self.contentType
                }
            case .timeoutInterval(let interval):
                request.timeoutInterval = interval
            case .allowsRedirect(let allow):
                self.allowsRedirect = allow
            case .allowsExpensiveNetworkAccess(let allow):
                request.allowsExpensiveNetworkAccess = allow
            case .allowsConstrainedNetworkAccess(let allow):
                request.allowsConstrainedNetworkAccess = allow
            case .cachePolicy(let cachePolicy):
                request.cachePolicy = cachePolicy
            case .httpShouldHandleCookies(let shouldHandle):
                request.httpShouldHandleCookies = shouldHandle
            case .httpShouldUsePipelining(let shouldUse):
                request.httpShouldUsePipelining = shouldUse
            case .networkServiceType(let networkServiceType):
                request.networkServiceType = networkServiceType
            }
        }
    }
}

