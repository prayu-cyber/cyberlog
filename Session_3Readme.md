#How Classes Were Used:

In this project, I created a custom Log class with three properties:

action (String)

timestamp (DateTime)

status (String)

Using a class allows the log data to be structured and organized in one place.

Instead of storing separate variables for each piece of log information, the class groups them together, making the program cleaner, easier to maintain, and scalable as more log types are added.

#How List Iteration Was Used to Render Widgets

I created a List<Log> containing multiple Log objects.

To display them in the UI, I used the Flutter map() method:

logs.map((log) => Text(log.action)).toList();


The map() method loops through each Log object and converts it into a widget.

This approach is efficient because:

>It avoids writing repetitive code

>It automatically updates the UI when the list changes

>It allows multiple widgets to be generated dynamically from data

>Using list iteration makes the UI flexible, clean, and easy to expand as the number of logs grows.
