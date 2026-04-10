//
//  CoreDataService.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import CoreData
import Foundation

final class CoreDataService {
    static let shared = CoreDataService()
    
    private init() {}
    
    lazy var persistenContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Yunseul")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data 로드 실패: \(error)")
            }
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistenContainer.viewContext
    }
    
    // MARK: - BirthDate 저장
    func saveBirthStar(
        nickname: String,
        birthDate: Date,
        constellation: String
    ) throws {
        let birthStar = BirthStar(context: context)
        birthStar.nickname = nickname
        birthStar.birthDate = birthDate
        birthStar.constellation = constellation
        birthStar.createdAt = Date()
        
        try context.save()
    }
    
    // MARK: - BirthStar 조회
    func fetchBirthStar() throws -> BirthStar? {
        let request = BirthStar.fetchRequest()
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    // MARK: - BirthStar 삭제
    func deleteBirthStar() throws {
        guard let birthStar = try fetchBirthStar() else { return }
        context.delete(birthStar)
        try context.save()
    }
}
