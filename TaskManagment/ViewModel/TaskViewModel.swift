//
//  TaskViewModel.swift
//  TaskManagment
//
//  Created by Tarlan on 03.02.22.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [
        Task(title: "Meeting", description: "Discuss team", date: .init(timeIntervalSince1970: 1643891123)),
        Task(title: "Meeting 2", description: "Discuss team 2", date: .init(timeIntervalSince1970: 1643918979)),
        Task(title: "Meeting 3", description: "Discuss team 3", date: .init(timeIntervalSince1970: 1643902779)),
        Task(title: "Meeting 4", description: "Discuss team 4", date: .init(timeIntervalSince1970: 1643898323)),
        Task(title: "Meeting 5", description: "Discuss team 5", date: .init(timeIntervalSince1970: 1643909979)),
        Task(title: "Meeting 6", description: "Discuss team 6", date: .init(timeIntervalSince1970: 1643913579)),
        Task(title: "Meeting 7", description: "Discuss team 7", date: .init(timeIntervalSince1970: 1643917179)),
    ]

    // MARK: Hefter gunleri

    @Published var currentWeek: [Date] = []

    @Published var currentDay: Date = Date()

    @Published var filteredTasks: [Task]?

    init() {
        fetchCurrentWeek()
        filteredTodayTasks()
    }

    func filteredTodayTasks() {
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current

            let filtered = self.tasks.filter {
                calendar.isDate($0.date, inSameDayAs: self.currentDay)
            }
            .sorted {
                $0.date < $1.date
            }

            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
                }
            }
        }
    }

    func fetchCurrentWeek() {
        let today = Date()

        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)

        guard let firstWeekDay = week?.start else {
            return
        }

        (1 ... 7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }

    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

    func isTodayDate(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }

    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())

        return hour == currentHour
    }
}
