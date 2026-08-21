-- Criação do Banco de Dados --
create database eventpay;
use eventpay;

-- Criação das Tabelas --
create table Endereco (
	cep char(8) not null,
	rua varchar(50) not null,
	numero smallint not null check (numero > 0),
	complemento varchar(30),
	status varchar(10) not null default 'ativo',
	constraint pk_endereco primary key(cep)
);

create table forma(
	id int auto_increment, 
	nome varchar(30) not null check( nome = 'pix' or nome = 'credito' or nome = 'debito' or nome = 'boleto'),
	constraint pk_forma_id_forma primary key(id)
);

create table pagamento(
	id int auto_increment,
    data datetime not null default current_timestamp,
    valor decimal(7,2) not null,
    id_forma int not null,
	ingressos_comprados int not null,
    status varchar(10) not null default 'ativo',
    constraint pk_id primary key(id),
    constraint fk_pagamento_id_forma foreign key(id_forma) references forma(id) on update cascade on delete restrict
);

create table empresa(
	cnpj char(18),
    nome varchar(50) not null,
    email varchar(80) unique not null,
    senha varchar(30) not null check (CHAR_LENGTH(senha) >= 8),
    endereco_cep char(8),
	status varchar(10) not null default 'ativo',
    constraint pk_cnpj primary key(cnpj),
    constraint fk_empresa_endereco_cep foreign key(endereco_cep) references endereco(cep) on update cascade on delete set null
);

create table evento(
	id int auto_increment,
    nome varchar(50) not null,
    data date not null,
    hora time not null,
    descricao varchar(200) not null,
    genero varchar(40) not null,
    quantidade int not null,
    empresa_cnpj varchar(18),
    endereco_cep char(8),
    status varchar(10) not null default 'ativo',
    constraint pk_id primary key(id),
    constraint fk_evento_empresa_cnpj foreign key(empresa_cnpj) references empresa(cnpj) on delete restrict,
    constraint fk_evento_endereco_cep foreign key(endereco_cep) references endereco(cep) on update cascade on delete set null
);

create table cliente(
	email varchar(80),
    nome varchar(50) not null,
    senha varchar(30) not null check (CHAR_LENGTH(senha) >= 8),
    cpf char(11) unique,
    data_nasc date not null,
    endereco_cep char(8),
    status varchar(10) not null default 'ativo',
    constraint pk_cliente primary key(email),
    constraint fk_cliente_endereco_cep foreign key(endereco_cep) references endereco(cep) on update cascade on delete set null
);

create table telefone(
	numero char(11) not null,
    empresa_cnpj char(18),
    cliente_email varchar(80),
    status varchar(10) not null default 'ativo',
    constraint pk_numero primary key(numero),
    constraint fk_empresa_cnpj foreign key(empresa_cnpj) references empresa(cnpj) on delete set null,
    constraint fk_cliente_email foreign key(cliente_email) references cliente(email) on update cascade on delete cascade
);

create table ingresso(
	id int auto_increment,
    tipo varchar(7) not null check(tipo = "Inteira" or tipo = "Meia"),
    preco decimal(6,2) not null,
    evento_id int,
    cliente_email varchar(80),
    pagamento_id int,
    status varchar(10) not null default 'ativo',
	constraint pk_id primary key(id),
	constraint fk_ingresso_evento_id foreign key(evento_id) references evento(id) on update cascade on delete restrict,
	constraint fk_ingresso_cliente_email foreign key(cliente_email) references cliente(email) on update cascade on delete set null,
    constraint fk_ingresso_pagamento_id foreign key(pagamento_id) references pagamento(id) on update cascade on delete set null
);

-- Criação dos Inserts 

