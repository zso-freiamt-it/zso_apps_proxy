#!/bin/bash
set -e
source ./.env
tmp=$(mktemp -d)
um() {
	set +e
	umount $tmp
	rm -rf $tmp
}
trap um EXIT
echo Mounting...
mount -t cifs -o rw,username=nuc,password=$NAS_PASSWORD //synoNAS/home/dumps\ zskarte $tmp
echo Dumping...
docker exec --env "PGPASSWORD=$POSTGRES_API_PASSWORD" --env "PGUSER=postgres" \
	postgresql-zskarte pg_dumpall > "$tmp/$(date '+strapi-dump-%Y-%m-%d_%H-%M-%S-boswil')"
