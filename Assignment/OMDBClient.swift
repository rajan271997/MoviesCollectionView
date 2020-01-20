//
//  OMDBClient.swift
//  Assignment
//
//  Created by rajan.arora on 16/01/20.
//  Copyright © 2020 IT. All rights reserved.
//

import UIKit

struct Movies {
    let posterURL : String
    let title : String
    let type : String
    let year : String
}

typealias moviesResponse = ([Movies]) -> Void

class OMDBClient {
    
    private init() {}
    static var instance = OMDBClient()
    var totalMovies : Int?
    var currentMovies = 0
    
    let imageCache = NSCache<NSString,UIImage>()
    
    /// fetch the data using url with id and return response
    func fetchData(id : String,callback : @escaping moviesResponse) {
        var url = "http://www.omdbapi.com/?s=Batman&page=$&apikey=eeefc96f".replacingOccurrences(of: "$", with: id)
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.timeoutInterval = 30;
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            
            if (self.totalMovies != nil) && (self.totalMovies == self.currentMovies) {
                return
            }
            
            do {
                guard let dictiniory = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else {return}
                self.totalMovies = Int("\(dictiniory["totalResults"]!)")
                let moviesData = dictiniory["Search"] as! [[String:Any]]
                self.currentMovies += moviesData.count
                print(dictiniory)
                print("Client: \(url)")
                self.handleResponse(dict: moviesData, callback: callback)
            } catch {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    
    /// Handling the response
    private func handleResponse(dict : [[String:Any]],callback : moviesResponse) {
         var movies = [Movies]()
        for item in dict {
            let title = "\(item["Title"]!)"
            let type = "\(item["Type"]!)"
            let year = "\(item["Year"]!)"
            let poster = "\(item["Poster"]!)"
            movies.append(Movies(posterURL: poster, title: title, type: type, year: year))
        }
        callback(movies)
    }
    
    /// find the image from cache if find then return that image.
    /// If not find from cache, then load image using URL.
    func downloadImage(url: String, completion: @escaping (UIImage) -> Void) {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
                  completion(cachedImage)
        } else {
            UIImageView().loadImageWithURL(url: url) { (image) in
                self.imageCache.setObject(image, forKey: url as NSString)
                completion(image)
            }
        }
    }
    
    ///Using current year return the difference.
    func getTimeAgoSinceYear(year : String) -> String {
        var year = year
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY"
        let currentYear = dateFormat.string(from: Date())

        if let index = year.firstIndex(of: "–") {
            year = year.substring(to: index)
        }
       let difference = Int(currentYear)! - Int(year)!
      
        if difference == 0 {
            return "Current year ago"
        }
        
        return "\(difference) years ago"
    }
    
}
