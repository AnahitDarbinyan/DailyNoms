//
//  UserInfoFormView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 26.05.25.
//

import SwiftUI
import SwiftData

enum Screen{
    case name
    case age
    case weight
    case height
    case gender
    case activitylevel
}


struct UserInfoFormView: View {
    @State private var screen: Screen = .name
    @State var name = ""
    @State var age = 0
    @State var weight = 0.0
    @State var height = 0.0
    @State var gender = User.Gender.female
    @State var activitylevel = Snapshot.ActivityLevel.extraActive
    @Environment(\.modelContext) var modelContext: ModelContext
    
    var body: some View {
        VStack {
            switch screen {
                
            case .name:
                LabeledContent {
                    TextField("Name", text: $name)
                }label: {
                    Text("Name")
                }
                Button(action: {
                    screen = .age
                }) {
                    Text("Next")
                }
            case .age:
                LabeledContent {
                    TextField("Age", value: $age, format: .number)
                }label: {
                    Text("Age")
                }
                Button(action: {
                    screen = .weight
                }) {
                    Text("Next")
                }
            case .weight:
                WeightPickerView(onNext: {
                    screen = .height
                })

            case .height:
                LabeledContent {
                    TextField("Height", value: $height, format: .number)
                }label: {
                    Text("Height")
                }
                Button(action: {
                    screen = .gender
                }) {
                    Text("Next")
                }
            case .gender:
                LabeledContent {
                    Picker("Gender", selection: $gender) {
                        ForEach(User.Gender.allCases, id: \.self) {gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                }label: {
                    Text("Gender")
                }
                Button(action: {
                    screen = .activitylevel
                }) {
                    Text("Next")
                }
            case .activitylevel:
                LabeledContent {
                    Picker("Activity Level", selection: $activitylevel) {
                        ForEach(Snapshot.ActivityLevel.allCases, id: \.self) {activitylevel in
                            Text(activitylevel.rawValue).tag(activitylevel)
                        }
                    }
                }label: {
                    Text("Activity Level")
                }
                Button(action: {
                    saveUserInfo()
                }) {
                    Text("Submit")
                }
            }
        }
    }
    private func saveUserInfo() {
        let user = User(name: name, age: age, gender: gender)
        let snapshot = Snapshot(weight: weight, height: height, activityLevel:  activitylevel, user: nil)
        modelContext.insert(snapshot)
        user.snapshots.append(snapshot)
        modelContext.insert(user)
        try! modelContext.save()
    }
}

#Preview {
    UserInfoFormView()
}

 
