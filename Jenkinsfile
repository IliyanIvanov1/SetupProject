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
} 