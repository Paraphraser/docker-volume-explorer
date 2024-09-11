FROM ubuntu

# reference supported argument and copy to environment var
ARG CONTAINER
ENV CONTAINER=${CONTAINER}

# add useful utilities
RUN apt update && apt install -y tree tzdata bsdmainutils

# create and populate vol1..vol6 (but NOT vol7..vol8)
RUN for V in vol1 vol2 vol3 vol4 vol5 vol6 ; do \
      mkdir -p /internal/${V} ; \
      echo "$(date) pre-VOLUME greeting for ${V}" > /internal/${V}/${V}.${CONTAINER}-pre-greeting ; \
    done

# declare vol1..vol3 (but NOT vol4..vol8)
VOLUME /internal/vol1 /internal/vol2 /internal/vol3

# post-VOLUME populate vol1..vol6 (again, NOT vol7..vol8)
RUN for V in vol1 vol2 vol3 vol4 vol5 vol6 ; do \
      echo "$(date) post-VOLUME greeting for ${V}" > /internal/${V}/${V}.${CONTAINER}-post-greeting ; \
    done

# cache the Dockerfile-initialised state
RUN cp -a /internal /internal-cache

# container starts and goes to sleep for a day
CMD sleep 86400

# copy any available scripts into the container
# (assumes both +x and that one of those is the entry-point)
COPY *.sh /usr/local/bin

# declare the entry-point
ENTRYPOINT ["docker-entrypoint.sh"]

RUN env >>/default_env.txt
