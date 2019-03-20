//
//  EffectiveClass.swift
//  ColorSynchronization
//
//  Created by iOS123 on 2019/3/15.
//  Copyright © 2019年 iOS123. All rights reserved.
//

import UIKit

class EffectiveClass: NSObject {

    //晃动效果
    class func shade(view:UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = CGAffineTransform.init(rotationAngle: 0.2)
        }, completion: { (Bool) in
            UIView.animate(withDuration: 0.5, animations: {
                view.transform = CGAffineTransform.init(rotationAngle: -0.2)
            }, completion: { (Bool) in
                UIView.animate(withDuration: 0.5, animations: {
                    view.transform = CGAffineTransform.init(rotationAngle: 0)
                })
            })
        })
    }
    
    //顺时针旋转效果
    class func rotateLeft(view:UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = CGAffineTransform.init(rotationAngle: 180)
        }, completion: { (Bool) in
            UIView.animate(withDuration: 0.5, animations: {
                view.transform = CGAffineTransform.init(rotationAngle: -180)
            }, completion: { (Bool) in
                UIView.animate(withDuration: 0.5, animations: {
                    view.transform = CGAffineTransform.init(rotationAngle: 0)
                })
            })
        })
    }
    
    //旋转放缩效果
    class func rotateAndScale(view:UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5).concatenating(CGAffineTransform.init(rotationAngle: 0.5))
        }, completion: { (Bool) in
            UIView.animate(withDuration: 0.5, animations: {
            }, completion: { (Bool) in
                UIView.animate(withDuration: 0.5, animations: {
                    view.transform = CGAffineTransform.init(scaleX: 2, y: 2).concatenating(CGAffineTransform.init(rotationAngle: 0))
                })
            })
        })
    }
    
    //翻转效果
    class func reverse(view:UIView){
        
        UIView.animate(withDuration: 0.25, animations: {
             view.layer.transform = CATransform3DRotate(view.layer.transform, CGFloat(Double.pi), 0, 1, 0)
        }) { (Bool) in
            UIView.animate(withDuration: 0.25) {
                view.layer.transform = CATransform3DRotate(view.layer.transform, CGFloat( -Double.pi), 0, 1, 0)
            }
        }
        
    }
    
    //跳动效果
    class func jump(view:UIView){
        UIView.animate(withDuration: 0.15, animations: {
            view.frame = CGRect.init(x: view.frame.origin.x, y: view.frame.origin.y - 30, width: view.frame.width, height: view.frame.height)
        }) { (Bool) in
            UIView.animate(withDuration: 0.15, animations: {
                view.frame = CGRect.init(x: view.frame.origin.x, y: view.frame.origin.y + 15, width: view.frame.width, height: view.frame.height)
            }) { (Bool) in
                UIView.animate(withDuration: 0.15, animations: {
                    view.frame = CGRect.init(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)
                }, completion: nil)
                
            }
        }
    }
    
    //放缩效果
    class func scale(view:UIView){
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
        }, completion: { (Bool) in
            UIView.animate(withDuration: 0.5, animations: {
                view.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            }, completion: { (Bool) in
                UIView.animate(withDuration: 0.5, animations: {
                    view.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                })
            })
        })
    }
    
    //左移至屏幕外
    class func moveLeftOutScreen(view:UIView){
        UIView.animate(withDuration: 1) {
            view.frame = CGRect.init(x: -UIScreen.main.bounds.width, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)
        }
    }
    
    //左移至屏幕外
    class func moveRightOutScreen(view:UIView){
        UIView.animate(withDuration: 1) {
            view.frame = CGRect.init(x: UIScreen.main.bounds.width, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)
        }
    }
}
