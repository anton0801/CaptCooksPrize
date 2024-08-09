import Foundation
import SwiftUI

struct Slot: Identifiable, Codable {
    var id = UUID()
    var symbol: String
    var isPurchased: Bool
    var symbolsCount: Int = 0
    var price: Int?
}

class SlotViewModel: ObservableObject {
    @Published var slots: [Slot] = []
    @Published var currentIndex: Int = 1
    @Published var selectedIndex: Int = 1
    private let purchasedKey = "purchasedSlots"
    
    init() {
        loadSlots()
    }
    
    func loadSlots() {
        let defaultSlots = [
            Slot(symbol: "slots_1", isPurchased: true, symbolsCount: 8),
            Slot(symbol: "slots_2", isPurchased: true, symbolsCount: 8),
            Slot(symbol: "slots_3", isPurchased: true, symbolsCount: 9),
            Slot(symbol: "slots_4", isPurchased: false, symbolsCount: 15, price: 500000),
            Slot(symbol: "slots_5", isPurchased: false, symbolsCount: 4, price: 600000),
            Slot(symbol: "slots_6", isPurchased: false, price: 700000)
        ]
        
        if let data = UserDefaults.standard.data(forKey: purchasedKey),
           let savedSlots = try? JSONDecoder().decode([Slot].self, from: data) {
            slots = savedSlots
        } else {
            slots = defaultSlots
        }
    }
    
    func saveSlots() {
        if let data = try? JSONEncoder().encode(slots) {
            UserDefaults.standard.set(data, forKey: purchasedKey)
        }
    }
    
    func isSlotPurchased(slot: Slot) -> Bool {
        return slot.isPurchased
    }
    
    func purchaseSlot(slot: Slot) -> Bool {
        if let index = slots.firstIndex(where: { $0.id == slot.id }) {
            if !slots[index].isPurchased {
                slots[index].isPurchased = true
                saveSlots()
                return true
            }
        }
        return false
    }
    
    func moveToNext() {
        currentIndex = (currentIndex + 1) % slots.count
        selectedIndex = currentIndex
    }
    
    func moveToPrevious() {
        currentIndex = (currentIndex - 1 + slots.count) % slots.count
        selectedIndex = currentIndex
    }
    
    func selectSlot(at index: Int) {
        selectedIndex = index
    }
}

