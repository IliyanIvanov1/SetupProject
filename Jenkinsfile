pipeline {
    agent { label 'mac' }

    options {
        timeout(time: 60, unit: 'MINUTES')
    }

    stages {
        stage('Checkstyle') {
            when { expression { BRANCH_NAME == 'main' } }
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
            when { expression { BRANCH_NAME.startsWith('PR-') } }
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

        stage('Archive IPA and dSym files') {
            when { expression { BRANCH_NAME == 'qa' || BRANCH_NAME == 'stage' || (BRANCH_NAME == 'main' && params.appVersion != '4.1.0') } }
            steps {
                archiveArtifacts artifacts: '*.dSYM.zip, *.ipa' // Archive the ipa and dsym files (if the deploymentChoise is other than 'None') so they can be downloaded from Jenkins
            }
        }
    }
}
