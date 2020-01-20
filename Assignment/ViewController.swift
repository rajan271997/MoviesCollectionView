//
//  ViewController.swift
//  Assignment
//
//  Created by rajan.arora on 16/01/20.
//  Copyright © 2020 IT. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var movies = [Movies]()
    var count = 1
    var id = "1"
    var selectedMovie : Movies?
    var selectedPoster : UIImage?
    
    @IBOutlet var collectionView : UICollectionView!
    
    //MARK: UIViewController Delegate Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // if the view display the first time
    override func viewWillAppear(_ animated: Bool) {
        if movies.count == 0 {
            OMDBClient.instance.fetchData(id: id) { (movies) in
                DispatchQueue.main.async {
                    self.movies = movies
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! DetailPageViewController
        viewController.image = selectedPoster
        viewController.movie = selectedMovie
    }
    
    // MARK:UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.row]
        cell.posterNameLabel.text = movie.title
        cell.posterYearLabel.text = OMDBClient.instance.getTimeAgoSinceYear(year: movie.year)
        cell.posterYearType.text = movie.type
        OMDBClient.instance.downloadImage(url: movie.posterURL) { (image) in
            DispatchQueue.main.async {
                cell.posterImageView.image = image
            }
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = collectionView.frame.size.width / 2 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    // MARK: UICollectionViewDelegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! MovieCollectionViewCell
        selectedPoster = cell.posterImageView.image
        performSegue(withIdentifier: "DetailPageSegue", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // find the last item in collection view
        if indexPath.row == movies.count - 1 {
            count += 1
            id = "\(count)"
            OMDBClient.instance.fetchData(id: id) { (movies) in
                movies.forEach { (movie) in
                    self.movies.append(movie)
                    print("Movies count : \(self.movies.count)")
                }
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
            
        }
    }
}

