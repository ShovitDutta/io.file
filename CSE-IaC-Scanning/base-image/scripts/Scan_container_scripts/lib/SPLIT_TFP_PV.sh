
SPLIT_TFP_PV ()
{
     cld=${1:-NONE}
     key_file=${2:-NONE}
     
     
     if [ "${cld}" == NONE ]; then
         echo "INFO: Usage- $0 cloud (gcp|azure) key_file. cloud missing."
         exit 100
     fi   
          
     if [ "${dir}" == NONE ]; then
         echo "INFO: Usage- $0 cloud (gcp|azure) key_file. key_file missing"
         exit 100
     fi      
             
          
     case "${cld}" in
     "azure") 
                  ECHO "INFO: FILE_PROCESSING ${key_file}"
                  ECHO "INFO: JQ_PROCESS cat ${key_file} | jq '.[]|.tags_already_set|select(.!=null)|values|select(.applicationname)' |grep -v \"^\{\}$\" | tr '\n' ' ' | sed 's/ //g' | sed \"s/}{/},{/g\" | sed 's/$/\n/' | sed 's/^/[/' | sed 's/$/]/' | sed \"s/},{/},\n{/g\"  | jq '.|sort'| grep -v createdondate | jq '.|unique|sort|values|select(.[].applicationname)|.[]' 2>/dev/null | jq -n 'input' 2>/dev/null"

                  cat ${key_file} 2>/dev/null | jq '.[]|.tags_already_set|select(.!=null)|values|select(.applicationname)' |grep -v "^\{\}$" | tr '\n' ' ' | sed 's/ //g' | sed "s/}{/},{/g" | sed 's/$/\n/' | sed 's/^/[/' | sed 's/$/]/' | sed "s/},{/},\n{/g"  | jq '.|sort'| grep -v createdondate | jq '.|unique|sort|values|select(.[].applicationname)|.[]' 2>/dev/null | jq -n 'input' 2>/dev/null

          
                  ECHO "INFO: FILE_PROCESSING ${all}"
                    ;;
     "gcp")
                  ECHO "INFO: FILE_PROCESSING ${key_file}"
                  ECHO "INFO: JQ_PROCESS cat ${key_file} |  jq '.[]|.tags_already_set|select(.!=null)|values|select(.applicationid)' |grep -v \"^\{\}$\" | tr '\n' ' ' | sed 's/ //g' | sed \"s/}{/},{/g\" | sed 's/$/\n/' | sed 's/^/[/' | sed 's/$/]/' | sed \"s/},{/},\n{/g\"  | jq '.|sort'| grep -v createdondate | jq '.|unique|sort|values|select(.[].applicationid)|.[]' 2>/dev/null | jq -n 'input' 2>/dev/null"       

          
                  cat ${key_file} 2>/dev/null | jq '.[]|.tags_already_set|select(.!=null)|values|select(.applicationid)' |grep -v "^\{\}$" | tr '\n' ' ' | sed 's/ //g' | sed "s/}{/},{/g" | sed 's/$/\n/' | sed 's/^/[/' | sed 's/$/]/' | sed "s/},{/},\n{/g"  | jq '.|sort'| grep -v createdondate | jq '.|unique|sort|values|select(.[].applicationid)|.[]' 2>/dev/null | jq -n 'input' 2>/dev/null

          
                  ECHO "INFO: FILE_PROCESSING ${key_file}"
                    ;;
      *)  
           ECHO "INFO: UNKNOWN CLOUD ${cld}"
           ;; 
    esac  
}

