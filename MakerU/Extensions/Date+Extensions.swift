//
//  Date+Extensions.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 06/11/20.
//

import Foundation

extension Date {
    
    func howMuchTimeAsString() -> String {
        let now = Date()
        let components = Calendar.current.dateComponents([.minute,.hour,.day,.month], from: self, to: now)
        var resultString = ""
        if components.month != 0 {
            resultString = "Há \(components.month!) mês"
            if components.month! > 1 {
                resultString = resultString.replacingOccurrences(of: "ê", with: "e")
                resultString.append("es")
            }
        }else if components.day != 0{
            resultString = "Há \(components.day!) dia"
            if components.day! > 1 {
                resultString.append("s")
            }
        }else if components.hour != 0 {
            resultString = "Há \(components.hour!) hora"
            if components.hour! > 1 {
                resultString.append("s")
            }
        }else if components.minute != 0 {
            resultString = "Há \(components.minute!) minuto"
            if components.minute! > 1 {
                resultString.append("s")
            }
        }else {
            resultString = "Agora"
        }
        return resultString
    }
    
    func addDays(days: Int) -> Date {
        var calendar = Calendar.current
        calendar.locale = Locale.init(identifier: "pt-BR")
        return calendar.date(byAdding: DateComponents(day: days), to: self)!
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
        var calendar = Calendar.current
        calendar.locale = Locale.init(identifier: "pt-BR")
        let someDate = calendar.startOfDay(for: self)
        let dayOfWeek = calendar.component(.weekday, from: someDate)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: someDate)!
        let days = (weekdays.lowerBound+1 ..< weekdays.upperBound+1)
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
    
    func monthAndYearString(withFormat format: String = "MMMM YYYY") -> String{
        let formatter = DateFormatter()
        
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.dateFormat = format
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
