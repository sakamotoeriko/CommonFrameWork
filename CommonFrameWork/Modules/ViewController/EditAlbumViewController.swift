//
//  EditAlbumViewController.swift
//  CommonFrameWork
//
//  Created by sayi on 2018/05/20.
//  Copyright © 2018年 sayi. All rights reserved.
//

import Foundation
import UIKit

/// Notify the editing status of the album.
protocol EditAlbumViewControllerDelegate : class {
    /// Occurs when editing or creation of a album is completed.
    ///
    /// - Parameters:
    ///   - viewController: Sender.
    ///   - album:        album data.
    func didFinishEditAlbum(viewController: EditAlbumViewController, oldAlbum: AlbumMode?, newAlbum: AlbumMode) -> Void
}

/// Edit or create a album.
class EditAlbumViewController: UIViewController, UINavigationBarDelegate, UITextFieldDelegate {
    /// Albums to edit, if it is created nil.
    weak var originalAlbum: AlbumMode?
    
    /// Notify the editing status of the album.
    weak var delegate: EditAlbumViewControllerDelegate?
    
    /// TextField to the edit of author.
    @IBOutlet weak var authorTextField: UITextField!
    
    /// TextField to the edit of title.
    @IBOutlet weak var titleTextField: UITextField!
    
    /// DatePicker to the edit of release date.
    @IBOutlet weak var createDatePicker: UIDatePicker!
    
    /// Button to complete editing.
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authorTextField.delegate = self
        self.titleTextField.delegate  = self
        
        if (self.originalAlbum != nil) {
            self.authorTextField.text   = self.originalAlbum?.author
            self.titleTextField.text    = self.originalAlbum?.title
            self.createDatePicker.date = (self.originalAlbum?.createDate)!
        } else {
            self.authorTextField.text = "Sample Author"
            self.titleTextField.text  = "Sample Title"
        }
    }
    
    /// Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Asks the delegate for the position of the specified bar in its new window.
    ///
    /// - Parameter bar: The bar that was added to the window.
    /// - Returns: The position of the bar.
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    /// Asks the delegate if the text field should process the pressing of the return button.
    ///
    /// - Parameter textField: The text field whose return button was pressed.
    /// - Returns: true if the text field should implement its default behavior for the return button; otherwise, false.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// Cancel the editing.
    ///
    /// - Parameter sender: Event target.
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Complete the editing.
    ///
    /// - Parameter sender: Event target.
    @IBAction func done(_ sender: Any) {
        let newAlbum = AlbumMode(albumId: (self.originalAlbum != nil) ? self.originalAlbum!.albumId : AlbumMode.AlbumIdNone,
                           author: self.authorTextField.text!,
                           title: self.titleTextField.text!,
                           createDate: self.createDatePicker.date)
        self.delegate?.didFinishEditAlbum(viewController: self, oldAlbum: self.originalAlbum, newAlbum: newAlbum)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    /// Occurs when the TextField to the author is edited.
    ///
    /// - Parameter sender: Event target.
    @IBAction func didEditingChangedAuthorTextField(_ sender: Any) {
        self.updateDoneButton()
    }
    
    /// Occurs when the TextField to the title is edited.
    ///
    /// - Parameter sender: Event target.
    @IBAction func didEditingChangedTitleTextField(_ sender: Any) {
        self.updateDoneButton()
    }
    
    /// Update the done button.
    func updateDoneButton() -> Void {
        self.doneButton.isEnabled = ( self.authorTextField.text != "" && self.titleTextField.text != "" )
    }
}