insert into endereco(cep,rua,numero,complemento) values
('01001000','Av. Paulista',1578,'Conj. 101'),
('02022030','Rua Voluntários da Pátria',345,'Apto 12'),
('04045040','Rua Vergueiro',2122,'Bloco B'),
('05010020','Rua Cerro Corá',800,'Casa'),
('06018025','Rua Antônio Agu',120,'Sala 3'),
('07090015','Av. Lucas Nogueira Garcez',500,'Loja 1'),
('08015010','Rua das Palmeiras',45,'Fundos'),
('09030000','Av. Getúlio Vargas',900,'Apto 21'),
('11045060','Rua XV de Novembro',310,'Casa'),
('13023055','Rua Barão de Jaguara',1500,'Sala 4');

insert into forma(nome) values
('pix'),
('credito'),
('debito'),
('boleto'),
('pix'),
('credito'),
('debito'),
('boleto'),
('pix'),
('credito');

insert into empresa(cnpj,nome,email,senha,endereco_cep) values
('12.345.678/0001-90','TechWave Solutions','contato@techwave.com','senha123','01001000'),
('23.456.789/0001-80','Brasil Eventos Ltda','eventos@brasil.com','segura12','02022030'),
('34.567.890/0001-70','Cia de Teatro Aurora','contato@aurorateatro.com','senha999','04045040'),
('45.678.901/0001-60','Festival Brasil Music','info@brmusic.com','music123','05010020'),
('56.789.012/0001-50','Gastrô Feira Gourmet','contato@gastrofeiras.com','gast1234','06018025'),
('67.890.123/0001-40','GameWorld Expo','contato@gameworld.com','expo2024','07090015'),
('78.901.234/0001-30','Balada Neon Club','neon@club.com','neon7777','08015010'),
('89.012.345/0001-20','Anime Brasil Convention','contato@animebr.com','otaku123','09030000'),
('90.123.456/0001-10','EcoFeira Sustentável','eco@feira.com','verde456','11045060'),
('11.987.654/0001-00','TechMasters Conference','info@techmasters.com','tech2025','13023055');


insert cliente(email,nome,senha,cpf,data_nasc,endereco_cep) values
('ana.silva@gmail.com','Ana Silva','ana12345','12345678901','1990-03-12','01001000'),
('joao.mendes@yahoo.com','João Mendes','jmendes22','98765432100','1988-07-20','02022030'),
('mariana.rocha@outlook.com','Mariana Rocha','mar12345','11122233344','1995-01-25','04045040'),
('carlos.souza@gmail.com','Carlos Souza','souza555','22233344455','1992-04-18','05010020'),
('juliana.lima@hotmail.com','Juliana Lima','lima9090','33344455566','1998-10-10','06018025'),
('ricardo.pires@gmail.com','Ricardo Pires','rp202456','44455566677','1985-11-05','07090015'),
('fernanda.alves@uol.com','Fernanda Alves','123fern7','55566677788','1991-09-09','08015010'),
('thiago.santos@gmail.com','Thiago Santos','ts777777','66677788899','1996-06-30','09030000'),
('isabela.castro@gmail.com','Isabela Castro','isa12345','77788899900','1994-02-14','11045060'),
('marcos.paiva@gmail.com','Marcos Paiva','mar11555','88899900011','1987-12-01','13023055');


insert into telefone(numero,empresa_cnpj,cliente_email) values
('11990010001','12.345.678/0001-90',NULL),
('11990010002','23.456.789/0001-80',NULL),
('11990010003','34.567.890/0001-70',NULL),
('11990010004','45.678.901/0001-60',NULL),
('11990010005','56.789.012/0001-50',NULL),
('11980020001',NULL,'ana.silva@gmail.com'),
('11980020002',NULL,'joao.mendes@yahoo.com'),
('11980020003',NULL,'mariana.rocha@outlook.com'),
('11980020004',NULL,'carlos.souza@gmail.com'),
('11980020005',NULL,'juliana.lima@hotmail.com');


