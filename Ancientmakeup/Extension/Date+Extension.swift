//
//  Date+Extension.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/8/10.
//

import Foundation



extension Date{
    ///时间段
    enum TimeQuantum {
        case morning
        case noon
        case afternoon
        case night
    }
    
    //根据当前的时间计算出当前时间段
    static var currentQuantum:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.timeZone = NSTimeZone.local
        //获取当前的小时（24进制）
        var res:String = "你好"
        if let nowHH = Int(dateFormatter.string(from: Date.now)){
            if  0 <= nowHH && nowHH <= 5{
                res = "夜深啦，有个好梦"
            }else if 5 < nowHH && nowHH <= 8{
                res = "早上好，有个元气的一天！"
            }else if 8 < nowHH && nowHH <= 11{
                res = "上午好"
            }else if 11 < nowHH && nowHH <= 13{
                res = "中午好，有好好吃饭吗"
            }else if 13 < nowHH && nowHH <= 16{
                res = "下午好"
            }else{
                res = "晚上好，一天辛苦了"
            }
        }
        
        return res
    }
}
