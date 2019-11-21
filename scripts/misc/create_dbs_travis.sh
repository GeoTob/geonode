#!/usr/bin/env bash

set -x

if [ "$BACKEND" = "geonode.geoserver" ]; then

	case $1 in
		"before_install")
			echo "Before install scripts"
			;;
		"before_script")
			echo "Setting up PostGIS Backend"
			export GEONODE_PROJECT_PATH=$TRAVIS_BUILD_DIR
      dropdb -h 127.0.0.1 -u runner template_postgis
      dropdb -h 127.0.0.1 -u runner geonode
      dropdb -h 127.0.0.1 -u runner geonode_data
      dropdb -h 127.0.0.1 -u runner upload_test
      dropdb -h 127.0.0.1 -u runner test_upload_test
      dropuser -h 127.0.0.1 -u runner geonode
      createuser -h 127.0.0.1 -u runner geonode -d -s
      psql --h 127.0.0.1 -u runner c "ALTER USER geonode WITH PASSWORD 'geonode';"
      createdb -h 127.0.0.1 -u runner template_postgis
      psql --h 127.0.0.1 -u runner d template_postgis -c 'CREATE EXTENSION postgis;'
      psql --h 127.0.0.1 -u runner d template_postgis -c 'GRANT ALL ON geometry_columns TO PUBLIC;'
      psql --h 127.0.0.1 -u runner d template_postgis -c 'GRANT ALL ON spatial_ref_sys TO PUBLIC;'
      psql --h 127.0.0.1 -u runner d template_postgis -c 'GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO geonode;'
      createdb --h 127.0.0.1 -u runner O geonode geonode
      createdb --h 127.0.0.1 -u runner T template_postgis -O geonode geonode_data
      createdb --h 127.0.0.1 -u runner T template_postgis -O geonode upload_test
			;;
		"after_script")
			;;
	esac
fi
