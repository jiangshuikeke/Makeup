//
//  PlistManager.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/8/18.
//

///.plist文件管理
import Foundation

class PlistManager{
    static let shared:PlistManager = PlistManager()
    
    private init(){
        
    }
}

extension PlistManager{
    
    ///获取五官的描述
    func readValueFor(_ key:String,type:OrgansType) -> String?{
        var res:String? = nil
        if let arrs = readFromPlist(name: "Organs") as? [Dictionary<String, String>]{
            var index = 0
            switch type {
            case .eye:
                index = 2
                break
            case .eyebrow:
                index = 3
                break
            case .nose:
                index = 0
                break
            case .mouth:
                index = 1
                break
            case .face:
                index = 4
                fallthrough
            default:
                break
            }
            
            res = arrs[index][key]
        }
        return res
    }
    
    ///获取妆容数据
    func loadMakeups(){
        //han
        if let han = readFromPlist(name: "Han") as? [Dictionary<String,Any>],
        let tang = readFromPlist(name: "Tang") as? [Dictionary<String,Any>],
        let song = readFromPlist(name: "Song") as? [Dictionary<String,Any>],
        let ming = readFromPlist(name: "Ming") as? [Dictionary<String,Any>]{
            let hans = processDynasty(makeups: han)
            let tangs = processDynasty(makeups: tang)
            let songs = processDynasty(makeups: song)
            let mings = processDynasty(makeups: ming)
        }
        
    }
    
    ///加载朝代
    func loadDynsaty(name:String) -> DynastyMakeup?{
        if let arr = readFromPlist(name: "DynastyMakeup") as? [Dictionary<String,String>]{
            for dict in arr{
                if dict["name"] != name{
                    continue
                }
                var pin:String
                switch name{
                    case "汉代":
                        pin = "Han"
                        break
                    case "唐代":
                        pin = "Tang"
                        break
                    case "宋代":
                        pin = "Song"
                        break
                    case "明代":
                        pin = "Ming"
                        break
                    default:
                        pin = "Han"
                }
                //获取朝代信息
                let dynasty = DynastyMakeup(dict: dict)
                //获取朝代妆容信息
                let makeups = loadMakups(by: pin)
                dynasty.makeups = makeups
                return dynasty
            }
        }
        return nil
    }
    
    ///根据朝代加载指定的妆容
    func loadMakups(by dynasty:String) -> [Makeup]?{
        if let dynasty = readFromPlist(name: dynasty) as? [Dictionary<String,Any>]{
            return processDynasty(makeups: dynasty)
        }
        return nil
    }
    
}

private extension PlistManager{
    func readFromPlist(name:String) -> NSArray?{
        guard let path = Bundle.main.path(forResource: name, ofType: ".plist") else{
            print("未找到该文件")
            return nil
        }
        return NSArray.init(contentsOfFile: path)
    }
    
    //处理每一个朝代中的妆容
    func processDynasty(makeups:[Dictionary<String,Any>]) -> [Makeup]{
        var res = [Makeup]()
        for dict in makeups {
            res.append(Makeup(dict: dict))
        }
        return res
    }
}
