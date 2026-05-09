pipeline {
    agent any

    stages {

    

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