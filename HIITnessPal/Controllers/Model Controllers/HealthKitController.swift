//
//  HealthKitController.swift
//  Get-HIIT
//
//  Created by Timothy Rosenvall on 8/21/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitController {
    // Singleton to keep the same HKHealthStore throughout the app.
    static let sharedInstance = HealthKitController()
    // Variables for healthKit
    // This is the HealthKit Store we will be accessing for all of our app
    let healthKitStore: HKHealthStore = HKHealthStore()
    var weights: [Double] = []
    var heartRates: [Double] = []
    var calories: [Double] = []
    var timestampsWeight: [Date] = []
    var timestampsHeartRate: [Date] = []
    var timestampsCalorie: [Date] = []
    var observerQuery: HKObserverQuery!
    // Units for HKObjects
    let weightUnit = HKUnit.pound()
    let heartRateUnit = HKUnit(from: "count/min")
    let calorieUnit = HKUnit.kilocalorie()
    
    // Function called to request authorization from the Health app.
    func authorizeHeatlhKitInApp( completion: @escaping (Bool) -> Void) {
        // Set the dateOfBirth, weight, heartRate, and activeEnergyBurned as unwrapped objects.
        guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth) else
        {return}
        guard let weight = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass) else
        {return}
        guard let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate) else {return}
        guard let activeCalorieExpendeture = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {return}
        
        // Request authorization for access to read the dateOfBirth, weight, heartRate, and activeEnergyBurned from the Health app.
        let healthKitTypesToRead: Set<HKObjectType> = [
            dateOfBirth,
            weight,
            heartRate,
            activeCalorieExpendeture,
        ]
        
        // Request authorization for access to write the weight, heartRate, and activeEnergyBurned to the Health app.
        let healthKitTypesToWrite: Set<HKSampleType> = [
            weight,
            heartRate,
            activeCalorieExpendeture,
        ]
        
        // Check whether or not the HealthKit Store is accessable.
        if !HKHealthStore.isHealthDataAvailable() {
            print( "Error Occured")
            return
        }
        
        // Authorize request for the items above.
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
            // Unwrap and handle any errors
            if let error = error {
                print(error.localizedDescription)
            } else {
                // Print off if it succeeded.
                print("Read/Write Authorization Request Successed")
            }
            // If the operation was successful, complete with true.
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func checkHeartRate(completion: @escaping(Double) -> Void) {
        var heartRate: Double = 0.0
        guard let heartRateType = HKSampleType.quantityType(forIdentifier: .heartRate) else {return}
        let queryHeartRate = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            if let error = error {
                print(error.localizedDescription)
                print("Error with readProfile function - heartRate query")
            }
            if let results = results {
                print(results)
                for result in results {
                    if let sample = result as? HKQuantitySample {
                        print(sample.quantity)
                    }
                }
            }
            if let result = results?.last as? HKQuantitySample {
                heartRate = result.quantity.doubleValue(for: HKUnit(from: "count/min"))
                completion(heartRate)
            }
        }
        healthKitStore.execute(queryHeartRate)
    }
    
    func heartRateObserver () {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {return}
        
        let queryHeartRate = HKObserverQuery(sampleType: sampleType, predicate: nil) { (query, completionHandler, error) in
            if let error = error {
                print(error.localizedDescription)
                print("Error in HKOberserver")
            }
            self.checkHeartRate(completion: { (heartRate) in
                self.heartRates.append(heartRate)
                print(self.heartRates)
                completionHandler()
            })
        }
        healthKitStore.execute(queryHeartRate)
    }
}
