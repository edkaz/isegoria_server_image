##Usage

1. Crate ./binary in this directory. Put dbInterface-0.1.0.war into ./binary

2. Build image via: ``$ docker build -t 45.113.234.214:5000/isegoria_server:0.1.0  --build-arg 'Neo4j_PWD=X8+Q4^9]1715q|W' .``

3. Run image via: ``$ docker run -d --network host --name isegoria_server -e "INSTITUTION=UniMelb" -e "CAMPUS=parkville" -v /mnt/docker:/mnt/data 115.146.95.30:5000/isegoria_server:0.1.0``

###Note

- 115.146.95.30 is the url of my docker repository. It can be changed to others

- -e "INSTITUTION=UniMelb" -e "CAMPUS=parkville" are runtime variable. It can be used to setup institution name and its campus

- Neo4j CLI client: ``$ cypher-shell -u neo4j -p 'X8+Q4^9]1715q|W'``



docker pull 115.146.95.30:5000/isegoria_server:0.1.0


### Export data
``CALL apoc.export.csv.query("match (u:User) where u.accountVerified=TRUE return u.email as email, u.givenName as firstName, u.familyName as familyName, u.accountVerified as verified", "verifiedUser.csv", {})``


