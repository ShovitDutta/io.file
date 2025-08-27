ECHO ()
{
    #echo "INFO: TYPE OPT-INDIRECT FN-NAME ECHO"

    choice=$(echo "${verbose_level_hash[${scan_verbose_level}]}")
    choice=${choice:-NONE}
    case "${choice}" in

    "all")
           echo "$1"
           ;;
    "error")
             ERROR_ONLY=$(echo "${1}" |  grep "^ERROR")
             ERROR_ONLY=${ERROR_ONLY:-NONE}
             if [ "${ERROR_ONLY}" != "NONE" ]; then
                  echo "${1}"
             fi
                 ;;
    "err")
             ERROR_ONLY=$(echo "${1}" |  grep "^ERROR")
             ERROR_ONLY=${ERROR_ONLY:-NONE}
             if [ "${ERROR_ONLY}" != "NONE" ]; then
                  echo "${1}"
             fi
                 ;;
    "warn")
             WARN_ONLY=$(echo "${1}" |  grep "^WARN")
             WARN_ONLY=${WARN_ONLY:-NONE}
             if [ "${WARN_ONLY}" != "NONE" ]; then
                  echo "${1}"
             fi
                 ;;
    "info")
                  echo "${1}"
                 ;;
    "NONE")
               echo "${1}"
               ;;
    *)
                 echo "${1}"
                 ;;
    esac
}
