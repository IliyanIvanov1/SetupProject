pipeline {
    agent { label 'mac' }

    options {
        timeout(time: 60, unit: 'MINUTES')
    }

    stages {
        stage('Checkstyle') {
            steps {
                echo 'Running swiftlint ...'
                sh """#!/bin/bash -l
                # In case you don't want to run pod install - commit your pods into the repository, otherwise pod install is needed
                pod install
                """
            }
        }
    }
}
