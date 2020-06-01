Production Grade infrastructure based on AWS EKS to install Validator Node.

Requrements:

AWS IAM role with programmatic access

![AWS Diagram](https://github.com/SkySonR/freeton-infra/blob/master/FreeTON_EKSInfra.png?raw=true)

Deployment instruction: 

1. Deploy EKS cluster:

    eksctl create cluster -f aws/eks/cluster.yaml
    
    aws eks --region us-west-2 update-kubeconfig --name freeton-cluster

2. Create Network Load Balancer:

    Set Target Group to newly create EKS nodes 
    
    Set Listener Protocol to UDP
    
    Set Port to 30310

3. Set parameters to helm/values.yaml:

    NLB endpoint to env.MY_ADDR
    
    Stake value to env.STAKE
    
    AWS IAM access key to fluentd-cloudwatch.awsAccessKeyId
    
    AWS IAM secret key to fluentd-cloudwatch.awsSecretAccessKey

4. Write validator keys and address: 

    Add files/conf/keys{l,c,s}
    
    Add msig.keys.json
    
    Add <release-name>-freeton-node-0.addr
    
    Add client/client.pub, server/server.pub, liteserver/liteserver.pub

    Generation guide https://docs.ton.dev/86757ecb2/v/0/p/708260-run-validator/t/08f3ce

5. Deploy Helm chart for Validator Node

    helm dependencies update
    
    helm install node helm/freeton-node/

EC2 metrics/K8s Logs collected by FluentD to CloudWatch

TODO:

Validator node monitoring and dashboard

Alerts (logs/metrics)

Add TONTgBot

Add one button deployment script
