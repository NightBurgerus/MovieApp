//
//  LoadingError.swift
//  MovieApp
//
//  Created by Чебупелина on 01.08.2023.
//

import Foundation

enum LoadingError: Error, CaseIterable {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case internalServerError
    case unavailable
    case unknownError
    case dataIsNil
    case invalidHttpBody
    case invalidURL
    case decodeError
    
    static func error(by code: Int) -> LoadingError {
        switch code {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 500: return .internalServerError
        case 503: return .unavailable
        default:  return .unknownError
        }
    }
}
