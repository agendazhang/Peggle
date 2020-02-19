//
//  String+Alphanumeric.swift
//  Peggle
//
//  Created by Zhang Cheng on 28/1/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

extension String {
    func isAlphanumeric() -> Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options:
            .regularExpression) == nil
    }
}
