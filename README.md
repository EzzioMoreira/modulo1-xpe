# Módulo 1: Computação em nuvem

## Requisitos

- Docker

## Criando image

Acesse o diretório build_ami e execute os seguintes comandos. 

```shell
docker run -it -v $PWD:/app -w /app --entrypoint "" hashicorp/packer:1.8 sh
```

### Variável de ambiente

```shell
export AWS_ACCESS_KEY_ID=CHANGE-ME
export AWS_SECRET_ACCESS_KEY=CHANGE-ME
export AWS_DEFAULT_REGION=CHANGE-ME
```
### Instalar Ansible no contianer Packer

```shell
apk -U add ansible
```
### Criar AMI AWS

Exeute o comando para criar image aws.

```shell
packer build aws-ubuntu.hcl
```

## Criar infraestrutura

Execute os seguintes comandos.

```shell
docker run -it --rm -v $PWD:/app -w /app/ -e AWS_ACCESS_KEY_ID=$$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$$AWS_SECRET_ACCESS_KEY --entrypoint "" hashicorp/terraform:1.3.7 sh
```

### Para criar infra

```shell
terraform apply
```
