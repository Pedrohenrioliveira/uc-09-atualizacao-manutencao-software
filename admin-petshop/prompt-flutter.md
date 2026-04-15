# Prompt Mestre para Geração do App Admin (Flutter) usando IA

Você pode usar o prompt abaixo em qualquer inteligência artificial (ChatGPT, GitHub Copilot, Gemini, Claude) para que ela gere a estrutura inicial e o código do aplicativo administrativo do Roberto Abreu (Dono da loja).

---

> Por favor, atue como um Desenvolvedor Flutter Sênior. 
> Minha aplicação é um painel administrativo interno para um Pet Shop chamado "Patas Felizes".
> Preciso que você gere um projeto Flutter multiplataforma (focado primariamente em Web/mobile, mas responsivo) com a estrutura completa e o código inicial para as seguintes funcionalidades:
> 
> **1. Arquitetura:**
> - Utilize a arquitetura **MVC** ou **Clean Architecture**.
> - Utilize o padrão **Provider** ou **Riverpod** para gerência de estado.
> - O layout principal deve ter um Menu Lateral (Drawer ou NavigationRail) com as seguintes opções: Dashboard, Contatos, Fotos e Depoimentos.
>
> **2. Menus e Telas:**
> - **Dashboard:** Uma tela inicial (home) estática mostrando cards fictícios com números (ex: 15 novos contatos hoje, 120 acessos). *Nesta tela haverá posteriormente a integração com o Google Analytics/Microsoft Clarity*.
> - **Gestão de Contatos (Leads):** Uma tela com uma lista (ListView/DataTable) mostrando os contatos recebidos (Nome, Email, Mensagem e Data). Deve ler de uma API REST (endpoints `GET /api/contatos`). Deve ter botão de "Excluir" chamando (`DELETE /api/contatos/{id}`).
> - **Gestão de Fotos "Antes e Depois":** Uma tela contendo um GridView com as fotos atuais. Um botão Flutuante (`+`) para adicionar uma nova foto. O formulário de adição deve pedir: Nome do Cachorro, Link da Imagem e Link do Instagram, e enviar um POST para `api/fotos`.
> - **Gestão de Depoimentos:** Uma tela similar à de contatos, com formulário para adicionar nome do cliente, texto do depoimento, e nota (1 a 5 estrelas).
>
> **3. Camada de Integração (API):**
> - Crie a classe base de `ApiService` usando o pacote `http` ou `dio`. 
> - A URL Base da API será `http://localhost:5000`. Crie os models/entidades em português (`FotoAntesDepois`, `Contato`, `Depoimento`), pois o backend foi construído em português.
>
> **Por favor, retorne:**
> 1. A estrutura de pastas sugerida (`lib/models`, `lib/views`, etc).
> 2. O conteúdo do `pubspec.yaml` com as dependências.
> 3. O código completo do `main.dart` com as rotas.
> 4. O código das 4 telas principais e dos seus controllers correspondentes.
