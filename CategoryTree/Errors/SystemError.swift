
//
//  SystemError.swift
//  CategoryTree
//
//  Created by Faheem Hussain on 24/03/22.
//

import Foundation

@objc class SystemError: NSObject, Error {
    enum ErrorType {
        case alert
        case error
        case validation
        
        var description: String {
            switch self {
            case .alert:
                return "Alert"
            case .error:
                return "Error"
            case .validation:
                return "Validation"
            }
        }
    }
    
    let type: ErrorType
    let errorCode: Int?
    let message: String
    let title: String?
    let response: Any?
    
    internal init(_ message: String, type: ErrorType = .alert, title: String? = nil, errorCode: Int? = nil, response: Any? = nil) {
        self.message = message
        self.type = type
        self.title = title
        self.errorCode = errorCode
        self.response = response
    }
}
