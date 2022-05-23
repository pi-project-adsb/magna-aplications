create database bd_magna;
use bd_magna;

create table empresa (
    id int primary key AUTO_INCREMENT,
    email varchar(45),
    nome varchar(45),
    cnpj VARCHAR(45),
    senha VARCHAR(45)
);

create table if not exists totem (
    id INT PRIMARY KEY AUTO_INCREMENT,
    hostname VARCHAR(50),
    localizacao VARCHAR(50),
    totem_status VARCHAR(50),
    endereco_mac VARCHAR(50),
    sistema_op varchar(50),
    total_disco int,
    modelo_cpu varchar(50),
    frequencia_cpu varchar(50),
    nucleos_cpu int,
    threads_cpu int,
    total_ram int,
    fk_empresa int,
    FOREIGN KEY (fk_empresa) REFERENCES empresa(id)
);

create TABLE if not exists registro (
    id INT PRIMARY KEY AUTO_INCREMENT,
    uso_disco int,
    disponivel_disco int,
	uso_cpu int,
	disponivel_ram int,
    uso_ram int,
    fk_totem int,
    dh_registro datetime
);

create table if not exists processo (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pid VARCHAR(50),
    nome VARCHAR(50),
    consumo_cpu VARCHAR(50),
    consumo_ram VARCHAR(50),
    fk_totem int,
    FOREIGN KEY (fk_totem) REFERENCES totem(id)
);

insert into empresa(email, senha) values ("lucas@gmail.com", "12345678");


