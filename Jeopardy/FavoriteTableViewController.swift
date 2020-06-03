//
//  FavoriteTableViewController.swift
//  Jeopardy
//
//  Created by Rave BizzDev on 6/3/20.
//  Copyright © 2020 Rave BizzDev. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteTableViewController: UITableViewController, ReloadDelegator {

    let realm = try! Realm()
    var myFavoriteClues = [Any]()
    @IBOutlet var table: UITableView!
    var myCurrentFavClue: FavoriteClue!
    var myClues = [Clue]()
    var unfavoriteDelegate: UnfavoriteDelegator!
    
    static let identifier = "FavoriteTableViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        myFavoriteClues = realm.objects(FavoriteClue.self).map({$0})
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFavoriteClues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as! FavoriteTableViewCell
        let myFavClue = myFavoriteClues[indexPath.row] as! FavoriteClue
        cell.myStar.image = UIImage(systemName: "star.fill")
        cell.myAnswer.text = myFavClue.question
        cell.configure(favClue: myFavClue)
        cell.reloadDelegate = self
        cell.unfavoriteDelegate = self.unfavoriteDelegate
        cell.myClueIndex = myClues.firstIndex(where: {$0.answer == cell.myFavClue.answer})!
        return cell
    }
    
    func reloadTheData() {
        myFavoriteClues = realm.objects(FavoriteClue.self).map({$0})
        table.reloadData()
    }
    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        myCurrentFavClue = myFavoriteClues[indexPath.row] as? FavoriteClue
//    }
    
//    func deleteFavClue(myFavClue: FavoriteClue) {
//         let clueAnswer = myFavClue.answer
//         let predicate = NSPredicate(format: "answer = %@", clueAnswer)
//         let oldFavClue = realm.objects(FavoriteClue.self).filter(predicate)
//         try! realm.write {
//             realm.delete(oldFavClue)
//             print("deleting clue")
//         }
//     }
//
//     @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        deleteFavClue(myFavClue: myCurrentFavClue)
//        table.reloadData()
//     }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


protocol ReloadDelegator {
    func reloadTheData()
}

