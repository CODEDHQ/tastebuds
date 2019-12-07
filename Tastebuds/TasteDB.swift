

import Foundation
import SQLite

    let users = Table("users")
    let id = Expression<Int64>("id")
    let username = Expression<String?>("username")
    let password = Expression<String>("password")
    
    let video = Table("video")
    let videoId = Expression<Int64>("videoId")
    let url = Expression<String?>("url")
    let catId = Expression<String?>("catId")
//    let userId = Expression<String>("userId")
    let voteCount = Expression<Int>("voteCount")

open class TasteDB {


    
    let sqlitedb = try? Connection(TasteDB.applicationDocumentsDirectory().appendingPathComponent("Taste.db").path)

     func createUsers() {

        try? sqlitedb?.run(users.create { t in
            t.column(id, primaryKey: true)
            t.column(username, unique: true)
            t.column(password)
        })
    }
    
      func createVideo() {

        try? sqlitedb?.run(video.create { t in
            t.column(id, primaryKey: true)
            t.column(catId)
            t.column(url, unique: true)
            t.column(username)
            t.column(voteCount)
        })
    }
    
    func insertUser(usernameValue: String, passwordValue: String) -> Bool {
        
        let insert = users.insert(username <- usernameValue, password <- passwordValue)
        
        do {
        let value = try sqlitedb?.run(insert)
            return value! > Int64(0)
        } catch {
            print(error)
        return false
        }

    }
    
    func insertVideo(urlValue: String, catIdValue: String) -> Bool {
        
        let insert = video.insert(url <- urlValue,
                                  catId <- catIdValue,
                                  username <- currentUser,
                                  voteCount <- 0 )
        
        do {
        try sqlitedb?.run(insert)
            return true
        } catch {
            print(error)
            return false
        }

    }
    
    func selectUser(usernameValue: String) -> Row? {
        
        do {
            guard let value = try sqlitedb?.prepare(users.where(username == usernameValue)) else { return nil }
            return Array(value).first
        } catch {
            return nil
        }
    }
    
    func validateUser(usernameValue: String, passwordValue: String) -> Bool {
        return Array(try! sqlitedb!.prepare(users.where(username == usernameValue && password == passwordValue))).count > 0
    }
    
    func selectVides(usernameValue: String) -> [Row]? {
        
        do {
            guard let value = try sqlitedb?.prepare(video.where(username == usernameValue).order(id.desc)) else { return nil }
            return Array(value)
        } catch {
            return nil
        }
    }
    
    func selectVides(catIdValue: String) -> [Row]? {
        
        do {
            guard let value = try sqlitedb?.prepare(video.where(catId == catIdValue).order(id.desc)) else { return nil }
            return Array(value)
        } catch {
            return nil
        }
    }

    func selectVideo(urlValue: String) -> Row? {
        
        do {
            guard let value = try sqlitedb?.prepare(video.where(url != urlValue).order(id.desc)) else { return nil }
            return Array(value).first
        } catch {
            return nil
        }
    }

    func updateVideoCounter(urlValue: String, voteCountValue: Int)  {
        
        do {
            
             try (sqlitedb?.prepare("UPDATE video SET voteCount = \(voteCountValue) WHERE url = '\(urlValue)'"))!
            
//            let row = selectVideo(urlValue: urlValue)
//            print(row?[voteCountValue])
            
//            let alice = users.filter(id == rowid)
//
//            try sqlitedb.run(users.update(username <- "email"))
//
//            try sqlitedb.run(users.update(voteCount <- voteCountValue))
//
//            let alice = video.filter(url == urlValue)
//            try sqlitedb.run(alice.update(voteCount <- voteCountValue))
//
//
//            guard let value = try sqlitedb?.prepare(video.where(url != urlValue).order(id.desc)) else { return nil }
//            return Array(value).first
        } catch {
            print(error)
            return
        }
    }
    
     func createDB() {
        
        createUsers()
        createVideo()
    }
    
    class func installIfNeeded() {
                
        let databaseUrl = applicationDocumentsDirectory().appendingPathComponent("Taste.db")
        
        if FileManager.default.fileExists(atPath: databaseUrl.path) {
            try? FileManager.default.removeItem(atPath: databaseUrl.path)
        }
        
        let sqlitedb = Foundation.Bundle.main.url(forResource: "Taste", withExtension: "db")!
        try? FileManager.default.copyItem(at: sqlitedb, to: databaseUrl)
    }
    
    // Returns the URL to the application's Documents directory.
    class func applicationDocumentsDirectory() -> URL {

        let documentURL = try? FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)

        return documentURL!
    }
    
    // Returns the URL to the application's Library directory.
    class func applicationLibraryDirectory() -> URL {
        
        let libraryURL = try? FileManager.default.url(for: FileManager.SearchPathDirectory.libraryDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        
        return libraryURL!
    }

     func databaseUrl() -> URL {
        return TasteDB.applicationDocumentsDirectory().appendingPathComponent("Taste.db")
    }

}
