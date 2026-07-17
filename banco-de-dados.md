# Estrutura Técnica — "Partiu Mickey"

> Próxima etapa após [premissas-projeto.md](premissas-projeto.md): define o modelo de dados, a lógica de cálculo e as telas do app.

## 1. Stack técnica

Mesmo padrão dos outros projetos do Yuri:

- **Front-end:** site estático (HTML/CSS/JS), responsivo, hospedado no GitHub Pages.
- **Back-end/dados:** Supabase (banco Postgres + API), projeto novo e separado dos demais.
- **Sem login** — acesso pelo link do site, todo mundo edita livremente.

## 2. Modelo de dados (tabelas)

### `pessoas`
| Campo | Tipo | Descrição |
|---|---|---|
| id | uuid | identificador |
| nome | texto | ex: "Yuri" |
| data_entrada | data | quando essa pessoa chega em Orlando |
| data_saida | data | quando essa pessoa vai embora |

### `airbnbs`
| Campo | Tipo | Descrição |
|---|---|---|
| id | uuid | identificador |
| nome_apelido | texto | ex: "Casa 1 — perto da Disney" (pra identificar facilmente) |
| link | texto | link do anúncio do Airbnb |
| data_checkin | data | |
| data_checkout | data | |
| valor_total | número | valor total cobrado por esse Airbnb |

*(o grupo pode cadastrar mais de um Airbnb, um "depois do outro" — cada um com seu período de datas)*

### `gastos`
| Campo | Tipo | Descrição |
|---|---|---|
| id | uuid | identificador |
| descricao | texto | ex: "Uber pro parque", "Mercado" |
| valor | número | valor **total** da compra (mesmo se foi parcelada) |
| data | data | opcional, só pra organizar |
| parcelas | número inteiro | em quantas vezes a compra foi parcelada (padrão 1 = à vista) |

### `gasto_participantes`
| Campo | Tipo | Descrição |
|---|---|---|
| gasto_id | uuid | referência ao gasto |
| pessoa_id | uuid | referência à pessoa que participa desse gasto específico |

*(tabela de ligação: cada gasto pode ter um subconjunto diferente de pessoas dividindo ele)*

### `pagamentos`
| Campo | Tipo | Descrição |
|---|---|---|
| pessoa_id | uuid | referência à pessoa |
| pago | verdadeiro/falso | se essa pessoa já quitou o que devia |
| marcado_em | data/hora | quando foi marcado como pago |

## 3. Lógica de cálculo (o "motor" do racha)

**Custo do Airbnb por pessoa:**
1. Para cada Airbnb, calcular o valor por noite = `valor_total ÷ número de noites`.
2. Para cada noite do período do Airbnb, ver quais pessoas estavam presentes naquela noite (comparando `data_entrada`/`data_saida` de cada pessoa com a data da noite).
3. Dividir o valor daquela noite igualmente entre as pessoas presentes.
4. Somar, por pessoa, o que ela deve em todas as noites de todos os Airbnbs.

**Custo de outros gastos por pessoa:**
1. Para cada gasto, dividir o valor **total** igualmente entre as pessoas marcadas como participantes daquele gasto — isso não muda com o parcelamento, é sempre o total que cada um deve daquele gasto.
2. Somar, por pessoa, o que ela deve em todos os gastos.
3. Se o gasto foi parcelado (`parcelas` > 1), o valor da parcela mensal de cada pessoa é a parte dela dividida pelo número de parcelas — usado só pra mostrar "quanto pagar por mês", não muda o total devido.

**Total devido por pessoa** = soma da parte do Airbnb + soma da parte dos outros gastos.

Esse cálculo é feito automaticamente pelo app sempre que algo muda (nova pessoa, novo Airbnb, novo gasto, data ajustada) — não precisa recalcular na mão.

## 4. Telas planejadas

1. **Resumo (tela inicial):** quanto cada pessoa deve no total, quem já pagou, total geral gasto na viagem.
2. **Pessoas:** lista dos 6 participantes com data de entrada/saída de cada um (editável a qualquer momento).
3. **Airbnbs:** lista dos Airbnbs cadastrados (link, datas, valor), com botão para adicionar um novo.
4. **Gastos:** lista de outras despesas, cada uma com quem participa, com botão para adicionar uma nova.
5. **Detalhe do Resumo:** abrir uma pessoa e ver o detalhamento (quanto ela deve de cada Airbnb + quanto ela deve de cada gasto), e o botão de marcar "paguei minha parte".

## 5. Pendências

- [ ] Validar o protótipo visual das telas (próximo passo) antes de começar a programar de fato.
- [ ] Criar o projeto novo no Supabase (login do Yuri) quando formos implementar.
