//
//  WorkoutTimerViewController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/20/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit
import HealthKit
import WatchConnectivity

class WorkoutTimerViewController: UIViewController, CountdownTimerDelegate {
    
    // Set IBOutlets
    @IBOutlet weak var timerHeaderGradient: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var workoutImage: UIImageView!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerImageView: UIView!
    @IBOutlet weak var setNumberLabel: UILabel!
    @IBOutlet weak var exerciseNumberLabel: UILabel!
    
    // Variables and constants for the workout timer.
    var gradient = CAGradientLayer()
    var countdownTimerDidStart = false
    var workouts: Workouts = WorkoutsController.sharedInstance.totalWorkouts[WorkoutMainViewController.lastSelectedIndex]
    var exercises: [(String, Double, String)] = []
    var currentExercise: Int = 0
    var percentage: Double = 0
    static var totalTime: Double = 0
    
    lazy var multiplier = workouts.multiplier
    lazy var countdownTimer: CountdownTimer = {
        let countdownTimer = CountdownTimer()
        return countdownTimer
    }()
    
    // Set the status bar to show as white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set this viewController as the timer's delegate.
        countdownTimer.delegate = self
        // Set the title views gradients.
        SetGradient.setGradient(view: timerHeaderGradient, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
        
        // Specialized gradient and function for setting the timer's image gradient.
        gradient = setGradient(chooseTwo: true, primaryBlue: false, accentOrange: true, accentBlue: false)
        setupTimerImage(gradient: gradient)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Tell the CountdownTimer model controller's timer to request a new timer.
        CountdownTimer.sharedInstance.newTimer = true
        // Call the function to define the exercises in teh workout.
        setExercises()
        // Call the function to set the labels.
        setupLabels { (finished) in
            if finished {
                DispatchQueue.main.async {
                    self.countdownTimer.startTimer()
                    self.countdownTimerDidStart = true
                }
            }
        }
        HealthKitController.sharedInstance.heartRates = []
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        var totalHeartRate: Double = 0
        for heartRate in HealthKitController.sharedInstance.heartRates {
            totalHeartRate += heartRate
        }
        HealthKitController.sharedInstance.averageHeartRate = totalHeartRate/Double(HealthKitController.sharedInstance.heartRates.count)
        // To help the calculations work, this is garbage data.
        if HealthKitController.sharedInstance.averageHeartRate.isNaN {
            HealthKitController.sharedInstance.averageHeartRate = 120
        }
    }
    
