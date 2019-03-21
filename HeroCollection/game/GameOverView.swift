//
//  GameOverView.swift
//  PurificationMonsters
//
//  Created by iOS123 on 2019/3/14.
//  Copyright © 2019年 iOS123. All rights reserved.
//

import UIKit


class GameOverView: UIView {

    let scoreLabel = UILabel.init()
    let titleLabel = UILabel.init()
    
    lazy var background : UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named:"resultbg"))
        return imageView
    }()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        //初始化背景
        self.background.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(self.background)
        //初始化标题
        if SystemLanguageClass.getCurrentLanguage() == "cn"{
            self.titleLabel.text = "收集完成"
        }else{
            self.titleLabel.text = "CLEAR"
        }
        self.titleLabel.font = UIFont.init(name: "Marker Felt", size: 32)
        self.titleLabel.textColor = #colorLiteral(red: 0.8957663824, green: 0.5068704644, blue: 0.548891146, alpha: 1)
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.frame = CGRect.init(x: self.frame.width / 2 - 75, y: 50, width: 150, height: 100)
        self.addSubview(titleLabel)
        
        //初始化结果
        self.scoreLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.scoreLabel.textColor = #colorLiteral(red: 0.8957663824, green: 0.5068704644, blue: 0.548891146, alpha: 1)
        self.scoreLabel.textAlignment = NSTextAlignment.center
        self.scoreLabel.frame = CGRect.init(x: self.frame.width / 2 - 100, y: 200, width: 200, height: 50)
        self.addSubview(scoreLabel)
        
        //启动特效
        self.labelEffective()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //设置结果
    func setResult(result:Dictionary<String,String>) {
        if SystemLanguageClass.getCurrentLanguage() == "cn" {
            self.scoreLabel.text = "分数:" + result["score"]!
        }else{
            self.scoreLabel.text = "Score:" + result["score"]!
        }
    }
    
    //标题特效设置
    func labelEffective() {
        //标题晃动效果
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (Timer) in
            
            EffectiveClass.rotateAndScale(view: self.titleLabel)
            EffectiveClass.rotateLeft(view: self.scoreLabel)
        }
    }
    
}
