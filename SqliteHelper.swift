//
//  SqliteHelper.swift
//  Flick
//
//  Created by JohnMajor on 8/10/15.
//  Copyright (c) 2015 JohnMajor. All rights reserved.
//

import Foundation

class SqliteHelper {
    
    var favPhotoDB: COpaquePointer = nil
    
    var insertStatement: COpaquePointer = nil
    var selectStatement: COpaquePointer = nil
    var updateStatement: COpaquePointer = nil
    var deleteStatement: COpaquePointer = nil
    var deleteAll: COpaquePointer = nil//need to comment
    var selectAllStatement: COpaquePointer = nil
    var insertComment: COpaquePointer = nil
    var selComment: COpaquePointer = nil
    var udComment: COpaquePointer = nil
    var delComment: COpaquePointer = nil
    var selectAllComment: COpaquePointer = nil
    var findAllComment: COpaquePointer = nil
    var deleteAllComment: COpaquePointer = nil//need to comment
    var selectFavname: COpaquePointer = nil
    
    var titleList = [String]()
    var urltitle:String!
    var commentList = [String]()
    //func crateDatabase()
    func crateDatabase() {
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var docsDir = paths.stringByAppendingPathComponent("FavPhotos.sqlite")
        
        if (sqlite3_open(docsDir, &favPhotoDB) == SQLITE_OK ) {
            
            var sql = "CREATE TABLE IF NOT EXISTS FAVPHOTOS (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, URL TEXT, COMMENT TEXT, SIZE TEXT)"
            var statement:COpaquePointer = nil
            
            if (sqlite3_exec(favPhotoDB, sql, nil, nil, nil) != SQLITE_OK) {
                println("Faile to create table")
                println(sqlite3_errmsg(favPhotoDB))
            }
        }
        else {
            println("Failed to open database")
            println(sqlite3_errmsg(favPhotoDB))
        }
        //prepareStatement()
        prepareStatement()
    }
    
    
    //func prepareStatement()
    func prepareStatement() {
        
        var sqlString: String
        
        //FAVPHOTOS TABLE
        sqlString = "INSERT INTO FAVPHOTOS (title, url, comment, size) VALUES (?, ?, ?, ?)"
        var cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(favPhotoDB, cSql!, -1, &insertStatement, nil)
        
        sqlString = "SELECT title, comment, size FROM FAVPHOTOS WHERE url = ?"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(favPhotoDB, cSql!, -1, &selectStatement, nil)
        
        sqlString = "SELECT title FROM FAVPHOTOS WHERE url = ?"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(favPhotoDB, cSql!, -1, &selectFavname, nil)
        
        sqlString = "UPDATE FAVPHOTOS SET title = ?, comment = ?, size = ? WHERE url = ?"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(favPhotoDB, cSql!, -1, &updateStatement, nil)
        
        sqlString = "DELETE FROM FAVPHOTOS WHERE url = ?"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(favPhotoDB, cSql!, -1, &deleteStatement, nil)
        
        sqlString = "SELECT title, url, comment FROM FAVPHOTOS"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare(favPhotoDB, cSql!, -1, &selectAllStatement, nil)
        
        //delete all statement //need to comment
        sqlString = "DELETE FROM FAVPHOTOS"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare(favPhotoDB, cSql!, -1, &deleteAll, nil)
        
//-------------------------------COMMENTS TABLE------------------------------------------------------------
        
        sqlString = "INSERT INTO COMMENTS (url, comment) VALUES (?, ?)"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(favPhotoDB, cSql!, -1, &insertComment, nil)
        
        sqlString = "SELECT url, comment FROM COMMENTS WHERE id = ?"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(favPhotoDB, cSql!, -1, &selComment, nil)
        
        sqlString = "UPDATE COMMENTS SET url = ?, comment = ? WHERE id = ?"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(favPhotoDB, cSql!, -1, &udComment, nil)
        
        sqlString = "DELETE FROM COMMENTS WHERE id = ?"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(favPhotoDB, cSql!, -1, &delComment, nil)
        
        sqlString = "SELECT url, comment FROM COMMENTS"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare(favPhotoDB, cSql!, -1, &selectAllComment, nil)
        
        sqlString = "SELECT comment FROM COMMENTS WHERE url = ?"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare(favPhotoDB, cSql!, -1, &findAllComment, nil)
        
        //delete all statement //need to comment
        sqlString = "DELETE FROM COMMENTS"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare(favPhotoDB, cSql!, -1, &deleteAllComment, nil)
    }
    
    //need to comment
    func deleteAllRows() {
        sqlite3_step(deleteAll)
    }
    
