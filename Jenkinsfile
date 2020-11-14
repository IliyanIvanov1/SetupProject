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
                # Run pod install if pods are not committed
                pod install

                # Run lint lane which generates the report xml file
                fastlane lint
                """
            }
        }

	stage('Run tests') {
      	    steps {
         	echo 'Running tests...'
         	// Don't stop the pipeline if this step fails
         	catchError {
         	    sh """#!/bin/bash -l
            	    # Run pod install if pods are not committed
         	    pod install

                    # Run lint lane which generates the report xml file
                    fastlane tests
                    """
         	}
            }
        }

        stage('Build, sign and deploy to AppDistribution') {
            steps {
                echo 'Building, signing and deploying iOS...'
                sh """#!/bin/bash -l
		    # unlock keychain
		    security -v unlock-keychain -p "H@rizma3716" "/Users/iliyan.ivanov/Library/Keychains/login.keychain-db"

                    # update fastlane
                    gem update fastlane

                    # build and deploy for AppDistribution
                    rm -rf Pods/ Podfile.lock
                    pod install --repo-update
		    fastlane upload_to_firebase
                """
            }
        }
    }
}
