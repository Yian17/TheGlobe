# TheGlobe News App

## Overview
TheGlobe is an iOS application that displays news stories from The Globe and Mail. It demonstrates modern iOS development practices including MVVM architecture, dependency injection, and unit testing.

## Features
- Fetches and displays a list of news stories
- Shows story details including title, authors, and images
- Indicates subscription-required articles with a red "X"

## Architecture
This project uses the MVVM (Model-View-ViewModel) architecture:
- **Models**: Represent the data structure of news stories
- **Views**: UI components (UITableViewCells, ViewControllers)
- **ViewModels**: Handle business logic and data preparation for views

## Key Technologies and Practices
- **Swift Concurrency**: Utilizes async/await for network calls
- **Dependency Injection**: Used in ViewModels and Services for better testability
- **Unit Testing**: Includes tests for ViewModels and Services
