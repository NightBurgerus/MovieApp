//
//  Response.swift
//  MovieApp
//
//  Created by Чебупелина on 01.08.2023.
//

import Foundation

enum LoadingResponse {
    case success(Data)
    case failure(LoadingError)
}

enum Response<T> {
    case success(T)
    case failure(LoadingError)
}
