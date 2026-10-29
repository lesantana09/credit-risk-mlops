# Infra

Uma stack por fase do diagrama, todas com state remoto no bucket criado pelo `bootstrap`.

| Stack | Módulo | Conteúdo |
| --- | --- | --- |
| `bootstrap/` | 0 | Bucket do state (lock nativo S3) + budget mensal com alertas |
| `data/` | 1 | Data lake (raw / processed), Glue Catalog, Athena |
| `serving/` | 5 | ECR, ECS, batch scoring |
| `monitoring/` | 6 | CloudWatch, EventBridge |

## Bootstrap (uma vez por conta)

```bash
cd infra/terraform/bootstrap
cp terraform.tfvars.example terraform.tfvars   # preencha o e-mail
terraform init && terraform apply
```

O state do bootstrap fica local de propósito (é ele que cria o bucket remoto). O bucket tem
`prevent_destroy`; o budget pode ficar ligado sempre — não tem custo.
