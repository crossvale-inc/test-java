#!groovy
import hudson.model.*


try {
	def branch = '';
	def source = '';
    node {
        stage('checkout-and-deploy') {
			sh "oc project test-java"
			//checkout the code and record the commit hash for easy traceability
			checkout scm
      		sh "git rev-parse HEAD > .git/commit-id"
      		def commit_id = readFile('.git/commit-id')
			
			//capture the branch name and keep it stored lower case
			branch = BRANCH_NAME.toLowerCase();
			source = BRANCH_NAME

			//if the branch is a feature, capture the branch name of the feature for shorter names
			if (branch.contains('/')){
				branch = branch.substring(branch.lastIndexOf("/") + 1)
			}

            // find any existing resources for this branch
            sh """oc get dc -l app='example-spring-boot-$branch' &> tempGetDC"""
            def existingDeploymentConfig = readFile('tempGetDC').trim()

            if(existingDeploymentConfig == "No resources found.") {
		//sh """oc create -f example-spring-boot-template.json"""
                sh """oc process -p NAME='example-spring-boot-$branch' -p SOURCE_REPOSITORY_URL=https://github.com/afeiszli/example-spring-boot-helloworld.git SOURCE_REPOSITORY_REF=$source -l app='example-spring-boot-$branch' java-jenkins-template | oc apply -f -"""
                sh """oc start-build example-spring-boot-$branch --from-dir=. -n test-java """
                openshiftVerifyBuild apiURL: '', bldCfg: """example-spring-boot-$branch""", checkForTriggeredDeployments: 'false', namespace: 'test-java', verbose: 'false'
                openshiftDeploy depCfg: """example-spring-boot-$branch""", verbose: 'false', namespace: 'test-java'
                openshiftVerifyDeployment depCfg: """example-spring-boot-$branch""", verbose: 'false', namespace: 'test-java'
            } else {
                sh """oc start-build example-spring-boot-helloworld-$branch --from-dir=. -n test-java """                
		openshiftDeploy depCfg: """example-spring-boot-$branch""", verbose: 'false', namespace: 'test-java'
                openshiftVerifyDeployment depCfg: """example-spring-boot-$branch""", verbose: 'false', namespace: 'test-java'
            }

        } 
    }
} catch (err) {
    echo "in catch block"
    echo "Caught: ${err}"
    currentBuild.result = 'FAILURE'
    throw err
}
