#!/bin/bash
end=$((SECONDS+10))

while [ $SECONDS -lt $end ]; do
  if command -v terraform &> /dev/null
  then
    echo "Terraform found"
    echo "Running: terraform init -upgrade"
    terraform init -upgrade
    exit 0
  fi
  sleep 1
done

echo "Terraform could not be found after 10 seconds"
exit 1