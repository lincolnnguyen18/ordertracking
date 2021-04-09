//
//  SubmitInfoViewController.swift
//  ordertracking
//
//  Created by Lincoln Nguyen on 4/9/21.
//

import UIKit

class SubmitInfoViewController: UIViewController {
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var trackNumInput: UITextField!
    @IBOutlet weak var carrierInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 15
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController, let trackViewController = nav.topViewController as? TrackViewController {
            trackViewController.setTrackingNumAndCarrier(trackNumInput.text, carrierInput.text)
        }
    }
}
