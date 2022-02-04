//
//  Task.swift
//  TaskManagment
//
//  Created by Tarlan on 03.02.22.
//

import Foundation

struct Task: Identifiable {
    var id = UUID().uuidString
    var title: String
    var description: String
    var date: Date
}
