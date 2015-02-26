# drupal-solr
A simple Docker container to provide a dev Solr instance that is configured to work with Drupal's apachesolr module.

# Getting Started:
The Solr instance is alread configured with the necessary schema to work with Drupal's apachesolr module. To begin using the Solr instance you simply need to build the Docker image and then run a Docker container of the image.

## Build the image:
Run a docker build in the repository directory and tag the image something useful.

`docker build -t stperona/drupal-solr .`

## Run the image:
Once the image has built, run a container and expose the Solr service to a desired port. The image exposes Solr on port 8983, feel free to map this to the port of your choosing as part of the run command.

`docker run -d -p 8983:8983 -t -i stperona/drupal-solr`

## Verify server:
Once the container has been launched, give it 15-30 seconds to fully stand up then verify you can access the instance by navigating to the admin interface.

`<Docker IP>:8983/solr`

If you are unable to reach the Solr instance check the docker logs for the container for any errors.

# Configuring Drupal:
Once you have verified you can access the Solr instance you should configure the Drupal apachesolr module search environment to point to the drupal core of the Solr instance.

Solr Server URL: `http://<Docker IP>:8983/solr/drupal`

Test the connection and save the settings.

You should now re-index the site. Flag the site for re-index by clicking and confirming the "re-index site" option on the search settings (admin/config/search/settings) page. 

Once all the content is flagged for re-indexing you can run `drush solr-index` to reindex the site content.
