-- Criação do banco de dados
CREATE DATABASE hospitals

-- Criar login no banco (deve estar no banco master e ter permissão)
/*
CREATE LOGIN <user>
	WITH PASSWORD = <password>
GO
*/

-- Criação do usuário no banco hospitals
/*
CREATE USER <user> FROM LOGIN <user>
WITH DEFAULT_SCHEMA = [dbo];
GO
EXEC sp_addrolemember 'db_ddladmin', '<user>';
GO
EXEC sp_addrolemember 'db_datawriter', '<user>';
GO
EXEC sp_addrolemember 'db_datareader', '<user>';
GO
GRANT REFERENCES TO <user>;  
GO
GRANT EXECUTE TO <user>; --- RUN dbo.new_id
GO
GRANT VIEW DATABASE STATE TO <user>; --- RUN rebuild_indexs
GO
ALTER SERVER ROLE ##MS_ServerStateManager## ADD MEMBER <user>; --- RUN DBCC DROPCLEANBUFFERS
GO
GRANT SHOWPLAN TO <user>;
GO
*/

-- Script para criar tabelas e populá-las, criar funções, procedures, auxiliares, etc.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Criação de view para valores aleatórios
CREATE VIEW [dbo].[rand_view]
AS
    SELECT RAND() VALUE;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Função para pegar valor aleatório
CREATE FUNCTION [dbo].[get_random](@min INT, @max INT) RETURNS INT AS
BEGIN
    RETURN ROUND(((@max-@min-1)*(SELECT r.value
    FROM rand_view r)+@min),0);
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Função para pegar os caracteres aleatórios
CREATE FUNCTION [dbo].[get_random_chars](@chars VARCHAR(max), @len INT) RETURNS VARCHAR(max) AS
BEGIN
    DECLARE @aux varchar(max)
    set @aux='';
    DECLARE @count int
    set @count=0;
    WHILE (@count<@len)
	BEGIN
        DECLARE @r INT
        SET @r=dbo.get_random(1,len(@chars));
        SET @aux+=substring(@chars,@r,1);
        SET @count+=1;
    END
    RETURN @aux;
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Função para criar ids com 8 caracteres aleatórios
CREATE FUNCTION [dbo].[new_id]() returns char(8) as
BEGIN
    return [dbo].[get_random_chars]('0123456789ABCDEFGHIJKLMNOPQRSTUVXWYZabcdefghijklmnopqrstuvxwyz',(8));
END
GO
-- Criação da tabela de pacientes, médicos e enfermeiros (Já popula as tabelas com dois mil linhas também!)
CREATE TABLE States
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    state NVARCHAR(50)
);
GO
INSERT INTO States
    (state)
VALUES
    ('Acre'),
    ('Alagoas'),
    ('Amapá'),
    ('Amazonas'),
    ('Bahia'),
    ('Ceará'),
    ('Distrito Federal'),
    ('Espírito Santo'),
    ('Goiás'),
    ('Maranhão'),
    ('Mato Grosso'),
    ('Mato Grosso do Sul'),
    ('Minas Gerais'),
    ('Pará'),
    ('Paraíba'),
    ('Paraná'),
    ('Pernambuco'),
    ('Piauí'),
    ('Rio de Janeiro'),
    ('Rio Grande do Norte'),
    ('Rio Grande do Sul'),
    ('Rondônia'),
    ('Roraima'),
    ('Santa Catarina'),
    ('São Paulo'),
    ('Sergipe'),
    ('Tocantins');
GO
-- Criação de tabela para cidades
CREATE TABLE Cities
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    city NVARCHAR(50),
    stateId INT FOREIGN KEY REFERENCES States(id)
);
GO
-- Inserir cidades (200 cidades, todos os estados do Brasil)
INSERT INTO Cities
    (city, stateId)
