from diagrams import Cluster, Diagram, Edge
from diagrams.onprem.client import User
from diagrams.k8s.infra import Master
from diagrams.k8s.infra import Node
from diagrams.k8s.infra import ETCD
from diagrams.gcp.network import NAT
from diagrams.gcp.compute import GCE
from diagrams.onprem.iac import Terraform
from diagrams.onprem.ci import GitlabCI
from diagrams.onprem.cd import Spinnaker 
from diagrams.onprem.monitoring import Grafana
from diagrams.onprem.monitoring import Prometheus
from diagrams.gcp.network import FirewallRules

with Diagram("Architecture cible de l'infrastructure", show=True):
    user = User("DevOps team")
    IaC= Terraform("")

    with Cluster("VPC Network"):
        with Cluster("Region: us-central1"):
            with Cluster("Zone: us-central1-c"):
                with Cluster("Subnet Publique"):
                    Pub_sub= GCE("Bastion: 192.168.0.3") 
                Frw= FirewallRules("Firewall bastion")
                Pub_ip= GCE("External IP 34.72.201.29") 

                with Cluster("Subnet Privé"):
                    k8s_node=ETCD("")
                    k8s_node = Master("10.2.0.2")
                    k8s_node - Edge(style="bold", label="kubelet") -[Node("10.2.0.4"),
                            Node("10.2.0.3")]
            
    
    
    Pub_sub << Frw << Pub_ip
    user >> IaC >> k8s_node
    
    k8s_node << Pub_sub

    
    
    
    
    



   
