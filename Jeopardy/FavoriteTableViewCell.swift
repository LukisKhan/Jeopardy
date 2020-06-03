//
//  FavoriteTableViewCell.swift
//  Jeopardy
//
//  Created by Rave BizzDev on 6/3/20.
//  Copyright © 2020 Rave BizzDev. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteTableViewCell: UITableViewCell {


    @IBOutlet weak var myAnswer: UILabel!
    @IBOutlet weak var myStar: UIImageView!
    var myProp: String!
    var myFavClue: FavoriteClue!
    let realm = try! Realm()
    var reloadDelegate: ReloadDelegator!
    var unfavoriteDelegate: UnfavoriteDelegator!
    var myClueIndex = 0
    
    static let identifier = "FavoriteTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapGesture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(favClue: FavoriteClue) {
        myFavClue = favClue
    }
    
    func setupTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.myStar.isUserInteractionEnabled = true
        self.myStar.addGestureRecognizer(gesture)
    }
    
    @objc func handleTap() {
        deleteFavClue(myFavClue: myFavClue)
    }
    
    func deleteFavClue(myFavClue: FavoriteClue) {
         let clueAnswer = myFavClue.answer
         let predicate = NSPredicate(format: "answer = %@", clueAnswer)
         let oldFavClue = realm.objects(FavoriteClue.self).filter(predicate)
         try! realm.write {
             realm.delete(oldFavClue)
         }
        if self.reloadDelegate != nil {
            self.reloadDelegate.reloadTheData()
        }
        self.unfavoriteDelegate.unfavorite(clueIndex: myClueIndex)
     }

}
