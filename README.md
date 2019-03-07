# factorio-docker
Simple Docker image for a headless Factorio Server

## Usage
```
git clone https://github.com/ChainsDD/factorio-docker.git
cd factorio-docker
./bin/factorio build 0.17.7 true
./bin/factorio create
```

The container should be created and running now. It stores the config and save files in a docker volume named factorio, see [Docker documentation](https://docs.docker.com/storage/volumes/) for more information on volumes.

The bin/factorio script has other functions to help manage the server.
```
./bin/factorio start
# starts a container that has already been created

./bin/factorio stop
# stops a running container

./bin/factorio restart
# restarts a running container

./bin/factorio setver 0.17.7
# recreates and starts the container with a new version. the image must already have been built. not specifying
# a version number will have the script use 'latest' as the version number.

./bin/factorio build 0.17.7 true
# builds a new image with the specified version. The Dockerfile uses the version number to download the tarball
# from factorio.com, so the build will fail if you specify an invalid version number. By adding 'true' to the end
# of the line, the created image will also be tagged as 'latest'.

./bin/factorio cp MySave.zip saves/MySave.zip
# copies a file to the factorio volume.

./bin/factorio shell
# opens a shell on the running container

./bin/factorio config server-settings
# opens a vi editor for the specifed config file. Useful files are
#   * settings
#   * whitelist
#   * banlist
#   * adminlist
#   * rconpw (the password used for the RCON connection)
# You can specify any filename, but only the ones listed will have any effect.
```

## Building your own base image
If you're unsure about using an unofficial base image, I have created another image that you can build from source to use as the base image. Download and build [docker-alpine-glibc](https://github.com/ChainsDD/docker-alpine-glibc), then change the FROM line in the Dockerfile to reference your newly built base image.
