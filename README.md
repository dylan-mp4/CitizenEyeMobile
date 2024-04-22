# Citizen Eye Mobile - FYP

Frontent application that uploads videos and recieves data back from API, customizeable server endpoint

## Pre-requisites 
The application is intended to run on Android devices, therefore an emulator such as Android studio needs to be running

Alternatively the build apk can be installed to an android device.
## Installation

```bash
# Clone the repository
git clone https://github.com/dylan-mp4/CitizenEyeMobile.git

# Navigate to the project directory
cd CitizenEyeMobile

# Install dependencies
flutter pub get

# Run the project
flutter run
```
## API Reference

#### Upload File

```http
  POST /upload
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `file` | `video` | **Required**. video to be processed |
| `start_latitude` | `string` | **Optional**. starting GPS lat |
| `start_longitude` | `string` | **Optional**. starting GPS lon |
| `end_latitude` | `string` | **Optional**. ending GPS lat |
| `end_longitude` | `string` | **Optional**. ending GPS lon |

### Returns
| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `licence_plate` | `string` | Licence plate text |
| `score` | `number(float)` | decimal score / confidence of plate being correct |
| `car_image` | `string` | Base64 represented image includes starting header |
| `start_latitude` | `string` | **Optional**. starting GPS lat |
| `start_longitude` | `string` | **Optional**. starting GPS lon |
| `end_latitude` | `string` | **Optional**. ending GPS lat |
| `end_longitude` | `string` | **Optional**. ending GPS lon |


## Author
- [@dylan-mp4](https://github.com/dylan-mp4)
