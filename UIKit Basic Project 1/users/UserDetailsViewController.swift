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
    private var userDefaults = UserDefaults.standard
    
    
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
            self?.saveNote(noteText)
            
        }
        
        guard let userId = user?.id else {return}
        
        if userDefaults.bool(forKey: "\(userId)") {
            
            alert = UIAlertController(title: "Edit Note", message: "Edit existing Note...", preferredStyle: .alert)
            
            saveAction = UIAlertAction(title: "Edit", style: .default) { [weak self] action in
                let textField = alert.textFields?.first
                guard let noteText = textField?.text else {return}
                self?.saveNote(noteText)
            }
        }
        
        let cancelAction =  UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        alert.textFields?.first?.text = getNote()?.content
        present(alert, animated: true)
    }
    
    func saveNote(_ noteStr: String) {
        
        if noteStr == "" {return}
        
        guard let userId = user?.id else {return}
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: context) else {return}
        
        if userDefaults.bool(forKey: "\(userId)") {
            
            getNote()?.content = noteStr
            
        } else {
            let note = Note(entity: entity, insertInto: context)
            note.content = noteStr
            note.user_id = Int16(userId)
        }
        
        do {
            
            try context.save()
            self.note.text = noteStr
            userDefaults.setValue(true, forKey: "\(userId)")
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "pencil")
            
        } catch let error as NSError {
            print("could not save note! \(error)")
        }
        
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
        
        guard let currentUser = user else {return}
        
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
        
        guard let userId = user?.id else {return}
        if userDefaults.bool(forKey: "\(userId)") {
            let note = getNote()
            self.note.text = note?.value(forKeyPath: "content") as? String
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "pencil")
        }
    }
    
    private func getNote() -> Note? {
        
        do {
            guard let userId = user?.id else {return nil}
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
            
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "user_id == %@", NSNumber(value: Int16(userId)))
            
            let notes = try context.fetch(fetchRequest)
            return notes.first
            
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
}

