//
//  WeiboProvider.swift
//  Mix
//
//  Created by Maxwell on 23/08/2017.
//  Copyright © 2017 Maxsey Inc. All rights reserved.
//

import Foundation
import SwiftyWeibo
import RealmSwift

public let weibo = Provider("1522592428", "223965c7ff7d2811d2312fb2630aa3a0", tokenStore: try! Realm(dbName: .public), redirectURL: "http://mix/weibo.com/callback")