VALUES
    ('Rio Branco', 1),
    ('Maceió', 2),
    ('Macapá', 3),
    ('Manaus', 4),
    ('Salvador', 5),
    ('Fortaleza', 6),
    ('Brasília', 7),
    ('Vitória', 8),
    ('Goiânia', 9),
    ('São Luís', 10),
    ('Cuiabá', 11),
    ('Campo Grande', 12),
    ('Belo Horizonte', 13),
    ('Belém', 14),
    ('João Pessoa', 15),
    ('Curitiba', 16),
    ('Recife', 17),
    ('Teresina', 18),
    ('Rio de Janeiro', 19),
    ('Natal', 20),
    ('Porto Alegre', 21),
    ('Porto Velho', 22),
    ('Boa Vista', 23),
    ('Florianópolis', 24),
    ('São Paulo', 25),
    ('Aracaju', 26),
    ('Palmas', 27),
    ('Anápolis', 9),
    ('Niterói', 19);
GO
-- Criação de tabela para nomes de pacientes
CREATE TABLE Names
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100),
    gender CHAR(1)
    -- M ou F
);
GO
-- Inserir nomes (100 nomes variados)
INSERT INTO Names
    (name, gender)
VALUES
    ('Carlos', 'M'),
    ('Rafael', 'M'),
    ('Gabriel', 'M'),
    ('Lucas', 'M'),
    ('Gustavo', 'M'),
    ('Mariana', 'F'),
    ('Isabela', 'F'),
    ('Juliana', 'F'),
    ('Ana', 'F'),
    ('Patrícia', 'F'),
    ('Thiago', 'M'),
    ('Eduardo', 'M'),
    ('Felipe', 'M'),
    ('Matheus', 'M'),
    ('Vinícius', 'M'),
    ('Larissa', 'F'),
    ('Amanda', 'F'),
    ('Carolina', 'F'),
    ('Camila', 'F'),
    ('Bruna', 'F'),
    ('Daniel', 'M'),
    ('Diego', 'M'),
    ('Fernando', 'M'),
    ('Rodrigo', 'M'),
    ('Renata', 'F'),
    ('Fábio', 'M'),
    ('Fernanda', 'F'),
    ('Jéssica', 'F'),
    ('Luiz', 'M'),
    ('Ricardo', 'M'),
    ('Thaís', 'F'),
    ('Nathália', 'F'),
    ('Paulo', 'M'),
    ('Márcio', 'M'),
    ('Leonardo', 'M'),
    ('Rafaela', 'F'),
    ('Roberta', 'F'),
    ('Luciana', 'F'),
    ('Anderson', 'M'),
    ('Adriana', 'F'),
    ('Alexandre', 'M'),
    ('André', 'M'),
    ('Bianca', 'F'),
    ('Cristiane', 'F'),
    ('Débora', 'F'),
    ('Elaine', 'F'),
    ('Elen', 'F'),
    ('Flávio', 'M'),
    ('Gabriela', 'F'),
    ('Giovanna', 'F'),
    ('Henrique', 'M'),
    ('Ingrid', 'F'),
    ('Igor', 'M'),
    ('João', 'M'),
    ('José', 'M'),
    ('Júlia', 'F'),
    ('Karla', 'F'),
    ('Laura', 'F'),
    ('Letícia', 'F'),
    ('Marcela', 'F'),
    ('Márcia', 'F'),
    ('Mário', 'M'),
    ('Maurício', 'M'),
    ('Michele', 'F'),
    ('Natália', 'F'),
    ('Nathan', 'M'),
    ('Patrícia', 'F'),
    ('Paula', 'F'),
    ('Pedro', 'M'),
    ('Priscila', 'F'),
    ('Rafael', 'M'),
    ('Rita', 'F'),
    ('Roberto', 'M'),
    ('Samuel', 'M'),
    ('Sandra', 'F'),
    ('Sara', 'F'),
    ('Simone', 'F'),
    ('Sueli', 'F'),
    ('Tatiane', 'F'),
    ('Thiago', 'M'),
    ('Viviane', 'F'),
    ('William', 'M'),
    ('Yasmin', 'F'),
    ('Yuri', 'M'),
    ('Camila', 'F');
