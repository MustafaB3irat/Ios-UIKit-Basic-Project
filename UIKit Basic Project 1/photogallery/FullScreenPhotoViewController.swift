import UIKit

class FullScreenPhotoViewController: UIViewController {
    
    
    @IBOutlet weak var fullScreenImage: UIImageView!
    
    var imageURL: String?
    
    override func viewDidLoad() {
        fullScreenImage.sd_setImage(with: URL(string: imageURL ?? ""))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(imageSwipedDown(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        fullScreenImage.addGestureRecognizer(swipeDown)
    }
    
    @IBAction func dismissView(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imageSwipedDown(_ sender: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

