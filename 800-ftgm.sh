#!/bin/bash

svcadm disable dcm4chee

IP=`grep ${ZONENAME} /etc/inet/hosts | awk '{print $1}'`
sed "/${ZONENAME}/d" /etc/inet/hosts > /etc/inet/hosts.tmp
echo "${IP}"$'\t'"${HOSTNAME}" >> /etc/inet/hosts.tmp
mv /etc/inet/hosts.tmp /etc/inet/hosts

echo nameserver 10.xx.xx.xx > /etc/resolv.conf
echo nameserver 10.xx.xx.xx >> /etc/resolv.conf

MYSQL_SERVER=$(mdata mysql_server)
MYSQL_ADM=$(mdata mysql_adm)
MYSQL_ADM_PWD=$(mdata mysql_adm_pwd)
DCM_AETITLE=$(mdata dcm_aetitle)
#DCM_ADM_PW=$(mdata dcm_adm_pw)

DCM_DB=${HOSTNAME}DB
DCM_DB_USR=${HOSTNAME}USR
DCM_DB_PWD=${HOSTNAME}PWD

mv /export/dcm4chee/server/default/data/xmbean-attrs/dcm4chee.web\@3Aservice\@3DWebConfig.xml /var/tmp
rm -rf /export/dcm4chee/server/default/data/xmbean-attrs/*

#find /export/dcm4chee/server/default -type f |xargs sed -i "s/DCM4SMARTOS1/${DCM_AETITLE}/g"

substitute_files=($(find /export/dcm4chee/server/default -type f | xargs \
  /usr/bin/egrep -l DCM4SMARTOS1 || true))

for file in ${substitute_files[@]}; do
  if sed -e "s/DCM4SMARTOS1/${DCM_AETITLE}/g" \
         ${file} > ${file}.tmp; then

    mv ${file}{.tmp,}
  fi
  rm -f ${file}.tmp
done

mysql -u${MYSQL_ADM} -p${MYSQL_ADM_PWD} -h ${MYSQL_SERVER} -e "create database ${DCM_DB}"

mysql -u${MYSQL_ADM} -p${MYSQL_ADM_PWD} -h ${MYSQL_SERVER} ${DCM_DB} -e "source /export/dcm4chee/sql/create.mysql.xtradb"

mysql -u${MYSQL_ADM} -p${MYSQL_ADM_PWD} -h ${MYSQL_SERVER} -e "grant all on ${DCM_DB}.* to ${DCM_DB_USR}@${IP} identified by '${DCM_DB_PWD}'"

mysql -u${MYSQL_ADM} -p${MYSQL_ADM_PWD} -h ${MYSQL_SERVER} ${DCM_DB} -e "UPDATE ae SET aet='${DCM_AETITLE}' WHERE aet='DCM4CHEE'"

DBCONF_FILE=/export/dcm4chee/server/default/deploy/pacs-mysql-ds.xml

sed "s/localhost/${MYSQL_SERVER}/" ${DBCONF_FILE} > ${DBCONF_FILE}.tmp

mv ${DBCONF_FILE}.tmp ${DBCONF_FILE}

sed "s/pacsdb/${DCM_DB}/" ${DBCONF_FILE} > ${DBCONF_FILE}.tmp

mv ${DBCONF_FILE}.tmp ${DBCONF_FILE}

sed "s/<user-name>pacs/<user-name>${DCM_DB_USR}/" ${DBCONF_FILE} > ${DBCONF_FILE}.tmp

mv ${DBCONF_FILE}.tmp ${DBCONF_FILE}

sed "s/<password>pacs/<password>${DCM_DB_PWD}/" ${DBCONF_FILE} > ${DBCONF_FILE}.tmp

mv ${DBCONF_FILE}.tmp ${DBCONF_FILE}

#sed "s/WebviewerNames\" type=\"java.lang.String\">none/WebviewerNames\" type=\"java.lang.String\">weasis/g"

mv /var/tmp/dcm4chee.web\@3Aservice\@3DWebConfig.xml /export/dcm4chee/server/default/data/xmbean-attrs/

#svcadm enable dcm4chee
