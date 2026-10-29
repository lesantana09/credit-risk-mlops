# credit-risk-mlops

Ciclo de vida completo de um modelo de **risco de crédito**: do dado bruto ao monitoramento em produção,
seguindo as fases do [AWS Well-Architected Machine Learning Lens](https://docs.aws.amazon.com/wellarchitected/latest/machine-learning-lens/architecture-diagram.html):
**Process Data → Develop Model → Deploy → Monitor**.

Dataset: [Home Credit Default Risk](https://www.kaggle.com/c/home-credit-default-risk) — prever se um
cliente vai ficar inadimplente, a partir de 7 tabelas relacionadas e com a classe positiva rara.

## Roadmap

| Módulo | Fase do diagrama | Entregável |
| --- | --- | --- |
| 0 | Fundação | Esqueleto do repo + [ADR-001](docs/adr/0001-problema-metrica-custo-do-erro.md) |
| 1 | Collect + Preprocess Data | Ingestão raw → S3, features em SQL, validação de dados |
| 2 | Train, Tune, Evaluate | Baseline → LightGBM, MLflow, SHAP, model card |
| 3 | Feature Store | Feast (offline + online), sem training-serving skew |
| 4 | Model Registry + CI/CD | Pipeline com gates: dados → treino → comparação → registro |
| 5 | Deploy | API real-time + batch scoring em AWS (Terraform) |
| 6 | Monitor | Drift com Evidently + alarme que dispara retreino |
| 7 | Big Data | Features em PySpark (Glue) |

## Estrutura

```text
src/credit_risk/
├── domain/       # schemas, alvo, contratos de feature
├── features/     # definições únicas (treino = inferência)
├── training/     # baseline, modelos, avaliação
├── serving/      # API + batch scoring
├── monitoring/   # drift, alarmes
└── pipelines/    # orquestração das etapas
infra/terraform/  # um módulo por fase; bootstrap = state remoto + budget
notebooks/        # apenas exploração — nada de produção aqui
tests/            # unit, dados (@pytest.mark.data), modelo (@pytest.mark.model)
docs/adr/         # toda decisão de modelo, métrica ou ferramenta
```

## Como rodar

Pré-requisitos: [uv](https://docs.astral.sh/uv/), Make e (a partir do módulo 1) Terraform ≥ 1.10.

```bash
make install   # dependências + hooks do pre-commit
make check     # lint, format, mypy e testes (o mesmo que a CI roda)
```

## Regras do projeto

- Clean Code / Clean Architecture, type hints e `mypy --strict`.
- Cobertura mínima de 80% em `src/`.
- Testes de ML além dos unitários: schema/distribuição dos dados e comportamento do modelo.
- Toda infra em Terraform; nada criado pelo console. `terraform destroy` ao fechar cada módulo.
- Notebook é rascunho: o que vai para produção vira código em `src/` com teste.
- Toda decisão relevante ganha um ADR em `docs/adr/`.
