# Terraform (EC2/ALB/RDS + CodeDeploy + CodePipeline)

This folder provisions:

- VPC (public + private subnets)
- Application Load Balancer (HTTP :80 → targets :8000)
- EC2 Auto Scaling Group (Docker + CodeDeploy agent via user-data)
- RDS MySQL (private subnets)
- Secrets Manager (DB password generated; Gemini API key secret placeholder)
- S3 artifacts bucket (CodePipeline artifact store + S3 source)
- CodeDeploy app + deployment group
- CodePipeline (S3 source → CodeDeploy deploy)

## Prereqs

- AWS account + credentials configured (`aws configure`)
- Terraform >= 1.5

## Apply

```bash
cd infra/terraform
terraform init
terraform apply
```

## Configure secrets

- Set the Gemini key secret value (created by Terraform):
	- Secret name: `${name}/app/AI_AGENTIC_AI_API_KEY`

## Deploy bundle (S3 source)

1) Create a zip where `appspec.yml` is at the zip root (this repo already includes `appspec.yml` and `scripts/*`).

2) Upload it to the artifacts bucket and key used by the pipeline:

```bash
BUCKET=$(terraform output -raw artifacts_bucket_name)
aws s3 cp app.zip s3://$BUCKET/app.zip
```

CodePipeline polls the S3 object and will trigger a CodeDeploy deployment.
