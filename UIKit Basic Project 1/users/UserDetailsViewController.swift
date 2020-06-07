import  UIKit
import  MessageUI
import  MapKit
import CoreData

class UserDetailsViewController: UIViewController, MFMailComposeViewControllerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    var user: User?
    
    
    private var mailComposer = MFMailComposeViewController() {
        didSet {
            mailComposer.mailComposeDelegate = self
        }
    }
    private lazy var userDetailsViewModel = UserDetailsViewModel(user: user)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUserData()
        initUserNote()
    }
    
    
    @IBAction func sendEmail(_ Sender: UILabel) {
        if MFMailComposeViewController.canSendMail(), let recipent = email.text {
            mailComposer.setToRecipients([recipent])
            self.present(mailComposer, animated: true, completion: nil)
        }
    }
    
    @IBAction func dialUpPhone(_ sender: UILabel) {
        
        guard let phoneNo = phone.text?.components(separatedBy: " ")[0] else {return}
        guard let url = URL(string: "tel:\(phoneNo)") else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    @IBAction func openUserWebsite(_ Sender: UILabel) {
        guard let website = user?.website else {return}
        guard let url = URL(string: website) else {return}
        UIApplication.shared.open(url)
    }
    
    @IBAction func saveNoteBarBtnTapped(_ Sender: UIBarButtonItem) {
        
        var alert = UIAlertController(title: "New Note", message: "Add a new Note...", preferredStyle: .alert)
        var saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            
            let textField = alert.textFields?.first
            guard let noteText = textField?.text else {return}
            self?.userDetailsViewModel.saveNote(noteText: noteText) { sucess in
                if sucess {
                    self?.note.text = noteText
                }
            }
            
        }
        
        if userDetailsViewModel.noteExist() {
            
            alert = UIAlertController(title: "Edit Note", message: "Edit existing Note...", preferredStyle: .alert)
            
            saveAction = UIAlertAction(title: "Edit", style: .default) { [weak self] action in
                let textField = alert.textFields?.first
                guard let noteText = textField?.text else {return}
                self?.userDetailsViewModel.saveNote(noteText: noteText) { sucess in
                    if sucess {
                        self?.note.text = noteText
                    }
                }
            }
        }
        
        let cancelAction =  UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        alert.textFields?.first?.text = userDetailsViewModel.getNote()?.content
        present(alert, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    private func initUserLocation() {
        
        guard let lat = user?.address.geo.lat else {return}
        guard let lng = user?.address.geo.lng else {return}
        guard let latDegrees = CLLocationDegrees(lat) else {return}
        guard let lngDegrees =  CLLocationDegrees(lng) else {return}
        let coordiantes = CLLocationCoordinate2D(latitude: latDegrees, longitude: lngDegrees)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordiantes
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
    }
    
    
    private func initUserData() {
        
        guard let currentUser = userDetailsViewModel.user else {return}
        
        username.text = currentUser.username
        fullName.text = currentUser.name
        email.text = currentUser.email
        phone.text = currentUser.phone
        website.text = currentUser.website
        companyName.text = currentUser.company.name
        city.text = currentUser.address.city
        
        initUserLocation()
    }
    
    
    private func initUserNote() {
        if userDetailsViewModel.noteExist() {
            let note = userDetailsViewModel.getNote()
            self.note.text = note?.content
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "pencil")
        }
    }
}
