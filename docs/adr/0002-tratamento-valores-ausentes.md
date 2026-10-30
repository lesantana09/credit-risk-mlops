# ADR-0002: Tratamento de valores ausentes

## 1. Contexto

O arquivo `application_train.csv` tem 122 colunas. Dessas, 41 têm mais de 50% dos valores faltantes. Boa parte das colunas com ausência vem de informações sobre o imóvel do cliente, organizadas em grupos com três versões de agregação: `_AVG`, `_MODE` e `_MEDI`.

A estrutura dos grupos é:

- **14 grupos completos (42 colunas), todos numéricos:** cada um tem `_AVG`, `_MODE` e `_MEDI`, com a mesma proporção de ausência entre as três versões.
- **5 colunas `_MODE` sem par:** `TOTALAREA_MODE` (numérica) e `FONDKAPREMONT_MODE`, `HOUSETYPE_MODE`, `WALLSMATERIAL_MODE`, `EMERGENCYSTATE_MODE` (categóricas, em texto).

Esse desenho exige tratamentos diferentes para cada tipo, por isso a decisão não pode ser uma regra única para todas as colunas.

## 2. Decisão

Adotamos a seguinte estratégia, na ordem:

1. **Consolidar os grupos completos:** para cada um dos 14 grupos numéricos, manter apenas a versão `_MEDI` e descartar `_AVG` e `_MODE`.
2. **Manter as colunas sem par:** `TOTALAREA_MODE` e as 4 categóricas continuam como colunas independentes nos passos seguintes.
3. **Remover colunas com mais de 50% de valores faltantes** que não tenham sido consolidadas no passo 1, aplicando o critério também às colunas sem par.
4. **Imputar as colunas restantes**, sempre aplicando o valor ajustado no treino à validação e ao teste:
   - **numéricas:** com a mediana, calculada somente sobre o conjunto de treino;
   - **categóricas:** com a categoria `"Desconhecido"`, que não depende dos dados.
5. **Criar uma coluna indicadora de ausência** para cada coluna imputada com proporção faltante acima de 5%, para que o modelo possa usar a ausência como sinal.

## 3. Alternativas consideradas

- **Imputar as categóricas com a moda:** descartada. Se a ausência de informação sobre o imóvel tiver um motivo, substituí-la pelo valor mais comum apaga esse sinal.
- **Imputar com média:** descartada, porque é sensível a outliers, comuns em renda e valor de crédito.
- **Remover todas as linhas com algum valor faltante:** descartada, porque eliminaria grande parte da base e introduziria viés se a ausência não for aleatória.
- **Manter todas as colunas e imputar tudo:** descartada, porque as colunas com mais de 50% de ausência adicionam muito ruído com pouco sinal.
- **Usar um modelo que lida com nulos nativamente (ex.: LightGBM):** considerada como complemento, não como substituta. A regressão logística não lida com nulos, então a comparação entre modelos exige o mesmo tratamento para todos.

## 4. Consequências

- O número de features cai de 122 para 75 após a consolidação dos trios (28 colunas) e a remoção das colunas com mais de 50% de faltantes (17 colunas). O total aumenta com as colunas indicadoras de ausência, criadas na etapa de imputação.
- O pipeline de pré-processamento ajusta (`fit`) os valores de imputação apenas no treino, para evitar vazamento de dados (data leakage).
- Das 4 colunas categóricas, 3 têm mais de 50% de faltantes e são removidas pela regra. A `EMERGENCYSTATE_MODE` (47%) fica abaixo do limite e recebe o tratamento `"Desconhecido"`.
- O limite de 50% para remoção e o de 5% para o indicador são hipóteses a testar no baseline. Se o resultado mudar muito com outro limite, o ADR precisa ser revisto.

---

Status: aceito. Revisar após o baseline, caso o limite de 50% ou o corte de 5% mude os resultados.
