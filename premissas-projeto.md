# Premissas do Projeto — "Partiu Mickey" (App da Viagem Orlando)

> Documento de definição inicial, gerado a partir de entrevista com o Yuri em 2026-07-16.
> Serve como base para as próximas etapas (desenho de telas, banco de dados, desenvolvimento).

## 1. Contexto e objetivo

App web para organizar a viagem de um grupo de amigos a Orlando, permitindo:

- Anexar os links dos Airbnbs usados na viagem.
- Controlar quantos dias cada pessoa fica hospedada (já que parte do grupo pode ir embora antes dos outros).
- Calcular de forma justa quanto cada um deve pagar da hospedagem e de outras despesas da viagem.
- Fazer o "racha" — mostrar quanto cada pessoa deve e permitir marcar quando já pagou.

## 2. Viagem e grupo

- **Datas da viagem:** 20/10/2026 a 31/10/2026 (11 dias / 10 noites).
- **Grupo (3 casais, 6 pessoas):** Yuri, Elisa, Filipe, Pietra, Jonathan e Luiza.
- Um dos casais **pode ir embora antes** do fim da viagem — possível data de saída: **27/10/2026** (ainda não 100% confirmada). O app precisa suportar datas de entrada/saída diferentes por pessoa.

## 3. Usuários e acesso

- **Sem login** — acesso via link compartilhado com o grupo, sem senha.
- **Edição livre:** todos os participantes podem cadastrar Airbnb, lançar gastos e marcar pagamentos — não há um único organizador centralizando os lançamentos.

## 4. Estrutura de dados

- **Pessoas:** cadastro é **por pessoa** (6 nomes individuais), não por casal — cada pessoa tem sua própria data de entrada/saída, mesmo que na prática os casais entrem/saiam juntos.
- **Airbnbs:** pode haver **mais de um Airbnb na mesma viagem**, usados em sequência (ex: alguns dias numa casa, depois trocam para outra) — todo o grupo junto no mesmo Airbnb por vez, sem subgrupos simultâneos em Airbnbs diferentes. Cada Airbnb tem:
  - Link do anúncio
  - Data de check-in e check-out
  - Valor total (ou por noite)
- **Estadia por pessoa:** cada pessoa tem uma data de entrada e de saída na viagem (para o caso de quem sai antes), usada para calcular quantas noites de cada Airbnb ela efetivamente ocupou.
- **Outros gastos:** além do Airbnb, é possível lançar outras despesas da viagem (passeio, Uber, mercado, etc.), cada uma com valor e lista de quem participou/deve dividir aquele gasto específico.

## 5. Regra de divisão de custos

- **Airbnb (divisão por diária/pessoa):** o valor de cada noite do Airbnb é dividido igualmente entre as pessoas que estavam hospedadas *naquela noite específica*. Quem fica menos dias paga proporcionalmente menos, e quem fica os dias em que há menos gente no grupo paga uma fração maior daquela noite. O total que cada pessoa deve do Airbnb é a soma do que ela deve em cada noite em que esteve presente.
- **Outros gastos:** divididos entre as pessoas marcadas como participantes daquele gasto específico (não necessariamente todo o grupo).
- O app deve mostrar, ao final, um resumo por pessoa com o total devido (Airbnb + outros gastos).

## 6. Controle de pagamentos

- O app deve funcionar como um checklist: além de calcular quanto cada pessoa deve, permite marcar cada pessoa como "pago" quando ela quitar sua parte (pagamento em si — Pix, dinheiro etc. — acontece fora do app).

## 7. Plataforma

- Aplicação **web responsiva**, funcionando bem tanto no celular quanto no computador, acessada por navegador (mesmo padrão dos outros projetos do Yuri — sem instalação de app de loja).
- **Infraestrutura própria e separada** deste projeto — novo projeto Supabase independente, sem reaproveitar a conta/projeto do CRM Instituto HH ou do Gestão Hyllua (mesmo padrão adotado nesses outros projetos).

## 8. Dados iniciais

- Não há dados existentes — cadastro começa do zero direto no app.

## 9. Prazo

- Viagem em 20/10/2026 — o app precisa estar funcional **antes dessa data**, com folga para o grupo já usar durante o planejamento (reservas de Airbnb, etc.) e durante a própria viagem.

## 10. Pendências / decisões em aberto para a próxima etapa

- [ ] Confirmar definitivamente se o casal sai mesmo dia 27/10/2026 — por enquanto é apenas uma possibilidade em aberto, não uma certeza. O app deve permitir editar/ajustar essa data de saída a qualquer momento (não travar no valor inicial).
- [ ] Detalhar a configuração da infraestrutura técnica (criação do novo projeto Supabase, hospedagem do front-end) na fase de implementação.