GO
-- Criação de tabela para sobrenomes
CREATE TABLE LastNames
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    last_name NVARCHAR(100)
);
GO
-- Inserir sobrenomes (50 sobrenomes variados)
INSERT INTO LastNames
    (last_name)
VALUES
    ('Silva'),
    ('Santos'),
    ('Oliveira'),
    ('Pereira'),
    ('Almeida'),
    ('Fernandes'),
    ('Melo'),
    ('Costa'),
    ('Araújo'),
    ('Martins'),
    ('Lima'),
    ('Gomes'),
    ('Ribeiro'),
    ('Sousa'),
    ('Carvalho'),
    ('Barbosa'),
    ('Rocha'),
    ('Alves'),
    ('Cardoso'),
    ('Mendes'),
    ('Nunes'),
    ('Monteiro'),
    ('Pinto'),
    ('Castro'),
    ('Cavalcanti'),
    ('Dias'),
    ('Teixeira'),
    ('Correia'),
    ('Cunha'),
    ('Freitas'),
    ('Moura'),
    ('Sales'),
    ('Oliveira'),
    ('Moraes'),
    ('Machado'),
    ('Ferreira'),
    ('Azevedo'),
    ('Campos'),
    ('Nascimento'),
    ('Lopes'),
    ('Cruz'),
    ('Batista'),
    ('Farias'),
    ('Vieira'),
    ('Amorim'),
    ('Dantas'),
    ('Peixoto'),
    ('Gonçalves'),
    ('Xavier'),
    ('Lemos');
GO
-- Criação de tabela para nomes de ruas
CREATE TABLE Streets
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    street NVARCHAR(255)
);
GO
-- Inserir nomes de ruas fictícias (você pode adicionar mais conforme necessário)
INSERT INTO Streets
    (street)
VALUES
    ('Rua 1'),
    ('Rua 2'),
    ('Rua 3'),
    ('Rua 4'),
    ('Rua 5'),
    ('Avenida 1'),
    ('Avenida 2'),
    ('Avenida 3'),
    ('Avenida 4'),
    ('Avenida 5'),
    ('Travessa 1'),
    ('Travessa 2'),
    ('Travessa 3'),
    ('Travessa 4'),
    ('Travessa 5'),
    ('Alameda 1'),
    ('Alameda 2'),
    ('Alameda 3'),
    ('Alameda 4'),
    ('Alameda 5');
