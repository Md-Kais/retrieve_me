
# <h1 align="center"> RETRIEVE ME </h1>

## Table of Contents
- [Overview](#overview)
- [Setup Guide](#setup-guide)
- [Installation](#installation)
- [Features](#features)
- [Getting Started](#getting-started)
- [Acknowledgements](#acknowledgements)
- [Contributors](#contributors)

## Overview


## Setup Guide

Welcome to the setup guide for the "Retrieve Me" project, a Flutter and Firebase-based application developed using Agile methodologies. In this guide, we will walk you through the process of setting up the project on your local machine for development and testing purposes.

### Prerequisites

Before you begin, make sure you have the following prerequisites installed on your system:

1. **Git**: Version control system for cloning the project repository.
2. **Flutter**: SDK for building native applications using the Dart programming language.
3. **Firebase Account**: Access to Firebase console for project configuration.
4. **Android Studio** or **VS Code**: Integrated development environment (IDE) for Flutter development.
5. **Android/iOS Emulator** or a physical device for testing.

### Step-by-Step Setup Process

Follow these steps to set up the "Retrieve Me" project on your local machine:

#### 1. Clone the Repository

Open a terminal and execute the following command to clone the project repository:

```bash
git clone https://github.com/Md-Kais/retrieve_me.git
```

### 2. Set Up Firebase

1. User have to provide me his EMAIL to access the firebase database.

### 3. Install Dependencies

Navigate to the project directory and install the required dependencies using the following command:

```bash
cd retrieve_me
flutter pub get
```

#### 4. Run the Application

Use your preferred IDE (Android Studio or VS Code) to open the project directory.

##### Running on Android Emulator/Device

1. Ensure your Android emulator or physical device is connected.
2. Run the app using the IDE's run button or execute the following command in the terminal:

```bash
flutter run
```

##### Running on iOS Simulator/Device

1. Ensure you have Xcode installed on macOS.
2. Open the `ios/Runner.xcworkspace` file in Xcode.
3. Select your desired simulator or device.
4. Click the run button or use the following command:

```bash
flutter run
```

#### 5. Testing

You can now interact with the "Retrieve Me" app on the emulator or device. Explore its features and functionalities to ensure everything is working as expected.

### Contributing and Agile Workflow

If you're interested in contributing to the project, we follow an Agile development workflow 
using Git. Create a new branch for your feature or bug fix, make your changes, and submit a pull 
request to the `development` branch.

For Agile-related tasks, we use tools like Trello to manage user stories, tasks, and sprints. Feel free to join our Agile boards and participate in the development process.

### Conclusion

Congratulations! You've successfully set up the "Retrieve Me" project on your local machine using Agile development practices. You can now start developing, testing, and contributing to the project. If you encounter any issues, refer to the project documentation or reach out to the development team for assistance.

Happy coding! 🚀

## Contributors:
1. Imran Farid
2. Md. Kais (ME)
3. Ramisa Zahara Matin

### Some important things to mention:
1. May be this code won't run on your PC because we removed some security files from here which are important and crucial for running this project.
2. If you find any bugs in this code, don't forget to create an issue.
3. If you have any issues run `Flutter doctor`
4. Also, In order to run it smoothly you might add multidex enable or change the `minSdkVersion 
   21` under defaultConfig in  `android/app/build.gradle` file.
