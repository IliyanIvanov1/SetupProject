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

                # Run lint lane which generates the report xml file
                fastlane lint
                """
                junit allowEmptyResults: true, testResults: 'swiftlint_report.xml'
            }
        }

	    stage('Run tests') {
            steps {
                echo 'Running tests...'
                // Don't stop the pipeline if this step fails
                catchError {
                    sh """#!/bin/bash -l
                    # In case you don't want to run pod install - commit your pods into the repository, otherwise pod install is needed
                    pod install

                    # Run lint lane which generates the report html and junit files
                    fastlane tests
                    """
                }
                junit allowEmptyResults: true, testResults: 'fastlane/test_output/report.junit'
            }
        }
    }
}
