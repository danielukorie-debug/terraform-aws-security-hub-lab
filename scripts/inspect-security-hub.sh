#!/usr/bin/env bash

set -euo pipefail

export AWS_PAGER=""

REGION="us-east-1"

echo "======================================"
echo "AWS SECURITY HUB READ-ONLY ASSESSMENT"
echo "======================================"

echo
echo "===== 1. AWS IDENTITY ====="

aws sts get-caller-identity \
  --query '{Account:Account,Arn:Arn}' \
  --output table

echo
echo "===== 2. SECURITY HUB CONFIGURATION ====="

aws securityhub describe-hub \
  --region "$REGION" \
  --query '{HubArn:HubArn,AutoEnableControls:AutoEnableControls,ControlFindingGenerator:ControlFindingGenerator}' \
  --output table

echo
echo "===== 3. ENABLED SECURITY STANDARDS ====="

aws securityhub get-enabled-standards \
  --region "$REGION" \
  --query 'StandardsSubscriptions[].{StandardsArn:StandardsArn,Status:StandardsStatus}' \
  --output table

echo
echo "===== 4. SAMPLE FINDING SEVERITY SUMMARY ====="

aws securityhub get-findings \
  --region "$REGION" \
  --max-results 10 \
  --query 'Findings[].{Severity:Severity.Label,Workflow:Workflow.Status,RecordState:RecordState}' \
  --output table

echo
echo "SUCCESS: SECURITY HUB ASSESSMENT COMPLETED"
echo "READ-ONLY: NO AWS RESOURCES MODIFIED"
