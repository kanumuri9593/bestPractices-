//
//  network.swift
//  patient info
//
//  Created by Yeswanth Kanumuri on 7/31/19.
//  Copyright © 2019 BeTorchBearer. All rights reserved.
//

import Foundation

class Network {
    
    private init() {}
    static let shared = Network()
    
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://my-json-server.typicode.com/")!
    
   
    func getPatientList(completion: @escaping(_ Patients: [[String: Any]]?, _ error: Error?) -> ()) {
        let PatientURL = baseURL.appendingPathComponent("brianmckee/clinical/patients")
        urlSession.dataTask(with: PatientURL) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "data Error", code: 101, userInfo: nil)
                completion(nil, error)
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let result = jsonObject as? [[String: Any]] else {
                    throw NSError(domain: "data Error", code:102, userInfo: nil)
                }
             print("fetching patients list ......")
                completion(result, nil)
            } catch {
                completion(nil, error)
            }
            }.resume()
    }
    
}
