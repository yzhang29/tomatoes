//
//  MovieViewController.swift
//  tomatoes
//
//  Created by Yuan Zhang on 9/14/14.
//  Copyright (c) 2014 Yuan Zhang. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var movies:[NSDictionary] = []
    var refreshControl:UIRefreshControl!
    var hasNetwork = true
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var progressView: M13ProgressViewRing!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.hidden = false
        self.progressView.indeterminate = true
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock{(status: AFNetworkReachabilityStatus?)          in
            if(status == AFNetworkReachabilityStatus.NotReachable ){
                self.networkErrorView.hidden = false
                self.hasNetwork = false
            }
        }
        if(self.hasNetwork){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.hidden = true
        var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us"
        var request = NSURLRequest(URL: NSURL(string:url))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            if(data == nil){
                self.networkErrorView.hidden = false
            }
            else{
            var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            self.movies = object["movies"] as [NSDictionary]
            self.tableView.reloadData()
            self.tableView.hidden = false
            }
            self.progressView.hidden = true
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        }
    }
    
    func refresh(sender:AnyObject)
    {
        self.refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        var movie = movies[indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"]as? String
        var posters = movie["posters"] as NSDictionary
        var posterUrl = posters["thumbnail"] as String
        cell.posterView.setImageWithURL(NSURL(string:posterUrl))
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.destinationViewController.isKindOfClass(MovieDetailViewController)) {
            var movieDetailsController:MovieDetailViewController = segue.destinationViewController as MovieDetailViewController;
            var indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            var movie = movies[indexPath.row]
            var images = movie["posters"] as NSDictionary
            var thumbnailUrl = images["thumbnail"] as String
            var detailUrl = thumbnailUrl.stringByReplacingOccurrencesOfString("tmb", withString: "org", options: NSStringCompareOptions.LiteralSearch, range: nil)
            movieDetailsController.imageString = detailUrl
            movieDetailsController.titleString = movie["title"] as? String
            movieDetailsController.detailString = movie["synopsis"] as? String

        }
    }

}
