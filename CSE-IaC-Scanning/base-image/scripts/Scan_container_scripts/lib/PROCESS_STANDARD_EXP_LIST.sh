
     declare -A ciss_standard_exception_ar
     veto_cvsid=$(echo "0.0.0.0")
     azure_exception=$(echo "0.0.0.0")
     gcp_exception=$(echo "0.0.0.0")
     aws_exception=$(echo "0.0.0.0")


cloud_based_global_exception ()
{

    echo "#INFO: TYPE DIRECT FN-NAME cloud_based_global_exception_${get_ucld}"
    case "${get_ucld}" in
            "AZURE")
                    if [ "${azure_exception}" == "1.1.1.1" ]; then
                         echo "#INFO: CLOUD_BASED_VETO. (${app_nm}) ALL_RULES_VIOLATION_EXCEPT. CLOUD=AZURE EXIT_CODE=0"
                         #exit 0
                         let final_exit_code=0
                    fi
                        ;;
            "GCP")
                    if [ "${gcp_exception}" == "2.1.1.1" ]; then
                         echo "#INFO: CLOUD_BASED_VETO. (${app_nm}) ALL_RULES_VIOLATION_EXCEPT. CLOUD=GCP EXIT_CODE=0"
                         let final_exit_code=0
                    fi
                        ;;
            "AWS")
                    if [ "${aws_exception}" == "3.1.1.1" ]; then
                         echo "#INFO: CLOUD_BASED_VETO. (${app_nm}) ALL_RULES_VIOLATION_EXCEPT. CLOUD=AWS EXIT_CODE=0"
                         let final_exit_code=0
                    fi
                        ;;
     esac
     
}
     
process_exception_global_list ()
{
     echo "INFO: TYPE DIRECT FN-NAME process_exception_global_list"
     ciss_standard_exception_ar=$(echo "${exception_process_cvsid_list}" | tr ',' '\n' | grep ".1.1.1" | tr '\n' ' ')
     number_of_exception_found=$(echo "${#ciss_standard_exception_ar[@]}")
     number_of_exception_found=${number_of_exception_found:-0}
     if [ ${number_of_exception_found} -gt 0 ]; then
         for all_exps in `echo "${ciss_standard_exception_ar[@]}"`
         do
            case "${all_exps}" in
            "0.1.1.1")
                        veto_cvsid=$(echo "0.1.1.1")
                        ;;
            "1.1.1.1")
                        azure_exception=$(echo "1.1.1.1")
                        ;;
            "2.1.1.1")
                        gcp_exception=$(echo "2.1.1.1")
                        ;;
            "3.1.1.1")
                        aws_exception=$(echo "3.1.1.1")
                        ;;
            *)
                        no_exception=$(echo "0.0.0.0")
                        ;;
            esac
         done
     fi
     echo "INFO: EXCEPTION_LIST_FROM_TB=(veto_cvsid=${veto_cvsid},azure_exception=${azure_exception},gcp_exception=${gcp_exception},aws_exception=${aws_exception})"
}
