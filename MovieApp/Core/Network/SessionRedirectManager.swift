//
//  SessionRedirectManager.swift
//  MovieApp
//
//  Created by Чебупелина on 01.08.2023.
//

import Foundation

class SessionRedirectManager: NSObject, URLSessionTaskDelegate {
    let oldRequest: URLRequest!     // Первоначальный запрос
    let allowsRedirect: Bool        // Разрешена ли переадресация
    
    override init() {
        oldRequest = nil
        allowsRedirect = true
    }
    init(oldRequest request: URLRequest, allowsRedirect: Bool = true) {
        oldRequest = request
        self.allowsRedirect = allowsRedirect
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        // Новый запрос копирует тело и метод старого, если они имеются
        // и, если редирект разрешён, метод выкидывает запрос в сессию
        
        if request.url == nil || String(request.url!.absoluteString.suffix(6)) == ".site/" {
            completionHandler(nil)
            return
        }
        
        if request.url?.absoluteURL == oldRequest.url?.absoluteURL {
            completionHandler(nil)
            return
        }

        var newRequest = request
        newRequest.httpBody = oldRequest.httpBody
        newRequest.httpMethod = oldRequest.httpMethod
        
        completionHandler(allowsRedirect ? newRequest : nil)
    }
}
