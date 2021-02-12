//
//  PersonController.swift
//  PairRandomizer
//
//  Created by Benjamin Tincher on 2/12/21.
//

import Foundation

class PersonController {
    
    //  MARK: - Properties
    static let shared = PersonController()
    
    var persons: [Person] = []
    
    
    //  MARK: - Methods
    func createPersonWith(name: String) {
        let person = Person(name: name)
        persons.append(person)
        saveToPersistenceStore()
    }
    
    func update(person: Person, name: String) {
        person.name = name
        saveToPersistenceStore()
    }
    
    func delete(person: Person) {
        guard let index = persons.firstIndex(of: person) else { return }
        persons.remove(at: index)
        saveToPersistenceStore()
    }
    
    //  MARK: - Persistence
    func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = urls[0].appendingPathComponent("PersonController.json")
        return fileURL
    }
    
    func saveToPersistenceStore() {
        do {
            let data = try JSONEncoder().encode(persons)
            try data.write(to: fileURL())
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    func loadFromPersistenceStore() {
        do {
            let data = try Data(contentsOf: fileURL())
            let loaded = try JSONDecoder().decode([Person].self, from: data)
            persons = loaded
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
}