insert into pagamento(data,valor,id_forma,ingressos_comprados) values
('2025-01-01',89.90,1,10),
('2025-01-02',120.00,2,2),
('2025-01-03',150.50,3,28),
('2025-01-04',200.00,4,2),
('2025-01-05',75.00,5,3),
('2025-01-06',95.00,6,8),
('2025-01-07',110.00,7,10),
('2025-01-08',180.00,8,19),
('2025-01-09',220.00,9,9),
('2025-01-10',60.00,10,13);

INSERT INTO evento(nome, data, hora, descricao, genero, quantidade, empresa_cnpj, endereco_cep) VALUES
('Show Capital Inicial', '2025-03-10', '20:00:00', 'Show da banda Capital Inicial com repertório dos maiores sucessos.', 'Show', 3000, '12.345.678/0001-90', '01001000'),
('Musical O Rei Leão', '2025-04-12', '18:00:00', 'Espetáculo musical inspirado na famosa produção da Broadway.', 'Teatro', 1500, '23.456.789/0001-80', '02022030'),
('Stand Up com Thiago Ventura', '2025-05-01', '19:30:00', 'Show de comédia stand-up com o humorista Thiago Ventura.', 'Comédia', 800, '34.567.890/0001-70', '04045040'),
('Festival de Jazz São Paulo', '2025-06-22', '21:00:00', 'Festival musical reunindo grandes artistas nacionais e internacionais do jazz.', 'Show', 5000, '45.678.901/0001-60', '05010020'),
('Feira Internacional de Gastronomia', '2025-07-15', '17:00:00', 'Feira com chefs renomados e degustações de diversas culinárias do mundo.', 'Feira', 2000, '56.789.012/0001-50', '06018025'),
('GameWorld Expo 2025', '2025-08-10', '10:00:00', 'Evento de games com lançamentos, campeonatos e área para testes.', 'Expo', 6000, '67.890.123/0001-40', '07090015'),
('Neon Night Festival', '2025-09-05', '23:00:00', 'Festival noturno com música eletrônica, efeitos de luz e DJs renomados.', 'Show', 3500, '78.901.234/0001-30', '08015010'),
('Anime Brasil 2025', '2025-10-12', '09:00:00', 'Grande encontro para fãs de anime, mangá, cosplay e cultura pop japonesa.', 'Expo', 8000, '89.012.345/0001-20', '09030000'),
('EcoFeira Sustentável 2025', '2025-11-01', '08:00:00', 'Feira dedicada à sustentabilidade, reciclagem e projetos ecológicos.', 'Feira', 1500, '90.123.456/0001-10', '11045060'),
('TechMasters Conference 2025', '2025-12-20', '14:00:00', 'Conferência tecnológica com palestras sobre inovação, IA e futuro digital.', 'Palestra', 1200, '11.987.654/0001-00', '13023055');

insert into ingresso(tipo,preco,evento_id,cliente_email,pagamento_id) values
('Inteira',120.00,1,'ana.silva@gmail.com',1),
('Inteira',150.00,2,'joao.mendes@yahoo.com',2),
('Meia',180.00,3,'mariana.rocha@outlook.com',3),
('Inteira',250.00,4,'carlos.souza@gmail.com',4),
('Meia',80.00,5,'juliana.lima@hotmail.com',5),
('Meia',300.00,6,'ricardo.pires@gmail.com',6),
('Inteira',90.00,7,'fernanda.alves@uol.com',7),
('Meia',250.00,8,'thiago.santos@gmail.com',8),
('Inteira',70.00,9,'isabela.castro@gmail.com',9),
('Inteira',350.00,10,'marcos.paiva@gmail.com',10);

select * from evento;
select * from ingresso;

-- Criação dos Procedures --
-- Exemplo de Chamada --
-- select * from endereco;
-- call insert_endereco('07500000','Av. Paulista',1578,'Conj. 101');
-- Procedures Endereco --
delimiter //

create procedure insert_endereco(
    in p_cep char(8),
    in p_rua varchar(50),
    in p_numero smallint,
    in p_complemento varchar(30)
)
begin
    insert into endereco(cep,rua,numero,complemento) values (p_cep, p_rua, p_numero, p_complemento);
