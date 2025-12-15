# Elixir - Todo List

## Nome do Aluno : Danniel Cristie

## Tutorial Base
[Como Criar um App Todo List com Elixir e LiveView do Zero](https://profsergiocosta.notion.site/Como-Criar-um-App-Todo-List-com-Elixir-e-LiveView-do-Zero-2a8cce97509380eba53fc82bbeb08435)

## Descrição

Este projeto é uma aplicação "Todo List" full-stack desenvolvida com Elixir e Phoenix LiveView.

**Tecnologias:**
- **Backend:** Elixir, Phoenix, Ecto, SQLite
- **Frontend:** Phoenix LiveView, Tailwind CSS, DaisyUI
- **Ambiente:** Mix

## Como Rodar

### Rodando com Docker

#### Pré-requisitos

- Docker
- Docker Compose

#### Instruções

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/dannielcristie/elixir_todo_list.git
    cd elixir_todo_list
    ```

2.  **Inicie a aplicação com Docker Compose:**
    ```bash
    docker compose up --build
    ```

3.  **Acesse a aplicação:**
    Abra seu navegador e acesse `http://localhost:4000`.

4.  **Para parar a aplicação:**
    ```bash
    docker compose down
    ```

### Rodando Localmente

Para executar o projeto diretamente na sua máquina, você precisará ter o ambiente Elixir e Node.js configurado.

#### Pré-requisitos

- Elixir (versão 1.14 ou superior)
- Erlang/OTP
- Node.js e npm (para assets)

#### Instruções

1.  **Clone o repositório e instale as dependências:**
    ```bash
    git clone https://github.com/dannielcristie/elixir_todo_list.git
    cd elixir_todo_list
    mix deps.get
    ```

2.  **Prepare o banco de dados:**
    Este comando cria o banco de dados SQLite e roda as migrações necessárias.
    ```bash
    mix setup
    ```

3.  **Inicie o servidor:**
    Em um terminal, execute:
    ```bash
    mix phx.server
    ```
    O servidor estará rodando na porta `4000`.

4.  **Acesse a aplicação:**
    Abra seu navegador e acesse `http://localhost:4000`.

## Funcionalidades

A aplicação permite:

- **Listar tarefas:** Visualização de todas as tarefas cadastradas.
- **Criar tarefa:** Adição de novas tarefas via formulário.
- **Concluir tarefa:** Alternar o status de uma tarefa (pendente/concluída) clicando no checkbox.
- **Excluir tarefa:** Remoção de tarefas do banco de dados.
