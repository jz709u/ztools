import XCTest
@testable import ztools

final class zCalendarTests: XCTestCase {
    
    let periodWindow = PeriodWindow(date: Date.now(),
                                    calendar: .autoupdatingCurrent)

    func test_periodWindow() {
        print(periodWindow?.debugDescription)
        //NSLog(periodWindow?.debugDescription ?? "")
    }
    
}
