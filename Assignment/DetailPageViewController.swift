//
//  DetailPageViewController.swift
//  Assignment
//
//  Created by rajan.arora on 20/01/20.
//  Copyright © 2020 IT. All rights reserved.
//

import UIKit

class DetailPageViewController: UIViewController {
    
    var movie : Movies?
    var image : UIImage?
    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var titleValueLabel: UILabel!
    @IBOutlet var yearValueLabel: UILabel!
    @IBOutlet var typeValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beautifyUI()
    }
    
    func beautifyUI() {
        posterImageView.image = image
        titleValueLabel.text = movie?.title
        yearValueLabel.text = OMDBClient.instance.getTimeAgoSinceYear(year: movie!.year)
        typeValueLabel.text = movie!.type
        
    }
    
    
}
