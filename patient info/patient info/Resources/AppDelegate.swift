//
//  AppDelegate.swift
//  patient info
//
//  Created by Yeswanth Kanumuri on 7/31/19.
//  Copyright © 2019 BeTorchBearer. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.setMinimumBackgroundFetchInterval(60)
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: PatientListViewController())
        setupRootVC(fetch: true)
        return true
    }
    
    // Support for background fetch
    func application(_ application: UIApplication,performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        setupRootVC(fetch: true)
        completionHandler(.newData)
    }


    func applicationWillEnterForeground(_ application: UIApplication) {
        setupRootVC(fetch: true)
    }

    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "patient_info")
            container.loadPersistentStores(completionHandler: { (_, error) in
                guard let error = error as NSError? else { return }
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            })
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            container.viewContext.undoManager = nil
            container.viewContext.shouldDeleteInaccessibleFaults = true
            container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    
    // MARK: - setting up root VC
    func setupRootVC(fetch:Bool){
        
        let vc = (window?.rootViewController as? UINavigationController)?.topViewController as? PatientListViewController
        vc?.dataProvider = DataProvider(persistentContainer: self.persistentContainer, repository: Network.shared)
        if fetch {
            vc?.dataProvider.fetchPatients(completion: { (error) in
                print("background fetch...")
                // handle error
            })
        }
    }


}

