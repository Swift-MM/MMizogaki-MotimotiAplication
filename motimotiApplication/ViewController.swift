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
    
    var timer: Timer!
    var count: Float = 0 /* 少数点以下の */
    var levelCounterBox = 0
    var attackCount = 0
    var leftFlag:Bool!
    var rightFlag:Bool!
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.time(_:)), userInfo: nil, repeats: true)
        timer.invalidate()
        
        
        self.leftFlag = true
        self.rightFlag = true
        self.levealLabel.text = NSString(format:"Level:%d",levelCounterBox) as String
    }
    
    
    /*
     * ゲームスタートさせるメソッド！
     */
    @IBAction func gameStart(_ sender: AnyObject) {
        
        /*
         * 
         */
        let button = sender as! UIButton
        button.setTitle("Tap Start!", for: UIControlState())
        
        count = 0;
        
        // plistのデータを取ってくるで！
        self.attackCount = (NSArray(contentsOfFile:Bundle.main.path(forResource: "levelList", ofType:"plist" )!)!.object(at: levelCounterBox) as! NSString).integerValue
        
        // フラグを初期化
        self.leftFlag = true
        self.rightFlag = true
        
        //　attackCountを表示
        self.attackCounterLabel.text = NSString(format:"%d",attackCount) as String
        
        // 時計が動いているか確認
        if timer.isValid == false {
            
            // 0.01秒ごとにtimeってメソッドを呼び出す！
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.time(_:)), userInfo: nil, repeats: true)
            print(timer)
        }
        
    }
    
    @IBAction func leftAction(_ sender: AnyObject) {
        
        
        if self.leftFlag == true  {
            
            self.buttonAction(sender)
            
            self.rightFlag = true
            self.leftFlag = false
            
        }else {
            self.timerStop("Error")
        }
    }
    
    @IBAction func rightAction(_ sender: AnyObject) {
        
        if self.rightFlag == true  {
            
            self.buttonAction(sender)
            
            self.rightFlag = false
            self.leftFlag = true
            
        }else{
            self.timerStop("Error")
        }
    }
    
    @IBAction func twitterButton(_ sender: AnyObject) {
        
        self .snsPost(SLComposeViewController(forServiceType: SLServiceTypeTwitter)!)
    }
    @IBAction func facebookButton(_ sender: AnyObject) {
        
        self .snsPost(SLComposeViewController(forServiceType: SLServiceTypeFacebook)!)
    }
    
    func time(_ timer: Timer) {
        
        count += 0.01
        timerLabel.text = NSString(format:"Timer:%0.2f",count) as String
        
        if count >= 15.0 {
            
            if self.attackCount == 0 {
                
                self.timerStop("Clear")
                self.levelCounterBox += 1
                self.levealLabel.text = NSString(format:"Level:%d",levelCounterBox) as String
            }else {
                self.timerStop("Failed")
                self.levelCounterBox -= 1
            }
        }
    }
    
    func buttonAction(_ sender : AnyObject) {
        
        if timer.isValid == true {
            
            let layer: CALayer = self.fuckAndroid.layer
            let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
            animation.duration = 0.18
            animation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(-0.8, -0.8, -1.0))
            animation.repeatCount = 1
            animation.autoreverses = true
            animation.isRemovedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            animation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.25, 1.25, 2.0))
            layer.add(animation, forKey: "animation")
            
            if self.attackCount != 0 {
                self.attackCount -= 1
            }else {
                self.timerStop("Clear")
                self.levelCounterBox += 1
                self.levealLabel.text = NSString(format:"Level:%d",levelCounterBox) as String
            }
            self.attackCounterLabel.text = NSString(format:"%ld",self.attackCount) as String!
            
            
            let titleSound = URL(fileURLWithPath:Bundle.main.path(forResource: "succes",ofType:"mp3")!)
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: titleSound, fileTypeHint: nil)
            } catch {
                print("Error")
            }
            
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.currentTime = 0;
            self.audioPlayer.play()
        }
    }
    
    func snsPost(_ serviceType: SLComposeViewController?) {
        
        if self.attackCount > 1  {
            
            let postView:SLComposeViewController = serviceType!
            postView.setInitialText(NSString(format:"ELITESで、自由を手に入れよう\nクリアレベルはの記録は%@です",self.levealLabel.text!) as String)
            postView.add(UIImage(named:"ELITES"))
            postView.add(URL(string:"http://elite.sc/"))
            self.present(postView, animated: true, completion: nil)
            
        }
        
    }
    
    func timerStop(_ timerString:String) {
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        timerLabel.text = timerString
        timer.invalidate()
        
        let titleSound = URL(fileURLWithPath:Bundle.main.path(forResource: "Failure",ofType:"mp3")!)
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: titleSound, fileTypeHint: nil)
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

