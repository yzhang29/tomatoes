//
//  MovieDetailViewController.swift
//  tomatoes
//
//  Created by Yuan Zhang on 9/15/14.
//  Copyright (c) 2014 Yuan Zhang. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var imageString:String?
    var titleString:String?
    var detailString:String?
    @IBOutlet weak var movieDetailImageView: UIImageView!
    @IBOutlet weak var movieDetails: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(imageString != nil){
            self.movieDetailImageView.setImageWithURL(NSURL(string:imageString!))
        }
        if(titleString != nil){
            self.movieTitle.text = titleString!
        }
        if(detailString != nil){
            self.movieDetails.text = detailString!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swipeDown(sender: AnyObject) {
        UIView.animateWithDuration(2, animations: {
            self.movieView.frame.origin.y = 350
        })
    }

    @IBAction func swipeUp(sender: AnyObject) {
        UIView.animateWithDuration(2, animations: {
            self.movieView.frame.origin.y = 100
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
