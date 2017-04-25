//
//  Request.swift
//  QSNetwork
//
//  Created by Nory Cao on 16/12/26.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

open class Request: NSObject {
    
    
}

public protocol RequestAdapter {
    /// Inspects and adapts the specified `URLRequest` in some manner if necessary and returns the result.
    ///
    /// - parameter urlRequest: The URL request to adapt.
    ///
    /// - throws: An `Error` if the adaptation encounters an error.
    ///
    /// - returns: The adapted `URLRequest`.
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest
}

