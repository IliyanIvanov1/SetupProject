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
    }
}
