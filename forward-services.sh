#!/usr/bin/env bash

namespace="${1:-"monitoring"}"

# Port forward services
kubectl --namespace "${namespace}" port-forward svc/prometheus-grafana 3000:80 &
kubectl --namespace "${namespace}" port-forward svc/alertmanager-operated 9093 &
kubectl --namespace "${namespace}" port-forward svc/prometheus-prometheus-oper-prometheus 9090 &