end //

create procedure update_endereco(
    in p_cep char(8),
    in p_rua varchar(50),
    in p_numero smallint,
    in p_complemento varchar(30)
)
begin
    update endereco set rua = p_rua, numero = p_numero, complemento = p_complemento where cep = p_cep;
end //

create procedure delete_endereco(
    in p_cep char(8)
)
begin
    update endereco
    set status = 'inativo'
    where cep = p_cep;
end //

delimiter ;

-- Chamando a Procedure --

CALL insert_endereco('99999999', 'Rua Exemplo', 100, 'Casa A');
CALL update_endereco('99999999', 'Rua Alterada', 120, 'Casa B');
CALL delete_endereco('99999999');
select * from endereco;

-- Procedures Forma --

delimiter //

create procedure insert_forma(in p_nome varchar(30))
begin
    insert into forma(nome) values(p_nome);
end // 

create procedure update_forma(in p_id int, in p_nome varchar(30))
begin
    update forma set nome = p_nome where id = p_id;
end //

create procedure delete_forma(in p_id int)
begin
    delete from forma where id = p_id;
end //

delimiter ;

-- Chamando a Procedure --

CALL insert_forma('pix');
CALL update_forma(1, 'credito');
CALL delete_forma(1);

-- Procedures Empresa --

delimiter //

create procedure insert_empresa(
    in p_cnpj char(18),
    in p_nome varchar(50),
    in p_email varchar(80),
    in p_senha varchar(30),
    in p_endereco_cep char(8)
)
begin
    insert into empresa(cnpj,nome,email,senha,endereco_cep) values (p_cnpj, p_nome, p_email, p_senha, p_endereco_cep);
end //

create procedure update_empresa(
    in p_cnpj char(18),
    in p_nome varchar(50),
    in p_email varchar(80),
    in p_senha varchar(30),
    in p_endereco_cep char(8)
)
begin
    update empresa
    set nome = p_nome, email = p_email, senha = p_senha, endereco_cep = p_endereco_cep where cnpj = p_cnpj;
end //

create procedure delete_empresa(in p_cnpj char(18))
begin
	update empresa
    set status = 'inativo'
    where cnpj = p_cnpj;
end //
desc empresa;
delimiter ;

-- Chamando a Procedure --

CALL insert_empresa('12.000.000/0001-00', 'Nova Empresa', 'empresa@teste.com', 'senha1234', '01001000');
CALL update_empresa('12.000.000/0001-00', 'Empresa Nova Ltda', 'contato@empresa.com', 'novaSenha88', '02022030');
CALL delete_empresa('12.000.000/0001-00');
select * from empresa;

-- Procedures Evento --
delimiter //

create procedure insert_evento(
    in p_nome varchar(50),
    in p_data date,
    in p_hora time,
    in p_descricao varchar(200),
    in p_genero varchar(40),
    in p_quantidade int,
    in p_empresa_cnpj char(18),
    in p_endereco_cep char(8)
)
begin
    insert into evento(nome, data, hora, descricao, genero, quantidade, empresa_cnpj, endereco_cep) 
    values(p_nome, p_data, p_hora, p_descricao, p_genero, p_quantidade, p_empresa_cnpj, p_endereco_cep);
end //

create procedure update_evento(
    in p_id int,
    in p_nome varchar(50),
    in p_data date,
    in p_hora time,
    in p_descricao varchar(200),
    in p_genero varchar(40),
    in p_quantidade int,
    in p_empresa_cnpj char(18),
    in p_endereco_cep char(8)
)
begin
    update evento
    set nome = p_nome,
        data = p_data,
        hora = p_hora,
        descricao = p_descricao,
        genero = p_genero,
        quantidade = p_quantidade,
        empresa_cnpj = p_empresa_cnpj,
        endereco_cep = p_endereco_cep
    where id = p_id;
end //

