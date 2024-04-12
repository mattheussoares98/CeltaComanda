# Login Page

> ## Regras
1. ✅ O botão de login deve iniciar desabilitado
2. ✅ O botão de login deve habilitar quando houver um usuário, senha e nome da empresa ou url do CCS informados
3. ✅ Exibir loading no início da ação de login
4. ✅ Salvar os dados de URL, nome do usuário e nome da empresa no banco de dados local
5. ✅ Exibir mensagem de erro caso o login falhe
6. ✅ Esconder loading no fim da ação de login
7. ✅ Salvar localmente a url do CCS, nome da empresa e usuário ao tentar fazer o login
8. ✅ Se der certo o login, salvar o crossId
9. ✅ Salvar o usuário ao tentar autenticar
10. ✅ Se der certo o login e não houver a URL ou nome da empresa no firebase, salvar a URL e o nome da empresa no firebase. O json deve conter somente o nome da empresa e a URL
11. ✅ Restaurar os dados de usuário, url e nome da empresa ao acessar a página
12. ✅ Se no campo de URL não for uma URL válida, pesquisar no firebase o cliente pelo nome da empresa
13. ✅ Se pesquisar o cliente no firebase e não encontrar, aparecer erro de que a empresa não foi encontrada
14. ✅ Ao usar o submit do usuário, mudar o foco pra senha
15. ✅ Ao usar o submit da senha, mudar o foco pra URL
16. ✅ Ao chamar o validate do user, url e password atualizar o loginData do presenter