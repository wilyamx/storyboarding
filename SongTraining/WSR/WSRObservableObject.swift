//
//  WSRObservableObject.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//
// https://www.youtube.com/watch?v=sLHVxnRS75w&list=WL

import Foundation

final class WSRObservableObject<T> {
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: @escaping(T) -> Void) {
        listener(value)
        self.listener = listener
    }
}
