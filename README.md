# SwiftMultitaskingDemoApp


## Introduction

This mini-project's main purpose was to familiarize myself with basics of modern ways of Multitasking in Swift, namely Async/Await (a.k.a. Swift Concurrency) and Combine. I have compared these new ways to write concurrently running code with "old-school" approach utilizing closures and to code with no management of threads at all to see what are the pros and cons of each implementation and whether the new ways are indeed more "swift" and safe.

## Project Idea

To illustrate how different solutions behave and to make the ideas easier to grasp, I have come up with with an idea for a simple demo app. The app acts as a simple Air Quality Sensor, which reads the status of three parameters: temperature, humidity and PM2.5 pollution level and displays the reading in three labels. It also "marks" the values to be as close to optimal for comfortable feeling and displays one of three states (good/neutral/bad) using animated emoji. The trick is that measuring each type of air quality parameter takes quite some time for our imaginary sensor. Reading temperature takes 3 seconds, humidity is being measured for 5 seconds and PM2.5 level measurement takes 10 seconds. Those three values are then combined to evaluate current "Comfort Level". This cycle is being repeated each 30 seconds.

Having three sources of data allowed me to test two different scenarios:
- parallel fetching of data (useful for cases where various sources of the similar data needs to be combined to give complete response)
- serial fetching of data (could be useful for cases, where one asynchronous task depends on the result of other task)

While having animated emoji as a main part of UI allowed me to visualize whether the compiled code correctly executes data fetching in the background, without interfering with animation and if it correctly updates the data displayed in the UI, which proved to not always be the case ;) 

Additionally I have added basic unit tests for each Sensor variant to see how difficult is to test these different styles of code.

## Main Classes Overview / Explanation

### ReadingsGenerator

### Sensor implementations

### ComfortLevel

### ContentView

## Swift Concurrency in Swift 6

## "Blocking" implementation

## Closure implementation

## Async/Await / Swift Concurrency implementation






