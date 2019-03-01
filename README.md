# azure-three-tier-service-concept

![alt text](https://raw.githubusercontent.com/vbrinza/azure-three-tier-service-concept/master/three_tier_service_architecture_concept.png)

General:
The concept supposes usage of cloud instances and it will work similar way with the services working inside contaienrs.

Details:
1. On scaling
The autoscaling group will make sure the instances are added/deleted depending on the load coming to the system in the respective period of time.
This permits the system to hold the incoming load and also takes care of the costs of the resources.

2. On backup
The databases are automatically backed up. The recovery of user data can happen into a separate database and extraction of the required data in the respective interval of time.

3. On migration
By having the infrastructure automation in place for all the components, it is possible to deploy the entire system in any other region by only migrating the data from the database.
Also the databases can have more slaves running in a separate region which will make the migration even more falwless.

4. On releases
The deployment of the new releases can happen by following principles like blue-green when the new release version will be deployed on a part of the instances and the old version will be decomissioned one by one.
This technique can be achieved very efficiently with Kubernetes implementation of deployments.

5. On monitoring
The monitoring, metrics and logging of the infrastructure and the services can be handled by native implementations of the concrete cloud solutions(AWS Cloudwatch, Azure Monitoring), by having an on premise impelementation of ELK or by using a 3rd party solution like Newrelic, Datadog, etc.

6. On multicloud support
By having the infrastructure setup done with tools like Terraform/Ansible/Puppet/Chef its possible to have separate code for different cloud providers.
