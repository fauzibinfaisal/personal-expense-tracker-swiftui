//
//  SwiftDataStack.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import Foundation
import SwiftData

/// Owns SwiftData configuration and ModelContainer construction for local persistence.
@MainActor
public final class SwiftDataStack {
    public let modelContainer: ModelContainer
    
    public init(isStoredInMemoryOnly: Bool = false) throws {
        let schema = Schema([ExpenseEntity.self])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isStoredInMemoryOnly
        )
        
        do {
            self.modelContainer = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            throw PersistenceError.containerInitializationFailed
        }
    }
}
