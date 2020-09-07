import yaml
import os
from os import path, listdir, mkdir
from shutil import copyfile, rmtree
from collections import deque
from datetime import datetime

NAMESPACE = 'owlvey'

class Repository:
    def __init__(self): 
        self.directory = None
        self.seed_deploy = []
        self.seed_service = []        
        self.seed_routes = []


def remove_folders():
    if os.path.exists('./cluster/stage_deploy'):
        rmtree('./cluster/stage_deploy', ignore_errors=True)
    if os.path.exists('./cluster/stage_services'):        
        rmtree('./cluster/stage_services', ignore_errors=True)
    if os.path.exists('./cluster/stage_routes'):        
        rmtree('./cluster/stage_routes', ignore_errors=True)

def parse_repositories():
    remove_folders()
    
    repositories = []
    for directory in [dI for dI in listdir('./cluster') if path.isdir(path.join('./cluster',dI))]:                        
        temp = Repository()
        temp.directory = path.join("./cluster",  directory, 'cluster')                                
        
        for target in [f for f in listdir(temp.directory) if f.startswith('deploy-')]:            
            if path.exists(path.join(temp.directory, target)):                
                temp.seed_deploy.append(path.join(temp.directory, target))                
        
        for target in [f for f in listdir(temp.directory) if f.startswith('service-')]:
            if path.exists(path.join(temp.directory, target)):
                temp.seed_service.append(path.join(temp.directory, target))
        
        for target in [f for f in listdir(temp.directory) if f.startswith('route-')]:
            if path.exists(path.join(temp.directory, target)):
                temp.seed_routes.append(path.join(temp.directory, target))               

        repositories.append(temp)        

    return repositories

def create_folders():
    if not os.path.exists('./cluster/stage_deploy'):
        mkdir('./cluster/stage_deploy')
    if not os.path.exists('./cluster/stage_services'):
        mkdir('./cluster/stage_services')
    if not os.path.exists('./cluster/stage_routes'):        
        mkdir('./cluster/stage_routes')

def execute_yaml(target):
    script = "{} \n".format(target)    
    return script


def generate_stage(repositories):
    create_folders()
    # script = execute_yaml("# generated at {}".format(datetime.now().isoformat()))    
    script = execute_yaml("kubectl create namespace owlvey \n")

    queue_stage = deque()
    # queue_stage.append(execute_yaml("# generated at {}".format(datetime.now().isoformat())))    
    queue_stage.append(execute_yaml("kubectl delete namespace owlvey \n"))

    for repository in repositories:
        for deploy in repository.seed_deploy:            
            _ , filename = path.split(deploy)
            copyfile(deploy, path.join('./cluster/stage_deploy', filename))        
            script += execute_yaml("kubectl apply -f ./stage_deploy/{} \n".format(filename))
            queue_stage.append(execute_yaml("kubectl delete -f ./stage_deploy/{} \n".format(filename)))
            
    for repository in repositories:
        for service in repository.seed_service:            
            _ , filename = path.split(service)
            copyfile(service, path.join('./cluster/stage_services', filename))        
            script +=  execute_yaml("kubectl apply -f ./stage_services/{} \n".format(filename))
            queue_stage.append(execute_yaml("kubectl delete -f ./stage_services/{} \n".format(filename)))
    
    for repository in repositories:
        for service in repository.seed_routes:            
            _ , filename = path.split(service)
            copyfile(service, path.join('./cluster/stage_routes', filename))        
            script +=  execute_yaml("kubectl apply -f ./stage_routes/{} \n".format(filename))
            queue_stage.append(execute_yaml("kubectl delete -f ./stage_routes/{} \n".format(filename)))
    
    drop_stage = ""
    while queue_stage:
        drop_stage += "\n" + queue_stage.pop()

    with open('./cluster/stage.bat', 'w+') as w:
        w.write(script)
    with open('./cluster/stage.bash', 'w+') as w:
        w.write(script)
    
    with open('./cluster/drop_stage.bat', 'w+') as w:
        w.write(drop_stage)
    with open('./cluster/drop_stage.bash', 'w+') as w:
        w.write(drop_stage)


