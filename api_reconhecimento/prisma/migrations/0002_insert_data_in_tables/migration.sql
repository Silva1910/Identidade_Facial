-- Inserir dados na tabela EMPRESA
INSERT INTO EMPRESA (CNPJ, NOMEFANTASIA, CEP, UF, CIDADE, BAIRRO, LOGRADOURO, NUMERO, COMPLEMENTO, DATACRIACAO)
VALUES 
('12345678901234', 'Empresa A', 12345678, 'SP', 'São Paulo', 'Centro', 'Rua Principal', 100, 'Sala 101', '2023-01-01'),
('98765432109876', 'Empresa B', 87654321, 'RJ', 'Rio de Janeiro', 'Copacabana', 'Avenida Beira Mar', 200, NULL, '2023-02-01');

-- Inserir dados na tabela COLABORADOR
INSERT INTO COLABORADOR (MATRICULA, CNPJ_EMPRESA, NOME, CPF, RG, DATA_NASCIMENTO, DATA_ADMISSAO, NIS, CTPS, CARGA_HORARIA, CARGO, BANCO_DE_HORAS)
VALUES 
('MAT001', '12345678901234', 'João Silva', '12345678901', '123456789', '1990-05-15', '2023-03-01', '12345678901', '12345678901', '08:00:00', 'Analista', '01:30:00'),
('MAT002', '98765432109876', 'Maria Oliveira', '98765432109', '987654321', '1985-10-20', '2023-04-01', '98765432109', '98765432109', '09:00:00', 'Gerente', '02:00:00');

-- Inserir dados na tabela USUARIO
INSERT INTO USUARIO (MATRICULA_COLABORADOR, CNPJ_EMPRESA, SENHA, ADMIN)
VALUES 
('MAT001', '12345678901234', 'senha123', TRUE),
('MAT002', '98765432109876', 'senha456', FALSE);

-- Inserir dados na tabela REGISTRO_PONTO
INSERT INTO REGISTRO_PONTO (MATRICULA_COLABORADOR, CNPJ_EMPRESA, DATA)
VALUES 
('MAT001', '12345678901234', '2023-10-01 08:00:00'),
('MAT001', '12345678901234', '2023-10-01 12:00:00'),
('MAT001', '12345678901234', '2023-10-01 13:00:00'),
('MAT001', '12345678901234', '2023-10-01 17:00:00'),
('MAT002', '98765432109876', '2023-10-01 09:00:00'),
('MAT002', '98765432109876', '2023-10-01 13:00:00'),
('MAT002', '98765432109876', '2023-10-01 14:00:00'),
('MAT002', '98765432109876', '2023-10-01 18:00:00');