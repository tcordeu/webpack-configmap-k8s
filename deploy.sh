#!/bin/bash

# Update static assets.
function update_assets {
    for asset in js css media
    do
        kubectl create configmap webapp-static-$asset-configmap --from-file app/build/static/$asset --dry-run=client -o yaml | kubectl replace -f -
    done
}

# Update public assets.
function update_public {
    kubectl create configmap webapp-public-configmap --from-file app/build --dry-run=client -o yaml | kubectl replace -f -
}

# Force pod resync by updating an annotation and wait.
# See: https://github.com/kubernetes/website/pull/18082/files
function sync_pod {
    kubectl annotate --overwrite `kubectl get pods --selector app=webapp -o name` timestamp=`date +"%d/%m/%Y-%T"`
    sleep 5
}

update_assets && sync_pod
update_public && sync_pod
