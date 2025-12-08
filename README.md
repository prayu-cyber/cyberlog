# cyberlog

# Session 1:

# What I Learned: 

->Native vs Cross-Platform
I learned how Flutter allows building apps for Android, iOS, Web, and Desktop using a single codebase.  
Unlike native development (Kotlin for Android, Swift for iOS), Flutter compiles the same Dart code into apps that run on multiple platforms, saving time and keeping the UI consistent.

->Hot Reload
Flutter’s Hot Reload feature instantly reflects code changes in the running app.  
This helped me experiment with UI, fix small issues quickly, and understand how widgets behave without restarting the whole app.

->Widgets
Everything in Flutter is a widget—text, layouts, buttons, app bars, etc.  
I learned how widgets are combined to build the UI, and how `MaterialApp`, `Scaffold`, `AppBar`, `Center`, and `Text` work together to create the screen.

# Steps I Followed to Install & Run the App

1. Installed Flutter SDK and added:

-C:\flutter\bin

-added to the system PATH.

2. Verified installation:
   
-flutter doctor

-flutter doctor --android-licenses
  
3.Installed Android Studio, then added:

-Flutter plugin

-Dart plugin

4.Opened SDK Manager to install:

-Android SDK Platform

-Platform-Tools

-Emulator components

-Created an Android Virtual Device (AVD) using Device Manager.

-Created a new Flutter project and replaced the main.dart code.

5.Ran the app using:

-flutter run

-or by clicking the Run ▶ button in Android Studio.

 <img width="1080" height="2400" alt="image" src="https://github.com/user-attachments/assets/d871d369-4ee2-4aa9-91b4-3dd3b1ef5324" />

# Session 2:

1]JIT vs AOT Compilation (Core Principles)

-> JIT (Just-In-Time) Compilation:

   > Happens while the app is running.
   
   > Enables Hot Reload, making development fast and interactive.
   
   > Used mainly during debugging.

-> AOT (Ahead-Of-Time) Compilation:

   > Code is compiled before the app runs.
   
   > Produces optimized machine code → faster startup & performance.
   
   > Used when building release APKs/app bundles.

-> Flutter uses JIT for development and AOT for production.

2] Using Dart Conditionals for Even/Odd Logic

   -> Inside the button press handler, a simple if–else conditional determines whether the input number is even or odd:
   
   if (numValue % 2 == 0) {
     resultMessage = "The number $numValue is Even.";
   } else {
     resultMessage = "The number $numValue is Odd.";
   }
   
   
   -> This demonstrates:
   
      > Reading user input
      
      > Converting String → int
      
      > Applying conditionals
      
      > Updating UI using setState()
   
-> String Interpolation for Output Formatting
   
   String Interpolation in Dart uses the $variable syntax.
   This helps embed values directly into the final result text:
   
   resultMessage = "The number $numValue is Even.";
   
   
   -> Instead of concatenation ("The number " + numValue.toString()), interpolation is:
   
   > Cleaner
   
   > Easier to read
   
   > More reliable
