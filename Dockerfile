FROM python:3.13-alpine

ARG GITMAN_VERSION=3.5.2

ADD entrypoint.sh /entrypoint.sh

RUN ( \
    set -eux; \
    apk add --no-cache git bash; \
    pip install gitman==${GITMAN_VERSION} --no-cache-dir; \
    \
    chmod +x /entrypoint.sh; \
)

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "gitman" ]

LABEL \
    org.label-schema.schema-version=1.0 \
    org.label-schema.version=${GITMAN_VERSION} \
    org.label-schema.name="redmatter/gitman" \
    org.label-schema.license="MIT License" \
    org.label-schema.url="https://redmatter.com/" \
    org.label-schema.vcs-url="https://github.com/redmatter/docker-gitman"
