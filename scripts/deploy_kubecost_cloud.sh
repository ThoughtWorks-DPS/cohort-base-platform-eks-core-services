#!/usr/bin/env bash
set -e

export CLUSTER=$1
export KUBECOST_CLUSTER_ID=$(cat $CLUSTER.auto.tfvars.json | jq -r .kubecost_cluster_id)
export KUBECOST_NETWORK_COSTS_ENABLED=$(cat $CLUSTER.auto.tfvars.json | jq -r .kubecost_network_costs_enabled)

helm upgrade --install kubecost-cloud \
--repo https://kubecost.github.io/cost-analyzer/ cost-analyzer \
--namespace kubecost-cloud --create-namespace \
-f https://raw.githubusercontent.com/kubecost/cost-analyzer-helm-chart/develop/cost-analyzer/values-cloud-agent.yaml  \
--set imageVersion="lunar-sandwich.v0.0.13" \
--set cloudAgentKey=$KUBECOST_CLOUD_AGENT_KEY \
--set cloudAgentClusterId=$KUBECOST_CLUSTER_ID \
--set cloudReportingServer="collector.app.kubecost.com:31356" \
--set networkCosts.enabled=$KUBECOST_NETWORK_COSTS_ENABLED
