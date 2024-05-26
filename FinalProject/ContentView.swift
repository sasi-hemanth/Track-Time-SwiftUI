//
//  ContentView.swift
//  FinalProject
//
//  Created by Sasi Hemanth Siripurapu on 2024-05-22.
//

import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false

    
    @State private var currentPage: Page = .login

    
    @State private var punchInTime: Date? = nil
    @State private var punchOutTime: Date? = nil
    @State private var punchRecords: [(Date, Date?, TimeInterval?)] = []

    
    @State private var totalHours: String = ""
    @State private var payPerHour: String = ""
    @State private var deductionRate: String = ""
    @State private var grossPay: Double? = nil
    @State private var netPay: Double? = nil

    enum Page {
        case login
        case home
        case trackTime
        case payCalculator
        case editProfile
    }

    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                switch currentPage {
                case .login:
                    loginPage
                case .home:
                    homePage
                case .trackTime:
                    trackTimePage
                case .payCalculator:
                    payCalculatorPage
                case .editProfile:
                    editProfilePage
                }
            }
            .padding()
        }
    }

    
    var loginPage: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                if !username.isEmpty && !password.isEmpty {
                    isLoggedIn = true
                    currentPage = .home
                }
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(username.isEmpty || password.isEmpty)
        }
    }

    
    var homePage: some View {
        VStack {
            Text("Welcome, \(username)")
                .font(.largeTitle)
                .padding()

            Button(action: {
                currentPage = .editProfile
            }) {
                Text("Edit Profile")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Button(action: {
                currentPage = .trackTime
            }) {
                Text("Track Time")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }

            Button(action: {
                currentPage = .payCalculator
            }) {
                Text("Pay Calculator")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Button(action: {
                isLoggedIn = false
                currentPage = .login
            }) {
                Text("Sign Out")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
    }

    var editProfilePage: some View {
        VStack {
            TextField("Edit Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Edit Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                currentPage = .home
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Button(action: {
                currentPage = .home
            }) {
                Text("Back")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
            }
        }
    }

    var trackTimePage: some View {
        VStack {
            HStack {
                Button(action: {
                    if punchInTime == nil {
                        punchInTime = Date()
                        punchRecords.append((punchInTime!, nil, nil))
                    }
                }) {
                    Text("Punch In")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(punchInTime != nil)
                .padding()

                Button(action: {
                    if punchInTime != nil {
                        punchOutTime = Date()
                        if let inTime = punchInTime {
                            let totalTime = punchOutTime!.timeIntervalSince(inTime)
                            if var lastRecord = punchRecords.popLast() {
                                lastRecord.1 = punchOutTime
                                lastRecord.2 = totalTime
                                punchRecords.append(lastRecord)
                            }
                            punchInTime = nil
                            punchOutTime = nil
                        }
                    }
                }) {
                    Text("Punch Out")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(punchInTime == nil)
                .padding()
            }

            VStack {
                HStack {
                    Text("Date")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("In Time")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Out Time")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Total Time")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()

                List {
                    ForEach(punchRecords, id: \.0) { record in
                        HStack {
                            Text("\(record.0, formatter: dateFormatter)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(record.0, formatter: timeFormatter)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if let outTime = record.1 {
                                Text("\(outTime, formatter: timeFormatter)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                Text("-")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            if let totalTime = record.2 {
                                Text("\(totalTime / 3600, specifier: "%.2f") hours")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                Text("-")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .padding(.top, -10)
            }

            Button(action: {
                currentPage = .home
            }) {
                Text("Back")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    var payCalculatorPage: some
    View {
            VStack {
                TextField("Total Hours", text: $totalHours)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Pay Per Hour", text: $payPerHour)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Deduction Rate (%)", text: $deductionRate)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: calculatePay) {
                    Text("Calculate")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                if let gross = grossPay, let net = netPay {
                    Text("Gross Pay: \(gross, specifier: "%.2f")")
                    Text("Net Pay: \(net, specifier: "%.2f")")
                }

                Button(action: {
                    currentPage = .home
                }) {
                    Text("Back")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
        }

        func calculatePay() {
            guard let hours = Double(totalHours),
                  let rate = Double(payPerHour),
                  let deduction = Double(deductionRate) else {
                return
            }
            grossPay = hours * rate
            netPay = grossPay! - (grossPay! * deduction / 100)
        }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    struct BackgroundView: View {
        var body: some View {
            Image("bg4")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .overlay(Color.black.opacity(0.3))
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
