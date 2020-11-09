#!/bin/sh
set -o errexit
echo "this will purge all containers, even those unassociated with this project. this is a terrible idea "
read -p "purge all containers? " -n 1 -r
echo    
if [[ $REPLY =~ ^[Yy]$ ]]
then

	for container in $(buildah containers -n --format "{{.ContainerID}}");
	do
		 buildah rm ${container};
	done

	for container in $(podman container list --all --format "{{.ID}}");
	do
		podman container rm ${container};
	done

	podman images prune
	rm -f $(pwd)/persistent/env/*.env
fi
