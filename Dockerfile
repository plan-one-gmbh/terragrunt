FROM alpine:3.11.3 as build

RUN apk add --no-cache --update libxml2-dev~=2.9 libxslt-dev~=1.1 python3-dev~=3.8.2 gcc~=9.3 build-base~=0.5
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install terraform-compliance==1.3.6

FROM alpine:3.11.3 as release
COPY --from=build /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN apk --no-cache add bash~=5.0 git~=2.24 curl~=7.67 openssh-client~=8.1 python3~=3.8.2 jq~=1.6

RUN git clone --depth 1 --branch v2.0.0 https://github.com/tfutils/tfenv.git ~/.tfenv && ln -s ~/.tfenv/bin/* /usr/local/bin
RUN git clone --depth 1 --branch v0.0.3 https://github.com/cunymatthieu/tgenv.git ~/.tgenv && ln -s ~/.tgenv/bin/* /usr/local/bin

ENV TERRAFORM_VERSION=0.13.5
ENV TERRAGRUNT_VERSION=0.26.2
ENV TF_INPUT="false"

RUN tfenv install $TERRAFORM_VERSION && tfenv use $TERRAFORM_VERSION
RUN tgenv install $TERRAGRUNT_VERSION && tgenv use $TERRAGRUNT_VERSION

CMD ["terragrunt"]