    func deleteAllCommentRows(){
        sqlite3_step(deleteAllComment)
    }
    
    
    func createFavPhoto(title:String, url:String, comment:String, size:String){

        var titletext = (title as NSString).UTF8String
        var urltext = (url as NSString).UTF8String
        var commenttext = (comment as NSString).UTF8String
        var sizetext = (size as NSString).UTF8String
        sqlite3_bind_text(insertStatement, 1, titletext, -1, nil)
        sqlite3_bind_text(insertStatement, 2, urltext, -1, nil)
        sqlite3_bind_text(insertStatement, 3, commenttext, -1, nil)
        sqlite3_bind_text(insertStatement, 4, sizetext, -1, nil)

        
        if (sqlite3_step(insertStatement) == SQLITE_DONE)
        {
            var urlList = [String]()
            urlList = selectAllFavPhotos()
            println("INSIDE Create ==========\(urlList)")
        }
        else
        {
            
            println("Error Code: ", sqlite3_errcode(favPhotoDB))
            let error = String.fromCString(sqlite3_errmsg(favPhotoDB))
            println("Error Msg: ",error)
        }
        sqlite3_reset(insertStatement)
        sqlite3_clear_bindings(insertStatement)
    }
    
    func findFavPhoto(url:String) -> NSDictionary {
        var result:AnyObject = NSDictionary()
        sqlite3_bind_text(selectStatement, 1, url, -1, nil)
        
        if (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            
            let title_buf =  sqlite3_column_text(selectStatement, 0)
            let comment_buf = sqlite3_column_text(selectStatement, 1)
            let size_buf = sqlite3_column_text(selectStatement, 2)
            urltitle = String.fromCString(UnsafePointer<CChar>(title_buf))!
            result = ["Title": String.fromCString(UnsafePointer<CChar>(title_buf))!,
                      "Comment": String.fromCString(UnsafePointer<CChar>(comment_buf))!,
                      "Size": String.fromCString(UnsafePointer<CChar>(size_buf))!]
        }
        else{
            println("Error code: ", sqlite3_errcode(favPhotoDB))
            let error = String.fromCString(sqlite3_errmsg(favPhotoDB))
            println("Error msg: ", error)
            
        }
        sqlite3_reset(selectStatement)
        sqlite3_clear_bindings(selectStatement)
        return result as! NSDictionary
    }
    
    func selectNameFav (url: String) -> String {
        var urltext = (url as NSString).UTF8String
        var text:String = ""
        sqlite3_bind_text(selectFavname, 1, urltext, -1, nil)
        if (sqlite3_step(selectFavname) == SQLITE_ROW ) {
            let title_buf =  sqlite3_column_text(selectFavname, 0)
            text = String.fromCString(UnsafePointer<CChar>(title_buf))!
        }else{
            println("Error code: ", sqlite3_errcode(favPhotoDB))
            let error = String.fromCString(sqlite3_errmsg(favPhotoDB))
            println("Error msg: ", error)
            
        }
        sqlite3_reset(selectFavname)
        sqlite3_clear_bindings(selectFavname)
        return text
    }

    func updateFavPhoto(title:String, url:String, comment:String, size:String){
        
        sqlite3_bind_text(updateStatement, 1, title, -1, nil)
        sqlite3_bind_text(updateStatement, 2, comment, -1, nil)
        sqlite3_bind_text(updateStatement, 3, size, -1, nil)
        sqlite3_bind_text(updateStatement, 4, url, -1, nil)

        
        if (sqlite3_step(updateStatement) == SQLITE_DONE )
        {
            selectAllFavPhotos()
        }
        else {
            
            println("Error Code: ", sqlite3_errcode(favPhotoDB))
            let error = String.fromCString(sqlite3_errmsg(favPhotoDB))
            println("Error Msg: ",error)
            
        }
        
        sqlite3_reset(updateStatement)
        sqlite3_clear_bindings(updateStatement)
    }
    
    
    func selectAllFavPhotos() -> [String]   {
        sqlite3_reset(selectAllStatement)
        sqlite3_clear_bindings(selectAllStatement)
        var urlList = [String]()
        //commentList.removeAll(keepCapacity: false)
        while(sqlite3_step(selectAllStatement) == SQLITE_ROW){
            let title_buf = sqlite3_column_text(selectAllStatement,0)
            let url_buf =  sqlite3_column_text(selectAllStatement, 1)
            let comment_buf = sqlite3_column_text(selectAllStatement, 2)
            titleList.append(String.fromCString(UnsafePointer<CChar>(title_buf))!)
            urlList.append(String.fromCString(UnsafePointer<CChar>(url_buf))!)
            //commentList.append(String.fromCString(UnsafePointer<CChar>(comment_buf))!)
        }
        return urlList
    }
    
    func deletFavPhoto(url:String) {
        
        sqlite3_bind_text(deleteStatement, 1, url, -1, nil)
        
        if (sqlite3_step(deleteStatement) == SQLITE_DONE)
        {
            selectAllFavPhotos()
        }
        else
        {
            println("Error Code: ", sqlite3_errcode(favPhotoDB))
            let error = String.fromCString(sqlite3_errmsg(favPhotoDB))
            println("Error Msg: ",error)
            
        }
        sqlite3_reset(deleteStatement)
        sqlite3_clear_bindings(deleteStatement)
    }
//-------------------------------COMMENTS TABLE------------------------------------------------------------
    func createCommentTable() {
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var docsDir = paths.stringByAppendingPathComponent("FavPhotos.sqlite")
        
        if (sqlite3_open(docsDir, &favPhotoDB) == SQLITE_OK ) {
            
            var sql = "CREATE TABLE IF NOT EXISTS COMMENTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, URL TEXT, COMMENT TEXT)"
            var statement:COpaquePointer = nil
            
            if (sqlite3_exec(favPhotoDB, sql, nil, nil, nil) != SQLITE_OK) {
                println("Faile to create table")
                println(sqlite3_errmsg(favPhotoDB))
            }
        }
        else {
            println("Failed to open database")
            println(sqlite3_errmsg(favPhotoDB))
        }
        //prepareStatement()
        prepareStatement()
    }
    
