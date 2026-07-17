-- Partiu Mickey — schema Supabase
-- Rode este script inteiro uma vez no SQL Editor do painel Supabase (Database > SQL Editor > New query > Run).
-- Seguro rodar de novo: usa "if not exists" / "drop policy if exists" onde possível.

-- ========== TABELAS ==========

create table if not exists pessoas (
  id uuid primary key default gen_random_uuid(),
  nome text not null unique,
  data_entrada date not null,
  data_saida date not null,
  created_at timestamptz default now()
);

create table if not exists airbnbs (
  id uuid primary key default gen_random_uuid(),
  nome_apelido text not null,
  link text,
  data_checkin date not null,
  data_checkout date not null,
  valor_total numeric not null default 0,
  created_at timestamptz default now()
);

create table if not exists gastos (
  id uuid primary key default gen_random_uuid(),
  descricao text not null,
  valor numeric not null default 0,
  data date,
  parcelas integer not null default 1,
  created_at timestamptz default now()
);

-- Se a tabela gastos já existia (banco criado antes do parcelamento ser adicionado):
alter table gastos add column if not exists parcelas integer not null default 1;

create table if not exists gasto_participantes (
  gasto_id uuid references gastos(id) on delete cascade,
  pessoa_id uuid references pessoas(id) on delete cascade,
  primary key (gasto_id, pessoa_id)
);

create table if not exists pagamentos (
  pessoa_id uuid primary key references pessoas(id) on delete cascade,
  pago boolean not null default false,
  marcado_em timestamptz
);

-- ========== RLS ==========
-- Sem login: o app usa link compartilhado, então a chave "anon" do navegador
-- precisa poder ler/escrever livremente em todas as tabelas (mesmo padrão do
-- CRM Instituto HH). Quem tiver a URL + anon key consegue ler/escrever os
-- dados diretamente pela API — aceitável aqui porque não há dado sensível
-- (só nomes, datas e valores da viagem).

alter table pessoas enable row level security;
alter table airbnbs enable row level security;
alter table gastos enable row level security;
alter table gasto_participantes enable row level security;
alter table pagamentos enable row level security;

drop policy if exists anon_all on pessoas;
create policy anon_all on pessoas for all to anon using (true) with check (true);

drop policy if exists anon_all on airbnbs;
create policy anon_all on airbnbs for all to anon using (true) with check (true);

drop policy if exists anon_all on gastos;
create policy anon_all on gastos for all to anon using (true) with check (true);

drop policy if exists anon_all on gasto_participantes;
create policy anon_all on gasto_participantes for all to anon using (true) with check (true);

drop policy if exists anon_all on pagamentos;
create policy anon_all on pagamentos for all to anon using (true) with check (true);

-- ========== DADOS INICIAIS (os 6 participantes) ==========
-- Datas de entrada/saída podem ser ajustadas depois direto no app.

insert into pessoas (nome, data_entrada, data_saida) values
  ('Yuri', '2026-10-20', '2026-10-31'),
  ('Elisa', '2026-10-20', '2026-10-31'),
  ('Filipe', '2026-10-20', '2026-10-31'),
  ('Pietra', '2026-10-20', '2026-10-31'),
  ('Jonathan', '2026-10-20', '2026-10-31'),
  ('Luiza', '2026-10-20', '2026-10-31')
on conflict (nome) do nothing;