create procedure delete_evento(in p_id int)
begin
    update evento
    set status = 'inativo'
    where id = p_id;
end //

delimiter ;

-- Chamando a Procedure --

CALL insert_evento(
'Festa Teste', '2025-05-10', '19:00:00', 'Descrição exemplo', 'Show', 500, '12.345.678/0001-90', '01001000');
CALL update_evento(
1, 'Evento Alterado', '2025-06-01', '20:00:00', 'Descrição atualizada', 'Teatro', 3000, '23.456.789/0001-80', '02022030'
);
CALL delete_evento(1);
select * from evento;

-- Procedure Pagamento --
delimiter //

create procedure insert_pagamento(
    in p_data date,
    in p_valor decimal(7,2),
    in p_id_forma int,
    in p_ingressos_comprados int
)
begin
    insert into pagamento(data, valor, id_forma, ingressos_comprados) values (p_data, p_valor, p_id_forma, p_ingressos_comprados);
end //

create procedure update_pagamento(
    in p_id int,
    in p_data date,
    in p_valor decimal(7,2),
    in p_id_forma int,
    in p_ingressos_comprados int
)
begin
    update pagamento
    set data = p_data,
        valor = p_valor,
        id_forma = p_id_forma,
        ingressos_comprados = p_ingressos_comprados
    where id = p_id;
end //

create procedure delete_pagamento(in p_id int)
begin
    update pagamento
    set status = 'inativo'
    where id = p_id;
end //

delimiter ;

-- Chamando a Procedure

CALL insert_pagamento('2025-05-01', 150.00, 1, 2);
CALL update_pagamento(1, '2025-05-02', 200.00, 2, 3);
CALL delete_pagamento(1);
select * from pagamento

-- Procedure Cliente -- 
delimiter //

create procedure insert_cliente(
    in p_email varchar(80),
    in p_nome varchar(50),
    in p_senha varchar(30),
    in p_cpf char(11),
    in p_data_nasc date,
    in p_cep char(8)
)
begin
    insert into cliente(email, nome, senha, cpf, data_nasc, endereco_cep) values (p_email, p_nome, p_senha, p_cpf, p_data_nasc, p_cep);
end //

create procedure update_cliente(
    in p_email varchar(80),
    in p_nome varchar(50),
    in p_senha varchar(30),
    in p_cpf char(11),
    in p_data_nasc date,
    in p_cep char(8)
)
begin
    update cliente
    set nome = p_nome,
        senha = p_senha,
        cpf = p_cpf,
        data_nasc = p_data_nasc,
        endereco_cep = p_cep
    where email = p_email;
end //

create procedure delete_cliente(in p_email varchar(80))
begin
    update cliente
    set status = 'inativo'
    where email = p_email;
end //

delimiter ;

-- Chamando a Procedure --

CALL insert_cliente('teste@teste.com', 'Cliente Teste', 'senha1234', '12345678999', '1990-01-01', '01001000');
CALL update_cliente('teste@teste.com', 'Cliente Alterado', 'senha9999', '99999999999', '1991-02-02', '02022030');
CALL delete_cliente('teste@teste.com');
select * from cliente;

-- Procedure Telefone --

delimiter //

create procedure insert_telefone(
    in p_numero char(11),
    in p_empresa_cnpj char(18),
    in p_cliente_email varchar(80)
)
begin
    insert into telefone(numero, empresa_cnpj, cliente_email)
    values (p_numero, p_empresa_cnpj, p_cliente_email);
end //

create procedure update_telefone(
    in p_numero char(11),
    in p_empresa_cnpj char(18),
    in p_cliente_email varchar(80)
)
begin
    update telefone
    set empresa_cnpj = p_empresa_cnpj,
        cliente_email = p_cliente_email
    where numero = p_numero;
end //

create procedure delete_telefone(in p_numero char(11))
begin
    update telefone
    set status = 'inativo'
    where numero = p_numero;
end //

delimiter;

-- Chamando a Procedure --

