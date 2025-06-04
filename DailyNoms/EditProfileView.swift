//
//  EditProfileView.swift
//  DailyNoms
//
//  Created by Anahit Darbinyan on 02.06.25.
//

import SwiftUI
import SwiftData

struct EditProfileView: View {

    @State private var isEditing = false
    @Query var users: [User]
    var user: User{users.first!}
    @State var weight: Double = 0.0
    @State var height: Double = 0.0
    @State var activityLevel: Snapshot.ActivityLevel = .extraActive
    @Environment(\.modelContext) var modelContext: ModelContext
    
   
    
    var body: some View {
    
            Form {
                Section(header: Text("User Info")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(user.name).foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Age")
                        Spacer()
                        Text("\(user.age)").foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Gender")
                        Spacer()
                        Text(user.gender.rawValue.capitalized).foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Health Info")) {
                    NavigationLink {
                        EditValueView(label: "Weight", value: $weight, suffix: "kg")
                            .onChange(of: weight){
                                
                                let snapshot = Snapshot(weight: weight, height: user.snapshot.height, activityLevel: user.snapshot.activityLevel, user: user)
                                modelContext.insert(snapshot)
                                try? modelContext.save()}
                    } label: {
                        HStack {
                            Text("Weight")
                            Spacer()
                            Text("\(user.snapshot.weight, specifier: "%.1f") kg").foregroundColor(.gray)
                        }
                    }
                    
                    NavigationLink {
                        EditValueView(label: "Height", value: $height, suffix: "cm")
                            .onChange(of: height){
                                
                                let snapshot = Snapshot(weight: user.snapshot.weight, height: height, activityLevel: user.snapshot.activityLevel, user: user)
                                modelContext.insert(snapshot)
                                try? modelContext.save()}
                    } label: {
                        HStack {
                            Text("Height")
                            Spacer()
                            Text("\(user.snapshot.height, specifier: "%.1f") cm").foregroundColor(.gray)
                            
                        }
                    }
                    
                    NavigationLink {
                        EditActivityLevelView(level: $activityLevel)
                            .onChange(of: activityLevel){
                                
                                let snapshot = Snapshot(weight: user.snapshot.weight, height: user.snapshot.height, activityLevel: activityLevel, user: user)
                                modelContext.insert(snapshot)
                                try? modelContext.save()
                            }
                    } label: {
                        HStack {
                            Text("Activity Level")
                            Spacer()
                            Text(user.snapshot.activityLevel.rawValue.capitalized).foregroundColor(.gray)
                            
                        }
                    }
                    
                    }
                }
                .navigationTitle("Edit Profile")
            }
            
        }

struct EditValueView: View {
    let label: String
    @Binding var value: Double
    let suffix: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Edit \(label)")) {
                TextField("Enter \(label)", value: $value, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
            }
            
            Button("Save") {
                dismiss()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("Edit \(label)")
    }
}

struct EditActivityLevelView: View {
    @Binding var level: Snapshot.ActivityLevel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Picker("Activity Level", selection: $level) {
                ForEach(Snapshot.ActivityLevel.allCases, id: \.self) { option in
                    Text(option.rawValue.capitalized).tag(option)
                }
            }
            .pickerStyle(.inline)
            
            Button("Save") {
                dismiss()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("Activity Level")
    }
}


#Preview {
    EditProfileView()
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
