//
//  ContentView.swift
//  BlogIdeaList-SwiftUI
//
//  Created by Andrew Bancroft on 7/30/19.
//  Copyright © 2019 Andrew Bancroft. All rights reserved.
//
// ❇️ Alerts you to Core Data pieces
// ℹ️ Alerts you to general info about what my brain was thinking when I wrote the code
//

import SwiftUI
import CoreData

struct EditView: View {
    // ❇️ Core Data property wrappers
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ℹ️ This is used to "go back" when 'Save' is tapped
    @Environment(\.presentationMode) var presentationMode

    var blogIdea: BlogIdea
    
    // ℹ️ Temporary in-memory storage for updating the title and description values of a Blog Idea
    @State var updatedIdeaTitle: String = ""
    @State var updatedIdeaDescription: String = ""
    
    var body: some View {
        VStack {
            VStack {
                TextField("Idea title", text: $updatedIdeaTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onAppear {
                        // ℹ️ Set the text field's initial value when it appears
                        self.updatedIdeaTitle = self.blogIdea.ideaTitle ?? ""
                }
        
                TextField("Idea description", text: $updatedIdeaDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onAppear {
                        // ℹ️ Set the text field's initial value when it appears
                        self.updatedIdeaDescription = self.blogIdea.ideaDescription ?? ""
                }
            }
            
            VStack {
                Button(action: ({
                    // ❇️ Set the blog idea's new values from the TextField's Binding and save
                    self.blogIdea.ideaTitle = self.updatedIdeaTitle
                    self.blogIdea.ideaDescription = self.updatedIdeaDescription
                    
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                    
                    self.presentationMode.value.dismiss()
                })) {
                    Text("Save")
                }
            .padding()
            }
        }
    }
}
