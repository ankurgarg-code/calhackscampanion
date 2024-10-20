import SwiftUI

struct AddContactsView: View {
    @Binding var isPresented: Bool
    @Binding var contacts: [EmergencyContact]  // Binding to the list of contacts
    @State private var name: String = ""  // Fields for new contact input
    @State private var phone: String = ""
    @State private var relation: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Title and description
                Text("Add your emergency contacts")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Before you hit the trail, let's set up your emergency contacts.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Emergency contacts will:")
                    .font(.subheadline)
                    .padding(.top, 5)
                
                VStack(alignment: .leading) {
                    Text("• Receive automated updates of your hike")
                    Text("• Be notified instantly in emergencies")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()

                // Form for contact input
                VStack(alignment: .leading, spacing: 15) {
                    Text("Emergency contact #\(contacts.count + 1)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Phone", text: $phone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Relation", text: $relation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Add contact button
                    Button(action: {
                        if !name.isEmpty && !phone.isEmpty && !relation.isEmpty {
                            // Append the new contact directly to the contacts list passed in
                            let newContact = EmergencyContact(name: name, phone: phone, relation: relation)
                            contacts.append(newContact)
                            
                            // Reset the input fields for a new contact entry
                            name = ""
                            phone = ""
                            relation = ""
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add new contact")
                        }
                        .foregroundColor(.primary)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                    }
                }

                Spacer()

                // Submit button
                Button(action: {
                    isPresented = false  // Close the modal
                }) {
                    Text("Submit")
                        .fontWeight(.bold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(hex: "2B5740"))
                        .cornerRadius(10)
                }
                .padding(.vertical, 20)
            }
            .padding()
            .navigationBarItems(trailing: Button(action: {
                isPresented = false  // Close modal
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.primary)
            })
        }
    }
}
