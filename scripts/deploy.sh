#!/usr/bin/env bash
if [ "$1" == "" ]
then
  echo "Please provide the path to the application archive."
  exit 1
fi

if [ ! -z "`cf m | grep "p\.config-server"`" ]; then
  export service_name="p.config-server"
elif [ ! -z "`cf m | grep "p-config-server"`" ]; then
  export service_name="p-config-server"
else
  echo "Can't find SCS Config Server in marketplace. Have you installed the SCS Tile?"
  exit 1;
fi

echo -n "Creating Config Server..."
{
  cf create-service -c '{ "git": { "uri": "https://github.com/cailalex/config-server-example", "label": "master" } }' ${service_name} standard cook-config-server
} &> /dev/null
until [ `cf service cook-config-server | grep -c "succeeded"` -eq 1  ]
do
  echo -n "."
done
echo
echo "Config Server created. Pushing application."
cf push -p "$@"
echo "Done!"
