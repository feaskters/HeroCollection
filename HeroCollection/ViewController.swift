//
//  ViewController.swift
//  HeroCollection
//
//  Created by iOS123 on 2019/3/20.
//  Copyright © 2019年 iOS123. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var music_btn: UIButton!
    @IBOutlet weak var titleLabel: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tip_btn: UIButton!
    
    var tipView : TipView = TipView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //判断当前是否静音
        if Music.shared().getMuteVolume() == 0 {
            music_btn.setBackgroundImage(UIImage.init(named: "mute"), for: UIControl.State.normal)
        }else{
            music_btn.setBackgroundImage(UIImage.init(named: "unmute"), for: UIControl.State.normal)
        }
        
        //初始化tipview
        self.tipView.frame = CGRect.init(x: UIScreen.main.bounds.width / 2 - 200, y: -200, width: 400, height: 190)
        self.view.addSubview(self.tipView)
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (Timer) in
            EffectiveClass.scale(view: self.titleLabel)
        }
        
    }
    
    @IBAction func start(_ sender: UIButton) {
        Music.shared().musicPlayEffective()
        
        self.tip_btn.tag = 1
        self.tip(self.tip_btn)
        //页面退出动画
        EffectiveClass.moveLeftOutScreen(view: self.titleLabel)
        EffectiveClass.moveRightOutScreen(view: self.containerView)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(1)) {
            let svc = SelectorViewController.init(nibName: nil, bundle: nil)
            self.present(svc, animated: false, completion: nil)
        }
    }
    
    //提示按钮
    @IBAction func tip(_ sender: UIButton) {
        Music.shared().musicPlayEffective()
        if sender.tag == 0 {
            sender.tag = 1
            //显示提示View
            UIView.animate(withDuration: 0.3, animations: {
                self.tipView.frame = CGRect.init(x: UIScreen.main.bounds.width / 2 - 200, y: UIScreen.main.bounds.height / 2 - 150, width: 400, height: 190)
            }) { (Bool) in
                EffectiveClass.jump(view: self.tipView)
            }
        }else{
            sender.tag = 0
            //关闭提示view
            UIView.animate(withDuration: 0.5, animations: {
                self.tipView.frame = CGRect.init(x: UIScreen.main.bounds.width / 2 - 200, y: -200, width: 400, height: 190)
            })
        }
    }
    
    //音乐开关
    @IBAction func muteOrNot(_ sender: UIButton) {
        //播放音效
        let music = Music.shared()
        music.musicPlayEffective()
        //更改静音状态
        music.musicChangeMute()
        //判断当前是否静音
        if music.getMuteVolume() <= 0 {
            sender.setImage(UIImage.init(named: "mute"), for: UIControl.State.normal)
        }else{
            sender.setImage(UIImage.init(named: "unmute"), for: UIControl.State.normal)
        }
    }
    


}

