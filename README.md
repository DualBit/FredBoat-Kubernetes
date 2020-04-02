# FredBoat-Kubernetes
[FredBoat](https://github.com/Frederikam/FredBoat) Discord Bot on Kubernetes

#### Components:
* PostgreSQL  - Quarterdeck's database
* RabbitMQ    - Brokers messages between FredBoat and Sentinel
* Lavalink    - Processes and streams music to Discord voice servers. Controlled by FredBoat
* Quarterdeck - Persistence layer. Handles SQL and caching.
* Sentinel    - Receives events from Discord and forwards them to FredBoat. FredBoat can request more data or submit requests
* FredBoat    - Controls everything, runs commands, queues music, etc

## How to create FredBoat yaml for your k8s cluster
* Run ``pip3 install -r requirements.txt``
* Run ``python3 create_custom.py -n *name* -k *dt* -y *gyk*`` with required arguments
* Check and modify the generated .yaml files if needed
* ⚠️ Modify ``k8s_fredboat_*name*/postgres/volume_claim.yaml`` to match the correct CSI driver
* Optional: Regenerate full.yaml file from .yaml files with 
  * ``python3 regenerate_full_yaml.py -n *name*``
* Use ``kubectl -f apply`` or other tools to deploy single .yaml files or full.yaml

## TODO
* ~~Implement component dependency (FredBoat require Quarterdeck, ...)~~
* Implement all available configuration options
* Add sentinel config file with port configuration
* Add rabbitmq user, pass and port configuration