def write_line(writer, target):
    writer.write('{} \n'.format(target))

def write_timeout(writer, timeout=5):
    # write_line(writer, 'TIMEOUT {}'.format(timeout))
    pass

def generate_cluster_builder():
    with open('./cluster/build.bat', 'w+') as w:
        for directory in [dI for dI in listdir('./cluster') if path.isdir(path.join('./cluster',dI))]:                        
            if path.exists("./cluster/{}/devops-build-local.bat".format(directory)):
                write_line(w, 'pushd {}'.format(directory))
                write_line(w, 'call ./devops-build-local.bat')
                write_line(w, 'popd')
            

def generate_cluster_script():
    with open('./cluster/cluster.bat', 'w+') as w:

        write_line(w, 'kubectl delete namespace {}'.format(NAMESPACE))
        write_timeout(w, 2)
        write_line(w, 'kubectl delete ingress-nginx {}'.format(NAMESPACE))
        write_timeout(w, 2)
        write_line(w, 'kubectl create namespace {}'.format(NAMESPACE))
        write_timeout(w, 2)
        for directory in [dI for dI in listdir('./cluster') if path.isdir(path.join('./cluster',dI))]:
            target_directory = './cluster/{}/cluster'.format(directory)            
            for file in [f for f in listdir(target_directory) if f.startswith('deploy-local')]:
                if path.exists("./cluster/{}/cluster/{}".format(directory, file)):
                    write_line(w, 'kubectl apply -n {} -f ./{}/cluster/{}'.format(NAMESPACE, directory, file))
                    write_timeout(w, 3)
        # write services 
        for directory in [dI for dI in listdir('./cluster') if path.isdir(path.join('./cluster',dI))]:
            target_directory = './cluster/{}/cluster'.format(directory)            
            for file in [f for f in listdir(target_directory) if f.startswith('service-local')]:
                if path.exists("./cluster/{}/cluster/{}".format(directory, file)):
                    write_line(w, 'kubectl apply -n {} -f ./{}/cluster/{}'.format(NAMESPACE, directory, file))
                    write_timeout(w, 3)
        
        write_timeout(w, 10)
        write_line(w, 'kubectl get pods -n {} -o wide'.format(NAMESPACE))
        write_line(w, 'kubectl get services -n {} -o wide'.format(NAMESPACE))
        write_line(w, 'kubectl get endpoints -n {} -o wide'.format(NAMESPACE))
        write_timeout(w, 10)
        # install gateways 
        for directory in [dI for dI in listdir('./cluster') if path.isdir(path.join('./cluster',dI))]:
            target_directory = './cluster/{}/cluster'.format(directory)            
            for file in [f for f in listdir(target_directory) if f.startswith('gateway-install')]:
                if path.exists("./cluster/{}/cluster/{}".format(directory, file)):
                    write_line(w, 'kubectl apply -f ./{}/cluster/{}'.format(NAMESPACE, directory, file))                    
                    
        write_timeout(w, 10)
        # write gateways         
        for directory in [dI for dI in listdir('./cluster') if path.isdir(path.join('./cluster',dI))]:
            target_directory = './cluster/{}/cluster'.format(directory)            
            for file in [f for f in listdir(target_directory) if f.startswith('gateway-local')]:
                if path.exists("./cluster/{}/cluster/{}".format(directory, file)):
                    write_line(w, 'kubectl apply -f ./{}/cluster/{}'.format(NAMESPACE, directory, file))
                    write_timeout(w, 3)                    
                    


if __name__ == "__main__":
    repositories = parse_repositories()    
    generate_stage(repositories)
    # generate_cluster_builder()
    # generate_cluster_script()

    volumenes = ['bifrost']

    files = [
                "./registry/registry-deploy-dev.yaml",
                "./registry/registry-service.yaml",
            ]
    gateways = [ "./gateway/owlvey-gateway.yaml"]

    