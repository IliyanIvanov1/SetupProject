/**
    This pipeline performs the following actions
    • Set timeout to 60 minutes
    • Set the needed parameters
    • Checkstyle iOS
    • Run tests
    • Build, sign and deploy to AppCenter - Compiles the iOS project and deploys to AppCenter
    • Build, sign and deploy to AppDistribution - Compiles the iOS project and deploys to TestFlight
    • Build, sign and deploy to TestFlight - Compiles the iOS project and deploys to TestFlight
    • Archive IPA and dSym files - archive the IPA and dsym files and upload them to Jenkins

    Branching structure:
    - qa   - builds the project and deploys to AppCenter
    - stage     - builds the project and deploys to AppDistribution
    - master    - builds the project and deploys to TestFlight
**/
pipeline {
    agent { label 'macos' }

    options {
        timeout(time: 60, unit: 'MINUTES')
        ansiColor('xterm')
    }

    parameters {
        string(name: 'appVersion', description: 'What appVersion version would you like to deploy (leave the default value, if not deploying to TestFlight)', defaultValue: '4.1.0')
    }

    stages {
        stage('Checkstyle iOS') {
            when { expression { BRANCH_NAME == 'qa' || BRANCH_NAME == 'stage' || BRANCH_NAME == 'main' || BRANCH_NAME.startsWith('PR-') } }
            steps {
                echo 'Running swiftlint iOS...'
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

        stage('Build, sign and deploy to AppCenter') {
            when { expression { BRANCH_NAME == 'qa' } }
            steps {
                echo 'Building, signing and deploying iOS...'
                sh """#!/bin/bash -l
                    # unlock keychain
                    security -v unlock-keychain -p "imperiamobile" "/Users/jenkins/Library/Keychains/login.keychain-db"

                    # update fastlane
                    gem update fastlane

                    # build and deploy for AppCenter
                    rm -rf Pods/ Podfile.lock
                    pod install --repo-update
                    fastlane deploy deploymentPlatform:'AppCenter' app_version:${params.appVersion} build_number:$BUILD_NUMBER

                    rm -rf ~/Library/Developer/Xcode/Archives/${new Date().format("yyyy-MM-dd")}/MLiTPDevelop*.xcarchive
                """
            }
        }

        stage('Build, sign and deploy to AppDistribution') {
            when { expression { BRANCH_NAME == 'stage' } }
            steps {
                echo 'Building, signing and deploying iOS...'
                sh """#!/bin/bash -l
                    # unlock keychain
                    security -v unlock-keychain -p "imperiamobile" "/Users/jenkins/Library/Keychains/login.keychain-db"

                    # update fastlane
                    gem update fastlane

                    # build and deploy for AppDistribution
                    rm -rf Pods/ Podfile.lock
                    pod install --repo-update
                    fastlane deploy deploymentPlatform:'AppDistribution' app_version:${params.appVersion} build_number:$BUILD_NUMBER

                    rm -rf ~/Library/Developer/Xcode/Archives/${new Date().format("yyyy-MM-dd")}/MLiTPStage*.xcarchive
                """
            }
        }


        stage('Build, sign and deploy to TestFlight') {
            when { expression { BRANCH_NAME == 'main' && params.appVersion != '4.1.0' } }
            steps {
                echo 'Building, signing and deploying iOS...'
                sh """#!/bin/bash -l
                    # unlock keychain
                    security -v unlock-keychain -p "imperiamobile" "/Users/jenkins/Library/Keychains/login.keychain-db"

                    # update fastlane
                    gem update fastlane

                    # build and deploy for TestFlight
                    rm -rf Pods/ Podfile.lock
                    pod install --repo-update
                    fastlane deploy deploymentPlatform:'TestFlight' app_version:${params.appVersion} build_number:$BUILD_NUMBER

                    rm -rf ~/Library/Developer/Xcode/Archives/${new Date().format("yyyy-MM-dd")}/MLiTP*.xcarchive
                """
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
