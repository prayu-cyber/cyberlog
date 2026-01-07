->JIT vs AOT Compilation (Core Principles):

  >Flutter uses two types of compilation depending on the build mode:
  
  >JIT (Just-In-Time) Compilation
  
  >Happens during runtime.

  >Enables Flutter’s powerful Hot Reload feature.
  
  >Used in debug mode to speed up development.
  
  >Compiles code quickly but not fully optimized.

->AOT (Ahead-Of-Time) Compilation:
  
  >Happens before the app runs.
  
  >Produces optimized machine code.
  
  >Used in release mode (APK/App Bundle).
  
  >Results in fast startup time and smooth performance.

  ->In summary:
  
    >JIT = Fast development
    
    >AOT = Fast runtime

->Dart Conditionals Used for Even/Odd Logic

  Inside the button’s onPressed handler, the app checks the user’s number using a simple conditional:
  
  if (parsed % 2 == 0) {
    result = "The number $parsed is Even.";
  } else {
    result = "The number $parsed is Odd.";
  }
  
  
->This demonstrates:
  
  >Reading user input from a TextField
  
  >Converting a String to an int
  
  >Using an if–else to perform logic based on numeric conditions
  
  >Updating UI with setState()
  
->String Interpolation for Output Formatting
  
  >String interpolation allows inserting variable values into a string easily:
  
  >result = "The number $parsed is Even.";

->Why it's used:

  >Cleaner and more readable than concatenation
  
  >Automatically converts numbers to strings
  
  >Avoids using "The number " + parsed.toString()
  
  >Makes UI-friendly messages easy to build

After session 5:

The CyberLog app was upgraded using a BottomNavigationBar with three main sections: Home, Logs, and Settings. A StatefulWidget manages the selected index, and tapping each navigation icon dynamically updates the screen content, forming the core structure of the application.

![img.png](img.png)

After session 6:

Than updated the cyberlog app with the provider, by managing the logs screen .!

<img width="1080" height="2400" alt="image" src="https://github.com/user-attachments/assets/0d3f36d8-3c72-489a-9eec-fd18643f75fd" />

#Session 8:

There are no public apis having cyber security tips as such , so right now added normal quotes api ! 

By building the cyber tips of the day and it also has an public api.

having refresh hover buttton like refresh tips . ! 

In future i will add the api containing only actual cyber sec tips / quotes .!

<img width="1080" height="2400" alt="image" src="https://github.com/user-attachments/assets/c23c288f-d372-49e4-b030-dae4ad505b55" />

#Session 9:

>Use SharedPreferences or Hive and applied it on cyberlog app.

>Applied in Logs to keep record of log count.

![WhatsApp Image 2025-12-24 at 9 13 33 PM](https://github.com/user-attachments/assets/23bd4d0f-da6c-4aee-b1bf-e98f1951d5f5)

Session 10 – Portfolio Assignment.

✨ Features
🔐 Permissions

📸 Camera Permission – Capture images using device camera

🖼️ Storage Permission – Save images permanently inside the app

🌐 Internet Permission – Fetch online data & detect connectivity

🌐 Internet Handling (Real App Behavior)

Detects real internet availability

Shows “No Internet Connection” message

Automatically reloads data when internet is restored

Offline cyber-tip cache using SharedPreferences

🖼️ Media / Image Features

Capture images using Camera

Pick images from Gallery

Images saved permanently (even after app restart)

Grid view of all images

Tap image → Full screen viewer

Zoom in / zoom out (pinch)

Delete image at any time

🎨 UI & UX

Bottom Navigation Bar

Dark Mode 🌙

Smooth navigation

Clean & minimal UI

Animated transitions

📦 State & Storage

Provider for state management

SharedPreferences for:

Log count

Dark mode state

Cached cyber tips

🧰 Tech Stack

Flutter (Dart)

Provider

Image Picker

Permission Handler

Path Provider

Connectivity Plus

HTTP

Shared Preferences

📂 Project Structure
lib/
 └── main.dart   // Complete application code

📜 Permissions Used (Android)
<uses-permission android:name="android.permission.CAMERA"/> 

<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>

<uses-permission android:name="android.permission.INTERNET"/>
