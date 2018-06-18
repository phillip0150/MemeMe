//
//  SentMemesTableVCViewController.swift
//  MemeMe
//
//  Created by Phillip Valdez on 4/21/18.
//  Copyright © 2018 Phillip Valdez. All rights reserved.
//

import UIKit

class SentMemesTableVC: UITableViewController {

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
        
    }

    //Collection View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        // Set the image
        cell.memeImageView?.image = meme.memedImage
        cell.memeILabel?.text = meme.topText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        
        //Populate view controller with data from the selected item
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    

}
