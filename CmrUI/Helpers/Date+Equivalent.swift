 //
//  Date+Equivalent.swift
//  CmrUI
//

import UIKit

infix operator ≡

extension Date {
    //Compare days, month, year and era
    static func ≡ (left: inout Date, right: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let cl = calendar.dateComponents(Set<Calendar.Component>([.day,.month,.year,.era]), from: left)
        let cr = calendar.dateComponents(Set<Calendar.Component>([.day,.month,.year,.era]), from: right)
        return cl.day == cr.day && cl.month == cr.month && cl.year == cr.year && cl.era == cr.era
    }
    
    static func fromString(stringDate: String) -> Date? {
        let dateFormat = "yyyy-MM-dd HH:mm"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.date(from: stringDate)
    }
}