    // MARK: - Actions
    @IBAction func exitButtonTapped(_ sender: Any) {
        // Call that the next time the view is loaded, the timer needs to restart.
        CountdownTimer.sharedInstance.newTimer = true
        // Stop the timer.
        countdownTimer.stop()
        // Turn off the variable that tells the timer it's started.
        countdownTimerDidStart = false
        // Dismiss the view controller.
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startTimerButton(_ sender: Any) {
        // If the timer is not started, start it and change the pause button image.
        if !countdownTimerDidStart{
            countdownTimer.startTimer()
            countdownTimerDidStart = true
            startButton.setImage(UIImage(named: "Pause Button"), for: .normal)
        } else {
            // Otherwise, stop the timer and change the pause button image to a play button.
            countdownTimer.stop()
            countdownTimerDidStart = false
            startButton.setImage(UIImage(named: "PlayButton"), for: .normal)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        // Call the function to move to the next exercise.
        nextExercise()
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        // Stop the timer
        countdownTimer.stop()
        countdownTimerDidStart = false
        // Don't allow the current exercise to go below the first in the array.
        if currentExercise > 0 {
            // If it's greater than that, move to the previous exercise.
            currentExercise -= 1
            // Call the setupLabels function to reset the timer labels.
            setupLabels { (finished) in
                if finished {
                    DispatchQueue.main.async {
                        // Update the theme of the timer to the blue timer if the current exercise is a rest.
                        if self.exercises[self.currentExercise % self.exercises.count].0 == "Rest" {
                            self.setBlue()
                        } else {
                            // Set back to orange when the current exercise is not a rest.
                            self.setOrange()
                        }
                        // Restart the timer.
                        self.countdownTimer.startTimer()
                        self.countdownTimerDidStart = true
                    }
                }
            }
            // Tell the timer model controller that it needs a new timer next time it starts the timer.
            CountdownTimer.sharedInstance.newTimer = true
        } else {
            // Keep the timer going if you're on the first exercise.
            countdownTimer.startTimer()
            countdownTimerDidStart = true
            CountdownTimer.sharedInstance.newTimer = false
        }
    }
    
    func setupLabels(completion: @escaping (Bool) -> Void) {
        // Pull the current exercise based on the current exercise number and the total kinds of exercises. The modulo here accounts for the fact that the multiplier will continue to repeat the exercises until the exercises have gone around the multipliers number of times. Ex: If there are 8 exercises (4 exercises and 4 rests in between) and we are on exercise 3, then 3 % 8 = 3. Likewise, if we are on our third exercise for the third time, then our currentExercise is 19 and 19 % 8 = 3. This let's curr track the needed exercise at any given time.
        let curr = currentExercise % exercises.count
        
        // Set the correct labels based on the exercises.
        workoutNameLabel.text = exercises[curr].0
        workoutImage.image = UIImage(named: exercises[curr].2)
        // Tell the timer what the correct duration and current time needs to be at start.
        CountdownTimer.sharedInstance.duration = exercises[curr].1
        CountdownTimer.sharedInstance.currentTime = exercises[curr].1
        // Reset the percentageComplete for the timer.
        CountdownTimer.sharedInstance.percentageComplete = 0
        
        // Set the setNumber lable to be the current set you're on in the exercise. This label ranges between 1 and the workout's multiplier.
        setNumberLabel.text = "\(currentExercise / exercises.count + 1)"
        // Pull the current exercise and set the exerciseNumberLabel to be the correct number.
        if (curr + 1) % 2 != 0 {
            exerciseNumberLabel.text = "\(((curr + 1) / 2) + 1)"
        }
        // Call the completion handler.
        completion(true)
    }
    
    func setExercises() {
        // Call the workout passed into the WorkoutTimerViewController
        let workout = workouts.workouts
        // Pull each exercise out of the workout
        for exercise in workout {
            // Define a tuple that contains each name, the duration of the exercise, and the image name.
            let exerciseTuple = (exercise.name, Double(exercise.duration), exercise.image)
            // Define a tuple that contains each rest, and their given durations and image names.
            let restTuple = ("Rest", Double(exercise.rest), "GetReady")
            // Append the above tuples into the class variable 'exercises' in order to space them out as each given exercise followed by each exercise's rest.
            exercises.append(exerciseTuple)
            exercises.append(restTuple)
        }
    }
    
    // MARK: - Countdown timer delegate
    func countdownTime(time: (minutes: String, seconds: String)) {
        // Set the timer time labels for minutes and seconds.
        minutesLabel.text = time.minutes
        secondsLabel.text = time.seconds
    }
    
    func updateTimerImage(percentage: Double) {
        // Pull the sublayers for the timerImage
        let sublayers = timerImageView.layer.sublayers
        // Pull the first layer in the sublayers (this is the gradient)
        guard let firstLayer = sublayers?[0] else {return}
        // Remove that gradient view.
        firstLayer.removeFromSuperlayer()
        // Call the function to update the timers image based on it's percentage complete. This slowly rotates the timer image as it's called.
        setupTimerImage(gradient: gradient, percentageComplete: percentage)
        // Update the percentage to the new current value.
        self.percentage = percentage
    }
    
    func killTimer() {
        // Call the function to move onto the next exercise.
        nextExercise()
    }
    
    
    // Mark: - Helper Functions
    func nextExercise() {
        // Pull the correct time for the given exercise.
        let currentWorkoutTime = exercises[currentExercise % exercises.count].1
        // Update the totalTime for the exercise based on the current time and the percentage
        WorkoutTimerViewController.totalTime += (percentage) * currentWorkoutTime
        // Handle any rounding errors.
        WorkoutTimerViewController.totalTime = Double((Int(WorkoutTimerViewController.totalTime * 100)))/100
        // Stop the timer.
        countdownTimer.stop()
        self.countdownTimerDidStart = false
        // Check if the number of exercises exceeds the total required for the workout.
        if currentExercise >= (exercises.count * multiplier) - 1 {
            // Tell the timer model controller that it will need a newTimer the next time it's started.
            CountdownTimer.sharedInstance.newTimer = true
            // Reset the current exercise to 0
            currentExercise = 0
            // Change the theme back to orange, it looks weird if you don't do this.
            setOrange()
            // Pull the storyboard for to transition to the WorkoutCompleteViewController
            let currStoryboard = UIStoryboard(name: "HiitnessWorkout", bundle: nil)
            // Set the view controller to be transfered to as the WorkoutCompleteViewController.
            let vc = currStoryboard.instantiateViewController(withIdentifier: "workoutView")
            // Present the WorkoutCompleteViewController.
            present(vc, animated: true, completion: nil)
        } else {
            // If we aren't at the last exercise, add one to the current exercise
            currentExercise += 1
            // Update the labels to the current exercise.
            setupLabels { (finished) in
                if finished {
                    DispatchQueue.main.async {
                        // Check if rest or not and update to the correct theme.
                        if self.exercises[self.currentExercise % self.exercises.count].0 == "Rest" {
                            self.setBlue()
                        } else {
                            self.setOrange()
                        }
                        // Restart the timer.
                        self.countdownTimer.startTimer()
                        self.countdownTimerDidStart = true
                    }
                }
            }
        }
        // tell the timer model controller that the next time it starts, it will need a new timer.
        CountdownTimer.sharedInstance.newTimer = true
    }
    
    func setBlue() {
        // Set the class gradient variable to be the blue gradients.
        gradient = setGradient(chooseTwo: false, primaryBlue: true, accentOrange: false, accentBlue: true)
        
        // Pull the sublayers for the timer.
        let sublayers = timerImageView.layer.sublayers
        // Pull the first sublayer from the sublayers.
        guard let firstLayer = sublayers?[0] else {return}
        // Remove that layer.
        firstLayer.removeFromSuperlayer()
        
        // Call the function to reset the timer gradient image.
        setupTimerImage(gradient: gradient)
        
        // Pull the sublayers for the title view
        let headerSublayers = timerHeaderGradient.layer.sublayers
        // Pull the first sublayer from those sublayers
        guard let headerFirstLayer = headerSublayers?[0] else {return}
        // Remove that layer.
        headerFirstLayer.removeFromSuperlayer()
        
        // Reset the gradient for the title view to be the blue theme.
        SetGradient.setGradient(view: timerImageView, mainColor: UIColor.getHIITPrimaryBlue, secondColor: UIColor.getHIITAccentBlue)
    }
    
    func setOrange() {
        // Set the class gradient variable to be the orange gradients.
        gradient = setGradient(chooseTwo: true, primaryBlue: false, accentOrange: true, accentBlue: false)
        
        // Pull the sublayers for the timer.
        let sublayers = timerImageView.layer.sublayers
        // Pull the first sublayer from the sublayers.
        guard let firstLayer = sublayers?[0] else {return}
        // Remove that layer.
        firstLayer.removeFromSuperlayer()
        
        // Call the function to reset the timer gradient image.
        setupTimerImage(gradient: gradient)
        
        // Pull the sublayers for the title view
        let headerSublayers = timerHeaderGradient.layer.sublayers
        // Pull the first sublayer from those sublayers
        guard let headerFirstLayer = headerSublayers?[0] else {return}
        // Remove that layer.
        headerFirstLayer.removeFromSuperlayer()
        
        // Reset the gradient for the title view to be the blue theme.
        SetGradient.setGradient(view: timerImageView, mainColor: UIColor.getHIITPrimaryOrange, secondColor: UIColor.getHIITAccentOrange)
    }
    
    func setGradient(chooseTwo primaryOrange: Bool, primaryBlue: Bool, accentOrange: Bool, accentBlue: Bool) -> CAGradientLayer {
        
        // Set two placeholder colors to be the orange colors.
        var color1: UIColor = .getHIITPrimaryOrange
        var color2: UIColor = .getHIITAccentOrange
        
        // Check the passed in values to identify which colors will be used.
        switch (primaryOrange, primaryBlue, accentOrange, accentBlue) {
        // Set the correct colors.
        case (true, true, false, false):
            color1 = .getHIITPrimaryOrange
            color2 = .getHIITPrimaryBlue
        case (true, false, true, false):
            color1 = .getHIITPrimaryOrange
            color2 = .getHIITAccentOrange
        case (false, true, false, true):
            color1 = .getHIITPrimaryBlue
            color2 = .getHIITAccentBlue
        default:
            print("That gradient didnt work")
        }
        
        // Define a gradient
        let gradient: CAGradientLayer = CAGradientLayer()
        // Set the gradient colors from the placeholders defined above.
        gradient.colors = [color2.cgColor, color1.cgColor]
        // Set the locations for the gradient start and finish.
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        // Set the gradient frame to be the appropriate.
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        // return the gradient.
        return gradient
    }
    
    func setupTimerImage(gradient: CAGradientLayer, percentageComplete: Double = 0) {
        // Define a Bezier Path in a circular shape. This appears to be measured from the bottom. The angles have been chosen from the set point at the top and the angles change based on the percentageCompleted.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: timerImageView.bounds.midX, y: timerImageView.bounds.midY), radius: CGFloat(view.frame.width/3), startAngle: CGFloat( Double.pi * 17/12 - percentageComplete * Double.pi * 22/12), endAngle: CGFloat( -Double.pi * 5/12), clockwise: false)
        
        // Declare a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        // Set the shapesLayer's path to be the circular path set above.
        shapeLayer.path = circlePath.cgPath
        // Round the edges of the circular path.
        shapeLayer.lineCap = .round
        
        // Define the shapeLayer to have a clear color, this prevents the gradient from showing through.
        shapeLayer.fillColor = UIColor.clear.cgColor
        // Define the stroke color to be black, this gives the mask a path to follow.
        shapeLayer.strokeColor = UIColor.getHIITBlack.cgColor
        // Multiplier is the ratio from the sketch file
        shapeLayer.lineWidth = view.frame.width * (14/375)
        
        // Define the gradient frame to be the timer image's bounds.
        gradient.frame = timerImageView.bounds
        // Let the gradients mask be the shape layer from above.
        gradient.mask = shapeLayer
        // Let the gradient be conic in shape, this gives a wrapping gradient.
        gradient.type = .conic
        // The start of the gradient is the center of it's frame.
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        // The end of the gradient is the top of it's frame. The gradient wraps around this line from the start to the end.
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        // Insert the gradient as the timerImageView's first sublayer.
        timerImageView.layer.insertSublayer(gradient, at: 0)
    }
}
