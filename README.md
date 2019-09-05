# android-studio-docker

Runs Android Studio in a Docker container.

## Usage
```sh
PROJECT_PATH=<PATH_TO_YOUR_ANDROID_PROJECT> ./run.sh
```

The `PROJECT_PATH` directory will be read-write volume mounted at `/$(basename ${PROJECT_PATH}) in the container.

The container is run in privileged mode in order for the hardware accelerated emulator to work.
