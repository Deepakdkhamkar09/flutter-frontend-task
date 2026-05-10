pipeline {
    agent any

    environment {
        FLUTTER_HOME = "D:\\flutter"
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