#DPC-Function chk_none_value -Definition Start
## this function will check for a given variable name, has vaule set or not
## if the variable is mandatory, it will exit with error code passed to this function
## else ECHO to screen about the status.( Valid). for security purpose
## no value of the variable is ECHOed to screep, only it name.
## parameters are variable value, error code, to exit or not
## example chk_none_value "E" "$SNYK_TOKEN" "snyn_token" "100"

chk_none_value ()
{
    ECHO "INFO: TYPE OPT-INDIRECT FN-NAME chk_none_value"

    pass_or_fail=${1}
    variable_to_chk=${2}

    if [ "${variable_to_chk}" == 'NONE' ]; then

          if [ ${pass_or_fail} == 'E' ]; then

              echo "EXIT: Mandatory variable ${3} is not passed. Exiting with error code ${4}"
              echo "ERROR: exit_code=${4}"
              exit ${4}
          else
              echo "WARN: Mandatory variable ${3} is not passed. let me try from .env file"
              echo "WARN: if .env file not found or APP_NM and PIPELINE_NM and SNYK_TOKEN defined"
              echo "WARN: exit with 127"
          fi

    else
          echo "INFO: variable name ${3} is valid"
    fi
}

#DPC-Function chk_none_value -Definition End

#DPC-help display to clients how to run this container. Start
help ()
{
     echo "INFO: TYPE INDIRECT FN-NAME help"
     echo "INFO: ******************* How to use Docker Container to Scan IaC Start  *******************"
     echo "INFO: Infra Structure- VM or Host Capable of running Docker run Command with Storage to mount by -v command"
     echo "INFO: Mount directory in the form of  -v /source:/scan  is needed, source can be anything but target is always scan"
     echo "INFO: target mount ( will go to inside container) must be always scan"
     echo "INFO: terraform plan output  files needed under /scan/tfutZ1, /scan/tfutZ2, ....  (Z1,Z2 can be anything, any valid string to keep terraform scan file output in JSON format)"
     echo "INFO: and all terraform files under /scan/tf01 (/scan/tfZ1,/scan/tfZ2, /scan/tfZ3 ....)"
     echo ""
     echo ""  
     echo "INFO: terraform files under /scan/tfxx/tfplan.json found we execute, if not no exection will be done"
     echo "INFO: one can have  /scan/tfx1/tfplan.json, /scan/tfx2/tfplan.json,/scan/tfxn/tfplan.json .... files, found we execute all the tfplan files"
     echo "INGO: one by one for scan and create a report"
     echo "INFO: by default kics scans will be executed. if env SCAN=kics will execute only one."
    
     echo "INFO: Variable Passing to Scan: by --env option or by .env file placed under scan directory (/scan/.env)"
     echo "INFO: .env file format is export Variable=Value. Example (export APP_NM=cse)"
     echo "INFO: .env requires 2 variable, export APP_NM=your application name 3 letter, export PIPELINE_NM=git or jen )"
     echo "INFO: exit senerios: Mandatory variables, (-env option or .env), /scan directory empty, /scan/tfutxx directory empty, il-formated"
     echo "INFO: json files"
     echo ""
     echo ""
     echo "INFO: optional variables- SCAN, SCAN_RETURN_CODE"
     echo "INFO: example: docker -it run -v /XXXX/YYYY:/scan --env PIPELINE_NM=p1 --env SCAN=kics  --env APP_NM=dal --env SCAN_TYPE=terraform --env SCAN_RETURN_CODE=0 (0=for success, 1=over all fail)  IMAGE_NAME /apps/bin/iac_srv.sh"
     echo ""
     echo ""
     echo "INFO: no --env options, but by .env file placed under /scan/.env with export format export APP_NM=abc , export PIPELINE_NM=git"
     echo "INFO: example: docker -it run -v /XXXX/YYYY:/scan IMAGE_NAME /apps/bin/iac_srv.sh"
     echo ""
     echo ""
     echo ""
     echo ""
     echo "INFO: Infra Structure- Cloud OS Optimized Container Run"
     echo "INFO: All scan output files of terraform kept under /workspace/scan directory with tfutp1 (p1=any project name)"
     echo "INFO: Example: pulled from pipeline and placing terraform plans, files are kept /workspace/scan/tfutp1/tfplan.json,"
     echo "INFO: /workspace/scan/tfutp2/tfplan.json,..../workspace/scan/tfutpn/tfplan.json"
     echo "INFO: Create a .env file with APP_NM, PIPELINE_NM values, under /workspace/.env"
     echo "INFO: Run Command with option to /apps/bin/iac_srv.sh sw"
     echo "INFO: option  sw is not mandatory, script will determine by /workspace dir existence, switch to stotage type sw"
     echo "INFO: option  sv is not mandatory, script will determine by /scan dir existence, switch to stotage type sv"
     echo "INFO: /scan and /workspace  dir existence,will abend the script with error code 70"
     echo "INFO: The script iac_srv.sh comes from downloaded container."
     echo "INFO: Please refer document from cloudbuild for jenkins pipeline"
     echo "INFO: ******************* How to use Docker Container to Scan IaC End    *******************"
}
#DPC-help display to clients how to run this container. End
