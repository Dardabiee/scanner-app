# Scanner App

A multiple function scanner app that help you everyday.

---

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Make sure you have the following installed on your machine:

* **Flutter SDK**: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
* **Android Studio**: [https://developer.android.com/studio](https://developer.android.com/studio)
    * Ensure you have the **Flutter and Dart plugins** installed in Android Studio.
* **VS Code (Optional)**: [https://code.visualstudio.com/](https://code.visualstudio.com/)
    * Ensure you have the **Flutter and Dart extensions** installed.

### Installation

1.  **Clone this repository**:
    ```bash
      https://github.com/Dardabiee/scanner-app.git
    ```
    (Replace `username` and `your-project-name` with your repository information)

2.  Navigate to the project directory:
    ```bash
    cd your-project-name
    ```

3.  Run the following command to install all dependencies:
    ```bash
    flutter pub get
    ```

---

## Running the App on a Real Android Device

Follow these steps to run your application on a physical Android device.

### 1. Enable Developer Mode

You need to enable **Developer Options** and **USB Debugging** on your Android device. The steps can vary depending on the brand and Android version, but generally follow this pattern:

* Open **Settings** on your Android device.
* Scroll down and find **About phone**.
* Locate the **Build number** and tap it **7 times** in a row. You should see a message saying, "You are now a developer!"
* Go back to **Settings**, then navigate to **System** > **Developer options**.
* Find and enable **USB debugging**.

### 2. Connect the Device

* Connect your Android device to your computer using a USB cable.
* When connecting for the first time, you might see a dialog on your device asking if you want to allow **USB debugging**. Select **OK**.

### 3. Check the Device

* Open a terminal or Command Prompt.
* Run the following command to ensure your device is detected by Flutter:
    ```bash
    flutter devices
    ```
* You should see an output similar to this:
    ```
    1 connected device:
    SM-A520F (mobile) • 3100000000000 • android-arm64 • Android 11 (API 30)
    ```
    If your device is listed, you're all set.

### 4. Run the App

* Run the following command in your terminal or Command Prompt to run the app on the connected device:
    ```bash
    flutter run
    ```
* Flutter will build the application and install it on your device. This process may take a few minutes.
* Once complete, the app will automatically open on your device.