GO
CREATE TABLE patients
(
    id CHAR(8) COLLATE Latin1_General_CS_AS PRIMARY KEY DEFAULT dbo.new_id(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    gender CHAR(1) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(8),
    phone VARCHAR(15)
);
GO
CREATE TABLE doctors
(
    id CHAR(8) COLLATE Latin1_General_CS_AS PRIMARY KEY DEFAULT dbo.new_id(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    gender CHAR(1) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(8),
    phone VARCHAR(15)
);
GO
CREATE TABLE nurses
(
    id CHAR(8) COLLATE Latin1_General_CS_AS PRIMARY KEY DEFAULT dbo.new_id(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    gender CHAR(1) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(8),
    phone VARCHAR(15)
);
GO
-- Modificação da procedure para inserir dados nas tabelas do esquema dbo com sobrenomes
CREATE PROCEDURE insert_data_in_specific_tables
AS
BEGIN
    DECLARE @table_name NVARCHAR(128);
    DECLARE @sql NVARCHAR(MAX);

    DECLARE table_cursor CURSOR FOR
    SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME IN ('nurses', 'doctors', 'patients');

    OPEN table_cursor;
    FETCH NEXT FROM table_cursor INTO @table_name;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @sql = '
        DECLARE @gender CHAR(1);
        SET @gender = (SELECT TOP 1 gender FROM Names ORDER BY NEWID());
        DECLARE @firstName NVARCHAR(100);
        SET @firstName = (SELECT TOP 1 name FROM Names WHERE gender = @gender ORDER BY NEWID());
        DECLARE @lastName NVARCHAR(100);
        SET @lastName = (SELECT TOP 1 last_name FROM LastNames ORDER BY NEWID());
        DECLARE @city NVARCHAR(50);
        SET @city = (SELECT TOP 1 city FROM Cities ORDER BY NEWID());
        DECLARE @state NVARCHAR(50);
        SET @state = (SELECT States.state FROM Cities INNER JOIN States ON Cities.stateId = States.id WHERE Cities.city = @city);
        DECLARE @street NVARCHAR(50);
        SET @street = (SELECT TOP 1 street FROM Streets ORDER BY NEWID());
        
        INSERT INTO ' + @table_name + ' (id, first_name, last_name, birth_date, gender, address, city, state, zip_code, phone)
        VALUES (
            dbo.new_id(),
            @firstName,
            @lastName,
            DATEADD(MONTH, -CAST(RAND()*12 AS INT), DATEADD(DAY, -CAST(RAND()*30 AS INT), DATEADD(YEAR, -CAST(RAND()*100 AS INT), GETDATE()))),
            @gender,
            @street,
            @city,
            @state,
            RIGHT(''00000000'' + CAST(CAST(RAND()*100000000 AS INT) AS VARCHAR(8)), 8),
            ''+55'' + RIGHT(''000000000000'' + CAST(CAST(RAND()*1000000000000 AS BIGINT) AS VARCHAR(12)), 12)
        );';

        EXEC sp_executesql @sql;

        FETCH NEXT FROM table_cursor INTO @table_name;
    END

    CLOSE table_cursor;
    DEALLOCATE table_cursor;
END;
GO
-- Executar a procedure para inserir dados nas tabelas de pacientes, médicos e enfermeiros
DECLARE @i INT = 0;
WHILE @i < 2000
    BEGIN
    EXEC insert_data_in_specific_tables;
    SET @i = @i + 1;
END
GO

-- Criar hospitais para os atendimentos
CREATE TABLE Hospitals
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    hospital NVARCHAR(100)
);
GO
INSERT INTO Hospitals
    (hospital)
VALUES
    ('Hospital Alegria'),
    ('Hospital Alvorada'),
    ('Hospital Amizade'),
    ('Hospital Amor'),
    ('Hospital Anjo'),
    ('Hospital Arco-Íris'),
    ('Hospital Aurora'),
    ('Hospital Aventura'),
    ('Hospital Azul'),
    ('Hospital Beleza'),
    ('Hospital Brilho'),
    ('Hospital Calma'),
    ('Hospital Caminho'),
    ('Hospital Canto'),
    ('Hospital Carinho'),
    ('Hospital Céu'),
    ('Hospital Compaixão'),
    ('Hospital Conforto'),
    ('Hospital Coração'),
    ('Hospital Cura'),
    ('Hospital Desejo'),
    ('Hospital Doce'),
    ('Hospital Esperança'),
    ('Hospital Estrela'),
    ('Hospital Felicidade'),
    ('Hospital Flor'),
    ('Hospital Harmonia'),
    ('Hospital Herói'),
    ('Hospital Horizonte'),
    ('Hospital Ilha'),
    ('Hospital Inspiração'),
    ('Hospital Jardim'),
    ('Hospital Jóia'),
    ('Hospital Luz'),
    ('Hospital Magia'),
    ('Hospital Maravilha'),
    ('Hospital Melodia'),
    ('Hospital Milagre'),
    ('Hospital Nascer'),
    ('Hospital Nuvem'),
    ('Hospital Oásis'),
    ('Hospital Onda'),
    ('Hospital Paixão'),
    ('Hospital Paz'),
    ('Hospital Perfeição'),
    ('Hospital Pétala'),
    ('Hospital Primavera'),
    ('Hospital Proteção'),
    ('Hospital Raio'),
    ('Hospital Recanto'),
    ('Hospital Riso'),
    ('Hospital Sabor'),
    ('Hospital Sabedoria'),
    ('Hospital Semente'),
    ('Hospital Sinfonia'),
    ('Hospital Sol'),
    ('Hospital Sonho'),
    ('Hospital Sossego'),
    ('Hospital Suave'),
    ('Hospital Sublime'),
    ('Hospital Sucesso'),
    ('Hospital Ternura'),
    ('Hospital Tesouro'),
    ('Hospital Tranquilidade'),
    ('Hospital União'),
    ('Hospital Universo'),
    ('Hospital Vida'),
    ('Hospital Vitória'),
    ('Hospital Viver'),
    ('Hospital Vontade'),
    ('Hospital Harmonia'),
    ('Hospital Herói'),
    ('Hospital Horizonte'),
    ('Hospital Ilha'),
    ('Hospital Inspiração'),
    ('Hospital Jardim'),
    ('Hospital Jóia'),
    ('Hospital Luz'),
    ('Hospital Magia'),
    ('Hospital Maravilha'),
    ('Hospital Melodia'),
    ('Hospital Milagre'),
    ('Hospital Nascer'),
    ('Hospital Nuvem'),
    ('Hospital Oásis'),
    ('Hospital Onda'),
    ('Hospital Paixão'),
    ('Hospital Paz'),
    ('Hospital Perfeição'),
    ('Hospital Pétala'),
    ('Hospital Primavera'),
    ('Hospital Proteção'),
    ('Hospital Raio'),
    ('Hospital Recanto'),
    ('Hospital Riso'),
    ('Hospital Sabor'),
    ('Hospital Sabedoria'),
    ('Hospital Semente'),
    ('Hospital Sinfonia'),
    ('Hospital Sol'),
    ('Hospital Sonho'),
    ('Hospital Sossego'),
    ('Hospital Suave'),
    ('Hospital Sublime'),
    ('Hospital Sucesso'),
    ('Hospital Ternura'),
    ('Hospital Tesouro'),
    ('Hospital Tranquilidade'),
    ('Hospital União'),
    ('Hospital Universo'),
    ('Hospital Vida'),
    ('Hospital Vitória'),
    ('Hospital Viver'),
    ('Hospital Vontade');
GO
-- Criar tipos de planos de saúde
CREATE TABLE HealthInsurance
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    health_insurance NVARCHAR(100)
)
GO
INSERT INTO HealthInsurance
    (health_insurance)
VALUES
    ('SUS'),
    ('Unimed'),
    ('NotreDame Intermédica'),
    ('Amil'),
    ('Sulamérica'),
    ('Bradesco Saúde'),
    ('Golden Cross'),
    ('Saúde Assim'),
    ('Allianz'),
    ('Caixa seguradora'),
    ('Salutar')
GO
-- Criar tipos de atendimento
CREATE TABLE AppointmentType
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    appointment_type NVARCHAR(100)
)
GO
INSERT INTO AppointmentType
    (appointment_type)
