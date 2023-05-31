# Documentação GERAL Curso Método TEM
Documentação destinada aos alunos do método tem.

Maiores informações do curso:
[Link](https://eduardodornellessouza.kpages.online/nova-pagina-626e9513-19bf-4ced-a2c7-723f1e96cc6e)

## Terraform
[Link](https://developer.hashicorp.com/terraform/tutorials)

## Criando cluster Kubernetes na Azure
[Link](https://learn.microsoft.com/pt-br/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks)

## Criar um par de chaves SSH
Use o comando ssh-keygen para gerar arquivos de chave SSH pública e privada. Por padrão, esses arquivos são criados no diretório ~/.ssh. Você pode especificar um local diferente e uma senha opcional (frase secreta) para acessar o arquivo de chave privada. Se um par de chaves SSH com o mesmo nome existir no local especificado, esses arquivos serão substituídos.

```
ssh-keygen -m PEM -t rsa -b 4096
```

## Ferramenta operador Kubernetes - kubectl
[Link](https://kubernetes.io/releases/download/)

## Criar uma entidade de serviço
Ferramentas automatizadas que implantam ou usam os serviços do Azure, como o Terraform, sempre têm permissões restritas. Em vez de os aplicativos entrarem como um usuário com privilégio total, o Azure oferece as entidades de serviço.

O padrão mais comum é entrar interativamente no Azure, criar uma entidade de serviço, testar a entidade de serviço e, em seguida, usar essa entidade de serviço para autenticação futura (interativamente ou de seus scripts).

export MSYS_NO_PATHCONV=1

```
az ad sp create-for-rbac --name spn_aks_metodotem --role Contributor --scopes /subscriptions/dae6c8b4-a025-4ed1-85c4-9aed73f7eb6f
```

{
  "appId": "dcbbbd08-dc47-4628-8492-1563ddabeb9d",
  "displayName": "spn_aks_metodotem",
  "password": "f328Q~Uj8vdwpyvRNq46YHB1IU-n3WskXw_CuaQG",
  "tenant": "505bf011-8306-408f-afc5-cf8fc8c2927f"
}

## Iniciando a construção do projeto
```
terraform init -upgrade
terraform plan -out main.tfplan
terraform apply main.tfplan
echo "$(terraform output resource_group_name)"
```
## Conectando no cluster
```
az account set --subscription dae6c8b4-a025-4ed1-85c4-9aed73f7eb6f
az aks get-credentials --resource-group rg-adjusted-crane --name k8stest
```
## Criando load balancer
[Link](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/)
[Link](https://learn.microsoft.com/en-us/azure/aks/ingress-basic?tabs=azure-cli)

Um controlador de entrada é um software que fornece proxy reverso, roteamento de tráfego configurável e terminação TLS para serviços Kubernetes. 
```
export NAMESPACE=ingress-basic

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace \
  --namespace $NAMESPACE \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz
```

## Deploy aplicação (wordpress) manualmente usando Helm
Criando namespace:
```
    $ kubectl create namespace wordpress
```
Navegar até onde fica a pasta "wordpress"
```
    $ helm upgrade -i wordpress ./wordpress -f ./wordpress/values.yaml -n wordpress
```
Acessando wordpress:
    $ user: user
    $ senha: echo Password: $(kubectl get secret --namespace wordpress wordpress -o jsonpath="{.data.wordpress-password}" | base64 -d)
Ajustando tráfego | balanceador de carga | service | ingress:
```
    $ helm upgrade wordpress ./wordpress -f ./wordpress/values.yaml -n wordpress
```

## Deploy aplicação NODE - imagem da aula Docker
Copiar especificação de deploy do site oficial: 
    [Link](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
Ajustar deployment com a imagem gerada na aula Docker: eduardods/app-node-tem:latest

Criando namespace para aplicação NODE
```
  $ kubectl create namespace app-node
```

Criando deploy:
```
  $ kubectl apply -f deployment.yaml -n app-node
```

Criando service: 
  [Link](https://kubernetes.io/docs/concepts/services-networking/service/)
```
  $ kubectl apply -f service.yaml -n app-node
```
Criando ingress:
  [Link](https://kubernetes.io/docs/concepts/services-networking/ingress/)
```
  $ kubernetes % kubectl apply -f ingress.yaml -n app-node
```
## Azure Devops - Primeiro pipeline
```
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

az login --service-principal -u dcbbbd08-dc47-4628-8492-1563ddabeb9d -p f328Q~Uj8vdwpyvRNq46YHB1IU-n3WskXw_CuaQG --tenant 505bf011-8306-408f-afc5-cf8fc8c2927f

az account set --subscription dae6c8b4-a025-4ed1-85c4-9aed73f7eb6f

az aks get-credentials --resource-group rg-adjusted-crane --name k8stest
```

## Criar container registry
Navegar até o resource group onde está o AKS e criar um Container Registry
Gerar chaves para acesso

Conectar:
```
  $ docker login acrcursometodotem01.azurecr.io
  $ Username: acrcursometodotem01
  $ Password: CU5rjaj72WeLTRqcBm8EVhIQDpi6K9vOAVmmsBTjmr+ACRBiy6Za
```
## Criar a VMSS
Criar Conjunto de escalas da máquina virtual (vmss) no mesmo resource group do AKS.

## Esteiras DevOps
Criar service connection com o AKS utilizando o service principal
Criar Agent Pool com a VMSS criada no passo anterior
Criar repositórios para organização da documentação e do código fonte:
  $ wordpress
  $ app-node-app
  $ iac_aks_terraform
  $ metodotem


## Configurar agente para rodar Docker
[Link](https://docs.docker.com/engine/install/ubuntu/)

```
echo "curl -fsSL https://get.docker.com -o get-docker.sh"
echo "sudo chmod 777 get-docker.sh"
echo "sudo ./get-docker.sh"

sudo chmod 777 /var/run/docker.sock
```