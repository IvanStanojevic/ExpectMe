//
//  Date+.swift
//  ExpectMe
//
//  Created by MobileDev on 7/4/19.
//  Copyright © 2019 Vasyl Boichuk. All rights reserved.
//

import UIKit

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}

extension Date {
    func string(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
