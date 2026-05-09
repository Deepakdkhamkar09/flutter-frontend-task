pipeline {
    agent any

    stages {

        stage('Clone Repository') {
            steps {
                git 'https://github.com/Deepakdkhamkar09/flutter-frontend-task.git'
            }
        }

        stage('Flutter Pub Get') {
            steps {
                bat 'C:\\Users\\Lenovo\\fvm\\default\\bin\\flutter.bat pub get'
            }
        }

        stage('Build APK') {
            steps {
                bat 'C:\\Users\\Lenovo\\fvm\\default\\bin\\flutter.bat build apk --release'
            }
        }
    }
}