//
//  FeedCell.swift
//  instaclone
//
//  Created by Yigit Ozdamar on 14.08.2022.
//

import UIKit
import FirebaseFirestore

class FeedCell: UITableViewCell {

    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        let firebaseDB = Firestore.firestore()
        
        if let likeCount = Int(likeCountLabel.text!){
            let fireLikeStore = ["likes": likeCount + 1] as [String:Any]
            firebaseDB.collection("Posts").document(documentIdLabel.text!).setData(fireLikeStore, merge: true)
        }
        
        
        
    }
    
}
