#
# Image for Isegoria dbinterface API and Neo4j graph database
#
FROM ubuntu:16.04
LABEL maintainer="Yikai Gong - yikaig@student.unimelb.edu.au"

ARG InstitutionName=Institution
ARG CampusName=Campus

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV TOMCAT_VERSION=8.5.23
ENV JENKINS_VERSION=2.73.3
ENV NEO4J_VERSION=3.1.3

RUN apt-get update && apt-get install -y software-properties-common \
    openssh-client curl sudo vim net-tools locales python3-software-properties \
    tar unzip openjdk-8-jdk git maven

# Setup local specific information for encoding
RUN locale-gen "en_AU.UTF-8"
ENV LANG="en_AU.UTF-8"
ENV LANGUAGE="en_AU:en"
ENV LC_ALL="en_AU.UTF-8"

## ====== Install Neo4j =========
ENV NEO4J_HOME=/opt/neo4j
ENV NEO4J_DATA_DIR=/mnt/data
ADD binary /opt
RUN cd /opt && tar -zxf neo4j-enterprise-${NEO4J_VERSION}-unix.tar.gz && \
    ln -s /opt/neo4j-enterprise-${NEO4J_VERSION} ${NEO4J_HOME} && \
    rm /opt/neo4j-enterprise-${NEO4J_VERSION}-unix.tar.gz && \
    mkdir -p ${NEO4J_DATA_DIR} && echo "dbms.directories.data=${NEO4J_DATA_DIR}" >> ${NEO4J_HOME}/conf/neo4j.conf
ENV PATH ${PATH}:${NEO4J_HOME}/bin

## ====== Install API =========
ARG Neo4j_PWD=X8+Q4^9]1715q|W
ENV NEO4j_PWD=${Neo4j_PWD}
ENV INSTITUTION=${InstitutionName}
ENV CAMPUS=${CampusName}
ENV API_HOME=/opt/dbinterface
RUN mkdir -p ${API_HOME} && mv /opt/dbInterface-0.1.0.war ${API_HOME}
ADD config ${API_HOME}
RUN sed -i -e "s/^spring.data.neo4j.username=.*$/spring.data.neo4j.username=neo4j/g" ${API_HOME}/application.properties && \
    sed -i -e "s/^spring.data.neo4j.password=.*$/spring.data.neo4j.password=${Neo4j_PWD}/g" ${API_HOME}/application.properties


## ==================== Setup scripts ================================
ENV SCRIPT_BASE=/root
ADD script/startup.sh ${SCRIPT_BASE}
ENV PATH ${PATH}:${SCRIPT_BASE}
RUN chmod +x ${SCRIPT_BASE}/*.sh


ENTRYPOINT ["/root/startup.sh"]
#CMD ["/usr/lib/postgresql/9.5/bin/postgres", "-D", "/var/lib/postgresql/9.5/main", "-c", "config_file=/etc/postgresql/9.5/main/postgresql.conf"]