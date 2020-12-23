//
//  SQLite+Extension.swift
//  zhuishushenqi
//
//  Created by yung on 2018/8/11.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation
import SQLite

protocol DBSaveProtocol {
    func db_save()
}


extension NSObject {
    
    public func db_connect(_ path:String?){
        var db:Connection!
        if let dbPath = path {
            db = try? Connection(dbPath)
        } else {
            let dbPath = NSHomeDirectory()
            db = try? Connection("\(dbPath)/db.sqlite3")
        }
    }
    
    public func test(){
//        let db = try? Connection("path/to/db.sqlite3")
//
//        let users = Table("users")
//        let id = Expression<Int64>("id")
//        let name = Expression<String?>("name")
//        let email = Expression<String>("email")
//
//        try? db?.run(users.create { t in
//            t.column(id, primaryKey: true)
//            t.column(name)
//            t.column(email, unique: true)
//        })
//        // CREATE TABLE "users" (
//        //     "id" INTEGER PRIMARY KEY NOT NULL,
//        //     "name" TEXT,
//        //     "email" TEXT NOT NULL UNIQUE
//        // )
//
//        let insert = users.insert(name <- "Alice", email <- "alice@mac.com")
//        let rowid = try? db?.run(insert)
//        // INSERT INTO "users" ("name", "email") VALUES ('Alice', 'alice@mac.com')
//
//        for user in try? db?.prepare(users) {
//            print("id: \(user[id]), name: \(user[name]), email: \(user[email])")
//            // id: 1, name: Optional("Alice"), email: alice@mac.com
//        }
//        // SELECT * FROM "users"
//
//        let alice = users.filter(id == rowid)
//
//        try? db.run(alice.update(email <- email.replace("mac.com", with: "me.com")))
//        // UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
//        // WHERE ("id" = 1)
//
//        try? db?.run(alice.delete())
//        // DELETE FROM "users" WHERE ("id" = 1)
//
//        try? db?.scalar(users.count) // 0
//        // SELECT count(*) FROM "users"
    }
}

