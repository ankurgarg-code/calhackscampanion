import SwiftUI

struct ItemInputScreen: View {
    @ObservedObject var viewModel: HikeViewModel
    @State private var item: String = ""

    var body: some View {
        VStack {
            Spacer()

            // Title
            Text("What are you taking with you?")
                .font(.title2)
                .bold()
                .foregroundColor(Color(hex: "2B5740"))
                .padding(.bottom, 20)

            // Input Field and Add Button
            HStack {
                TextField("Add item", text: $item)  // Placeholder with leading space for "+" sign
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)

                Button(action: {
                    if !item.isEmpty {
                        viewModel.addItem(item)
                        item = ""
                    }
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                }
                .padding(.trailing, 35)
            }

            // Item List
            VStack(alignment: .leading) {
                ForEach(viewModel.hikerDetails.items) { item in
                    HStack {
                        // Increased touch area for minus button
                        Button(action: {
                            viewModel.removeItem(item)
                        }) {
                            Image(systemName: "minus")
                                .foregroundColor(.black)
                                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))  // Increase padding for touchable area
                        }
                        .contentShape(Rectangle()) // Ensures the entire padded area is tappable
                        .padding(.trailing, 10)

                        Text(item.name)
                            .font(.system(size: 18))
                            .foregroundColor(.black)

                        Spacer()
                    }
                    .padding()
                    .background(Color(hex: "E8F5E9"))  // Light green background
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                }
            }
            .padding(.vertical, 10)

            Spacer()

            // "Next" Button
            HStack {
                Spacer()

                NavigationLink(destination: HikeTabView(viewModel: viewModel)) {
                    HStack {
                        Text("next")
                            .font(.system(size: 18))
                            .foregroundColor(Color(hex: "2B5740"))

                        Image(systemName: "arrow.right")
                            .foregroundColor(Color(hex: "2B5740"))
                    }
                }
                .padding()
            }
            .padding([.trailing, .bottom], 20) // Align to bottom-right
        }
        .navigationTitle("")
        .navigationBarHidden(true) // Hide the navigation bar title for cleaner look
    }
}
