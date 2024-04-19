# ENTERPRISE VALIDATION PAGE

> ## FLUXO
## VERIFICAR SE HÁ EMPRESA NO BANCO LOCAL
# SE HOUVER EMPRESA
1. Atualiza o text do nome da empresa
# SE NÃO HOUVER EMPRESA
1. Habilitar o botão de validação quando houver pelo menos 2 caracteres

## AO CLICAR NO BOTÃO DE LOGIN
1. Exibir o loading
2. Salvar o nome da empresa localmente

## PESQUISAR A EMPRESA NO FIREBASE
# CASO DE ERRO
1. Retornar mensagem de empresa não encontrada
# CASO DE SUCESSO
1. Salvar localmente a URL e enterpriseId retornada do Firebase

## VALIDAÇÃO DA URL NA API DO COMANDA
# CASO DE ERRO
1. Retornar erro de empresa não encontrada
2. Esconder o loading
# CASO DE SUCESSO
1. Ir para a tela de grupos expansíveis
