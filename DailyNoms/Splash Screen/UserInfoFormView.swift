//
//  UserInfoFormView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 26.05.25.
//

import SwiftData
import SwiftUI

enum Screen {
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
    @State var weight = 40.0
    @State var height = 0.0
    @State var gender = User.Gender.female
    @State var activitylevel = Snapshot.ActivityLevel.extraActive
    @Environment(\.modelContext) var modelContext: ModelContext

    var body: some View {
        VStack {
            switch screen {
            case .name:
                NameInputView(name: $name, onNext: {
                    screen = .age
                })
            case .age:
                AgePickerView(selectedAge: $age, onNext: {
                    screen = .weight
                }, onBack: { screen = .name })
            case .weight:
                WeightPickerView(weight: $weight, onNext: {
                    screen = .height
                }, onBack: { screen = .age })
            case .height:
                HeightPickerView(onNext: {
                    screen = .gender
                }, height: $height, onBack: { screen = .weight })
            case .gender:
                GenderSelectionView(gender: $gender, onNext: {
                    screen = .activitylevel
                }, onBack: { screen = .height })
            case .activitylevel:
                ActivityLevelSelectorView(
                    activitylevel: $activitylevel, onSubmit: {
                        saveUserInfo()
                    },
                    onBack: { screen = .gender }
                )
            }
        }
    }

    private func saveUserInfo() {
        let user = User(name: name, age: age, gender: gender)
        let snapshot = Snapshot(weight: weight, height: height, activityLevel: activitylevel, user: user)
        user.snapshots.append(snapshot)

        modelContext.insert(user)
        modelContext.insert(snapshot)

        try? modelContext.save()
    }
}

#Preview {
    UserInfoFormView()
}

//                LabeledContent {
//                    Picker("Gender", selection: $gender) {
//                        ForEach(User.Gender.allCases, id: \.self) { gender in
//                            Text(gender.rawValue).tag(gender)
//                        }
//                    }
//                } label: {
//                    Text("Gender")
//                }
//                Button(action: {
//                    screen = .activitylevel
//                }) {
//                    Text("Next")
//                }
