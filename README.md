# moviepad

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Moviepad has 2 planned firebase cloud message. 
One of them sends a message at 13:30 every day. (After lunch)
Another one sends a message at 20:00 every day. (After dinner)
We think that these time slots are the perfect time for watching a movie.

Also, Moviepad has a background task which is a local notification.
When upload a new film from the http to the database, 
local notification sends a message.

In the User Dashboard Page, there is a connectivity checker. 
It checks connection status and shows it on the screen.
