# Google Cloud App Engine managing shell script

Cleaning up old versions of App Engine services in GCP projects is a tedious task if there are many micro services running and published in a gcp project in a day. it could quickly reach the limit of number of App Engine instances.    This shell script runs to automatically clean up old versions of them but keeping the certain number of recent versions of them, which is configurable in the script. (3 by defaults)

This can also be done by scheduled Jenkins's job if there is a gcp service account credentials available in your Jenkins.

### Setup gcp project

Install gcloud-sdk in your working environment.
Run 'gcloud init' command to config your google account for gcp project.

### Cleaning up App Engine versions

appVersions.sh provides commands to manage Google Cloud App Engine versions.
You can either:
* Cleaning up App Engine versions

    > ./appVersions.sh delete-versions {gcp-project-id}

* Listing up App Engine versions

    > ./appVersions.sh list {gcp-project-id}

