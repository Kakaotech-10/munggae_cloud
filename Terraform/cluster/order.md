

# providers.tf -> varibles.tf -> vpc.tf -> eks.tf -> helm.tf


# $ terraform apply -target="module.vpc" -auto-approve (vpc만 먼저 적용)

# $ terraform apply -auto-approve (전체 구성을 적용합니다. main.tf, vpc.tf, eks.tf, helm.tf 등)


# helm 차트를 통해 argocd, prometheus, grafana, loki 등을 미리 설치만 해놓은 상황
# -> 직접 설정은 각 values.yaml 파일을 수정해서 연결해야함!