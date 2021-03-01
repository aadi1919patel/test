

import Foundation
import SQLite3


class DBHelper
{
    
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "myDb2.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    
    
    
    
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS category(Id INTEGER PRIMARY KEY,title TEXT,category TEXT,Price TEXT, inStock INTEGER, imageCategory TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert( title:String, category:String,Price:String, inStock:Int, imageCategory : String)
    {
        let createTableString = "CREATE TABLE IF NOT EXISTS person(Id INTEGER PRIMARY KEY,title TEXT,category TEXT,Price TEXT, inStock INTEGER, imageCategory TEXT);"
       // let persons = read()
     
        let insertStatementString = "INSERT INTO category (title, category, Price, inStock,imageCategory) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
    
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (category as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (Price as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, Int32(inStock))
            sqlite3_bind_text(insertStatement, 5, (imageCategory as NSString).utf8String, -1, nil)
           
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func
    read() -> [Person] {
        let queryStatementString = "SELECT * FROM category;"
       // let queryStatementString = "SELECT * FROM category WHERE inStock = 1;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Person] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let title = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let category = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let price = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let inStock = sqlite3_column_int(queryStatement, 4)
                let imgLogo = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
               
               // let imgData =  String(describing: Blob(cString: sqlite3_column_blob(queryStatement, 5)))
              //  let imgData = sqlite3_column_blob(queryStatement, 5)
                //psns.append(Person(id: Int(id), name: name, age: Int(year)))
                psns.append(Person.init(title: title, category: category, Price: price, inStock: Int(inStock), imageCategory: imgLogo))
                print("Query Result:")
                print("\(id) | \(title) | \(price)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
