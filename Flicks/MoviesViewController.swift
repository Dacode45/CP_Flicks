//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Labuser on 1/21/16.
//  Copyright (c) 2016 David Ayeke. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    var refreshControl:UIRefreshControl!
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNetworkError()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        
        self.refreshControl = UIRefreshControl()
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh", attributes: attributes)
        
        self.refreshControl.addTarget(self, action:"refresh", forControlEvents: UIControlEvents.ValueChanged)
                // Do any additional setup after loading the view.
        
        collectionView.insertSubview(self.refreshControl, atIndex: 0)
        getMovies()
        
    }
    
    
    func showNetworkError(){
        errorView.hidden = false
        println("NetworkError shown")
    }
    
    func hideNetworkError(){
        errorView.hidden = true
        println("NetworkError hidden")
    }
    func toggleNetworkError(){
        if let timer = timer{
           timer.invalidate()
        }
        showNetworkError()
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target:self, selector: Selector("hideNetworkError"), userInfo:nil, repeats: false)
        
    }
    
    func getMovies(){
    
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        //Display hud before task
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = NSJSONSerialization.JSONObjectWithData(
                        data, options:NSJSONReadingOptions.MutableContainers, error:nil) as? NSDictionary{
                            //print("response: \(responseDictionary)")
                            self.movies = (responseDictionary["results"] as! [NSDictionary])
                            self.filteredMovies = self.movies
                            self.collectionView.reloadData()
                                MBProgressHUD.hideHUDForView(self.view, animated: true)
                            
                    }
                    
                    if error != nil{
                        self.toggleNetworkError()
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }
                }
        })
        task.resume()
    }
    
    func refresh(){
       
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = NSJSONSerialization.JSONObjectWithData(
                        data, options:NSJSONReadingOptions.MutableContainers, error:nil) as? NSDictionary{
                            //print("response: \(responseDictionary)")
                            self.movies = (responseDictionary["results"] as! [NSDictionary])
                            self.filteredMovies = self.movies
                            self.collectionView.reloadData()
                                self.refreshControl.endRefreshing()
                                MBProgressHUD.hideHUDForView(self.view, animated: true)
                            
                            
                    }
                    
                    if error != nil{
                        self.toggleNetworkError()
                        self.refreshControl.endRefreshing()
                    }
                }
        })
        task.resume()
    
    }
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int)->Int{
        if let filteredMovies = filteredMovies{
            return filteredMovies.count
        }else{
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCollectionCell", forIndexPath: indexPath) as! MovieCollectionCell
        let movie = filteredMovies![indexPath.row]
        let title: String = movie["title"] as! String
        let overview: String = movie["overview"] as! String
        let posterPath: String = movie["poster_path"] as! String
        
        let baseImageURL = "http://image.tmdb.org/t/p/w500"
        let imageURL = NSURL(string: baseImageURL+posterPath)
        let imageRequest = NSURLRequest(URL: imageURL!)
        
        cell.movieImage.setImageWithURLRequest(
            imageRequest,
            placeholderImage: nil,
            success:{(imageRequest, imageResponse, image)-> Void in
                //response nil if image cached
                if imageResponse != nil{
                    println("image was not cached, fade in image")
                    cell.movieImage.alpha = 0.0
                    cell.movieImage.image = image
                    UIView.animateWithDuration(0.3, animations:{() -> Void in
                        cell.movieImage.alpha = 1.0
                    })
                }else{
                    print("Image was cached update image")
                    cell.movieImage.image = image
                }
            },
            failure:{(imageRequest, imageResponse, error)-> Void in
                println("failed to load image")
            }
        )
        
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText:String){
        filteredMovies = searchText.isEmpty ? movies:
            movies?.filter({(movie:NSDictionary)->Bool in
                return (movie["title"] as! String).rangeOfString(searchText, options:.CaseInsensitiveSearch) != nil})
        collectionView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

