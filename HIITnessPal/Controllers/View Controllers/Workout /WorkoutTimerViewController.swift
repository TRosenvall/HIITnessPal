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
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var timerHeaderGradient: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var workoutImage: UIImageView!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var minuteSecondsDividerLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var timerImageView: UIView!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var setNumberLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var exerciseNumberLabel: UILabel!
    @IBOutlet weak var darkOverlayView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var discardButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    // Variables and constants for the workout timer.
    var gradient = CAGradientLayer()
    var countdownTimerDidStart = false
    var workouts: Workouts = WorkoutsController.sharedInstance.totalWorkouts[WorkoutMainViewController.lastSelectedIndex]
    var exercises: [(String, Double, String, Int)] = []
    var currentExercise: Int = 0
    var percentage: Double = 0
    var count: Int = 0
    var gifCount: Int = 0
    var wasGoingBeforePause: Bool = false
    static var totalTime: Double = 0
    static var fromWorkoutComplete: Bool = false
    
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
        alertView.isHidden = true
        darkOverlayView.isHidden = true
        // Set this viewController as the timer's delegate.
        countdownTimer.delegate = self
        timerImageView.isHidden = false
        setupConstraints()
        // Set the title views gradients.
        timerHeaderGradient.addGradient(colors: [.getHIITPrimaryOrange, .getHIITAccentOrange], locations: [0,1])
        timerHeaderGradient.layer.masksToBounds = false
        timerHeaderGradient.layer.shadowOpacity = 0.3
        timerHeaderGradient.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        // Specialized gradient and function for setting the timer's image gradient.
        gradient = setGradient(chooseTwo: true, primaryBlue: false, accentOrange: true, accentBlue: false)
        setupTimerImage(gradient: gradient)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("-----")
        print("-----")
        print("-----")
        print("Passthrough")
        print("-----")
        print("-----")
        print("-----")
        initialFade()
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
        if WorkoutTimerViewController.fromWorkoutComplete == false {
            timerImageView.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if WorkoutTimerViewController.fromWorkoutComplete == false {
            fadeIn()
            darkOverlayView.alpha = 0.8
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        var totalHeartRate: Double = 0
        for heartRate in HealthKitController.sharedInstance.heartRates {
            totalHeartRate += heartRate.heartRate
        }
        HealthKitController.sharedInstance.averageHeartRate = totalHeartRate/Double(HealthKitController.sharedInstance.heartRates.count)
        // To help the calculations work, this is garbage data.
        if HealthKitController.sharedInstance.averageHeartRate.isNaN {
            HealthKitController.sharedInstance.averageHeartRate = 120
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timerImageView.isHidden = true
    }
    
    // MARK: - Actions
    @IBAction func exitButtonTapped(_ sender: Any) {
        wasGoingBeforePause = countdownTimerDidStart
        
        countdownTimer.stop()
        countdownTimerDidStart = false
        startButton.setImage(UIImage(named: "PlayButton"), for: .normal)
        
        timerImageView.isHidden = true
        nextButton.isEnabled = false
        backButton.isEnabled = false
        startButton.isEnabled = false
        previousButton.isEnabled = false
        darkOverlayView.isHidden = false
        alertView.isHidden = false
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
        count = 0
        gifCount = 0
        nextExercise()
        startButton.setImage(UIImage(named: "Pause Button"), for: .normal)
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        // Stop the timer
        count = 0
        gifCount = 0
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
        startButton.setImage(UIImage(named: "Pause Button"), for: .normal)
    }
    
    @IBAction func quitButtonTapped(_ sender: Any) {
        // Pull the correct time for the given exercise.
        let currentWorkoutTime = exercises[currentExercise % exercises.count].1
        // Update the totalTime for the exercise based on the current time and the percentage
        WorkoutTimerViewController.totalTime += (percentage) * currentWorkoutTime
        // Handle any rounding errors.
        WorkoutTimerViewController.totalTime = Double((Int(WorkoutTimerViewController.totalTime * 100)))/100
        // Stop the timer.
        countdownTimer.stop()
        self.countdownTimerDidStart = false
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
        vc.modalPresentationStyle = .fullScreen
        // Present the WorkoutCompleteViewController.
        fadeOut { (success) in
            if success {
                self.initialFade()
                self.present(vc, animated: false, completion: nil)
            }
        }
    }
       
    @IBAction func continueButtonTap(_ sender: Any) {
        alertView.isHidden = true
        // If the timer is not started, start it and change the pause button image.
        timerImageView.isHidden = false
        if wasGoingBeforePause {
            countdownTimer.startTimer()
            countdownTimerDidStart = true
            startButton.setImage(UIImage(named: "Pause Button"), for: .normal)
        }

        nextButton.isEnabled = true
        backButton.isEnabled = true
        startButton.isEnabled = true
        previousButton.isEnabled = true
        darkOverlayView.isHidden = true
    }
    
    @IBAction func discardButtonTapped(_ sender: Any) {
        fadeOut { (success) in
            if success {
                self.dismiss(animated: false, completion: nil)
            }
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
            let exerciseTuple = (exercise.name, Double(exercise.duration), "\(exercise.image)0", exercise.gif)
            // Define a tuple that contains each rest, and their given durations and image names.
            let restTuple = ("Rest", Double(exercise.rest), "rest0", 4)
            // Append the above tuples into the class variable 'exercises' in order to space them out as each given exercise followed by each exercise's rest.
            exercises.append(exerciseTuple)
            exercises.append(restTuple)
        }
    }
    
    // MARK: - Countdown timer delegate
    func countdownTime(time: (minutes: String, seconds: String)) {
        // Set the timer time labels for minutes and seconds.
        if Int(time.minutes)! > 9 {
            minutesLabel.text = time.minutes
        } else {
            minutesLabel.text = "0\(time.minutes)"
        }
        if Int(time.seconds)! > 9 {
            secondsLabel.text = time.seconds
        } else {
            secondsLabel.text = "0\(time.seconds)"
        }
        count += 1
        if count % 80 == 0 {
            gifCount += 1
        }
        let curr = exercises[currentExercise % exercises.count]
        var imageName = curr.2
        let index = imageName.lastIndex(of: imageName.last!)
        imageName.remove(at: index!)
        workoutImage.image = UIImage(named: "\(imageName)\(gifCount % curr.3)")
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
            vc.modalPresentationStyle = .fullScreen
            // Present the WorkoutCompleteViewController.
            fadeOut { (success) in
                if success {
                    self.initialFade()
                    self.present(vc, animated: false, completion: nil)
                }
            }
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
    
    func initialFade() {
        for sub in self.view.subviews {
            if sub != timerHeaderGradient {
                sub.alpha = 0
            }
        }
        for sub in timerHeaderGradient.subviews {
            sub.alpha = 0
        }
    }
    
    func fadeOut(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            for sub in self.view.subviews {
                if sub != self.timerHeaderGradient {
                    sub.alpha = 0
                }
            }
            for sub in self.timerHeaderGradient.subviews {
                sub.alpha = 0
            }
        }) { (success) in
            completion(success)
        }
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.2) {
            for sub in self.view.subviews {
                if sub != self.timerHeaderGradient {
                    sub.alpha = 1
                }
            }
            for sub in self.timerHeaderGradient.subviews {
                sub.alpha = 1
            }
        }
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
        timerHeaderGradient.addGradient(colors: [.getHIITPrimaryBlue, .getHIITAccentBlue], locations: [0,1])
        timerHeaderGradient.layer.masksToBounds = false
        timerHeaderGradient.layer.shadowOpacity = 0.3
        timerHeaderGradient.layer.shadowOffset = CGSize(width: 0, height: 3)
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
        timerHeaderGradient.addGradient(colors: [.getHIITPrimaryOrange, .getHIITAccentOrange], locations: [0,1])
        timerHeaderGradient.layer.masksToBounds = false
        timerHeaderGradient.layer.shadowOpacity = 0.3
        timerHeaderGradient.layer.shadowOffset = CGSize(width: 0, height: 3)
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
        var sizeConstant: CGFloat = 0
        switch (getiPhoneSize()) {
        case "small":
            sizeConstant = 0.8
        case "medium":
            sizeConstant = 0.8
        case "large":
            sizeConstant = 0.8
        case "x":
            sizeConstant = 0.8
        case "r":
            sizeConstant = 0.8
        default:
            print("Something went wrong getting iphone screen size")
        }
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: timerImageView.bounds.midX, y: timerImageView.bounds.midY), radius: CGFloat(view.frame.width/3 * sizeConstant), startAngle: CGFloat( Double.pi * 17/12 - percentageComplete * Double.pi * 22/12), endAngle: CGFloat( -Double.pi * 5/12), clockwise: false)
        
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
    
    func getiPhoneSize () -> String {
        switch( self.view.frame.height) {
        case 568:
            return "small"
        case 667:
            return "medium"
        case 736:
            return "large"
        case 812:
            return "x"
        case 896:
            return "r"
        default:
            print("...")
            print("---")
            print(self.view.frame.height)
            print("---")
            print("...")
        }
        return ""
    }
    
    func setupConstraints() {
        var titleFontSize: CGFloat = 0
        var titleHeightMultiplier: CGFloat = 0
        var backButtonLeadingConstant: CGFloat = 0
        var backButtonBottomConstant: CGFloat = 0
        var backButtonHeightMultiplier: CGFloat = 0
        var titleLabelWidthMultiplier: CGFloat = 0
        var workoutNameLabelTopConstant: CGFloat = 0
        var workoutImageTopConstant: CGFloat = 0
        var workoutImageWidthMultiplier: CGFloat = 0
        var timerImageViewWidthMultiplier: CGFloat = 0
        var timerImageViewTopConstant: CGFloat = 0
        var previousButtonHeightMultiplier: CGFloat = 0
        var minuteSecondsDividerLabelCenterYAnchorConstant: CGFloat = 0
        
        switch (getiPhoneSize()) {
        case "small":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 9
            backButtonHeightMultiplier = 0.7
            
            titleLabelWidthMultiplier = 0.9
            
            workoutNameLabelTopConstant = 11
            
            workoutImageTopConstant = 11
            workoutImageWidthMultiplier = 0.4
            
            timerImageViewWidthMultiplier = 0.72
            timerImageViewTopConstant = 11
            
            previousButtonHeightMultiplier = 0.4
            
            minuteSecondsDividerLabelCenterYAnchorConstant = -22
        case "medium":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.71
            
            titleLabelWidthMultiplier = 0.9
            
            workoutNameLabelTopConstant = 11
            
            workoutImageTopConstant = 11
            workoutImageWidthMultiplier = 0.4
            
            timerImageViewWidthMultiplier = 0.72
            timerImageViewTopConstant = 11
            
            previousButtonHeightMultiplier = 0.4
            
            minuteSecondsDividerLabelCenterYAnchorConstant = -22
        case "large":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.72
            
            titleLabelWidthMultiplier = 0.9
            
            workoutNameLabelTopConstant = 11
            
            workoutImageTopConstant = 11
            workoutImageWidthMultiplier = 0.4
            
            timerImageViewWidthMultiplier = 0.72
            timerImageViewTopConstant = 11
            
            previousButtonHeightMultiplier = 0.4
            
            minuteSecondsDividerLabelCenterYAnchorConstant = -22
        case "x":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.74
            
            titleLabelWidthMultiplier = 0.9
            
            workoutNameLabelTopConstant = 11
            
            workoutImageTopConstant = 11
            workoutImageWidthMultiplier = 0.4
            
            timerImageViewWidthMultiplier = 0.72
            timerImageViewTopConstant = 11
            
            previousButtonHeightMultiplier = 0.4
            
            minuteSecondsDividerLabelCenterYAnchorConstant = -22
        case "r":
            titleFontSize = 30
            
            titleHeightMultiplier = 0.125
            
            backButtonLeadingConstant = 11
            backButtonBottomConstant = 2
            backButtonHeightMultiplier = 0.75
            
            titleLabelWidthMultiplier = 0.9
            
            workoutNameLabelTopConstant = 11
            
            workoutImageTopConstant = 11
            workoutImageWidthMultiplier = 0.4
            
            timerImageViewWidthMultiplier = 0.72
            timerImageViewTopConstant = 11
            
            previousButtonHeightMultiplier = 0.4
            
            minuteSecondsDividerLabelCenterYAnchorConstant = -22
        default:
            print("Something went wrong getting iphone screen size")
        }
        
        timerHeaderGradient.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = titleLabel.font.withSize(titleFontSize)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        workoutNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        workoutImage.translatesAutoresizingMaskIntoConstraints = false
        
        minutesLabel.translatesAutoresizingMaskIntoConstraints = false
        minutesLabel.textAlignment = .right
        
        minuteSecondsDividerLabel.translatesAutoresizingMaskIntoConstraints = false
        minuteSecondsDividerLabel.textAlignment = .center
        
        secondsLabel.translatesAutoresizingMaskIntoConstraints = false
        secondsLabel.textAlignment = .left
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        timerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        setLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        exerciseLabel.translatesAutoresizingMaskIntoConstraints = false
        
        exerciseNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        darkOverlayView.translatesAutoresizingMaskIntoConstraints = false
        darkOverlayView.layer.backgroundColor = UIColor.black.cgColor
        darkOverlayView.alpha = 0.8
        
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.layer.borderColor = UIColor.black.cgColor
        alertView.layer.borderWidth = 0.33
        
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
        borderView.layer.borderWidth = 3
        
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.font = alertLabel.font.withSize(alertView.frame.height/10)
        
        quitButton.translatesAutoresizingMaskIntoConstraints = false
        quitButton.layer.cornerRadius = discardButton.frame.height/2
        quitButton.layer.borderColor = UIColor.getHIITPrimaryOrange.cgColor
        quitButton.layer.borderWidth = 3
        
        discardButton.translatesAutoresizingMaskIntoConstraints = false
        discardButton.layer.cornerRadius = discardButton.frame.height/2
        discardButton.layer.borderColor = UIColor.getHIITPrimaryBlue.cgColor
        discardButton.layer.borderWidth = 3
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.layer.cornerRadius = discardButton.frame.height/2
        
        NSLayoutConstraint.activate([
            timerHeaderGradient.topAnchor.constraint(equalTo: self.view.topAnchor),
            timerHeaderGradient.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: titleHeightMultiplier),
            timerHeaderGradient.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            timerHeaderGradient.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        
            backButton.leadingAnchor.constraint(equalTo: timerHeaderGradient.leadingAnchor, constant: backButtonLeadingConstant),
            backButton.bottomAnchor.constraint(equalTo: timerHeaderGradient.bottomAnchor, constant: backButtonBottomConstant),
            backButton.heightAnchor.constraint(equalToConstant: timerHeaderGradient.frame.size.height * backButtonHeightMultiplier),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: timerHeaderGradient.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: timerHeaderGradient.widthAnchor, multiplier: titleLabelWidthMultiplier),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            workoutNameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            workoutNameLabel.topAnchor.constraint(equalTo: timerHeaderGradient.bottomAnchor, constant: workoutNameLabelTopConstant),
            
            workoutImage.centerXAnchor.constraint(equalTo: workoutNameLabel.centerXAnchor),
            workoutImage.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: workoutImageTopConstant),
            workoutImage.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: workoutImageWidthMultiplier),
            workoutImage.heightAnchor.constraint(equalTo: workoutImage.widthAnchor),
            
            timerImageView.centerXAnchor.constraint(equalTo: workoutImage.centerXAnchor),
            timerImageView.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: timerImageViewWidthMultiplier),
            timerImageView.heightAnchor.constraint(equalTo: timerImageView.widthAnchor),
            timerImageView.topAnchor.constraint(equalTo: workoutImage.bottomAnchor, constant: timerImageViewTopConstant),
            
            previousButton.heightAnchor.constraint(equalTo: timerImageView.heightAnchor, multiplier: previousButtonHeightMultiplier),
            previousButton.centerYAnchor.constraint(equalTo: timerImageView.centerYAnchor),
            previousButton.trailingAnchor.constraint(equalTo: timerImageView.leadingAnchor),
            previousButton.widthAnchor.constraint(equalTo: previousButton.heightAnchor, multiplier: 0.5),
            
            nextButton.heightAnchor.constraint(equalTo: previousButton.heightAnchor),
            nextButton.centerYAnchor.constraint(equalTo: previousButton.centerYAnchor),
            nextButton.leadingAnchor.constraint(equalTo: timerImageView.trailingAnchor),
            nextButton.widthAnchor.constraint(equalTo: nextButton.heightAnchor, multiplier: 0.5),
            
            minuteSecondsDividerLabel.centerYAnchor.constraint(equalTo: timerImageView.centerYAnchor, constant: minuteSecondsDividerLabelCenterYAnchorConstant),
            minuteSecondsDividerLabel.centerXAnchor.constraint(equalTo: timerImageView.centerXAnchor),
            minuteSecondsDividerLabel.heightAnchor.constraint(equalToConstant: minuteSecondsDividerLabel.intrinsicContentSize.height),
            minuteSecondsDividerLabel.widthAnchor.constraint(equalToConstant: minuteSecondsDividerLabel.intrinsicContentSize.width),
            
            minutesLabel.heightAnchor.constraint(equalTo: minuteSecondsDividerLabel.heightAnchor),
            minutesLabel.widthAnchor.constraint(equalTo: timerImageView.widthAnchor, multiplier: 1/2.5),
            minutesLabel.centerYAnchor.constraint(equalTo: minuteSecondsDividerLabel.centerYAnchor),
            minutesLabel.trailingAnchor.constraint(equalTo: minuteSecondsDividerLabel.leadingAnchor),
            
            secondsLabel.heightAnchor.constraint(equalTo: minutesLabel.heightAnchor),
            secondsLabel.widthAnchor.constraint(equalTo: minutesLabel.widthAnchor),
            secondsLabel.centerYAnchor.constraint(equalTo: minutesLabel.centerYAnchor),
            secondsLabel.leadingAnchor.constraint(equalTo: minuteSecondsDividerLabel.trailingAnchor),
            
            startButton.topAnchor.constraint(equalTo: minuteSecondsDividerLabel.bottomAnchor),
            startButton.heightAnchor.constraint(equalTo: timerImageView.heightAnchor, multiplier: 0.3),
            startButton.widthAnchor.constraint(equalTo: timerImageView.heightAnchor),
            startButton.centerXAnchor.constraint(equalTo: timerImageView.centerXAnchor),
            
            setLabel.topAnchor.constraint(equalTo: timerImageView.bottomAnchor, constant: 6),
            setLabel.widthAnchor.constraint(equalToConstant: setLabel.intrinsicContentSize.width),
            setLabel.heightAnchor.constraint(equalToConstant: setLabel.intrinsicContentSize.height),
            setLabel.trailingAnchor.constraint(equalTo: minutesLabel.trailingAnchor),
            
            setNumberLabel.bottomAnchor.constraint(equalTo: setLabel.bottomAnchor),
            setNumberLabel.widthAnchor.constraint(equalTo: timerImageView.widthAnchor, multiplier: 0.5),
            setNumberLabel.heightAnchor.constraint(equalTo: setLabel.heightAnchor),
            setNumberLabel.leadingAnchor.constraint(equalTo: secondsLabel.leadingAnchor),
            
            exerciseLabel.topAnchor.constraint(equalTo: setLabel.bottomAnchor, constant: 11),
            exerciseLabel.widthAnchor.constraint(equalToConstant: exerciseLabel.intrinsicContentSize.width),
            exerciseLabel.heightAnchor.constraint(equalToConstant: exerciseLabel.intrinsicContentSize.height),
            exerciseLabel.trailingAnchor.constraint(equalTo: minutesLabel.trailingAnchor),
            
            exerciseNumberLabel.bottomAnchor.constraint(equalTo: exerciseLabel.bottomAnchor),
            exerciseNumberLabel.widthAnchor.constraint(equalTo: timerImageView.widthAnchor, multiplier: 0.5),
            exerciseNumberLabel.heightAnchor.constraint(equalTo: setLabel.heightAnchor),
            exerciseNumberLabel.leadingAnchor.constraint(equalTo: secondsLabel.leadingAnchor),
            
            darkOverlayView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            darkOverlayView.topAnchor.constraint(equalTo: self.view.topAnchor),
            darkOverlayView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            darkOverlayView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            alertView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            alertView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.28),
            
            borderView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 6),
            borderView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -6),
            borderView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 6),
            borderView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -6),
            
            alertLabel.widthAnchor.constraint(equalTo: alertView.widthAnchor, multiplier: 0.8),
            alertLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 6),
            alertLabel.heightAnchor.constraint(equalTo: alertView.heightAnchor, multiplier: 1/2),
            alertLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            
            continueButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            continueButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -16),
            continueButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalTo: alertView.heightAnchor, multiplier: 0.2),
            
            discardButton.widthAnchor.constraint(equalTo: alertView.widthAnchor, multiplier: 0.43),
            discardButton.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -5),
            discardButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            discardButton.heightAnchor.constraint(equalTo: alertView.heightAnchor, multiplier: 0.2),
            
            quitButton.widthAnchor.constraint(equalTo: alertView.widthAnchor, multiplier: 0.43),
            quitButton.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -5),
            quitButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16),
            quitButton.heightAnchor.constraint(equalTo: alertView.heightAnchor, multiplier: 0.2),
            
        ])
    }
}
