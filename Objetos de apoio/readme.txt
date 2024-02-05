Pasta dedicada para objetos de banco de dados utilizados como apoio para o desenvolvimento.
Estes foram criados principalmente visando facilitar e agilizar contratempos recorrentes identificados durante o trabalho com banco de dados.

Abaixo, índice contendo os objetos e seus usos:
tb_obj_dicionário:
  É uma forma automatizada de documentar todas as functions e procedures criados no banco, criando uma tabela que os armazena, e traz consigo uma coluna(mensagem) cujo objetivo é possibilitar a escrita de um texto curto sobre os parâmetros dos objetos. Veja o exemplo abaixo, considerando a função "f_div_segura", presente neste mesmo diretório (msql_server_queries/"Objetos de apoio"/): 
    - f_div_segura.numerador: Parâmetro responsável por alimentar o numerador da divisão;
    - f_div_segura.divisor: Parâmetro responsável por alimentar o denominador da divisão.

f_div_segura:
  É uma função responsável por realizar divisões utilizando um try...catch, evitando problemas como divisão por zero, por exemplo.
