//
//  ExerciseController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/20/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class ExerciseController {
    
    // Singleton to access the exercises.
    static let sharedInstance = ExerciseController()
    
    // List of all specific exercises for each workout.
    var workouts: [Workout] {
        let sitUp = Workout(gif: "situpGif", name: "Sit Up", image: "SitUp2", description: "Lay down on your back and bring your legs in by bending your knees 90 degrees. Place your hands by your ears and extend your elbows out wide. From this start position engage your core by contracting your stomach muscles and raise up to a sitting position.")
        let lunges = Workout(gif: "lungesGif", name: "Lunges", image: "Lunge2", description: "Go easy on the knees with this lunge. Stand with feet hip-width apart, engage core, and take a big step backward. Engage glutes as you bend front knee to lower body so back knee lightly taps floor while keeping upper body upright. Drive front heel into floor to return to starting position.")
        let squats = Workout(gif: "squatsGif", name: "Squats", image: "Squat2", description: "Place your feet shoulder-width apart. Sit back and down like you're sitting into an imaginary chair. Keep your head facing forward as your upper body bends forward a bit. Lower yourself down so your thighs are parallel to the floor, with your knees over your ankles. Press your weight back into your heels. Push through your heels to bring yourself back to the starting position.")
        let pushUps = Workout(gif: "pushUpGif", name: "Push Up", image: "PushUp1", description: "To do a pushup, start by positioning yourself on the floor with your face down, your palms on the floor shoulder-width apart, and the balls of your feet touching the ground. When you're ready to start, push yourself up, keeping your body in a straight line and your elbows pointed to your toes")
        let climbers = Workout(gif: "climberGif", name: "Climbers", image: "Climber2", description: "Start in a traditional plank with shoulders over hands and weight on your toes. Bring your right knee forward under your chest, with the toes just off the ground. Return to your basic plank. Switch legs, bringing the left knee forward. Keep switching legs and begin to pick up the pace until it feels a little like running in place in a plank position.")
        let pullUps = Workout(gif: "pullUpGif", name: "Pull ups", image: "PullUp1", description: "Grab the bar with your palms down, shoulder-width apart. Hang on the bar with straight arms and your legs off the floor. Pull yourself up by pulling your elbows down to the floor. Go all the way up until your chin passes the bar. Slowly lower yourself until your arms are straight.")
        let dips = Workout(gif: "dipGif", name: "Dips", image: "Dip2", description: "Place your hands behind you on a flat surface that is 2 feet above the ground. Straighten your legs in front of you and straighten your arms. Lower your body by bending your arms until you can’t go any lower. Lift your body up by straightening your arms.")
        let pike = Workout(gif: "dipGif", name: "Pike", image: "Pike1", description: "Assume a pushup position on the floor. Straighten your arms and place your hands shoulder-width apart. Lift up your hips so that your body forms an upside down V. Keep your legs and arms straight as you bend your elbows. Lower your upper body until the top of your head nearly touches the floor. Pause, and then push yourself back up.")
        return [sitUp, lunges, squats, pushUps, climbers, pullUps, dips, pike]
    }
}
