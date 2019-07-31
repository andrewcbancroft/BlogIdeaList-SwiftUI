//
//  ContentView.swift
//  BlogIdeaList-SwiftUI
//
//  Created by Andrew Bancroft on 7/30/19.
//  Copyright © 2019 Andrew Bancroft. All rights reserved.
//


import SwiftUI
import CoreData

struct ContentView: View {
    // ✴️ Core Data property wrappers
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ✴️ The BlogIdea class has an `allIdeasFetchRequest` function that can be used here
    @FetchRequest(fetchRequest: BlogIdea.allIdeasFetchRequest()) var blogIdeas: FetchedResults<BlogIdea>
    
    // ✴️ Temporary in-memory storage for adding new blog ideas
    @State var newIdeaTitle = ""
    @State var newIdeaDescription = ""
    
    var body: some View {
        List {
            Section(header: Text("Add Blog Idea")) {
                VStack {
                    VStack {
                        TextField("Idea title", text: $newIdeaTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Idea description", text: $newIdeaDescription)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack {
                        Button(action: ({
                            // ✴️ Initializes new BlogIdea and saves using the @Environment's managedObjectContext
                            let idea = BlogIdea(context: self.managedObjectContext)
                            idea.ideaTitle = self.newIdeaTitle
                            idea.ideaDescription = self.newIdeaDescription
                            
                            try! self.managedObjectContext.save()
                            
                            // Reset the temporary in-memory storage variables for the next new blog idea!
                            self.newIdeaTitle = ""
                            self.newIdeaDescription = ""
                        })) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                                    .imageScale(.large)
                                Text("Add Idea")
                            }
                        }
                    .padding()
                    }
                }
            }
            .font(.headline)
            
            Section(header: Text("Blog Ideas")) {
                ForEach(self.blogIdeas) { blogIdea in
                    VStack(alignment: .leading) {
                        Text(blogIdea.ideaTitle ?? "")
                            .font(.headline)
                        Text(blogIdea.ideaDescription ?? "")
                            .font(.subheadline)
                    }
                }
                .onDelete { (indexSet) in
                    // ✴️ Gets the BlogIdea instance out of the blogIdeas array
                    // and deletes it using the @Environment's managedObjectContext
                    let blogIdeaToDelete = self.blogIdeas[indexSet.first!]
                    self.managedObjectContext.delete(blogIdeaToDelete)
                    try! self.managedObjectContext.save()
                }
            }
            .font(.headline)
        }
        .listStyle(GroupedListStyle())
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
