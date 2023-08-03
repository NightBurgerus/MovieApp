//
//  URLSession.swift
//  MovieApp
//
//  Created by Чебупелина on 03.08.2023.
//

import Foundation

extension URLSession {
    func syncDataTask(with request: URLRequest) -> (Data?, URLResponse?, Error?) {
        var data: Data? = nil
        var response: URLResponse? = nil
        var error: Error? = nil
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data = $0
            response = $1
            error = $2
            semaphore.signal()
            // Hotel? Trivago!
        })
        task.resume()
        semaphore.wait()
        return (data, response, error)
    }
}
