//
//  MovieCollectionViewCell.swift
//  Assignment
//
//  Created by rajan.arora on 17/01/20.
//  Copyright © 2020 IT. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var posterNameLabel: UILabel!

    @IBOutlet var posterImageView: UIImageView!

    @IBOutlet var posterYearLabel: UILabel!

    @IBOutlet var posterYearType: UILabel!
    
}

extension UIImageView {
    func loadImageWithURL(url : String,poster : @escaping (UIImage) -> Void ) {
        let Url = URL(string: url)!
        var request = URLRequest(url: Url)
        request.timeoutInterval = 15
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            poster(image)
        }.resume()
    }
}

