//
//  SelectorViewController.swift
//  HeroCollection
//
//  Created by iOS123 on 2019/3/20.
//  Copyright © 2019年 iOS123. All rights reserved.
//

import UIKit

class SelectorViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.containerView.alpha = 0
        UIView.animate(withDuration: 1) {
            self.containerView.alpha = 1
        }
    }

    @IBAction func back(_ sender: Any) {
        Music.shared().musicPlayEffective()
        //退出动画
        UIView.animate(withDuration: 1, animations: {
            self.containerView.alpha = 0
            let trans = CGAffineTransform.init(scaleX: 0.0001, y: 0.0001)
            let trans2 = CGAffineTransform.init(rotationAngle: -2.5)
            let t = trans.concatenating(trans2)
            self.containerView.transform = t
        }) { (Bool) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func btn_click(_ sender: UIButton) {
        Music.shared().musicPlayEffective()
        let gvc = GameViewController.init(nibName: nil, bundle: nil)
        switch sender.tag {
        case 0:
            gvc.setConfig(x: 8, y: 8, is_random: false)
            break
        case 1:
            gvc.setConfig(x: 8, y: 8, is_random: true)
            break
        case 10:
            gvc.setConfig(x: 11, y: 8, is_random: false)
            break
        case 11:
            gvc.setConfig(x: 11, y: 8, is_random: true)
            break
        default:
            break
        }
        //退出动画
        UIView.animate(withDuration: 1, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform.init(scaleX: 2.1, y: 2.1)
        }) { (Bool) in
            self.containerView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            self.present(gvc, animated: false, completion: {
                self.containerView.alpha = 1
                self.reloadInputViews()
            })
        }
    }
    

}
