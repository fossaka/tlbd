use master;

drop database dtbSql;

create database dtbSql;

use dtbSql;


CREATE TABLE tb_metodologia(
	[idMetodologia] [int]PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[nmTitulo] [varchar](50) NULL,
	[descrucao] [varchar](100) NULL);

CREATE TABLE tb_tarefa(
	[idTarefa] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[nmTitulo] [varchar](30) NOT NULL,
	[prazoEstimado] [date] NOT NULL,
	[descricao] [varchar](150) NULL,
	[dataInicio] [date] NOT NULL,
	[dataTermino] [date] NULL,
	[idMetodologia] [int]	
	FOREIGN KEY (idMetodologia) REFERENCES tb_metodologia(idMetodologia));

CREATE TABLE tb_pessoas(
	[idPessoa] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[nmPessoa] [varchar](50) NOT NULL,
	[email] [varchar](50) NULL,
	[cep] [varchar](50) NULL,
	[sexo] [varchar](20));

CREATE TABLE tb_relacao_tarefa_pessoa(
	[idRelacao] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[idTarefa] [int] NULL,
	[idPessoa] [int] NULL
	FOREIGN KEY (idTarefa) REFERENCES tb_tarefa(idTarefa),
	FOREIGN KEY (idPessoa) REFERENCES tb_pessoas(idPessoa));
	
insert into tb_metodologia (nmTitulo, descrucao)VALUES 
('Metodologia1', 'metodologia1metodologia'),
('Metodologia2', 'Metodologia2Metodologia'),
('Metodologia3', 'Metodologia3Metodologia'),
('Metodologia4', 'Metodologia4Metodologia'),
('Metodologia5', 'Metodologia5Metodologia');

INSERT INTO tb_tarefa (nmTitulo, prazoEstimado, descricao, dataInicio, dataTermino, idMetodologia)Values
('titulo1', '2000-01-02', 'descricao1', '2000-01-01', '2000-01-01', 1), 
('titulo2', '2000-01-02', 'descricao2', '2000-01-01', '2000-01-01', 2),
('titulo3', '2000-01-02', 'descricao3', '2000-01-01', '2000-01-01', 2),
('titulo4', '2000-01-02', 'descricao4', '2000-01-01', '2003-01-03', 3),
('titulo5', '2000-01-02', 'descricao5', '2000-01-01', '2000-01-03', 4);

INSERT INTO tb_pessoas (nmPessoa, email, cep, sexo) VALUES 
('Pessoa1', 'pessoa1@asd.com', '08110-150', 'Homem'),
('Pessoa2', 'pessoa2@asd.com', '08110-150', 'Mulher'),
('Pessoa3', 'pessoa3@asd.com', '08110-150', 'Homem'),
('Pessoa4', 'pessoa4@asd.com', '08110-150', 'Mulher'),
('Pessoa5', 'pessoa5@asd.com', '08110-150', 'Mulher'),
('Pessoa6', 'pessoa6@asd.com', '08110-150', 'Homem'),
('Pessoa7', 'pessoa7@asd.com', '08110-150', 'Homem');

INSERT INTO tb_relacao_tarefa_pessoa (idTarefa, idPessoa )VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(1,2),
(1,3),
(1,4),
(1,5),
(3,5),
(2,5),
(5,3),
(4,5);

/*
select * from tb_metodologia
select * from tb_relacao_tarefa_pessoa
select * from tb_pessoas
select * from tb_tarefa
*/

-- 1) Listar pessoas que não fazem parte de nenhuma tarefa
select * from tb_pessoas as p
left join tb_relacao_tarefa_pessoa as r 
on p.idPessoa = r.idPessoa where r.idRelacao is NULL

-- 2) Listar nome das metodologias mais utilizadas

select COUNT(m.idMetodologia) as VezesUtilizadas, m.nmTitulo as NomeMetodologia
from tb_metodologia as m
right join tb_tarefa as t
on (m.idMetodologia = t.idMetodologia)
group by m.idMetodologia,m.nmTitulo
order by COUNT(t.idMetodologia) desc;

order by COUNT(r.idTarefa);

 --3)Contagem tarefas só com homens
select COUNT (r.idTarefa) as TarefasSoHomens, p.nmPessoa as Pessoa from tb_relacao_tarefa_pessoa as r
INNER JOIN tb_pessoas as p 
on p.idPessoa = r.idPessoa where p.sexo = 'homem' 
group by p.nmPessoa
	
	-- 3.1) Listar tarefas com homens
	select idTarefa,p.sexo,p.nmPessoa from tb_relacao_tarefa_pessoa as r
	inner join tb_pessoas as p on p.idPessoa = r.idPessoa where p.sexo = 'homem' order by r.idTarefa asc; 

	
	--3.2)listagem tarefas com mulheres
select idTarefa,p.sexo from tb_relacao_tarefa_pessoa as r
inner join tb_pessoas as p on p.idPessoa = r.idPessoa where p.sexo = 'mulher' order by r.idTarefa asc; 

-- 4) Quais os nomes das pessoas com tarefas atrasadas?
select * from ((tb_tarefa as t
inner join tb_relacao_tarefa_pessoa as r on r.idTarefa = t.idTarefa)
inner join tb_pessoas as p on p.idPessoa = r.idPessoa)
where t.dataTermino > prazoEstimado;

-- 5) listar tarefas com os 2 sexos
select r.idTarefa,p.nmPessoa ,p.sexo from tb_relacao_tarefa_pessoa as r
inner join tb_pessoas as p on p.idPessoa = r.idPessoa 
where p.sexo = 'Homem'
group by r.idTarefa,p.nmPessoa,p.sexo 

