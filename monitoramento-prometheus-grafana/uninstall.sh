#/bin/sh

source .env

helm uninstall $RELEASE_NAME --namespace $NAMESPACE --wait --debug

kubectl delete crd alertmanagerconfigs.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
kubectl delete crd probes.monitoring.coreos.com
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd thanosrulers.monitoring.coreos.com

echo -----------------------------------------
echo Valide e execute os seguintes commandos
echo -----------------------------------------

kubectl get ValidatingWebhookConfiguration -n $NAMESPACE | awk '/prometheus/{print $1}' | xargs -I {} echo kubectl delete ValidatingWebhookConfiguration/{}
kubectl get MutatingWebhookConfiguration -n $NAMESPACE | awk '/prometheus/{print $1}' | xargs -I {} echo kubectl delete MutatingWebhookConfiguration/{}

kubectl delete namespace $NAMESPACE