CALL insert_telefone('11999999999', '12.345.678/0001-90', NULL);
CALL update_telefone('11999999999', NULL, 'ana.silva@gmail.com');
CALL delete_telefone('11999999999');
select * from telefone;

-- Procedure Ingresso -- 

delimiter //

create procedure insert_ingresso(
    in p_tipo varchar(50),
    in p_preco decimal(6,2),
    in p_evento_id int,
    in p_cliente_email varchar(80),
    in p_pagamento_id int
)
begin
    insert into ingresso(tipo, preco, evento_id, cliente_email, pagamento_id) values (p_tipo, p_preco, p_evento_id, p_cliente_email, p_pagamento_id);
end //

create procedure update_ingresso(
    in p_id int,
    in p_tipo varchar(50),
    in p_preco decimal(6,2),
    in p_evento_id int,
    in p_cliente_email varchar(80),
    in p_pagamento_id int
)
begin
    update ingresso
    set tipo = p_tipo,
        preco = p_preco,
        evento_id = p_evento_id,
        cliente_email = p_cliente_email,
        pagamento_id = p_pagamento_id
    where id = p_id;
end //

create procedure delete_ingresso(in p_id int)
begin
    update ingresso
    set status = 'inativo'
    where id = p_id;
end //

delimiter ;

-- Chamando a Procedure --

CALL insert_ingresso('Inteira', 150.00, 1, 'ana.silva@gmail.com', 1);
CALL update_ingresso(1, 'Meia', 80.00, 2, 'joao.mendes@yahoo.com', 2);
CALL delete_ingresso(1);
select * from ingresso;

-- Criação das Views --

create view view_eventos_disponiveis as
select evento.id,
		evento.nome,
        evento.data,
		evento.hora,
        evento.descricao,
        evento.genero,
        evento.quantidade as capacidade_total 
from evento
left join ingresso on ingresso.evento_id = evento.id
group by evento.id;

SELECT * FROM view_eventos_disponiveis;

---------------------------

create view view_compra as
select evento.nome,
		ingresso.tipo as tipo_ingresso, 
        ingresso.preco as preco_unitario, 
        pagamento.ingressos_comprados, 
        (ingresso.preco * pagamento.ingressos_comprados) as valor_total 
from ingresso 
left join evento on evento.id = ingresso.evento_id 
left join pagamento on pagamento.id = ingresso.pagamento_id;

SELECT * FROM view_compra;

-------------------------------

create view view_carrinho_usuario as
select cliente.email,
       cliente.nome,
       empresa.nome as nome_empresa,
       count(ingresso.id) as total_itens,
       sum(ingresso.preco) as total_carrinho
from cliente
left join ingresso on ingresso.cliente_email = cliente.email
left join evento on evento.id = ingresso.evento_id
left join empresa
       on empresa.cnpj = evento.empresa_cnpj
group by cliente.email;

SELECT * FROM view_carrinho_usuario;

-- Criação dos Indices --

create fulltext index idx_evento_resumo on evento(nome,descricao);

create index idx_ingresso_preco on ingresso(preco);

create index idx_empresa_nome on empresa(nome);

-- Criação da Transação --

delimiter //

create procedure comprar_ingresso(
    in p_evento_id int,
    in p_qtd_comprada int,
    in p_valor_total decimal(10,2),
    in p_forma int
)
begin
    declare estoque_atual int;

    start transaction;

    select quantidade into estoque_atual
    from evento
    where id = p_evento_id;

    if estoque_atual < p_qtd_comprada then
        rollback;
    end if;

    insert into pagamento (valor, id_forma, ingressos_comprados)
    values (p_valor_total, p_forma, p_qtd_comprada);

    update evento
    set quantidade = quantidade - p_qtd_comprada
    where id = p_evento_id;

    commit;
end //

delimiter ;

-- Transação Exemplo --
-- select * from pagamento;
-- select * from evento;
-- CALL comprar_ingresso(1, 1, 150.00, 1);

