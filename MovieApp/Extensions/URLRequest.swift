//
//  URLRequest.swift
//  MovieApp
//
//  Created by Чебупелина on 01.08.2023.
//

import Foundation

extension URLRequest {
    ///  Передача multipart/form-data в тело запроса
    public mutating func setMultipartFormData(_ parameters: [String: String], encoding: String.Encoding) throws -> String {

        let makeRandom = { UInt32.random(in: (.min)...(.max)) }
        let boundary = String(format: "------------------------%08X%08X", makeRandom(), makeRandom())

        let contentType: String = try {
            guard let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(encoding.rawValue)) else {
                throw MultipartFormDataEncodingError.characterSetName
            }
            return "multipart/form-data; charset=\(charset); boundary=\(boundary)"
        }()
        addValue(contentType, forHTTPHeaderField: "Content-Type")

        httpBody = try {
            var body = Data()

            for (rawName, rawValue) in parameters {
                if !body.isEmpty {
                    body.append("\r\n".data(using: .utf8)!)
                }

                body.append("--\(boundary)\r\n".data(using: .utf8)!)

                guard
                    rawName.canBeConverted(to: encoding),
                    let disposition = "Content-Disposition: form-data; name=\"\(rawName)\"\r\n".data(using: encoding) else {
                    throw MultipartFormDataEncodingError.name(rawName)
                }
                body.append(disposition)

                body.append("\r\n".data(using: .utf8)!)

                guard let value = rawValue.data(using: encoding) else {
                    throw MultipartFormDataEncodingError.value(rawValue, name: rawName)
                }

                body.append(value)
            }

            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

            return body
        }()
        
        return contentType
    }
}

public enum MultipartFormDataEncodingError: Error {
    case characterSetName
    case name(String)
    case value(String, name: String)
}

extension URLRequest {
    private func percentEscapeString(_ string: String) -> String {
        let characterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-._* "))
        
        return string.addingPercentEncoding(withAllowedCharacters: characterSet)!.replacingOccurrences(of: " ", with: "+")
    }
    /// Передача параметров x-www-form-urlencoded в тело запроса
    public mutating func setURLEncodedParams(_ parameters: [String: String], encoding: String.Encoding = .utf8) throws {
        let parametersArray = parameters.map { (key, value) in
            return "\(key)"
        }
        let parameterArray = parameters.map { (key, value) -> String in
            return "\(key)=\(self.percentEscapeString(value))"
        }
        
        httpBody = parametersArray.joined(separator: "&").data(using: encoding)
    }
}

extension URLRequest {
    /// Передача объекта в тело запроса
    public mutating func setJSONBody(json: Encodable) {
        httpBody = try? JSONEncoder().encode(json)
    }
}