    func insertComment(url:String, comment:String){
        
        var urltext = (url as NSString).UTF8String
        var commenttext = (comment as NSString).UTF8String
        
        sqlite3_bind_text(insertComment, 1, urltext, -1, nil)
        sqlite3_bind_text(insertComment, 2, commenttext, -1, nil)
        
        if (sqlite3_step(insertComment) == SQLITE_DONE)
        {
            var comments:[String] = [String]()
            comments = findAllCommentByURL(url)
            println("Insert successful \(comments)")
        }
        else
        {
            println("INSERT")
            println("\(sqlite3_step(insertComment))")
            println("Error Code: ", sqlite3_errcode(favPhotoDB))
            let error = String.fromCString(sqlite3_errmsg(favPhotoDB))
            println("Error Msg: ",error)
        }
        sqlite3_reset(insertComment)
        sqlite3_clear_bindings(insertComment)
    }
    
    func findComment(id:String) -> NSDictionary {
        var result:AnyObject = NSDictionary()
        sqlite3_bind_text(selComment, 1, id, -1, nil)
        
        if (sqlite3_step(selComment) == SQLITE_ROW) {
            
            let url_buf = sqlite3_column_text(selComment, 0)
            let comment_buf = sqlite3_column_text(selComment, 1)
            
            result = ["URL": String.fromCString(UnsafePointer<CChar>(url_buf))!,
                "Comment": String.fromCString(UnsafePointer<CChar>(comment_buf))!]
        }
        else{
            println("Error code: ", sqlite3_errcode(favPhotoDB))
            let error = String.fromCString(sqlite3_errmsg(favPhotoDB))
            println("Error msg: ", error)
            
        }
        sqlite3_reset(selComment)
        sqlite3_clear_bindings(selComment)
        return result as! NSDictionary
    }
    
    func findAllCommentByURL(url:String) -> [String] {
        
        sqlite3_reset(findAllComment)
        sqlite3_clear_bindings(findAllComment)
        
        var urlstr = (url as NSString).UTF8String
        sqlite3_bind_text(findAllComment, 1, urlstr, -1, nil)
        var allcomment:[String] = [String]()
        
        while (sqlite3_step(findAllComment) == SQLITE_ROW) {
            let comment_buf = sqlite3_column_text(findAllComment, 0)
            allcomment.append(String.fromCString(UnsafePointer<CChar>(comment_buf))!)
            println("inside while loop \(allcomment)")
        }
        println("ERR CODE \(sqlite3_errcode(favPhotoDB)) and ERR MSG \(sqlite3_errmsg(favPhotoDB)))")
        return allcomment
    }
    
    func updateComment(url:String, comment:String, id:String){
        
        sqlite3_bind_text(udComment, 1, url, -1, nil)
        sqlite3_bind_text(udComment, 2, comment, -1, nil)
        sqlite3_bind_text(udComment, 3, id, -1, nil)
        
        
        if (sqlite3_step(udComment) == SQLITE_DONE )
        {
            var comments:[String] = [String]()
            comments = selectAllComments()
            println("Insert successful \(comments)")
        }
        else {
            println("update")
            println("Error Code: ", sqlite3_errcode(favPhotoDB))
            let error = String.fromCString(sqlite3_errmsg(favPhotoDB))
            println("Error Msg: ",error)
            
        }
        
        sqlite3_reset(udComment)
        sqlite3_clear_bindings(udComment)
    }
    
    
    func selectAllComments() -> [String]   {
        
        sqlite3_reset(selectAllComment)
        sqlite3_clear_bindings(selectAllComment)
        
        var comList:[String] = [String]()
        while(sqlite3_step(selectAllComment) == SQLITE_ROW){
            let url_buf =  sqlite3_column_text(selectAllComment, 0)
            let comment_buf = sqlite3_column_text(selectAllComment, 1)
            comList.append(String.fromCString(UnsafePointer<CChar>(comment_buf))!)
        }
        return comList
    }
    
    func deleteComment(id:String) {
        
        sqlite3_bind_text(delComment, 1, id, -1, nil)
        
        if (sqlite3_step(delComment) == SQLITE_DONE)
        {
            selectAllFavPhotos()
        }
        else
        {
            println("delete")
            println("Error Code: ", sqlite3_errcode(favPhotoDB))
            let error = String.fromCString(sqlite3_errmsg(favPhotoDB))
            println("Error Msg: ",error)
            
        }
        sqlite3_reset(delComment)
        sqlite3_clear_bindings(delComment)
    }

}