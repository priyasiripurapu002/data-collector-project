# data-collector-project
# Data Collection Flutter App & SDK

## Overview

This project is a **Data Collection System** consisting of three main components:
1. **Flutter App**: A mobile app that requests user permissions to read SMS and call logs and sends this data to a backend server.
2. **Data Collection SDK (Dart)**: A self-contained Dart module that buffers, processes, and sends SMS and call log data to the backend.
3. **Backend API (FastAPI)**: A server that receives, logs, and processes data from the app.

---

## Architecture Diagram

![Architecture Diagram](https://github.com/priyasiripurapu002/data-collector-project/blob/main/Flutter.png) <!-- Include the diagram file here -->

### **Components**:
1. **Flutter App**:
   - Requests user permissions to access SMS and call logs.
   - Sends data to the Data Collection SDK.
   - Displays the status of permissions and a log of sent events.

2. **Data Collection SDK**:
   - Receives SMS and call logs.
   - Buffers non-transactional events and sends them in batches of 50.
   - Immediately sends **transactional** SMS (OTP, payment notifications, etc.) to the backend.

3. **Backend API (FastAPI)**:
   - Receives event data via a POST request to `/v1/events`.
   - Logs the received data and confirms the receipt with a response.

---

## Functional Requirements

### Part 1: The Minimalist Backend API
- **Endpoint**: `POST /v1/events`
- **Functionality**: Logs the received data to the console or a file/database.

### Part 2: The Data Collection SDK
- **Buffering**: Holds events in memory and sends them when the buffer reaches 50 items.
- **Transactional SMS Detection**: Detects transactional SMS based on keywords like "OTP", "transaction", etc., and sends them immediately.
- **Intelligent Sending**: Non-transactional SMS and call logs are added to the buffer and sent in batches.

### Part 3: The Flutter Application
- Requests permissions to access SMS and call logs.
- Sends the events to the Data Collection SDK.
- Displays minimal UI showing:
  - The current status of the required permissions (Granted/Denied).
  - A simple log view that shows when an event is being passed to the SDK (e.g., "Sent SMS #123 to SDK," "Sent Call Log #45 to SDK").

---

## Getting Started

### 1. Clone the Repository

Clone the repository to your local machine:

```
git clone https://github.com/your-username/data-collector-project.git
cd data-collector-project
```



### 2. Set Up the Backend
#### Install dependencies:

- Navigate to the backend folder and install the required dependencies:
  
```
cd backend
pip install -r requirements.txt
```

#### Run the Backend Server:

- Start the FastAPI server with the following command:

```
uvicorn main:app --reload
```

- The backend will now be running on http://127.0.0.1:8000.

### 3. Set Up the Flutter App
- Install Flutter Dependencies:

- Navigate to the app folder and install Flutter dependencies:

```
cd app
flutter pub get
```

- Run the Flutter App:

- If you want to run the app on the web, use:
  
```
flutter run -d chrome
```

#### Permissions:

The app will request permissions to access SMS and call logs on Android/iOS. Since Im testing on Chrome (web), this won't actually request permissions, but it simulates the process.

## SDK Design & Logic
### Public Interface:

- trackSMSEvent: Adds SMS events to the buffer or sends them immediately if they are transactional.

- trackCallEvent: Adds call log events to the buffer.

## Internal Logic:
- Buffering: Non-transactional events are stored in memory, and once 50 items are collected, they are sent in a batch.

- Transactional SMS Detection: SMS containing keywords like "OTP", "transaction", etc., are sent immediately.

- Batching: Once 50 events are buffered, all events are sent in a batch to the backend.

### Conclusion
This project demonstrates how data can be collected from mobile devices, processed intelligently, and sent to a backend API. The Flutter app, Data Collection SDK, and Backend API work seamlessly together to provide a comprehensive solution.
