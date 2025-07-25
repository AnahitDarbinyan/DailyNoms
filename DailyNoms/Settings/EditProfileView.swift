//
//  EditProfileView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 02.06.25.
//

import SwiftData
import SwiftUI

struct EditProfileView: View {
    @State private var isEditing = false
    @Query var users: [User]
    var user: User { users.first! }
    @State private var editedName: String = ""
    @State private var editedAge: String = ""
    @State private var editedWeight: String = ""
    @State private var editedHeight: String = ""
    @State private var editedActivityLevel: Snapshot.ActivityLevel = .extraActive
    @State private var editedGender: User.Gender = .male
    @Environment(\.modelContext) var modelContext: ModelContext

    var body: some View {
        List {
            Section(header: Text("User Info")) {
                HStack {
                    Text("Name")
                    Spacer()
                    if isEditing {
                        TextField("Name", text: $editedName)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.blue)
                    } else {
                        Text(user.name)
                            .foregroundColor(.gray)
                    }
                }

                HStack {
                    Text("Age")
                    Spacer()
                    if isEditing {
                        TextField("Age", text: $editedAge)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.blue)
                    } else {
                        Text("\(user.age)")
                            .foregroundColor(.gray)
                    }
                }

                HStack {
                    Text("Gender")
                    Spacer()
                    if isEditing {
                        Picker("", selection: $editedGender) {
                            ForEach(User.Gender.allCases, id: \.self) { gender in
                                Text(gender.rawValue.capitalized).tag(gender)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                    } else {
                        Text(user.gender.rawValue.capitalized)
                            .foregroundColor(.gray)
                    }
                }
            }

            Section(header: Text("Health Info")) {
                HStack {
                    Text("Weight")
                    Spacer()
                    if isEditing {
                        TextField("Weight", text: $editedWeight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.blue)
                        Text("kg")
                            .foregroundColor(.gray)
                    } else {
                        Text("\(user.snapshot.weight, specifier: "%.1f") kg")
                            .foregroundColor(.gray)
                    }
                }

                HStack {
                    Text("Height")
                    Spacer()
                    if isEditing {
                        TextField("Height", text: $editedHeight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.blue)
                        Text("cm")
                            .foregroundColor(.gray)
                    } else {
                        Text("\(user.snapshot.height, specifier: "%.1f") cm")
                            .foregroundColor(.gray)
                    }
                }

                HStack {
                    Text("Activity Level")
                    Spacer()
                    if isEditing {
                        Picker("", selection: $editedActivityLevel) {
                            ForEach(Snapshot.ActivityLevel.allCases, id: \.self) { level in
                                Text(level.rawValue.capitalized).tag(level)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                    } else {
                        Text(user.snapshot.activityLevel.rawValue.capitalized)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Done") {
                        saveChanges()
                        isEditing.toggle()
                    }
                    .bold()
                } else {
                    Button("Edit") {
                        loadCurrentValues()
                        isEditing.toggle()
                    }
                }
            }
        }
    }

    private func loadCurrentValues() {
        editedName = user.name
        editedAge = "\(user.age)"
        editedGender = user.gender
        editedWeight = String(format: "%.1f", user.snapshot.weight)
        editedHeight = String(format: "%.1f", user.snapshot.height)
        editedActivityLevel = user.snapshot.activityLevel
    }

    private func saveChanges() {
        // Update user info
        user.name = editedName
        user.age = Int(editedAge) ?? user.age
        user.gender = editedGender

        // Create new snapshot
        let newWeight = Double(editedWeight) ?? user.snapshot.weight
        let newHeight = Double(editedHeight) ?? user.snapshot.height

        let snapshot = Snapshot(
            weight: newWeight,
            height: newHeight,
            activityLevel: editedActivityLevel,
            user: user
        )
        modelContext.insert(snapshot)
        try? modelContext.save()
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
    }
}

/*
         @ViewBuilder
         func editableField(label: String, value: Binding<Double>, suffix: String) -> some View {
             HStack {
                 Text(label)
                 Spacer()
                 if isEditing {
                     TextField("", value: value, formatter: NumberFormatter())
                         .keyboardType(.decimalPad)
                         .multilineTextAlignment(.trailing)
                         .frame(width: 80)
                         .foregroundColor(.gray)
                 } else {
                     Text(String(format: "%.1f %@", value.wrappedValue, suffix))
                         .foregroundColor(.gray)
                 }
             }
         }

         @ViewBuilder
         func editableTextField(label: String, value: Binding<Snapshot.ActivityLevel>) -> some View {
             HStack {
                 Text(label)
                 Spacer()
                 if isEditing {
                     Picker("Activity Level", selection: value){
                         ForEach(Snapshot.ActivityLevel.allCases, id: \.self) { level in
                             Text(level.rawValue.capitalized).tag(level)
                         }
                     }
                     .pickerStyle(.menu)
                 } else {
                     Text(value.wrappedValue.rawValue.capitalized)
                         .foregroundColor(.gray)
                 }
             }
         }
     }
 }
 */
