//
//  ViewController.swift
//  motimotiApplication
//
//  Created by voice on 2/29/16.
//  Copyright © 2016 Masahito Mizogaki. All rights reserved.
//

import UIKit
import AudioToolbox
import CoreMotion
import AVFoundation
import Social



class ViewController: UIViewController {
    
    @IBOutlet weak var levealLabel: UILabel!
    @IBOutlet weak var fuckAndroid: UIImageView!
    @IBOutlet weak var attackCounterLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    var timer: NSTimer!
    var count: Float = 0
    var levelCount = 0
    var attackCount = 0
    var leftFlag:Bool!
    var rightFlag:Bool!
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "time:", userInfo: nil, repeats: true)
        timer.invalidate()
        
        self.leftFlag = true
        self.rightFlag = true
        self.levealLabel.text = NSString(format:"Level:%d",levelCount) as String
    }
    
    @IBAction func gameStart(sender: AnyObject) {
        
        let button = sender as! UIButton
        button.setTitle("Tap Start!", forState: .Normal)
        
        count = 0;
        self.attackCount = (NSArray(contentsOfFile:NSBundle.mainBundle().pathForResource("levelList", ofType:"plist" )!)!.objectAtIndex(levelCount) as! NSString).integerValue
        self.leftFlag = true
        self.rightFlag = true
        self.attackCounterLabel.text = NSString(format:"%d",attackCount) as String
        
        if timer.valid == false {
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "time:", userInfo: nil, repeats: true)
            print(timer)
        }
        
    }
    
    @IBAction func leftAction(sender: AnyObject) {
        
        if self.leftFlag == true  {
            
            self.buttonAction(sender)
            
            self.rightFlag = true
            self.leftFlag = false
            
        }else {
            self.timerStop("Error")
        }
    }
    
    @IBAction func rightAction(sender: AnyObject) {
        
        if self.rightFlag == true  {
            
            self.buttonAction(sender)
            
            self.rightFlag = false
            self.leftFlag = true
            
        }else{
            self.timerStop("Error")
        }
    }
    
    @IBAction func twitterButton(sender: AnyObject) {
        
        self .snsPost(SLComposeViewController(forServiceType: SLServiceTypeTwitter)!)
    }
    @IBAction func facebookButton(sender: AnyObject) {
        
        self .snsPost(SLComposeViewController(forServiceType: SLServiceTypeFacebook)!)
    }
    
    func time(timer: NSTimer) {
        
        count += 0.01
        timerLabel.text = NSString(format:"Timer:%0.2f",count) as String
        
        if count >= 15.0 {
            
            if self.attackCount == 0 {
                
                self.timerStop("Clear")
                ++self.levelCount
                self.levealLabel.text = NSString(format:"Level:%d",levelCount) as String
            }else {
                self.timerStop("Failed")
                --self.levelCount
            }
        }
    }
    
    func buttonAction(sender : AnyObject) {
        
        if timer.valid == true {
            
            let layer: CALayer = self.fuckAndroid.layer
            let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
            animation.duration = 0.18
            animation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(-0.8, -0.8, -1.0))
            animation.repeatCount = 1
            animation.autoreverses = true
            animation.removedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            animation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(1.25, 1.25, 2.0))
            layer.addAnimation(animation, forKey: "animation")
            
            if self.attackCount != 0 {
                --self.attackCount
            }else {
                self.timerStop("Clear")
                ++self.levelCount
                self.levealLabel.text = NSString(format:"Level:%d",levelCount) as String
            }
            self.attackCounterLabel.text = NSString(format:"%ld",self.attackCount) as String!
            
            
            let titleSound = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("succes",ofType:"mp3")!)
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: titleSound, fileTypeHint: nil)
            } catch {
                print("Error")
            }
            
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.currentTime = 0;
            self.audioPlayer.play()
        }
    }
    
    func snsPost(serviceType: SLComposeViewController?) {
        
        if self.attackCount > 1  {
            
            let postView:SLComposeViewController = serviceType!
            postView.setInitialText(NSString(format:"ELITESで、自由を手に入れよう\nクリアレベルはの記録は%@です",self.levealLabel.text!) as String)
            postView.addImage(UIImage(named:"ELITES"))
            postView.addURL(NSURL(string:"http://elite.sc/"))
            self.presentViewController(postView, animated: true, completion: nil)
            
        }
        
    }
    
    func timerStop(timerString:String) {
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        timerLabel.text = timerString
        timer.invalidate()
        
        let titleSound = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("Failure",ofType:"mp3")!)
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: titleSound, fileTypeHint: nil)
        } catch {
            print("Error")
        }
        
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

