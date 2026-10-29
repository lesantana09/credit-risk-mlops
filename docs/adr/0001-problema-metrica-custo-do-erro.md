# ADR-0001: Problema, métrica e custo do erro

- **Status:** proposto
- **Data:** _preencher_

> **Este ADR é seu.** É o raciocínio que a sabatina vai cobrar. Responda cada pergunta com suas
> palavras antes de escrever qualquer linha de modelo. Respostas curtas e específicas.

## 1. Problema de negócio

- Quem usa a previsão e em que momento da jornada do cliente?
- Que decisão muda por causa dela?

## 2. Formulação de ML

- É supervisionado ou não supervisionado? Por quê? Qual é exatamente o alvo (`TARGET`)?
- Classificação ou regressão? A saída é uma classe ou uma probabilidade? Qual das duas o negócio precisa?
- Que informação **não** pode entrar como feature por só existir depois da decisão (data leakage)?

## 3. Custo do erro

- O que é um falso positivo aqui, e quanto custa ao banco?
- O que é um falso negativo, e quanto custa?
- Qual dos dois é pior? Isso muda o limiar de decisão?

## 4. Métrica

- Por que a acurácia é enganosa neste dataset? (Use a proporção real da classe positiva.)
- Métrica principal de otimização e por quê (ROC-AUC? AUC-PR? recall a uma precisão fixa?)
- Métrica de guarda (*guardrail*) que não pode piorar.

## 5. Baseline

- Qual é o modelo mais burro possível, e qual nota ele tira na métrica escolhida?
- A partir de quanto acima do baseline vale a pena colocar um modelo em produção?

## Decisão

_Uma frase que resume problema, alvo, métrica e limiar de sucesso._
