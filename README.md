# PictsManager

a mobile application and a server which takes and stores pictures. It allow the user to perform a variety of actions on the database.

## Technology used

Our Application is written in Dart using Flutter to work on mobile platforms. The advantages of using Flutter are that we can target both Android and iOS. Dart is simpler, more flexible. Flutter also has many different libraries which can be used to boost development, and are very easy to install and use in a project. Furthermore, we wanted to discover Cross Platform development, as we have a background in native app development.

## Building 🛠

To build the project locally, you will need docker, docker-compose.

To start the server and build the apk just run `docker-compose up --build` and the apk will be generated at `mobile/build/app/outputs/apk/release/app-release.apk`

## Deploying 🛫

The project is automatically deployed to a VPS instance by the Github Action 🤖

When you push on `develop`, an action is running in order to deploy the new versions on the dev environment (https://pic-dev.courthias.space)

When you push on `main`, an action is running in order to deploy the new versions on the prod environment (https://pic.courthias.space)

## Documentation 🗂

You can find the documention inside the `documentations` folder. API documentation will need to be open in Postman.
