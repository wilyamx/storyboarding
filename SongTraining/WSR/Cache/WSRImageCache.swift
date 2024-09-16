//
//  WSRImageCache.swift
//  SongTraining
//
//  Created by William Rena on 7/23/23.
//

import UIKit

enum WSRFileLoaderError: Error, CustomStringConvertible {
    case fileNotFound(String)
    case fileCannotLoad(Error)
    case parsing(DecodingError?)
    case unknown
    
    var localizedDescription: String {
        // user feedback
        switch self {
        case .fileNotFound, .fileCannotLoad, .parsing, .unknown:
            return "Sorry, something went wrong."
        }
    }
    
    var description: String {
        //info for debugging
        switch self {
        case .unknown: return "Unknown Error"
        case .fileNotFound(let filePath): return "Invalid file path: \(filePath)"
        case .fileCannotLoad(let error): return "File cannot load: \(error)"
        case .parsing(let error):
            return "Parsing error \(error?.localizedDescription ?? "")"
        }
    }
}

enum WSRFileURLLoaderError: Error, CustomStringConvertible {
    case url
    case fileNotFound(String)
    case fileCannotLoad
    case data
    case unknown
    
    var localizedDescription: String {
        // user feedback
        switch self {
        case .fileNotFound, .fileCannotLoad, .unknown, .url, .data:
            return "Sorry, something went wrong."
        }
        
    }
    
    var description: String {
        //info for debugging
        switch self {
        case .unknown: return "Unknown Error"
        case .fileNotFound(let filePath): return "Invalid file path: \(filePath)"
        case .fileCannotLoad: return "File cannot load"
        case .url: return "URL Session Error"
        case .data: return "Corrupt data"
        }
    }
}
