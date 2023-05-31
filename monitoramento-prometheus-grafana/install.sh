#/bin/sh

source .env

COMMON=${COMMON:-values.yaml}
RELEASE_NAME=${RELEASE_NAME:-monitoring}

echo "Instalando com values do arquivo ${COMMON} com release name de $RELEASE_NAME..."

helm upgrade $RELEASE_NAME --values "${COMMON}" ${1:+--values "$1"} --namespace $NAMESPACE --create-namespace \
    --install --debug --cleanup-on-fail .
