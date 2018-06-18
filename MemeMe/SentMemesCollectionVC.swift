//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Phillip Valdez on 4/21/18.
//  Copyright © 2018 Phillip Valdez. All rights reserved.
//
import Foundation
import UIKit

class SentMemesCollectionVC: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

 
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()

    }
    
    //Collection View Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        // Set the image
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        
        //Populate view controller with data from the selected item
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)

    }



}
