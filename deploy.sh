#!/bin/bash

# Update static assets.
kubectl create configmap webapp-static-js-configmap --from-file app/build/static/js --dry-run=client -o yaml | kubectl replace -f -
kubectl create configmap webapp-static-css-configmap --from-file app/build/static/css --dry-run=client -o yaml | kubectl replace -f -
kubectl create configmap webapp-static-media-configmap --from-file app/build/static/media --dry-run=client -o yaml | kubectl replace -f -

# Force pod resync by updating an annotation and wait.
kubectl annotate --overwrite `kubectl get pods --selector app=webapp -o name` timestamp=`date +"%d/%m/%Y-%T"`
sleep 5

# Update public assets.
kubectl create configmap webapp-public-configmap --from-file app/build --dry-run=client -o yaml | kubectl replace -f -

# Force pod resync by updating an annotation.
kubectl annotate --overwrite `kubectl get pods --selector app=webapp -o name` timestamp=`date +"%d/%m/%Y-%T"`
