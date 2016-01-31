//
//  DetailsViewController.swift
//  Flicks
//
//  Created by Labuser on 1/26/16.
//  Copyright (c) 2016 David Ayeke. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var movie: NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
   
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        let overview = movie["overview"] as? String
        titleLabel.text = title
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        if let posterPath: String = movie["poster_path"] as? String{
            let baseImageURL = "http://image.tmdb.org/t/p/w500"
            let imageURL = NSURL(string: baseImageURL+posterPath)
            let imageRequest = NSURLRequest(URL: imageURL!)
            
            movieImage.setImageWithURLRequest(
                imageRequest,
                placeholderImage: nil,
                success:{(imageRequest, imageResponse, image)-> Void in
                    //response nil if image cached
                    if imageResponse != nil{
                        print("image was not cached, fade in image")
                        self.movieImage.alpha = 0.0
                        self.movieImage.image = image
                        UIView.animateWithDuration(0.3, animations:{() -> Void in
                            self.movieImage.alpha = 1.0
                        })
                    }else{
                        print("Image was cached update image")
                        self.movieImage.image = image
                    }
                },
                failure:{(imageRequest, imageResponse, error)-> Void in
                    print("failed to load image")
                }
            )
            
        }

    }

    @IBAction func detailTap(sender: UITapGestureRecognizer) {
        self.performSegueWithIdentifier("fullScreenSeque", sender:self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     
        let destinationViewController = segue.destinationViewController as! FullScreenPhotoViewController
        destinationViewController.image = self.movieImage.image
              // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
