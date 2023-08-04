//
//  MethodParameters.swift
//
//  Created by Чебупелина on 01.08.2023.
//

import Foundation

enum MethodParams {
    case headers([String: String])
    case timeoutInterval(Double = 60.0)
    case allowsRedirect(Bool = true)
    case allowsExpensiveNetworkAccess(Bool)
    case allowsConstrainedNetworkAccess(Bool)
    case cachePolicy(URLRequest.CachePolicy)
    case httpShouldHandleCookies(Bool = true)
    case httpShouldUsePipelining(Bool)
    case networkServiceType(URLRequest.NetworkServiceType)
    case synchronous
}
