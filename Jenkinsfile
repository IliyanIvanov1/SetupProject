pipeline {
        agent { label 'mac' }
    
   	options {
  	    timeout(time: 60, unit: 'MINUTES')
  	}

	stages {
		stage('Checkstyle') {
			when { expression { BRANCH_NAME == 'main' } }
			steps {
				echo 'Running swiflint ...'
				sh """#!/bin/bash -l
				
				# In case pods are not committed
				pod install

				# Run lint lane that generates report xml file
				fastlane lint
				"""
				unit allowEmptyResults: true, testResults: 'SwiftLint_report.xml'
			}
		echo 'Hello'
		}
	}
} 