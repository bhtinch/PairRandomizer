//
//  Person.swift
//  PairRandomizer
//
//  Created by Benjamin Tincher on 2/12/21.
//

import Foundation

class Person: Codable {
    var name: String
    let id: String
    
    init(name: String, id: String = UUID().uuidString) {
        self.name = name
        self.id = id
    }
}

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }
}
