//
//  MarkChoreCompleteViewController.swift
//  Home Chore Tracker
//
//  Created by Alex Shillingford on 2/6/20.
//  Copyright © 2020 HomeChoreTrackeriOSDevs. All rights reserved.
//

import UIKit

class MarkChoreCompleteViewController: UIViewController {
    
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var photoPreviewImageView: UIImageView!
    
    var assignedChore: ChoreRepresentation?
    
    let pickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerController.sourceType = UIImagePickerController.SourceType.camera
        pickerController.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPhotoOfChore(_ sender: UIButton) {
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func completeChore(_ sender: UIButton) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MarkChoreCompleteViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        photoPreviewImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("The camera has been closed")
    }
}

extension MarkChoreCompleteViewController: UINavigationControllerDelegate {
    
}
