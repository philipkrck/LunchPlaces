//
//  LunchPlaceStore.swift
//  Lunch Places
//
//  Created by Philip Krück on 24.06.20.
//

import Combine
import Foundation

class LunchPlaceStore: ObservableObject {
    @Published private(set) var lunchPlaces: [LunchPlace]
    
    init(lunchPlaces: [LunchPlace] = []) {
        self.lunchPlaces = lunchPlaces
    }
    
    var favoriteLunchPlaces: [LunchPlace] {
        lunchPlaces.filter { $0.isFavorite }
    }
    
    func addLunchPlace(_ lunchPlace: LunchPlace) {
        lunchPlaces.append(lunchPlace)
    }
    
    func moveLunchPlace(from indexSet: IndexSet, to offset: Int) {
        lunchPlaces.move(fromOffsets: indexSet, toOffset: offset)
    }
    
    func removeLunchPlace(at offsets: IndexSet) {
        lunchPlaces.remove(atOffsets: offsets)
    }
    
    func lunchPlaceStore(for id: LunchPlace.ID) -> LunchPlace? {
        return lunchPlaces.first(where: { $0.id == id })
    }
    
    func distance(to lunchPlace: LunchPlace) -> String {
        let time = Int.random(in: 5..<10)
        return "\(time) minutes"
    }
}

let testStore = LunchPlaceStore(lunchPlaces: testData)
