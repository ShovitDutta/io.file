#p1_hash[ST_0]="tfp"
#p2_hash[ST_0]="NONE"
#p3_hash[ST_0]="NONE"
#p4_hash[ST_0]="NONE"

PROCESS_ST_0 ()
{            
             
  echo "INFO: FN-NAME PROCESS_ST_0"
             
    case "${1}" in 
    "csv")
             mkdir -p ${dir_nm}
               ;;
     "tfp")
             mkdir -p ${dir_nm}
               ;;
     "buk")
             mkdir -p ${dir_nm}
               ;;
      esac
}         
