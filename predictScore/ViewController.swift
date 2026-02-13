//
//  ViewController.swift
//  predictScore
//
//  Created by GEU on 13/02/26.
//

import UIKit
import CoreML

class ViewController: UIViewController {

    @IBOutlet weak var extraCurricular: UISwitch!
    @IBOutlet weak var hoursSleep: UILabel!
    @IBOutlet weak var questionPapers: UILabel!
    @IBOutlet weak var hoursStudied: UILabel!
    @IBOutlet weak var previousScore: UITextField!
    
    //drtdtr
    @IBOutlet weak var questionPaperStepper: UIStepper!
    @IBOutlet weak var hoursSleepStepper: UIStepper!
    @IBOutlet weak var hoursStudiedStepper: UIStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hoursSleep.text = "0"
        questionPapers.text = "0"
        hoursStudied.text = "0"
//        previousScore.text = "0"
        // Do any additional setup after loading the view.
    }

    @IBAction func hoursSleepedChanged(_ sender: Any) {
        hoursSleep.text = "\(Int(hoursSleepStepper.value))"
    }
    
    
    
    @IBAction func hoursStudiedChanged(_ sender: Any) {
        hoursStudied.text = "\(Int(hoursStudiedStepper.value))"
    }
    
    
    
    @IBAction func qpSolvedChanged(_ sender: Any) {
        questionPapers.text = "\(Int(questionPaperStepper.value))"
    }
    
    
    
    @IBAction func calculate(_ sender: Any) {
        
        guard let previousscore = previousScore.text else{
            print("Invalid previous score")
            return
        }
        
        let qpsolved = Int64(questionPaperStepper.value)
        let hoursstudied = Int64(hoursStudiedStepper.value)
        let hoursslept = Int64(hoursSleepStepper.value)
        
        let score = Int64(previousScore.text!) ?? 0
        
        let extracurricular: String
       if extraCurricular.isOn{
            extracurricular = "Yes"
       }else{
           extracurricular = "No"
       }
        
        var message: String = ""
                                 
        let modelConfig = MLModelConfiguration()
        
        let model = try? MyTabularRegressorForPerformancePrediction(configuration: modelConfig)
        
        let prediction = try! model?.prediction(Hours_Studied: hoursstudied, Previous_Scores: score, Extracurricular_Activities: extracurricular, Sleep_Hours: hoursslept, Sample_Question_Papers_Practiced: qpsolved)
        
        if let performancePrediction = prediction?.Performance_Index{
            message = "Your predicted score is : \(performancePrediction)"
        } else{
            message = "Error"
        }
        
        let resultAlert = UIAlertController(title: "Result", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        resultAlert.addAction(okAction)
        present(resultAlert, animated: true, completion: nil)
    }
}

