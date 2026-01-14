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

the cyberlog app screenshots :

![1](https://github.com/user-attachments/assets/9b02af77-bfdf-4495-8fd1-6b334bac79cc)

![2](https://github.com/user-attachments/assets/cc2cb680-24fb-4d05-aae0-b0a72c2f46e2)

![3](https://github.com/user-attachments/assets/705865d0-592a-4187-83c9-3a915618a3a6)

![4](https://github.com/user-attachments/assets/5e69342f-610a-4d72-99c6-ae032dbc934c)

![5](https://github.com/user-attachments/assets/207c64c7-399f-4e22-9e33-30fb37261e47)

![6](https://github.com/user-attachments/assets/22bce004-65ba-4629-a4e3-2cc22b2278f4)

![7) by clicking the selected image this opens up](https://github.com/user-attachments/assets/a4bc5a8d-ab07-4dbe-b6ea-6195e7009941)

![8)we can zoom in and out also can delete ](https://github.com/user-attachments/assets/a030b16a-4d0c-4f87-abdf-0c1a53bd67e5)

![9](https://github.com/user-attachments/assets/097c0f7d-d742-4b50-9864-fb77a60cc824)

![10) After deleting the image ](https://github.com/user-attachments/assets/b16b2aea-553e-4a30-8e4c-124969d6e420)


Session 11 – Portfolio Assignment

📌 Assignment Objective

Enhance the CyberLog Flutter application by adding a Settings page and displaying basic device information using native Android integration.

✅ Features Implemented
🔧 Settings Page

A new Settings section has been added to the CyberLog app and is accessible via the bottom navigation bar.

📱 Device Information Displayed

The following device details are shown inside the Settings page:

Device Model

Android Version (Optional – implemented)

Device Manufacturer (Additional enhancement)

These details are fetched from native Android code using a MethodChannel.

🧠 Technical Implementation

Flutter (Dart) for UI and state management

Provider for theme handling

MethodChannel for communication between Flutter and Android

Android (Java) to fetch device system information:

Build.MODEL

Build.MANUFACTURER

Build.VERSION.RELEASE

📂 Project Structure (Key Files)

lib/main.dart – Main application logic and UI

android/app/src/main/java/.../MainActivity.java – Native Android code for device info

pubspec.yaml – Dependencies and configuration

#Screenshot of the session 11 work:

![S11 l](https://github.com/user-attachments/assets/f8d5cd5e-766b-4ee2-a12e-c0d33de2fabc)

![S11 d](https://github.com/user-attachments/assets/312c3a6d-6eda-469e-81cc-0b25c27c90fb)


Session 12 Portfolio Assignment:-

Security Checklist & Security-Awareness Application (Flutter):

🎯 Objective (Session 12)

The objective of Session 12 is to understand and implement mobile security concepts through a practical application.

This project demonstrates:

App-level security using PIN lock

Permission awareness and risk indication

Root / emulator awareness (placeholder)

Security-awareness focused UI

📱 About the Application

CyberLog is a Flutter-based mobile application designed to demonstrate security best practices and user awareness.

The app includes logging features, offline media storage, permission inspection, and a dedicated Security Awareness Dashboard.

🔐 Security Features Implemented:

1️⃣ App Lock (Custom PIN)

First-time users are prompted to create a 4-digit PIN

PIN is stored securely using device-level secure storage

Same PIN works:

On every app launch

Even after app reinstallation on the same device

Demonstrates screen lock / app lock security

✔ Session 12 requirement: Screen lock enabled (mock / basic check)

2️⃣ Dangerous Permissions Indicator

The app checks and displays sensitive permissions:

Permission	Risk Level:

->Camera	🔴 High Risk

->Storage	🟠 Medium Risk

Displayed clearly in:

Permissions page

Security Awareness Dashboard

✔ Session 12 requirement: Dangerous permissions indicator

3️⃣ Root / Emulator Warning (Placeholder)

A placeholder UI element is shown for root/emulator detection

Clearly labeled as not enabled

Educates users about potential risks of rooted/emulated environments

✔ Session 12 requirement: Root / emulator warning (placeholder allowed)

🧠 Security-Awareness UI (Core Focus of Session 12)

The Security Awareness Dashboard is designed to educate users, not just show system data.

UI Elements Included:

⚠️ Warning banner highlighting security risks

Color-coded risk cards (green / orange / red)

Clear, non-technical explanations

Security best-practice tips such as:

Avoid unnecessary permissions

Use app locks

Avoid unknown app sources

Keep OS and apps updated

✔ Session 12 requirement: Security-awareness UI

📂 Other Application Features:

🏠 Home Page:

Displays cybersecurity tips fetched from an API

Offline caching supported

📝 Logs Page:

Simple log counter to demonstrate local data storage

🖼 Media Page:

Capture images using camera

Select images from gallery

Images stored locally

Features:

Full-screen image viewer

Pinch-to-zoom

Delete images

🔑 Permissions Page

Shows current permission status

Color-coded granted / denied indicators

⚙ Settings Page

Displays device information:

Model

Manufacturer

Android version

Uses native platform channel

🛠 Technologies Used

Flutter & Dart

Provider (state management)

SharedPreferences (local data)

Flutter Secure Storage (secure PIN storage)

Permission Handler

Image Picker

Connectivity Plus

Path Provider

Platform Channels (Android)

->All screenshots from session 12 required changes updated:

![12 1](https://github.com/user-attachments/assets/cd12f914-51e7-4405-b231-123d7d20a779)

![12 2](https://github.com/user-attachments/assets/c22d2cf6-8c25-4fc4-8392-0372aa7cffa0)

![12 3](https://github.com/user-attachments/assets/85184a4b-6f24-46da-bf25-b96dc50ac8be)

![12 4](https://github.com/user-attachments/assets/619699c7-6d43-4ebe-85e8-3a2132f97e45)

#Session 13:

I am getting the error in solving the project :

-> After adding the all code correct , connecting properly to the firebase console database using authentication. But, the main problem coming is about the gradle file. Its not syncing properly.
Below is the screenshot of the error sir :

<img width="1365" height="767" alt="Screenshot 2026-01-14 225429" src="https://github.com/user-attachments/assets/03386d5f-94ed-4414-9be9-f97ff0ed4b1c" />









