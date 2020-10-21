FROM alpine:3.11.3
RUN apk --no-cache add bash~=5.0 git~=2.24 curl~=7.67

RUN git clone --depth 1 --branch v2.0.0 https://github.com/tfutils/tfenv.git ~/.tfenv && ln -s ~/.tfenv/bin/* /usr/local/bin
RUN git clone --depth 1 --branch v0.0.3 https://github.com/cunymatthieu/tgenv.git ~/.tgenv && ln -s ~/.tgenv/bin/* /usr/local/bin

ENV TERRAFORM_VERSION=0.13.4
ENV TERRAGRUNT_VERSION=0.25.4
ENV TF_INPUT="false"

RUN tfenv install $TERRAFORM_VERSION && tfenv use $TERRAFORM_VERSION
RUN tgenv install $TERRAGRUNT_VERSION && tgenv use $TERRAGRUNT_VERSION

CMD ["terragrunt"]