//
//  DetailVC.swift
//  MemeMe
//
//  Created by Phillip Valdez on 5/3/18.
//  Copyright © 2018 Phillip Valdez. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.memeDetailImageView.image = meme.memedImage
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
}
