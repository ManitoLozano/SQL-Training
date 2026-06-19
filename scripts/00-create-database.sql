/*
    Aula: Script - Criação de base de dados
    Objetivo: Criar base de dados do nosso treinamento SQLs
*/

IF DB_ID('SqlTraining') is null
BEGIN
    CREATE DATABASE SqlTraining;
END;

/*
    Como verificar se funcionou:
*/

SELECT
    DB_NAME() AS CurrentDatabase,
    GETDATE() AS CurrentDateTime