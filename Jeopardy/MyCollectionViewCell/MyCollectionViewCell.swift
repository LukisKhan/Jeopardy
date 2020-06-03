
import UIKit


//class CollectionViewCell: UICollectionViewCell {
//
//    override var highlighted: Bool {
//        didSet {
//            self.contentView.backgroundColor = highlighted ? UIColor(white: 217.0/255.0, alpha: 1.0) : nil
//        }
//    }
//}

class MyCollectionViewCell: UICollectionViewCell {

    static let identifier = "MyCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet var myLabel: UILabel!
    var myClue: Clue!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with clue: Clue) {
        myClue = clue
        if let myValue = myClue.value {
            self.myLabel.text = "$" + String(myValue)
            myLabel.font = UIFont(name: "Futura", size: 46)
        } else {
            self.myLabel.text = String(0)
        }
    }
    
    func configure(with string: String) {
        self.myLabel.text = string.uppercased()
        myLabel.textColor = .white
        myLabel.font = UIFont(name: "Futura", size: 26)
    }
    
}
