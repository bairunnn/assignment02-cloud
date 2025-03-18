# Fix postgres installation
brew install postgresql
createuser -s postgres
brew services restart postgresql

# Install PostGIS
brew install postgis

# Connect to PostgreSQL
psql -U postgres

# Quit psql shell
\q

# Load phl.pwd_parcels
ogr2ogr \
    -f "PostgreSQL" \
    PG:"host=localhost port=5432 dbname=assignment2byron user=postgres password=7777" \
    -nln phl.pwd_parcels \
    -nlt MULTIPOLYGON \
    -t_srs EPSG:4326 \
    -lco GEOMETRY_NAME=geog \
    -lco GEOM_TYPE=GEOGRAPHY \
    -overwrite \
    "/Users/bairun/Documents/GitHub/course-info-spring-2025/assignment2-local/PWD_PARCELS/PWD_PARCELS.shp"


# Load phl.neighborhoods
ogr2ogr \
    -f "PostgreSQL" \
    PG:"host=localhost port=5432 dbname=assignment2byron user=postgres password=7777" \
    -nln phl.neighborhoods \
    -nlt MULTIPOLYGON \
    -lco GEOMETRY_NAME=geog \
    -lco GEOM_TYPE=GEOGRAPHY \
    -overwrite \
    "/Users/bairun/Documents/GitHub/course-info-spring-2025/assignment2-local/philadelphia-neighborhoods.geojson"

# Load census.blockgroups_2020
ogr2ogr \
    -f "PostgreSQL" \
    PG:"host=localhost port=5432 dbname=assignment2byron user=postgres password=7777" \
    -nln census.blockgroups_2020 \
    -nlt MULTIPOLYGON \
    -t_srs EPSG:4326 \
    -lco GEOMETRY_NAME=geog \
    -lco GEOM_TYPE=GEOGRAPHY \
    -overwrite \
    "/Users/bairun/Documents/GitHub/course-info-spring-2025/assignment2-local/tl_2020_42_bg/tl_2020_42_bg.shp"