VALUES
    ('Clínica Geral'),
    ('Pediatria'),
    ('Ginecologia e Obstetrícia'),
    ('Cardiologia'),
    ('Ortopedia'),
    ('Dermatologia'),
    ('Oftalmologia'),
    ('Otorrinolaringologia'),
    ('Endocrinologia'),
    ('Gastroenterologia'),
    ('Neurologia'),
    ('Psiquiatria'),
    ('Urologia'),
    ('Radiologia'),
    ('Anestesiologia');
GO
-- Criar descrição do atendimento
CREATE TABLE AppointmentDescription
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    appointment_description NVARCHAR(255)
)
GO
INSERT INTO AppointmentDescription
    (appointment_description)
VALUES
    ('Consulta de Rotina'),
    ('Emergência por Lesão'),
    ('Cirurgia'),
    ('Exame de Sangue para Diagnóstico'),
    ('Avaliação Pediátrica'),
    ('Consulta Anual'),
    ('Atendimento por Febre e Resfriado'),
    ('Fratura Óssea'),
    ('Consulta de Acompanhamento Psiquiátrico'),
    ('Tratamento de Urgência');
GO
-- Criar avaliação do atendimento
CREATE TABLE AppointmentRating
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    appointment_rating NVARCHAR(255)
)
GO
INSERT INTO AppointmentRating
    (appointment_rating)
