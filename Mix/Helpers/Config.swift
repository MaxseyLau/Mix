//
//  Config.swift
//  Mix
//
//  Created by Maxwell on 25/08/2017.
//  Copyright © 2017 Maxsey Inc. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import SwiftyWeibo
import SwiftyJSON

public class Config: Object {
    
    public static let appGroupID: String = "group.Maxsey.Mix"
    
    override public class func primaryKey() -> String? {
        return "bundleIdentifier"
    }
    
    @objc dynamic var lastLoginVersion: String = "0.0.0"
    
    @objc dynamic var bundleIdentifier: String = Bundle.bundleIdentifier!
    
    public required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    public required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    public required init() {
        super.init()
    }
    
}

class OAuthToken: Object {
    
    override public class func primaryKey() -> String? {
        return "clientID"
    }
    
    @objc dynamic var clientID: String = ""
    
    @objc dynamic var clientSecret: String? = nil
    
    @objc dynamic var code: String? = nil
    
    @objc dynamic var expiresAt: NSDate? = nil
    
    @objc dynamic var accessToken: String? = nil
    
    fileprivate var parameters: SwiftyWeibo.Token.Parameters {
        var params: [String: Any] = [
            "clientID": clientID,
            "clientSecret": clientSecret ?? "",
            "expiresAt": expiresAt ?? NSDate() as Date,
            "accessToken": accessToken ?? ""
        ]
        if let code = self.code {
            params["code"] = code
        }
        return params
    }
    
    fileprivate func token() -> Token? {
        return Token(parameters: parameters)
    }
}

extension Realm: TokenStore {
    
    fileprivate func key(forProvider provider: SwiftyWeibo.Provider) -> String {
        return provider.clientID
    }
    
    public func token(forProvider provider: SwiftyWeibo.Provider) -> SwiftyWeibo.Token? {
        let key = self.key(forProvider: provider)
        guard let token: OAuthToken = self.object(ofType: OAuthToken.self, forPrimaryKey: key) else {
            return nil
        }
        
        return token.token()
    }
    
    public func set(_ token: SwiftyWeibo.Token?, forProvider provider: SwiftyWeibo.Provider) {
        let key = self.key(forProvider: provider)
        
        try? self.write {
            if let token = token {
                self.create(OAuthToken.self, value: token.parameters, update: true)
            } else {
                if let token = self.object(ofType: OAuthToken.self, forPrimaryKey: key) {
                    self.delete(token)
                }
            }
        }
    }
    
}
