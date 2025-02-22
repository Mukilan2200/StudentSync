//
//  ContentView.swift
//  StudentSync 2.0
//
//  Created by Mukilan Karikalan on 2025-02-18.
//

import SwiftUI

struct ContentView: View {
    @State private var email = ""//this declares email as a variable so the user can enter their email
    @State private var password = ""//this declares their password as a variable so users can enter their passwords
    @State private var isLoggedIn = false//if a wrong password is typed, it will delete everything and take them back to the first login page
    
    var body: some View { //here, we are declaring the design of the components. specifically, we are designing the login, password and email buttons
        NavigationView {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Login") {
                    isLoggedIn = true
                }
                .padding()
                .buttonStyle(.borderedProminent)
                
                NavigationLink("New here? Sign up", destination: HomeView(userEmail: email))//here, we are setting the sign up button where useres can sign up.
                    .padding()
            }
            .fullScreenCover(isPresented: $isLoggedIn) {
                HomeView(userEmail: email)
            }
        }
    }
}

struct HomeView: View { //here, we are declaring the main homepage where the user has 2 options, the first one is a Quiz
    var userEmail: String
    @State private var startQuiz = false
    @State private var showToDoList = false
    
    var body: some View {
        VStack {
            Text("Welcome!") //this is the introduction text that the users will see before starting their quiz.
                .font(.largeTitle)
                .padding()
            Button("Start Quiz") {
                startQuiz = true
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
            Button("Go To-Do List") { //here, we are declaring and setting up the To Do List Variable.
                showToDoList = true
            }
            .padding()
            .buttonStyle(.bordered)
        }
        .fullScreenCover(isPresented: $startQuiz) { //these lines of code basically design all the buttons and the graphics to make sure that they don't look plain
            QuizView(userEmail: userEmail)
        }
        .fullScreenCover(isPresented: $showToDoList) {
            ToDoListView()
        }
    }
}

struct QuizView: View { //here we set the questions for the quiz
    var userEmail: String
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers = Array(repeating: "", count: 20) //this shows the amount of questions that the users have to answer
    @State private var timer = 0
    @State private var timerRunning = true
    @State private var quizCompleted = false
    @Environment(\.dismiss) var dismiss
    
    let questions = [
        Question(text: "What is the largest ocean on Earth?", options: ["Atlantic Ocean", "Indian Ocean", "Pacific Ocean"], correct: "Pacific Ocean"),
            Question(text: "Who wrote 'Hamlet'?", options: ["Charles Dickens", "William Shakespeare", "Jane Austen"], correct: "William Shakespeare"),
            Question(text: "What is the capital of Japan?", options: ["Beijing", "Seoul", "Tokyo"], correct: "Tokyo"),
            Question(text: "How many continents are there on Earth?", options: ["5", "6", "7"], correct: "7"),
            Question(text: "Which planet is known as the Red Planet?", options: ["Venus", "Mars", "Jupiter"], correct: "Mars"),
            Question(text: "What is the currency of the United Kingdom?", options: ["Euro", "Pound Sterling", "Dollar"], correct: "Pound Sterling"),
            Question(text: "What is the chemical symbol for gold?", options: ["Ag", "Au", "Pb"], correct: "Au"),
            Question(text: "Which country is famous for the Great Wall?", options: ["India", "China", "Japan"], correct: "China"),
            Question(text: "Who painted the Mona Lisa?", options: ["Vincent van Gogh", "Pablo Picasso", "Leonardo da Vinci"], correct: "Leonardo da Vinci"),
            Question(text: "What is the longest river in the world?", options: ["Amazon River", "Nile River", "Yangtze River"], correct: "Nile River"),
            Question(text: "Which element has the chemical symbol O?", options: ["Oxygen", "Osmium", "Oganesson"], correct: "Oxygen"),
            Question(text: "What is the smallest country in the world?", options: ["Monaco", "Vatican City", "Liechtenstein"], correct: "Vatican City"),
            Question(text: "How many sides does a hexagon have?", options: ["5", "6", "7"], correct: "6"),
            Question(text: "Which language is the most spoken worldwide?", options: ["English", "Spanish", "Mandarin Chinese"], correct: "Mandarin Chinese"),
            Question(text: "Which gas do plants absorb from the atmosphere?", options: ["Oxygen", "Nitrogen", "Carbon Dioxide"], correct: "Carbon Dioxide"),
            
            // Technology Questions
            Question(text: "Who is known as the father of computers?", options: ["Charles Babbage", "Alan Turing", "Steve Jobs"], correct: "Charles Babbage"),
            Question(text: "What does 'CPU' stand for?", options: ["Central Processing Unit", "Computer Processing Unit", "Central Power Unit"], correct: "Central Processing Unit"),
            Question(text: "What company created the Android operating system?", options: ["Apple", "Microsoft", "Google"], correct: "Google"),
            Question(text: "What is the most widely used programming language in web development?", options: ["Java", "Python", "JavaScript"], correct: "JavaScript"),
            Question(text: "What does 'HTTP' stand for?", options: ["HyperText Transfer Protocol", "High-Tech Transmission Process", "Hyperlink and Text Transfer Protocol"], correct: "HyperText Transfer Protocol")
       
    ]
    
