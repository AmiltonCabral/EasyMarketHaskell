{-# LANGUAGE OverloadedStrings #-}
module LocalDB.ConnectionDB where
import Database.PostgreSQL.Simple

localDB:: ConnectInfo
localDB = defaultConnectInfo {
    connectHost = "localhost",
    connectDatabase = "easymarket",
    connectUser = "easymarket",
    connectPassword = "1234",
    connectPort = 5432
}

connectionMyDB :: IO Connection
connectionMyDB = connect localDB

createTables :: Connection -> IO()
createTables conn = do
    execute_ conn "CREATE TABLE IF NOT EXISTS Estabelecimento\
\(\
\    Id_Estabelecimento SERIAL PRIMARY KEY,\
\    Login              VARCHAR(30),\
\    Senha              VARCHAR,\
\    Nome               CHAR(20),\
\    CNPJ               INT,\
\    Endereço           VARCHAR(100)\
\);\
\\
\CREATE TABLE IF NOT EXISTS Produto\
\(\
\    Id_Produto         SERIAL PRIMARY KEY,\
\    Nome               VARCHAR(20) UNIQUE,\
\    Preço              MONEY,\
\    Descrição          VARCHAR(100),\
\    Categoria          CHAR(10),\
\    QuantidadeEstoque  INT,\
\    Id_Estabelecimento INT,\
\    FOREIGN KEY (Id_Estabelecimento) REFERENCES Estabelecimento (Id_Estabelecimento)\
\);\
\\
\CREATE TABLE IF NOT EXISTS Cliente\
\(\
\    ID_Cliente           SERIAL PRIMARY KEY,\
\    Nome                 VARCHAR(30),\
\    CPF                  CHAR(11),\
\    Login                VARCHAR(30),\
\    Senha                VARCHAR,\
\    Endereco             VARCHAR(100),\
\    Telefone             CHAR(11),\
\    Email                CHAR(30),\
\    ID_ComprasRealizadas INT\
\);\
\\
\CREATE TABLE IF NOT EXISTS Compra\
\(\
\    ID_Compra     SERIAL PRIMARY KEY,\
\    TipoPagamento CHAR(15),\
\    DataPagamento DATE,\
\    Status        CHAR(10),\
\    TotalCompra   MONEY,\
\    Id_Cliente    INT,\
\    FOREIGN KEY (Id_Cliente) REFERENCES Cliente (ID_Cliente)\
\);\
\\
\CREATE TABLE IF NOT EXISTS Carrinho\
\(\
\    QuantidadeDoProduto INT,\
\    ID_Produto          INT PRIMARY KEY,\
\    ID_Compra           INT,\
\    FOREIGN KEY (ID_Compra) REFERENCES Cliente (ID_Cliente),\
\    FOREIGN KEY (ID_Produto) REFERENCES Produto (ID_Produto)\
\);"
    return ()

iniciandoDatabase :: IO Connection
iniciandoDatabase = do
		c <- connectionMyDB
		createTables c
		return c