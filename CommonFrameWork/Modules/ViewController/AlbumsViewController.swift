//
//  AlbumViewController.swift
//  CommonFrameWork
//
//  Created by sayi on 2018/05/17.
//  Copyright © 2018年 sayi. All rights reserved.
//

import UIKit

class AlbumsViewController: UITableViewController,EditAlbumViewControllerDelegate {

    /// Segue fot the edit album.
    private static let SegueEditAlbum = "EditAlbum"
    
    /// Name for the cell.
    private static let CellIdentifier = "Cell"
    
    /// A value indicating that a new album should be created.
    private var creatingAlbum = false
    
    /*private var AlbumInfo = { timeline in
        
    }*/

    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Albums"
        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(didTouchCreateAlbumButton(sender:)))
        self.navigationItem.leftBarButtonItem  = button
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        //テスト
        // 呼び出し側
        /*ApiManager.instance.getArticles{ response in
            print(response)
        }*/
        let parameter:[String: Any] = ["page":"1", "per_page":"3"]
        
        ApiManager.instance.getArticle(parameter:parameter,success: {response in LogPrint.whLog(response)}){
            (error) in LogPrint.whLog(error.localizedDescription)
        }
        
    }
    
    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    ///
    /// - Parameter animated: If true, the disappearance of the view is being animated.
    override func viewWillAppear(_ animated: Bool) {
        self.setEditing(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    /// Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Notifies the view controller that a segue is about to be performed.
    ///
    /// - Parameters:
    ///   - segue: The segue object containing information about the view controllers involved in the segue.
    ///   - sender: The object that initiated the segue. You might use this parameter to perform different actions based on which control (or other object) initiated the segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AlbumsViewController.SegueEditAlbum {
            let vc  = segue.destination as! EditAlbumViewController
            vc.originalAlbum = self.creatingAlbum ? nil : self.albumAtIndexPath(indexPath: self.tableView.indexPathForSelectedRow!)
            vc.delegate     = self
        }
    }
    
    /// Occurs when editing or creation of a album is completed.
    ///
    /// - Parameters:
    ///   - viewController: Sender.
    ///   - album: album data.
    func didFinishEditAlbum(viewController: EditAlbumViewController,oldAlbum: AlbumMode?, newAlbum: AlbumMode) {
        let albumService   = self.albumService()
        var success = false;
        if (newAlbum.albumId == AlbumMode.AlbumIdNone) {
            success = albumService.add(album: newAlbum)
        } else {
            success = albumService.update(oldAlbum: oldAlbum!, newAlbum: newAlbum)
        }

        if success {
            self.tableView.reloadData()
        }
    }
    
    /// Occurs when the album creation button is touched.
    ///
    /// - Parameter sender: Target of the event.
    @objc func didTouchCreateAlbumButton(sender: Any?) {
        self.creatingAlbum = true
        self.performSegue(withIdentifier: AlbumsViewController.SegueEditAlbum, sender: self)
    }
    
    /// Asks the data source to return the number of sections in the table view.
    ///
    /// - Parameter tableView: An object representing the table view requesting this information.
    /// - Returns: The number of sections in tableView. The default value is 1.
    override func numberOfSections(in tableView: UITableView) -> Int {
        let albumDataService  = self.albumService()
        return albumDataService.authors.count
        //return 1;
    }
    
    /// Tells the data source to return the number of rows in a given section of a table view.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - section:   An index number identifying a section in tableView.
    /// - Returns: The number of rows in section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let albumDataService  = self.albumService()
        let author = albumDataService.authors[section]
        let albums  = albumDataService.albumsByAuthor[author]
        
        return (albums?.count)!
    }
    
    /// Asks the data source for the title of the header of the specified section of the table view.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object asking for the title.
    ///   - section:   An index number identifying a section of tableView.
    /// - Returns: A string to use as the title of the section header. If you return nil , the section will have no title.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let albumDataService  = self.albumService()
        return albumDataService.authors[section]
    }
    
    /// Asks the data source for a cell to insert in a particular location of the table view.
    ///
    /// - Parameters:
    ///   - tableView: A table-view object requesting the cell.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: AlbumsViewController.CellIdentifier, for: indexPath)
        //let label = cell.viewWithTag(1) as! UILabel
        let album  = self.albumAtIndexPath(indexPath: indexPath)
        cell.textLabel!.text = album.title
        //label.text = album.title
        
        return cell
    }
    
    /// Asks the data source to commit the insertion or deletion of a specified row in the receiver.
    ///
    /// - Parameters:
    ///   - tableView:    The table-view object requesting the insertion or deletion.
    ///   - editingStyle: The cell editing style corresponding to a insertion or deletion requested for the row specified by indexPath. Possible editing styles are UITableViewCellEditingStyleInsert or UITableViewCellEditingStyleDelete.
    ///   - indexPath:    An index path locating the row in tableView.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let albumDataService = self.albumService()
            let album  = self.albumAtIndexPath(indexPath: indexPath)
            if albumDataService.remove(album: album) {
                self.tableView.reloadData()
            }
        }
    }
    
    /// Tells the delegate that the specified row is now selected.
    ///
    /// - Parameters:
    ///   - tableView: A table-view object informing the delegate about the new row selection.
    ///   - indexPath: An index path locating the new selected row in tableView.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.creatingAlbum = false
        self.performSegue(withIdentifier: AlbumsViewController.SegueEditAlbum, sender: self)
    }
    
    /// Get the album at index path.
    ///
    /// - Parameter indexPath: An index path locating a row in tableView.
    /// - Returns: Album data.
    private func albumAtIndexPath(indexPath: IndexPath) -> AlbumMode {
        let albumDataService  = self.albumService()
        let author = albumDataService.authors[indexPath.section]
        let albums  = albumDataService.albumsByAuthor[author]
        
        return albums![indexPath.row]
    }
    
    /// Get the album service.
    ///
    /// - Returns: Instance of the album service.
    func albumService() -> AlbumDataService {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.albumDataService
    }


}

