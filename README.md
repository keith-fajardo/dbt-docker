# dbt Docker Container

This project is used to create a dbt-core image and container.

A dbt image is already created using the Dockerhub Repository called keithfajardo/i-dbt-core:python3.12.10.

## Running the container
Run the command to run the container:
```
sh run_docker_build_run.sh
```

When the image already exists, it will ask if you want to run a clean build. It means the build will run without cache.
