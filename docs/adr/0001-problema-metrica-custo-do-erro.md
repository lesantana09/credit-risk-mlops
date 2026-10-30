# ADR-0001: Problema, alvo e critério de sucesso para o modelo de risco de crédito

## 1. Contexto

O banco concede crédito a pessoas físicas e precisa estimar a probabilidade de que um cliente se torne inadimplente. Aprovar um mau pagador gera perda do principal, somada aos custos de cobrança. Negar um bom pagador gera perda de receita de juros, um custo de oportunidade menor. Este projeto constrói um modelo que apoia essa decisão.

## 2. Problema técnico

- **Tarefa:** classificação binária, com saída em probabilidade de inadimplência por cliente.
- **Classe positiva:** inadimplente (rótulo `TARGET = 1`).
- **Desbalanceamento:** 8,07% dos clientes são inadimplentes e 91,93% são adimplentes, medido no arquivo application_train.csv.
- **Volume:** 307.511 clientes e 122 colunas no arquivo application_train.csv.
- **Dados:** várias tabelas relacionadas por cliente, com agregação de features por cliente.

## 3. Critério de sucesso

- **Erro mais caro:** falso negativo, ou seja, aprovar um mau pagador. O custo estimado por caso será registrado quando houver um valor médio de empréstimo confirmado.
- **Métrica principal:** AUC-PR (área sob a curva precisão × recall). Ela foca na classe rara e ignora o ruído dos verdadeiros negativos, ao contrário da acurácia, que é alta mesmo para um modelo que não detecta inadimplentes.
- **Métricas de apoio:** recall e precisão no ponto de corte escolhido, mais o custo estimado de cada tipo de erro para definir esse corte.
- **Baseline:** um modelo que sempre prevê adimplente, com acurácia de cerca de 92% e recall zero para inadimplentes. Todo modelo precisa superar esse piso no critério principal.

---

Status: aceito!
