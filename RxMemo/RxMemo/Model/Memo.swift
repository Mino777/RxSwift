//
//  Memo.swift
//  RxMemo
//
//  Created by MiDASHnT on 2021/03/29.
//

import Foundation
import RxDataSources
import RxCoreData
import CoreData

struct Memo: Equatable, IdentifiableType {
    var content: String
    var insertDate: Date
    var identity: String
    
    init(content: String, insertDate: Date = Date()) {
        self.content = content
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    init(original: Memo, updatedContent: String) {
        self = original
        self.content = updatedContent
    }
}

extension Memo: Persistable {
    public static var entityName: String {
        return "Memo"
    }
    
    static var primaryAttributeName: String {
        return "identity"
    }
    
    init(entity: NSManagedObject) {
        content = entity.value(forKey: "content") as! String
        insertDate = entity.value(forKey: "insertDate") as! Date
        identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(content, forKey: "content")
        entity.setValue(insertDate, forKey: "insertDate")
        entity.setValue("\(insertDate.timeIntervalSinceReferenceDate)", forKey: "identity")
        
        // save 메서드를 직접 호출해주어야 함. 그렇지 않으면 update한 내용이 사라질 수 도 있음.
        // 그러므로 Rx로 CoreData를 구현할 때는 이부분을 조심해줘야 함.
        do {
            try entity.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
}
