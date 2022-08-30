//
//  PlistManager.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/8/18.
//

///.plist文件管理
import Foundation

class PlistManager{
    init(){
        
    }
}

extension PlistManager{
    
    ///获取五官的描述
    func readValueFor(_ key:String,type:OrgansType) -> String?{
        var res:String? = nil
        if let arrs = arrayFromPlist(name: "Organs") as? [Dictionary<String, String>]{
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
    
    ///根据风格推荐适合妆容
    func loadMakeups(style:String) -> [Makeup]{
        var res = [Makeup]()
        //加载风格字典
        let styles = dictFromPlist(name: "Styles")
        if let arr = styles?[style] as? [String]{
            res = loadMakeups(names: arr)
        }
        return res
    }
    
    ///根据妆容名称获取妆容
    func loadMakeups(names:[String]) -> [Makeup]{
        var res = [Makeup]()
        //han
        if let han = arrayFromPlist(name: "Han") as? [Dictionary<String,Any>],
        let tang = arrayFromPlist(name: "Tang") as? [Dictionary<String,Any>],
        let song = arrayFromPlist(name: "Song") as? [Dictionary<String,Any>],
        let ming = arrayFromPlist(name: "Ming") as? [Dictionary<String,Any>]{
            let hans = processDynasty(makeups: han)
            let tangs = processDynasty(makeups: tang)
            let songs = processDynasty(makeups: song)
            let mings = processDynasty(makeups: ming)
            
            res.append(contentsOf: lookForMakup(by: names, makeups: hans))
            res.append(contentsOf: lookForMakup(by: names, makeups: tangs))
            res.append(contentsOf: lookForMakup(by: names, makeups: songs))
            res.append(contentsOf: lookForMakup(by: names, makeups: mings))
        }
        return res
    }
    
    ///加载各个朝代下的妆容
    func loadDynsaty(name:String) -> DynastyMakeup?{
        if let arr = arrayFromPlist(name: "DynastyMakeup") as? [Dictionary<String,String>]{
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
        if let dynasty = arrayFromPlist(name: dynasty) as? [Dictionary<String,Any>]{
            return processDynasty(makeups: dynasty)
        }
        return nil
    }
    
}

private extension PlistManager{
    func arrayFromPlist(name:String) -> NSArray?{
        if let path = filePath(by: name){
            return NSArray.init(contentsOfFile: path)
        }
        return nil
    }
    
    func dictFromPlist(name:String) -> NSDictionary?{
        if let path = filePath(by: name){
            return NSDictionary.init(contentsOfFile: path)
        }
        return nil
    }
    
    func filePath(by fileName:String) -> String?{
        guard let path = Bundle.main.path(forResource: fileName, ofType: ".plist") else{
            print("未找到该文件")
            return nil
        }
        return path
    }
    //处理每一个朝代中的妆容
    func processDynasty(makeups:[Dictionary<String,Any>]) -> [Makeup]{
        var res = [Makeup]()
        for dict in makeups {
            let makeup = Makeup(dict: dict)
            if dict["name"] as! String == "桃花妆"{
                modelForMakeup(makeup: makeup)
            }
            res.append(makeup)
        }
        return res
    }
    
    func lookForMakup(by names:[String],makeups:[Makeup]) -> [Makeup]{
        return makeups.filter { makeup in
            return names.contains(makeup.name!)
        }
    }
}
