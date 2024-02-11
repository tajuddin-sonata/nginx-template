pipeline {
    agent {
        label 'jenkins-slave'
    }

    parameters {
        string(name: 'TEMPLATE_FILE_NAME', defaultValue: '', description: '''Template File Name
        dev-nginx-template.conf
        butterfly-nginx-template.conf
        ''')

        string(name: 'MODIFIED_FILE_NAME', defaultValue: '', description: '''Template File Name
        dev.conf
        butterfly.conf''')

        string(name: 'SERVER_NAME', defaultValue: '', description: '''Server Name
        dev-cca.cloud.247-inc.net
        dev-cca-247ci-butterfly.cloud.247-inc.net dev-cca-247ci-bjs.cloud.247-inc.net 247ci-bjs-dev-internal.cloud.247-inc.net 247ci-omni-dev-internal.cloud.247-inc.net
        ''')

        string(name: 'ROOT_DIRECTORY', defaultValue: '', description: '''Root Directory
        /opt/247ci-butterfly-dev-frontend
        /opt/247ci-dev-dev-frontend
        ''')

        string(name: 'API_FORWARD_PORT', defaultValue: '', description: '''API Forwarded-Port
        80
        ''')

        string(name: 'API_PROXY_PASS', defaultValue: '', description: '''API Proxy Pass
        http://127.0.0.1:9089/api/
        http://127.0.0.1:9088/api/
        ''')
        
        string(name: 'AUTH_FORWARD_PORT', defaultValue: '', description: '''AUTH Forwarded-Port
        80
        ''')

        string(name: 'AUTH_PROXY_PASS', defaultValue: '', description: '''AUTH Proxy Pass
        https://sso-247-inc.oktapreview.com/oauth2/aus14la6k8dMmd8pn0h8
        https://sso-247-inc.oktapreview.com/oauth2/aus14la6k8dMmd8pn0h8
        ''')

        string(name: 'TARGET_SERVER_DNS', defaultValue: '', description: '''Target server DNS or IP 
        20.40.49.121
        ''')

        string(name: 'TARGET_PATH', defaultValue: '', description: '''Target server path to deploy the code
        /etc/nginx/proxy-confs/
        ''')

        string(name: 'USER_NAME', defaultValue: '', description: '''Username of Target server.
        root
        ''')
    }

    // environment {
    //     TEMPLATE_FILE = "${params.TEMPLATE_FILE_NAME}"
    //     MODIFIED_FILE = "${params.MODIFIED_FILE_NAME}"
    // }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/tajuddin-sonata/nginx-template.git'
            }
        }

        stage('Generate Nginx Config') {
            steps {
                script {
                    def template = readFile(params.TEMPLATE_FILE_NAME)
                    sh """
                        echo "${template}" |
                        sed 's|\$SERVER_NAME|${params.SERVER_NAME}|g' |
                        sed 's|\$ROOT_DIRECTORY|${params.ROOT_DIRECTORY}|g' |
                        sed 's|\$API_FORWARD_PORT|${params.API_FORWARD_PORT}|g' |
                        sed 's|\$API_PROXY_PASS|${params.API_PROXY_PASS}|g' |
                        sed 's|\$AUTH_FORWARD_PORT|${params.AUTH_FORWARD_PORT}|g' |
                        sed 's|\$AUTH_PROXY_PASS|${params.AUTH_PROXY_PASS}|g' > ${params.MODIFIED_FILE_NAME}
                        cat "${params.MODIFIED_FILE_NAME}"

                    """
                }
            }
        }

        stage('copy the file to server') {
            steps {
                script {
                    echo "copying the file to the target server"
                    sh "scp -r ${params.MODIFIED_FILE_NAME} ${params.USER_NAME}@${params.TARGET_SERVER_DNS}:${params.TARGET_PATH}"
                }
            }
        }

    }
}