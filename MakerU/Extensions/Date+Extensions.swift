//
//  Date+Extensions.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 06/11/20.
//

import Foundation

extension Date {
    
    func addDays(days: Int) -> Date {
        Calendar.current.date(byAdding: DateComponents(day: days), to: self)!
    }
    
    func advanceAWeek() -> Date {
        addDays(days: 7)
    }
    
    func backAWeek() -> Date {
        addDays(days: -7)
    }
    
    func isToday() -> Bool {
        let today =  Calendar.current.startOfDay(for: Date())
        let selfDate = Calendar.current.startOfDay(for: self)
        
        return today == selfDate
    }
    
    func getDaysInThisWeek() -> [Date] {
        let calendar = Calendar.current
        let someDate = calendar.startOfDay(for: self)
        let dayOfWeek = calendar.component(.weekday, from: someDate)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: someDate)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: someDate) }
        
        return days
    }
    
    func getDay() -> Int {
        Calendar.current.component(.day, from: self)
    }
    
    func isSameDay(as date: Date) -> Bool {
        let selfComponents = Calendar.current.dateComponents([.year,.month,.day], from: self)
        
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day], from: date)
        
        return selfComponents == dateComponents
    }
    
    func asString(with format: String)-> String{
        let formatter = DateFormatter()
        
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.dateFormat = "MMMM YYYY"
        formatter.locale = Locale.init(identifier: "pt-BR")
        
        return formatter.string(from: self).replacingOccurrences(of: " ", with: " de ")
    }
    
    func timeAsString() -> String {
        let formatter = DateFormatter()
        
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        formatter.locale = Locale.init(identifier: "pt-BR")
        return formatter.string(from: self)
    }
}
