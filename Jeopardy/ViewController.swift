import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyCustomCellDelegator, UnfavoriteDelegator {
    
    func unfavorite(clueIndex: Int) {
        print("unfavoriting \(clueIndex)")
        myClues[clueIndex].isFavorite = false
    }
    

    let theURL = "http://jservice.io/api/clues"
    var myClues = [Clue]()
    var myCluesDictionary = [String: [Clue]]()
    var myCategories: [String] = []
    var myFavoriteClues = [Clue]()
    
    let realm = try! Realm()
    
    @IBOutlet var table: UITableView!
    
    @IBAction func tapShowFavorites(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: FavoriteTableViewController.identifier) as! FavoriteTableViewController
        vc.myClues = myClues
        vc.unfavoriteDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .black
        loadClues()
    }

    func loadClues() {
        let myURL = URL(string: theURL)!
        URLSession.shared.dataTask(with: myURL) { (data, response, error) in
            do {
                let clues = try JSONDecoder().decode([Clue].self, from: data!)
                self.myClues = clues
                DispatchQueue.main.async {
                    self.organizeClues()
                    self.table.reloadData()
                }
            }
            catch {
                print("There was an error with downloading the data")
            }
        }.resume()
    }
    
    
    // MARK: Organize the clues into categories and their dictionary [Category: [ClueArray]]
    func organizeClues() {
        for clue in self.myClues {
            clue.isFavorite = false
            if myCluesDictionary[clue.category.title] != nil {
                myCluesDictionary[clue.category.title]!.append(clue)
            } else {
                myCluesDictionary[clue.category.title] = [clue]
            }
        }
        myCategories = myCluesDictionary.keys.map({$0})
    }
    
    
    // MARK: Set up Table items
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier, for: indexPath) as! MyTableViewCell
        cell.configure(with: myCluesDictionary, and: myCategories)
        //Use delegate to call segue
        cell.delegate = self
        return cell
    }
    
    func callSegueFromCell(myData dataobject: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        vc.myClue = dataobject as? Clue
//        navigationController?.present(vc, animated: true, completion: nil)
        self.performSegue(withIdentifier: "showDetails", sender:dataobject )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let vc = segue.destination as! DetailViewController
            vc.myClue = sender! as? Clue
        }
    }
    
    
    // MARK: Set up Table Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
}

protocol MyCustomCellDelegator {
    func callSegueFromCell(myData dataobject: AnyObject)
}


class Clue: Codable {
    var id: Int
    var answer: String
    var question: String
    var value: Int?
    var airdate: String?
    var created_at: String?
    var updated_at: String?
    var category_id: Int?
    var category: Category
    var isFavorite: Bool!
}

struct Category: Codable {
    var id: Int
    var title: String
    var clues_count: Int
}

class FavoriteClue: Object {
    @objc dynamic var id = 0
    @objc dynamic var answer = "Unknown"
    @objc dynamic var question = "Unknown"
    @objc dynamic var value = 0
    @objc dynamic var airdate = "Unknown"
    @objc dynamic var created_at = "Unknown"
    @objc dynamic var updated_at = "Unknown"
    @objc dynamic var category_id = 0
    @objc dynamic var category = "Unknown"
}

protocol UnfavoriteDelegator {
    func unfavorite(clueIndex: Int)
}
