//
//  ExerciseController.swift
//  Get-HIIT
//
//  Created by Leah Cluff on 8/20/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import UIKit

class ExerciseController {
    
    static let sharedExercises = ExerciseController()
    
    var workouts: [Workout] {
        let sitUp = Workout(name: "Sit Up", description: "Lay down on your back and bring your legs in by bending your knees 90 degrees. Place your hands by your ears and extend your elbows out wide. From this start position engage your core by contracting your stomach muscles and raise up to a sitting position.", image: "SitUp2", gif: "situpGif")
        let lunges = Workout(name: "Lunges", description: "Go easy on the knees with this lunge. Stand with feet hip-width apart, engage core, and take a big step backward. Engage glutes as you bend front knee to lower body so back knee lightly taps floor while keeping upper body upright. Drive front heel into floor to return to starting position.", image: "Lunge2", gif: "lungesGif")
        let squats = Workout(name: "Squats", description: "Place your feet shoulder-width apart. Sit back and down like you're sitting into an imaginary chair. Keep your head facing forward as your upper body bends forward a bit. Lower yourself down so your thighs are parallel to the floor, with your knees over your ankles. Press your weight back into your heels. Push through your heels to bring yourself back to the starting position.", image: "Squat2", gif: "squatsGif")
        let pushUps = Workout(name: "Push Up", description: "To do a pushup, start by positioning yourself on the floor with your face down, your palms on the floor shoulder-width apart, and the balls of your feet touching the ground. When you're ready to start, push yourself up, keeping your body in a straight line and your elbows pointed to your toes", image: "PushUp1", gif: "pushUpGif")
        let climbers = Workout(name: "Climbers", description: "Start in a traditional plank with shoulders over hands and weight on your toes. Bring your right knee forward under your chest, with the toes just off the ground. Return to your basic plank. Switch legs, bringing the left knee forward. Keep switching legs and begin to pick up the pace until it feels a little like running in place in a plank position.", image: "Climber2", gif: "climberGif")
        let pullUps = Workout(name: "Pull ups", description: "Grab the bar with your palms down, shoulder-width apart. Hang on the bar with straight arms and your legs off the floor. Pull yourself up by pulling your elbows down to the floor. Go all the way up until your chin passes the bar. Slowly lower yourself until your arms are straight.", image: "PullUp1", gif: "pullUpGif")
        let dips = Workout(name: "Dips", description: "Place your hands behind you on a flat surface that is 2 feet above the ground. Straighten your legs in front of you and straighten your arms. Lower your body by bending your arms until you can’t go any lower. Lift your body up by straightening your arms.", image: "Dip2", gif: "dipGif")
        let pike = Workout(name: "Pike", description: "Assume a pushup position on the floor. Straighten your arms and place your hands shoulder-width apart. Lift up your hips so that your body forms an upside down V. Keep your legs and arms straight as you bend your elbows. Lower your upper body until the top of your head nearly touches the floor. Pause, and then push yourself back up.", image: "Pike1", gif: "dipGif")
        return [sitUp, lunges, squats, pushUps, climbers, pullUps, dips, pike]
    }
    
}
