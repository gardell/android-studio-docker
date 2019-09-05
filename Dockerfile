# Note: Ubuntu has `openjdk-8-jdk`, debian doesn't.
FROM ubuntu

ARG ANDROID_STUDIO_VERSION=3.5.0.21
ARG ANDROID_STUDIO_OTHER_VERSION=191.5791312
ARG SDK_TOOLS_VERSION=4333796

ARG UID=1000
ARG GID=1000
ARG USER=android-studio
ARG HOME=/home/${USER}
ARG ANDROID_SDK_ROOT=${HOME}/Android/Sdk

RUN dpkg --add-architecture i386 \
    && apt-get update -qq \
    && apt-get install -yqq \
        git \
        libc6:i386 \
        libncurses5:i386 \
        libstdc++6:i386 \
        lib32z1 \
        libbz2-1.0:i386 \
     	libfreetype6 \
        libgl1 \
        libpulse0 \
        libqt5widgets5 \
        libxi6 \
        libxrender1 \
        libxtst6 \
        make \
        openjdk-8-jdk \
        python3 \
        unzip \
        wget

RUN groupadd \
    -g ${GID} \
    -r \
    ${USER}

RUN useradd \
    -u ${UID} \
    -g ${GID} \
    --create-home \
    -r \
    ${USER}

USER ${USER}
WORKDIR ${HOME}

RUN wget -qO- \
    https://dl.google.com/dl/android/studio/ide-zips/${ANDROID_STUDIO_VERSION}/android-studio-ide-${ANDROID_STUDIO_OTHER_VERSION}-linux.tar.gz \
    | tar xz

RUN mkdir -p ${ANDROID_SDK_ROOT}

RUN wget -q https://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS_VERSION}.zip \
    && cd ${ANDROID_SDK_ROOT} \
    && unzip ${HOME}/sdk-tools-linux-4333796.zip \
    && rm ${HOME}/sdk-tools-linux-4333796.zip

RUN yes | ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager --licenses

RUN ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager --install "platforms;android-29" \
    && ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager --install "build-tools;29.0.2" \
    && ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager --install "emulator" \
    && ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager --install "platform-tools" \
    && ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager --install "system-images;android-29;default;x86_64"

RUN ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager --install "system-images;android-29;google_apis_playstore;x86"

CMD ANDROID_SDK_ROOT=/home/${USER}/tools/ android-studio/bin/studio.sh
