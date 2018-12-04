# Social Cloud Mobile

The mobile frontend client for the Social Cloud project.

## Running The Application

The mobile application can be run in Android Studio through the use of a virtual device.
Before continuing with the installation of the virtual device, begin by installing Android
Studio and the Flutter framework. To install Android Studio and the Flutter framework,
follow the instructions found at this address: https://flutter.io/docs/get-started/install.
After both Android Studio and Flutter have been successfully installed, continue with
the following instructions by loading the project into Android Studio with the Flutter and
Dart plugins installed and enabled. First, begin by installing a virtual device through the
AVD Manager tool found in the Tools menu of the menu bar. Then click "Create Virtual Device"
at the bottom left of the window and follow the instructions. That is, Tools -> AVD Manager
-> Create Virtual Device.

Second, after the installation, the mobile client can be run by booting up the virtual
device within Android Studio. Select a device from the devices drop down in the top right
corner of Android Studio. Alternatively, you can return to the AVD Manager and click the
green play button to the right of the device you would like to launch. The selected device
will boot up and appear on your screen. Once the device has finished booting up, click the
green play button next to the device dropdown to build, install, and run the mobile client
on the running virtual device. Android Studio will display the installation and boot up
processes it is running in the bottom half of the IDE. Once finished, the app will appear
on the virtual device and setup is complete. The application can now be used.

## Project Decomposition

The Social Cloud Mobile frontend project has been decomposed into the following directories.

### android

This folder contains the generated Android code for the hybrid project. The only
relevant files in this directory are build.gradle and google-services.json files found in
the app directory. The first file contains build dependencies of the android project. This
includes the Google services dependencies for the Firebase authentication. The second file
is a JSON file specifying the projects access variables that are used by the Google services
dependencies to interact with Firebase securely. The Firebase JSON specifies a Firebase
account that has been setup for the purposes of this application.

### assets

The assets folder stores the assets for the project. This includes the Google image used
to build the Google sign-in button. Any other additional assets should be placed here.

### ios

This folder contains the IOS generated code for the hybrid project. The project has yet
to be developed for running on an IOS device and has yet to be tested.

### lib

This folder contains all the dart source code files for the project. The code here is what is
used to generate the android and IOS folders. The code is written in the Dart programming
language developed by Google and makes use of the Flutter framework also developed by Google
to develop the Android application. This folder is decomposed into the following directories.

#### main.dart

This file contains the source code to start the application. This is the application's entry
point when it is started. This file mostly includes theme related definitions and route
definitions that define the overall look and feel of the application and the navigation methods
to the individual components.

#### components

This folder contains the dart source code for each of the project's individual components. This
includes the startup component, the home component, the composer component, the thread component,
and other components. Essentially, each component that is navigated to within the mobile client is
defined within its own dart file within this directory. Each smaller component used within the
larger components are also defined within the component file that uses it. In the future, the
reusable components should be isolated into their own dart source files. Each of these components
defines some app behaviour and logic, as well as the interactive components.

#### services

This folder contains the dart source code for each of the project's individual services. This
includes the http service, the profile service, the post service, the comment service, and other
services. Essentially, each service that is used by the components are defined here within its
own dart source code file. Note that each service has been defined as a singleton instance. Each
of these service handles a service that is provided by the Social Cloud Server backend project
through the use of standard HTTP requests. All requests and responses are serialized into JSON.
These services include interacting with the Social Cloud Server backend to manage all resources
used, including profiles, posts, notifications, and more.

### util

This folder contains common utility functions used throughout the application. This includes
utility functions that handle date formatting, common dialogs, common snackbars, and common
file manipulation functions. These are used by other components and services for completing
common tasks. Additional common utilities should be placed here in the future.

### Other files of interest

pubspec.yaml
    -> This file defines the dependencies of the project. This includes flutter packages that
       provide some predefined functionality, such as the Google sign-in package and the image
       picker package.
