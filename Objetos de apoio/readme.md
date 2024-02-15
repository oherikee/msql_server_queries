## Descrição
Pasta dedicada para objetos de banco de dados utilizados como apoio para o desenvolvimento.
Estes foram criados principalmente visando facilitar e agilizar contratempos recorrentes identificados durante o trabalho com banco de dados.
Abaixo, uma lista contendo os objetos e seus usos:
## Índice de objetos
[tb_obj_dicionário](https://github.com/oherikee/msql_server_queries/blob/main/Objetos%20de%20apoio/tb_obj_dicion%C3%A1rio.sql):
  É uma forma automatizada de documentar todas as functions e procedures criados no banco, criando uma tabela que os armazena, e traz consigo uma coluna(mensagem) cujo objetivo é possibilitar a escrita de um texto curto sobre os parâmetros dos objetos. Veja o exemplo abaixo, considerando a função "f_div_segura", presente neste mesmo diretório (msql_server_queries/"Objetos de apoio"/): 
- f_div_segura.numerador: Parâmetro responsável por alimentar o numerador da divisão;
- f_div_segura.divisor: Parâmetro responsável por alimentar o denominador da divisão.
<br>

[f_div_segura](https://github.com/oherikee/msql_server_queries/blob/main/Objetos%20de%20apoio/f_div_segura.sql):
  É uma função responsável por realizar divisões utilizando um try...catch, evitando problemas como divisão por zero, por exemplo.
<br>

[f_tabela_por_culuna](https://github.com/oherikee/msql_server_queries/blob/main/Objetos%20de%20apoio/f_tabela_por_coluna.sql):
  Esta função retorna todas as tabelas que contenham uma coluna semelhante ao parâmetro informado.
