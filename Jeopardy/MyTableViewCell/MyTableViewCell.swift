
import UIKit

class MyTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    static func nib() -> UINib {
        return UINib(nibName: "MyTableViewCell", bundle: nil)
    }
    static let identifier = "MyTableViewCell"

    @IBOutlet var collectionView: UICollectionView!
    
    var myClueDictionary: [String: [Clue]]!
    var myCategories: [String]!
    var delegate:MyCustomCellDelegator!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
// Header
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//            layout.itemSize = CGSize(width: 150, height: 150)
//        }
//        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: Setup collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myClueDictionary[myCategories[section]]!.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        let currentCategory = myCategories[indexPath.section]
        if indexPath.row == 0 {
            let currentString = myClueDictionary![currentCategory]![0].category.title
            cell.configure(with: currentString)
        } else {
            let currentClue = myClueDictionary![currentCategory]![indexPath.row - 1]
            cell.configure(with: currentClue)
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return myCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCategory = myCategories[indexPath.section]
        if indexPath.row == 0 { return }
        
        let myClue = myClueDictionary[currentCategory]![indexPath.row - 1]
        if(self.delegate != nil){
            self.delegate.callSegueFromCell(myData: myClue as AnyObject)
            
        }
    }
    
    
    // MARK: Setup layout of collection view cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 155, height: 155)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // MARK: Pass new info and reload data
    func configure(with clueDictionary: [String: [Clue]], and myCategories: [String]) {
        self.myClueDictionary = clueDictionary
        self.myCategories = myCategories
        collectionView.reloadData()
    }
    
    
// MARK: Header
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//       let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
//       header.configure()
//       return header
//   }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 1, height: 1)
//    }
    

}
