//
//  TipView.swift
//  HeroCollection
//
//  Created by iOS123 on 2019/3/20.
//  Copyright © 2019年 iOS123. All rights reserved.
//

import UIKit

class TipView: UIView {
    
    override func layoutSubviews() {
        
        self.clipsToBounds = true
        
        //初始化背景
        let backgroundView = UIImageView.init(image: UIImage.init(named: "tipBackground"))
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        backgroundView.contentMode = UIView.ContentMode.scaleToFill
        self.addSubview(backgroundView)
        
        //初始化文字框
        let tipLabel = UILabel.init(frame: CGRect.init(x: 20, y: 10, width: self.frame.width - 40, height: self.frame.height - 20))
        tipLabel.textColor = #colorLiteral(red: 0.4470588235, green: 0.2705882353, blue: 0.09019607843, alpha: 1)
        tipLabel.font = UIFont.boldSystemFont(ofSize: 18)
        tipLabel.numberOfLines = 0
        if SystemLanguageClass.getCurrentLanguage() == "cn" {
            tipLabel.text = ""
        }else{
            tipLabel.text = "How to play: \n\t Click a hero block to change the other of selected blocks.When all blocks are changed to a same team, you win!"
        }
        
        self.addSubview(tipLabel)
        
    }

}
