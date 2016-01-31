//
//  FullScreenPhotoViewController.swift
//  Flicks
//
//  Created by Labuser on 1/31/16.
//  Copyright © 2016 David Ayeke. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController {
    var image: UIImage?
    @IBOutlet weak var movieImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        movieImage.image = self.image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
