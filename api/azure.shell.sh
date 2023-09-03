az appservice plan create \
    --name recommerce-plan01 \
    --resource-group personal \
    --sku S1 \
    --is-linux

az webapp create \
    --resource-group personal \
    --plan recommerce-plan01 \
    --name recommerce-api-01 \
    --multicontainer-config-type compose \
    --multicontainer-config-file compose.yml