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
