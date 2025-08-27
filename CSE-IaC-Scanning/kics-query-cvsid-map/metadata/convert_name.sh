#!/usr/bin/env sh

   cld=${1:-NONE}

   declare -A cloud

   cloud['aws']='aws'
   cloud['azure']='azure'
   cloud['gcp']='google'

   get_cloud=$(echo "${cloud[${cld}]}")
   get_cloud=${get_cloud:-NONE}
   if [ "${get_cloud}" != "NONE" ]; then
       root_dir=$(echo "/apps/custom/common/assets/queries/terraform/${cld}/passwords_and_secrets")
       cd ${root_dir}
       #cat regex_rules.json | jq . | tr '\n' '#' | sed 's/{#      "id":/{#      "id": \"XXXXX\"\,#\"remove\":/g' | tr '#' '\n' | grep -v remove  > regex_rules_ids_xxxxx.json
       cat regex_rules.json | jq . | tr '\n' '#' | sed 's/#      "name": "/#      "name": \"CN-00XX:/g' | tr '#' '\n' > regex_rules_ids_xxxxx.json
       buffer=$(cat regex_rules_ids_xxxxx.json | tr '\n' '#') 
       echo "INFO: buffer ${buffer}"
       read SSSSS
       #for all_uuids in `cat uuids.txt`
       for all in {1..36} #do fmt=$(printf "CN-%02d:" ${all}); echo "${fmt}";  done
       do
         fmt=$(printf "%02d" ${all})
         echo "INFO: Replacing name ${fmt}"
         echo "${buffer}" | sed  "s/00XX/00${fmt}/" > buffer.txt
         buffer=$(cat buffer.txt)
       done
       echo "${buffer}" | tr '#' '\n' > regex_rules_ids_${get_cloud}.json
       cd -
   else
        echo "INFO: cloud name required. $0 aws/azure/google"
        exit 100
   fi