VALUES
    ('Muito ruim'),
    ('Ruim'),
    ('Aceitável'),
    ('Bom'),
    ('Muito bom');
GO
-- Criar tabela de atendimentos
CREATE TABLE appointments
(
    id CHAR(8) COLLATE Latin1_General_CS_AS PRIMARY KEY DEFAULT dbo.new_id(),
    id_doctor CHAR(8) COLLATE Latin1_General_CS_AS,
    id_nurse CHAR(8) COLLATE Latin1_General_CS_AS,
    id_patient CHAR(8) COLLATE Latin1_General_CS_AS,
    appointment_date DATE NOT NULL,
    appointment_type VARCHAR(100),
    appointment_description VARCHAR(255),
    appointment_rating VARCHAR(255),
    paid BIT NOT NULL DEFAULT 0,
    amount_paid DECIMAL(14,2) DEFAULT 0.0,
    FOREIGN KEY (id_doctor) REFERENCES doctors(id),
    FOREIGN KEY (id_nurse) REFERENCES nurses(id),
    FOREIGN KEY (id_patient) REFERENCES patients(id)
);
GO
-- Criar procedure para preencher tabela de atendimentos
CREATE PROCEDURE populate_appointments
AS
BEGIN
    DECLARE @counter INT = 1;

    WHILE @counter <= 2000
    BEGIN
        INSERT INTO appointments (
            id_doctor,
            id_nurse,
            id_patient,
            appointment_date,
            appointment_type,
            appointment_description,
            appointment_rating,
            paid,
            amount_paid
        )
        VALUES (
            (SELECT TOP 1 id FROM doctors ORDER BY NEWID()),
            (SELECT TOP 1 id FROM nurses ORDER BY NEWID()), 
            (SELECT TOP 1 id FROM patients ORDER BY NEWID()),
            DATEADD(day, -@counter, GETDATE()), -- Usando dias passados para criar datas variadas
            (SELECT TOP 1 appointment_type FROM AppointmentType ORDER BY NEWID()),
            (SELECT TOP 1 appointment_description FROM AppointmentDescription ORDER BY NEWID()),
            (SELECT TOP 1 appointment_rating FROM AppointmentRating ORDER BY NEWID()),
            CASE WHEN @counter % 2 = 0 THEN 1 ELSE 0 END, -- Alternando entre 0 e 1 para a coluna 'paid'
            CAST(RAND(CHECKSUM(NEWID())) * 500 + 50 AS DECIMAL(14,2)) -- Valor aleatório entre 50 e 550 para 'amount_paid'
        );

        SET @counter = @counter + 1;
    END;
END;
GO
-- Executar procedure para preencher tabela de atendimentos
EXEC populate_appointments
GO

-- Procedure para dropar tabelas utilizadas para popular a tabela
CREATE PROCEDURE dbo.drop_all_data
AS
BEGIN
    DROP TABLE Hospitals
    DROP TABLE HealthInsurance
    DROP TABLE AppointmentType
    DROP TABLE AppointmentDescription
    DROP TABLE AppointmentRating
    DROP TABLE appointments
    DROP PROCEDURE populate_appointments
    DROP TABLE Names;
    DROP TABLE LastNames;
    DROP TABLE Streets;
    DROP TABLE Cities;
    DROP TABLE States;
    DROP TABLE patients;
    DROP TABLE doctors;
    DROP TABLE nurses;
    DROP PROCEDURE insert_data_in_specific_tables
END
GO

-- Verificar dados
SELECT *
FROM dbo.patients
GO
SELECT *
FROM dbo.doctors
GO
SELECT *
FROM dbo.nurses
GO
SELECT * FROM dbo.appointments

-- Dropar tudo criado até o momento
EXEC drop_all_data
GO