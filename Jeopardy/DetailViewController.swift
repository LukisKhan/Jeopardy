
import UIKit
import RealmSwift

class DetailViewController: UIViewController {

    let realm = try! Realm()
    var myClue: Clue!
    @IBOutlet var myQuestionView: UIView!
    @IBOutlet var myQuestion: UILabel!
    @IBOutlet var myAnswer: UILabel!
    @IBOutlet var myValue: UILabel!
    @IBOutlet var myAirdate: UILabel!
    @IBOutlet var created_at: UILabel!
    @IBOutlet var updated_at: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var myStar: UIImageView!
    
    @IBAction func answerButton(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.myAnswer.alpha = 1
            self.myValue.alpha = 1
            self.myAirdate.alpha = 1
            self.created_at.alpha = 1
            self.updated_at.alpha = 1
        }
        UIView.animate(withDuration: 0.45, animations:  {
            self.myQuestionView.transform3D =  CATransform3DRotate(CATransform3DIdentity, CGFloat(180 * Double.pi / 180.0), 0, 1, 0)
            self.myQuestionView.alpha = 0.0
            self.answerButton.alpha = 0.0
        }) { (_) in
            UIView.animate(withDuration: 0.05, animations: {
                self.myQuestionView.transform3D =  CATransform3DRotate(CATransform3DIdentity, CGFloat(180 * Double.pi / 180.0), 0, 0, 0)
                self.myQuestionView.alpha = 1.0
          })
        }

    }
    
    func setupTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.myStar.isUserInteractionEnabled = true
        self.myStar.addGestureRecognizer(gesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if myClue.isFavorite! {
            deleteClue(myClue: myClue)
            myStar.image = UIImage(systemName: "star")
        } else {
            saveClue(myClue: myClue)
            myStar.image = UIImage(systemName: "star.fill")
        }
    }
    
    func saveClue(myClue: Clue) {
        let newFavClue = FavoriteClue()
        newFavClue.id = myClue.id
        newFavClue.answer = myClue.answer
        newFavClue.question = myClue.question
        newFavClue.value = myClue.value ?? 0
        newFavClue.airdate = myClue.airdate ?? "Unknown"
        newFavClue.created_at = myClue.created_at ?? "Unknown"
        newFavClue.updated_at = myClue.updated_at ?? "Unknown"
        newFavClue.category_id = myClue.category_id ?? 0
        newFavClue.category = myClue.category.title
        try! realm.write{
            realm.add(newFavClue)
            print("saved clue")
        }
        myClue.isFavorite = true
    }
    
    func deleteClue(myClue: Clue) {
        let clueAnswer = myClue.answer
        let predicate = NSPredicate(format: "answer = %@", clueAnswer)
        let oldFavClue = realm.objects(FavoriteClue.self).filter(predicate)
        try! realm.write {
            print(oldFavClue)
            realm.delete(oldFavClue)
            print("deleting clue")
        }
        myClue.isFavorite = false
    }


    fileprivate func configureStar() {
        myStar.image = myClue.isFavorite ? UIImage(systemName: "star.fill")! : UIImage(systemName: "star")!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureStar()
        setupTapGesture()
        UIView.animate(withDuration: 0.1) {
            self.myAnswer.alpha = 0.0
            self.myValue.alpha = 0.0
            self.myAirdate.alpha = 0.0
            self.created_at.alpha = 0.0
            self.updated_at.alpha = 0.0
//            self.view.backgroundColor = .link
            UIView.animate(withDuration: 0.1, delay: 0.0, animations: {
                self.myQuestionView.transform3D =  CATransform3DRotate(CATransform3DIdentity, CGFloat(180 * Double.pi / 180.0), 0, 1, 0)
            })
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.myQuestionView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height/2 - self.myQuestionView.frame.size.height)
        })
        myQuestion.text = myClue.question.uppercased()
        myAnswer.text = "What is " + myClue.answer + "?"
        if let text = myClue.value {
            myValue.text = "Value: " + String(text)
        }
        if let text = myClue.airdate {
            myAirdate.text = "Airdate: " + text
        }
        if let text = myClue.created_at {
            created_at.text = "Created at: " + text
        }
        if let text = myClue.updated_at {
            updated_at.text = "Updated at: " + text
        }
    }

}
