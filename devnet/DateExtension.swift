//
//  DateExtension.swift
//  devnet
//
//  Created by Zulwiyoza Putra on 2/13/17.
//  Copyright © 2017 zulwiyozaputra. All rights reserved.
//

import Foundation

extension Date {
    func dateToStringConverterDate() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: DateFormatter.Style.medium, timeStyle: .none)
    }
    
    func dateToStringConverterHour() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: .none, timeStyle: .short)
    }
}
