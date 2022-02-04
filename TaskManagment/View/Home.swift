//
//  Home.swift
//  TaskManagment
//
//  Created by Tarlan on 03.02.22.
//

import SwiftUI

struct Home: View {
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(taskModel.currentWeek, id: \.self) { day in
                                VStack {
                                    Text(taskModel.extractDate(date: day, format: "d"))
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)

                                    Circle().fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isTodayDate(date: day) ? 1 : 0)
                                }
                                .foregroundStyle(taskModel.isTodayDate(date: day) ? .primary : .secondary)
                                .foregroundColor(taskModel.isTodayDate(date: day) ? .white : .black)
                                .frame(width: 45, height: 90)
                                .background(
                                    ZStack {
                                        if taskModel.isTodayDate(date: day) {
                                            Capsule().fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation {
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    TasksView()

                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }

    func TasksView() -> some View {
        LazyVStack(spacing: 20) {
            if let tasks = taskModel.filteredTasks {
                if tasks.isEmpty {
                    Text("No task")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                } else {
                    ForEach(tasks) { task in
                        TaskCardView(task: task)
                    }
                }
            } else {
                ProgressView().offset(y: 100)
            }
        }
        .padding()
        .padding(.top)

        .onChange(of: taskModel.currentDay) { _ in
            taskModel.filteredTodayTasks()
        }
    }

    func TaskCardView(task: Task) -> some View {
        HStack {
            VStack(spacing: 10) {
                Circle()
                    .fill(taskModel.isCurrentHour(date: task.date) ? .black : .clear)
                    .frame(width: 15, height: 15)
                    .background(
                        Circle().stroke(.black, lineWidth: 1)
                            .padding(-3)
                    )
                    .scaleEffect(!taskModel.isCurrentHour(date: task.date) ? 0.8 : 1)
                Rectangle().fill(.black).frame(width: 3)
            }
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.title).font(.title2.bold())

                        Text(task.description).font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()

                    Text(task.date.formatted(date: .omitted, time: .shortened))
                }

                if taskModel.isCurrentHour(date: task.date) {
                    HStack(spacing: 0) {
                        HStack(spacing: -10) {
                            ForEach(["img1", "img2", "img3"], id: \.self) { user in
                                Image(user).resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .background(
                                        Circle().stroke(.black, lineWidth: 5)
                                    )
                            }
                        }
                        .hLeading()

                        Button {
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black)
                                .padding(10)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }.padding(.top)
                }
            }
            .foregroundColor(taskModel.isCurrentHour(date: task.date) ? .white : .black)
            .padding(taskModel.isCurrentHour(date: task.date) ? 15 : 0)
            .padding(.bottom, taskModel.isCurrentHour(date: task.date) ? 0 : 10)
            .hLeading()
            .background(
                Color.black
                    .cornerRadius(25)
                    .opacity(taskModel.isCurrentHour(date: task.date) ? 1 : 0)
            )
        }.hLeading()
    }

    func HeaderView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                Text("Today").font(.largeTitle.bold())
            }.hLeading()

            Button {
            } label: {
                Image("img1").resizable().aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color.white)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

extension View {
    func hLeading() -> some View {
        frame(maxWidth: .infinity, alignment: .leading)
    }

    func hTraling() -> some View {
        frame(maxWidth: .infinity, alignment: .trailing)
    }

    func hCenter() -> some View {
        frame(maxWidth: .infinity, alignment: .center)
    }

    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }

        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }

        return safeArea
    }
}
