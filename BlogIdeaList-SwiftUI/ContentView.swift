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

struct ContentView: View {
    // ❇️ Core Data property wrappers
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ❇️ The BlogIdea class has an `allIdeasFetchRequest` static function that can be used here
    @FetchRequest(fetchRequest: BlogIdea.allIdeasFetchRequest()) var blogIdeas: FetchedResults<BlogIdea>
    
    // ℹ️ Temporary in-memory storage for adding new blog ideas
    @State private var newIdeaTitle = ""
    @State private var newIdeaDescription = ""
    
    // ℹ️ Two sections: Add Blog Idea at the top, followed by a listing of the ideas in the persistent store
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add Blog Idea")) {
                    VStack {
                        VStack {
                            TextField("Idea title", text: self.$newIdeaTitle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Idea description", text: self.$newIdeaDescription)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack {
                            Button(action: ({
                                // ❇️ Initializes new BlogIdea and saves using the @Environment's managedObjectContext
                                let idea = BlogIdea(context: self.managedObjectContext)
                                idea.ideaTitle = self.newIdeaTitle
                                idea.ideaDescription = self.newIdeaDescription
                                
                                do {
                                    try self.managedObjectContext.save()
                                } catch {
                                    print(error)
                                }
                                
                                // ℹ️ Reset the temporary in-memory storage variables for the next new blog idea!
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
                    ForEach(self.blogIdeas, id:\.self) { blogIdea in
                        NavigationLink(destination: EditView(blogIdea: blogIdea)) {
                            VStack(alignment: .leading) {
                                Text(blogIdea.ideaTitle ?? "")
                                    .font(.headline)
                                Text(blogIdea.ideaDescription ?? "")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onDelete { (indexSet) in // Delete gets triggered by swiping left on a row
                        // ❇️ Gets the BlogIdea instance out of the blogIdeas array
                        // ❇️ and deletes it using the @Environment's managedObjectContext
                        let blogIdeaToDelete = self.blogIdeas[indexSet.first!]
                        self.managedObjectContext.delete(blogIdeaToDelete)
                        
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
                    }
                }
                .font(.headline)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Blog Idea List"))
            .navigationBarItems(trailing: EditButton())
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    }
}
#endif
