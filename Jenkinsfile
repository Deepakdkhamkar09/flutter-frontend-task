pipeline {
    agent any

    environment {
        FLUTTER_HOME = "D:\\Flutter\\flutter_windows_3.41.9-stable\\flutter"

    }

    stages {

        stage('Flutter Doctor') {
            steps {
                bat '"%FLUTTER_HOME%\\bin\\flutter.bat" doctor'
            }
        }

        stage('Flutter Pub Get') {
            steps {
                bat '"%FLUTTER_HOME%\\bin\\flutter.bat" pub get'
            }
        }

        stage('Build APK') {
            steps {
                bat '"%FLUTTER_HOME%\\bin\\flutter.bat" build apk --release'
            }
        }
    }
}