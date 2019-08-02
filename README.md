# Using Core Data With SwiftUI - An Introduction

This sample code project is associated with [Using Core Data With SwiftUI - An Introduction
](https://www.andrewcbancroft.com/blog/ios-development/data-persistence/using-core-data-with-swiftui-introduction/) at [andrewcbancroft.com](https://www.andrewcbancroft.com).

## Overview

How does Apple intend for us to use Core Data with SwiftUI?

This project demonstrates how to stitch things together.

It's a single-view app that can

* Persist a list of `BlogIdea`s to a Core Data persistent store
* Use the new `@FetchRequest` property wrapper to fetch `BlogIdea`s
* Use the `@Environment`'s `managedObjectContext` to create, update, and delete `BlogIdea`s

Within the code,

❇️ Alerts you to Core Data pieces

ℹ️ Alerts you to general info about what my brain was thinking when I wrote the code
