import Foundation

// MARK: - Date Extension

extension Date {
    static func now() -> Date {
        Self()
    }
    func formatedString() -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.string(from: self)
    }
    
    func add(component: Calendar.Component, value: Int, calendar: Calendar = Calendar.autoupdatingCurrent) -> Date? {
        calendar.date(byAdding: component, value: value, to: self, wrappingComponents: true)
    }
}

// MARK: - Calendar Extension

extension Calendar {
    
    /// Get First day from month for this year
    func getFirstDateOf(month: Int, from date: Date = Date()) -> Date? {
        guard let sixMonthsBefore = self.date(byAdding: .month,
                                              value: month,
                                              to: date) else { return nil }
        let comps = dateComponents([.month, .year], from: sixMonthsBefore)
        return self.date(from: comps)
    }
    
    func isLeapYear(_ year: Int) -> Bool { ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0)) }
    func isLeapYear(_ date: Date = Date()) -> Bool {
        guard let year = dateComponents([.year], from: date).year else { return false }
        return isLeapYear(year)
    }
    
    func start(of component: Calendar.Component,
               date: Date = Date()) -> Date? {
        
        var dateComps = dateComponents(in: timeZone, from: date)
        switch component {
        case .year:
            dateComps.month = 1
            fallthrough
        case .month, .weekday:
            if component == .month || component == .year {
                dateComps.day = 1
            } else {
                dateComps.weekday = 1
            }
            fallthrough
        case .day:
            dateComps.hour = 0
            fallthrough
        case .hour:
            dateComps.minute = 0
            fallthrough
        case .minute:
            dateComps.second = 0
            fallthrough
        case .second:
            dateComps.nanosecond = 0
        default:
            return nil
        }
        
        return self.date(from: dateComps)
    }
    
    func group<T: DateRepresentable>(dateRepresentables: [T],
                                     component: Calendar.Component) -> [Date: [T]] {
        var returnGroups = [Date: [T]]()
        for datable in dateRepresentables {

            guard let startDateOfComponent = start(of: component, date: datable.date) else { continue }

            if var existingDatables = returnGroups[startDateOfComponent] {
                existingDatables.append(datable)
                returnGroups[startDateOfComponent] = existingDatables.sorted()
            } else {
                returnGroups[startDateOfComponent] = [datable]
            }
        }

        return returnGroups
    }
}

// MARK: - DateRepresentable

protocol DateRepresentable: Comparable {
    var date: Date { get }
}

extension DateRepresentable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.date < rhs.date
    }

    static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.date <= rhs.date
    }

    static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.date >= rhs.date
    }

    static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.date > rhs.date
    }
}

extension Date: DateRepresentable {
    var date: Date { self }
}


// MARK: - 1 Year Period Helper Calculator

struct PeriodWindow: CustomDebugStringConvertible {
    
    enum DayOfWeek: Int {
        case sun = 1, mon = 2, tue = 3, wed = 4, thru = 5, fri = 6, sat = 7
    }
    enum MonthName: Int {
        case Jan = 1, Feb, LeapFeb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec
    }

    struct Day: CustomDebugStringConvertible {
        var value: Int
        var date: Date
        var dayOfWeek: DayOfWeek
        
        init?(value: Int, date: Date, dayOfWeek: Int){
            self.value = value
            self.date = date
            guard let dayOfWeek = DayOfWeek(rawValue: dayOfWeek) else { return nil }
            self.dayOfWeek = dayOfWeek
        }
        
        var debugDescription: String { "\ndayOfWeek: \(dayOfWeek) day: \(value) date: \(date)" }
    }

    struct Month: CustomDebugStringConvertible {
        var days = [Day]()
        var type: MonthName
        
        init(type: MonthName) {
            self.type = type
        }
        
        mutating func add(day: Day) {
            days += [day]
        }
        
        var debugDescription: String {
            return "\(type)\n \(days)"
        }
    }

    var date: Date
    var calendar: Calendar
    var months: [MonthName: Month] = [ .Jan: Month(type: .Jan),
                                       .Feb: Month(type: .Feb),
                                       .Mar: Month(type: .Mar),
                                       .Apr: Month(type: .Apr),
                                       .May: Month(type: .May),
                                       .Jun: Month(type: .Jun),
                                       .Jul: Month(type: .Jul),
                                       .Aug: Month(type: .Aug),
                                       .Sep: Month(type: .Sep),
                                       .Oct: Month(type: .Oct),
                                       .Nov: Month(type: .Nov),
                                       .Dec: Month(type: .Dec) ]
    var monthsInOrder = [MonthName]()

    init?(date: Date,
          calendar: Calendar = Calendar.autoupdatingCurrent) {
        self.date = date
        self.calendar = calendar
        
        guard let _sixthMonthsBeforeDate = calendar.getFirstDateOf(month: -6, from: date),
            let sixthMonthsAfterDate = calendar.getFirstDateOf(month: 6, from: date) else { return nil }
        guard let sixthMonthsBeforeDate = calendar.date(byAdding: .day, value: -1, to: _sixthMonthsBeforeDate) else { return nil }
        calendar.enumerateDates(startingAfter: sixthMonthsBeforeDate,
                                matching: DateComponents(hour: 0, minute: 0, second: 0),
                                matchingPolicy: .nextTime) { (date, strict, stop) in
                                    guard let date = date else { return }
                                    guard date <= sixthMonthsAfterDate else { stop = true; return; }
                                    guard let monthName = MonthName(rawValue: calendar.component(.month, from: date)),
                                        var month = months[monthName] else { return }
            
                                    if !monthsInOrder.contains(monthName){ monthsInOrder += [monthName] }
                                    
                                    guard let day = Day(value: calendar.component(.day, from: date), date: date, dayOfWeek: calendar.component(.weekday, from: date)) else { return }
                                    month.add(day:day)
                                    months[monthName] = month
        }
    }
    
    
    var debugDescription: String {
        var stringToPrint = ""
        
        for monthName in monthsInOrder {
            guard let month = months[monthName] else { continue }
            stringToPrint += "\n=====================================================\n"
            stringToPrint += "\(month)"
            stringToPrint += "\n=====================================================\n"
        }
    
        return stringToPrint
    }
}
