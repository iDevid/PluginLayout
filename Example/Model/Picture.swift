//
//  Picture.swift
//  Example
//
//  Created by Stefano Mondino on 30/06/2019.
//  Copyright © 2019 Stefano Mondino. All rights reserved.
//

import Foundation
import UIKit

fileprivate class ImageCache {
    private var cache = NSCache<NSURL, UIImage>()
    subscript(key: URL) -> UIImage? {
        get {
            return cache.object(forKey: key as NSURL)
        }
        set {
            if let image = newValue {
                cache.setObject(image, forKey: key as NSURL)
            }
            
        }
    }
}

struct Picture {
    private static var cache = ImageCache()
    enum ContentType: String {
        case cats
        case food
        case sports
        case people
        case nature
        
        var ratio: CGFloat {
            switch self {
            case .cats: return 4/3
            case .nature, .people: return CGFloat([16.0/9.0 ,4.0/3.0, 9.0/16.0, 3.0/4.0, 21.0/9.0 , 9.0/21.0].randomElement() ?? 1)
            default: return 1
            }
        }
        var max: Int {
            switch self {
            case .nature: return 6
            case .people: return 13
            case .cats: return 11
            default: return 7
            }
        }
    }
    
    var id: Int
    var type: ContentType
    var ratio: CGFloat
    
    init(id: Int, type: ContentType = .food) {
        self.id = id
        self.ratio = type.ratio
        self.type = type
    }
    var url: URL {
        let width = 600
        let height = Int(round(CGFloat(width) / ratio))
        return URL(string:"http://lorempixel.com/\(width)/\(height)/\(type.rawValue)/\(id % type.max)")!
    }
    
    func download(_ completion: @escaping (UIImage) -> ()) -> URLSessionTask? {
        print (url)
        if let cached = Picture.cache[url] {
            completion(cached)
            return nil
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    Picture.cache[self.url] = image
                    completion(image)
                } else {
//                    Picture.cache.removeObject(forKey: self.url as NSURL)
                    completion(UIImage())
                }
            }
        }
        task.resume()
        return task
    }
}
