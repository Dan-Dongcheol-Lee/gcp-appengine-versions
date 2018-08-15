# appVersions.sh to manage GCP App Engine service versions

Cleaning up old versions of App Engine services in GCP projects is a tedious task if there are many micro services running and published in a gcp project in a day.

This shell script runs to clean up old versions of App Engine services but keeping the certain number of recent versions of them, which is configurable in the script. (3 for each service by default)

This can also be done by scheduled Jenkins's job if there is a gcp service account credentials available in your Jenkins.

### Setup gcp project

Install gcloud-sdk in your working environment.

Run 'gcloud init' command to set up your google account for the project.

### Cleaning up App Engine versions

You can either:
* Cleaning up App Engine versions

    > ./appVersions.sh delete-versions {gcp-project-id}

* Listing up App Engine versions

    > ./appVersions.sh list {gcp-project-id}

and it will show very detailed logs while the command is running.