    var body: some View {
        VStack {
            Text("Time: \(timer) sec") //this is wehre we declare the time variable (starting the stopwatch) and design it to make sure it doesn't look bland.
                .onAppear(perform: startTimer)
                .padding()
            
            if currentQuestionIndex < questions.count {
                Text(questions[currentQuestionIndex].text)
                    .font(.title2)
                    .padding()
                
                ForEach(questions[currentQuestionIndex].options, id: \.self) { option in
                    Button(option) {
                        selectedAnswers[currentQuestionIndex] = option
                        nextQuestion()
                    }
                    .padding()
                    .buttonStyle(.bordered)//here, we style the buttons that show each option
                }
            } else {
                Text("Quiz Completed!") //this code shows that once the quiz is completed, a popup saying "Quiz completed" will be shown
                    .font(.title)
                    .padding()
                
                Text("Time taken: \(timer) sec") //this code will output the amount of time taken for the user to complete all 20 questions. the time taken to complete the quiz is being recorded.
                    .padding()
                
                Button("Back to Home") {
                    dismiss()
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    func startTimer() { //here, we make sure that the timer is working properly, i've set the interval (of the timer) to 1 second as certain timers increase by 2 seconds of 5 seconds which may reduce accuracy.
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timerRunning {
                self.timer += 1
            }
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            timerRunning = false
            currentQuestionIndex += 1
        }
    }
}

struct ToDoListView: View {
    @State private var tasks: [String] = [] //declaring the variable for letting users to add their own tasks.
    @State private var newTask: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                
                Button("Back to Home") { //here, i've created the button that will take users back to the home page where they can again choose between the 2 options.
                    dismiss()
                }
                .padding()
                .buttonStyle(.bordered)
                
                TextField("Enter a new task", text: $newTask) //this is the text that will be shown to guide the users to add their own task.
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Add Task") { //the text that goes in the button that users have to click to add a new task
                    if !newTask.isEmpty {
                        tasks.append(newTask)
                        newTask = ""
                    }
                }
                .padding()
                .buttonStyle(.borderedProminent)
                
                List {
                    ForEach(tasks, id: \.self) { task in
                        Text(task)
                    }
                    .onDelete { indexSet in
                        tasks.remove(atOffsets: indexSet) //this shows that when the delete button is clicked on a task, it will remove it.
                    }
                }
            }
            .navigationTitle("To-Do List")
        }
    }
}

struct Question {
    let text: String
    let options: [String]
    let correct: String
}

@main
struct QuizApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView() //declaring the variable to see the mockup of all of this code
        }
    }
}

#Preview {
    ContentView() //to see a final mockup of all this code, we declare these functions, this will open up a mock Iphone and show the app that has been built on that screen.
}
