pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                echo "Hello World!"
            }
        }
    }
}

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
		}

		stage('Run test') {
		when { expression { BRANCH_NAME == "main" } } 
		steps {
			echo 'Running tests...'
			// Don't stop the pipeline if this step fails
			catchError {
				sh """#!/bin/bash -l
				# In cas pods are not committed
				pod install

				# Run lint lane that generates report html and junit files
				fastlane tests
				"""
			}
			junit allowEmptyResults: true, testResults: 'Fastlane/test_output/report.junit'
		}

		stage('Archive IPA and dSym files') {
			when { expression { BRANCH_NAME == 'main' } }
			steps {
				archiveArtifacts artefacts: '*dSYM.zip, *.ipa' // Archive the spa and dlsym files so they can be downloaded from Jenkins
			}
		}
	}
} 