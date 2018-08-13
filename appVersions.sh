#!/usr/bin/env bash


workspace=$(pwd)
new_line="----------------------------------------------------------"
versions_path="$workspace/versions.tmp"
services_path="$workspace/services.tmp"
# recent number of versions in a service to keep
nums_to_keep=3

delete_a_service_vers() {

    PROJECT_ID=$1
    SERVICE_ID=$2

    rm -f ${versions_path}

    echo
    echo "Deleting versions [ * ] of [$SERVICE_ID] in $PROJECT_ID:"
    echo "${new_line}"

    list_vers $PROJECT_ID $SERVICE_ID | sed '1d' | sort -k4 -r > ${versions_path}

    versToDelete=()
    count=1
    while read line; do
        set $line

        if [[ $count -le ${nums_to_keep} ]]; then
            echo "[   ] $line"
        elif [[ "$3" == "0.00" ]]; then
            echo "[ * ] $line"
            versToDelete+=("$2")
        fi

        count=`expr $count + 1`
    done < ${versions_path}

    if [[ ${#versToDelete[@]} -gt 0 ]]; then
        echo
        echo "Deleting versions of [$SERVICE_ID]: ${versToDelete[@]}"
        gcloud app versions delete ${versToDelete[@]} -q --project=$PROJECT_ID --service=$SERVICE_ID
    fi

    echo
    echo "Remaining versions of [$SERVICE_ID] in $PROJECT_ID:"
    echo "${new_line}"

    list_vers $PROJECT_ID $SERVICE_ID | sed '1d' | sort -k4 -r
}

list_services() {
    PROJECT_ID=$1
    gcloud app services list --project=$PROJECT_ID
}

list_vers() {
    PROJECT_ID=$1
    SERVICE_ID=$2
    gcloud app versions list --project=$PROJECT_ID --service=$SERVICE_ID
}

delete_all_services_vers() {

    rm -f ${services_path}

    PROJECT_ID=$1

    echo
    echo "Deleting old versions of all app services in $PROJECT_ID:"
    echo "${new_line}"

    list_services $PROJECT_ID | sed '1d' > ${services_path}

    count=1
    servicesToDelete=()
    while read line; do
        set $line

        if [[ ${2} -gt ${nums_to_keep} ]]; then
            echo "[ * ] $line"
            servicesToDelete+=("${1}")
        else
            echo "[   ] $line"
        fi

        count=`expr $count + 1`
    done < ${services_path}


    for service in "${servicesToDelete[@]}"
    do
        delete_a_service_vers $PROJECT_ID ${service}
    done

    echo
    echo "Remaining versions of all app services in $PROJECT_ID:"
    echo "${new_line}"

    list_services $PROJECT_ID
}

command="default"
project_id=
if [ "$#" -ge 1 ]; then
    command=$1
fi
if [ "$#" -ge 2 ]; then
    project_id=$2
fi

cat << EOF
-----------------------------------------------------
 * workspace: ${workspace}
 * command: ${command}
 * project_id: ${project_id}
 * number of versions to keep: ${nums_to_keep}
-----------------------------------------------------
EOF

case $command  in
    default)
cat << EOF

 * appVersions.sh guide

 /> ./appVersions.sh list <project-id>
   - Lists up app services with number of versions in <project-id>

 /> ./appVersions.sh delete-versions <project-id>
   - Deletes old versions of all app services in <project-id>

EOF
        ;;
    list)
        list_services ${project_id}
        ;;
    delete-versions)
        delete_all_services_vers ${project_id}
        ;;
    *)
esac
