//
//  dataProvider.swift
//  patient info
//
//  Created by Yeswanth Kanumuri on 7/31/19.
//  Copyright © 2019 BeTorchBearer. All rights reserved.
//
import CoreData

class DataProvider {
    
    private let persistentContainer: NSPersistentContainer
    private let repository: Network
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer, repository: Network) {
        self.persistentContainer = persistentContainer
        self.repository = repository
    }
    
    func fetchPatients(completion: @escaping(Error?) -> Void) {
        repository.getPatientList() { jsonDictionary, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let jsonDictionary = jsonDictionary else {
                let error = NSError(domain: "data Error", code: 102, userInfo: nil)
                completion(error)
                return
            }
            
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil
            
            _ = self.syncPatients(jsonDictionary: jsonDictionary, taskContext: taskContext)
            
            completion(nil)
        }
    }
    
    private func syncPatients(jsonDictionary: [[String: Any]], taskContext: NSManagedObjectContext) -> Bool {
        var successfull = false
        taskContext.performAndWait {
            let matchingPatientRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Patient")
            
            let patientIds = jsonDictionary.map { $0["id"] as? Int }.compactMap { $0 }
            matchingPatientRequest.predicate = NSPredicate(format: "id in %@", argumentArray: [patientIds])
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingPatientRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.persistentContainer.viewContext])
                }
            } catch {
                print("Error: \(error)\nCould not batch delete existing records.")
                return
            }
            
            
            for PatientInfo in jsonDictionary {
                
                guard let patient = NSEntityDescription.insertNewObject(forEntityName: "Patient", into: taskContext) as? Patient else {
                    print("Error: Failed to create a new Patient object!")
                    return
                }
                
                do {
                    try patient.update(with: PatientInfo)
                } catch {
                    print("Error: \(error)\nThe quake object will be deleted.")
                    taskContext.delete(patient)
                }
            }
            
           
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                taskContext.reset()
            }
            successfull = true
        }
        return successfull
    }
}

