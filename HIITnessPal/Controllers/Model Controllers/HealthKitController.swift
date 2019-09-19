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
    var calories: [Double] = []
    var heartRates: [Double] = []
    var timestampsWeight: [Date] = []
    var timestampsCalorie: [Date] = []
    var timestampsHeartRate: [Date] = []
    var observerQuery: HKObserverQuery!
    var averageHeartRate: Double = 0
    var caloriesBurned: Double = 0
    
    // Units for HKObjects
    let weightUnit = HKUnit.pound()
    let calorieUnit = HKUnit.kilocalorie()
    let heartRateUnit = HKUnit(from: "count/min")
    
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
    
    // Function to get the heart rate from the health app.
    func checkHeartRate(completion: @escaping(Double) -> Void) {
        
        // Needed placeholder variable.
        var heartRate: Double = 0.0
        
        // Set and unwrap the heart rate sample type from HealthKit
        guard let heartRateType = HKSampleType.quantityType(forIdentifier: .heartRate) else {return}
        
        // Run a query to pull the heart rate data from the Health app.
        let queryHeartRate = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
            // Unwrap and handle the errors.
            if let error = error {
                print(error.localizedDescription)
                print("Error with readProfile function - heartRate query")
            }
            // Unwrap the latest result from the data
            if let result = results?.last as? HKQuantitySample {
                // Convert the result to a double from the appropriate units and set it to the placeholder declared above.
                heartRate = result.quantity.doubleValue(for: HKUnit(from: "count/min"))
                // Run the completion handler and pass back the heart rate.
                completion(heartRate)
            }
        }
        // Run the heart rate check query.
        healthKitStore.execute(queryHeartRate)
    }
    
    // Function to set up an observer to pull new heart rates whenever the watch reads an updated heart rate.
    func heartRateObserver (completion: @escaping (Double) -> Void) {
        
        // Set and unwrap the heart rate sample type from HealthKit
        guard let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {return}
        
        // Setup the observer from the sample heart rate above.
        let queryHeartRate = HKObserverQuery(sampleType: sampleType, predicate: nil) { (query, completionHandler, error) in
            // Unwrap and handle any errors.
            if let error = error {
                print("Error in HKOberserver")
                print(error.localizedDescription)
            }
            
            // Run the function to pull and read the heart rate when a new heart rate update is recieved.
            self.checkHeartRate(completion: { (heartRate) in
                // Add the new heart rate to the total number of heart rates tracked.
                self.heartRates.append(heartRate)
                // Run the completion handler for the observer query to allow it to continue running
                completionHandler()
                // Run the completion for the function to pass the heart rate out and send it to the watch.
                completion(heartRate)
            })
        }
        // Run the observer query.
        healthKitStore.execute(queryHeartRate)
        observerQuery = queryHeartRate
    }
    
    func stopHeartRateObserver() {
        healthKitStore.stop(observerQuery)
    }
    
    func getCaloriesBurned(durationOfWorkoutInMinutes: Double) -> Double {
        guard let profile = ProfileController.sharedInstance.profile else {return 0}
        var calorieExpenditure: Double = 0.0
        let averageHeartRate = HealthKitController.sharedInstance.averageHeartRate
        let age = profile.age
        let weight = profile.weight
        let gender = profile.gender
        let minutes = durationOfWorkoutInMinutes
        let weightInKilograms = weight * 0.453592
        switch gender {
        case 0:
            let heartRatePortion: Double = (0.6309 * averageHeartRate)
            let weightPortion: Double = (0.1988 * weightInKilograms)
            let agePortion: Double = (0.2017 * Double(age))
            let calorieExpenditurePerMinute = (-55.0969 + heartRatePortion + weightPortion + agePortion)/4.184
            calorieExpenditure = calorieExpenditurePerMinute * minutes
        case 1:
            let heartRatePortion: Double = (0.4472 * averageHeartRate)
            let weightPortion: Double =  (-0.1263 * weightInKilograms)
            let agePortion: Double = (0.074 * Double(age))
            let calorieExpenditurePerMinute = (-20.4022 + heartRatePortion + weightPortion + agePortion)/4.184
            calorieExpenditure = calorieExpenditurePerMinute * minutes
        default:
            calorieExpenditure = 0.0
        }
        return calorieExpenditure
    }
    
}
