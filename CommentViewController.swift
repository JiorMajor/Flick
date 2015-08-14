//
//  CommentViewController.swift
//  Flick
//
//  Created by JohnMajor on 8/12/15.
//  Copyright (c) 2015 JohnMajor. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var id:Int = 0
    var givenURL:String!
    var Sqlite:SqliteHelper = SqliteHelper()
    var commentList = [String]()
    var foundURL:String!
    
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        commentTextField.delegate = self
        Sqlite.createCommentTable()
        if givenURL != nil {
            commentList = Sqlite.findAllCommentByURL(givenURL)
            println("view did load \(commentList.count)")
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        Sqlite.createCommentTable()
        if givenURL != nil {
            commentList = Sqlite.findAllCommentByURL(givenURL)
            println("view did appear \(commentList.count)")
        }
        self.tableView.reloadData()
    }


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentCollectionViewCell
        cell.textLabel?.text = commentList[indexPath.row] as String
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if commentList.count > 1 {
            commentList.removeAtIndex(indexPath.item)
            Sqlite.deleteComment(toString(indexPath.item))
            println(Sqlite.deleteComment(toString(indexPath.item)))
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        commentTextField.text = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text
        id = indexPath.item
        tableView.reloadData()
    }

    @IBAction func addComment(sender: AnyObject) {
        
            let comment:String = commentTextField.text
            var url:String = givenURL
            Sqlite.insertComment(url, comment: comment)
            commentList = Sqlite.findAllCommentByURL(givenURL)
            println("givenURL \(givenURL)")
            println("addcomment \(commentList)")
            commentTextField.text = ""
            self.tableView.reloadData()

    }
    
}
