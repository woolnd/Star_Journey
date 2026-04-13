//
//  CoreDataService.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

internal import CoreData
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

    // MARK: - StarTrailEntry

    func fetchLastTrailDate() -> Date? {
        let request = NSFetchRequest<StarTrailEntry>(entityName: "StarTrailEntry")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = 1
        return try? context.fetch(request).first?.date
    }

    func fetchAllTrailEntries() -> [StarTrailEntry] {
        let request = NSFetchRequest<StarTrailEntry>(entityName: "StarTrailEntry")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }

    func saveTrailEntry(
        date: Date,
        latitude: Double,
        longitude: Double,
        regionName: String,
        constellation: String
    ) {
        // 중복 방지
        let request = NSFetchRequest<StarTrailEntry>(entityName: "StarTrailEntry")
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay   = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            startOfDay as CVarArg,
            endOfDay as CVarArg
        )
        guard (try? context.fetch(request))?.isEmpty == true else { return }
        
        let entry = StarTrailEntry(context: context)
        entry.setValue(UUID(),        forKey: "id")
        entry.setValue(date,          forKey: "date")
        entry.setValue(latitude,      forKey: "latitude")
        entry.setValue(longitude,     forKey: "longitude")
        entry.setValue(regionName,    forKey: "regionName")
        entry.setValue(constellation, forKey: "constellation")
        
        try? context.save()
    }

    // MARK: - StarJournalEntry

    func fetchAllJournalEntries() -> [StarJournalEntry] {
        let request = NSFetchRequest<StarJournalEntry>(entityName: "StarJournalEntry")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return (try? context.fetch(request)) ?? []
    }

    func fetchJournalEntry(for date: Date) -> StarJournalEntry? {
        let request = NSFetchRequest<StarJournalEntry>(entityName: "StarJournalEntry")
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay   = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            startOfDay as CVarArg,
            endOfDay as CVarArg
        )
        return try? context.fetch(request).first
    }

    func saveJournalEntry(
        date: Date,
        constellation: String,
        starLatitude: Double,
        starLongitude: Double,
        starRegionName: String,
        userLatitude: Double,
        userLongitude: Double,
        userRegionName: String,
        starAltitude: Double,
        starAzimuth: Double,
        distanceKm: Double,
        starDirection: String,
        photoPath: String,
        memo: String?
    ) {
        let entry = StarJournalEntry(context: context)
        entry.setValue(UUID(),          forKey: "id")
        entry.setValue(date,            forKey: "date")
        entry.setValue(constellation,   forKey: "constellation")
        entry.setValue(starLatitude,    forKey: "starLatitude")
        entry.setValue(starLongitude,   forKey: "starLongitude")
        entry.setValue(starRegionName,  forKey: "starRegionName")
        entry.setValue(userLatitude,    forKey: "userLatitude")
        entry.setValue(userLongitude,   forKey: "userLongitude")
        entry.setValue(userRegionName,  forKey: "userRegionName")
        entry.setValue(starAltitude,    forKey: "starAltitude")
        entry.setValue(starAzimuth,     forKey: "starAzimuth")
        entry.setValue(distanceKm,      forKey: "distanceKm")
        entry.setValue(starDirection,   forKey: "starDirection")
        entry.setValue(photoPath,       forKey: "photoPath")
        entry.setValue(memo,            forKey: "memo")
        
        try? context.save()
    }
}
