--BD AVANZADA
--Registricciones SQL
CREATE DATABASE restricciones;
GO--es para que sepa donde termina y ejecute
USE restricciones;
CREATE TABLE clientes(
	cliente_id int not null primary key,	--primary key
	nombre nvarchar(50) not null,
	apellido_paterno nvarchar(20) not null,
	apellido_materno nvarchar(20)
)
GO
INSERT INTO clientes
VALUES (1,'Panfilo Pancracio','Bad Bunny','Good Bunny');
GO
INSERT INTO clientes
VALUES (2,'Pancracio','Bad','Bunny');
GO
INSERT INTO clientes
(apellido_paterno,nombre,cliente_id,apellido_materno)
VALUES('Miranda','Ana',3,'Barreto');
GO
INSERT INTO clientes
VALUES
(4,'Alfredo','Juan','Moroni'),
(5,'Zoe','Yoshelin','Garcia');

SELECT * FROM clientes;
GO

CREATE TABLE clientes_2(
	cliente_id int not null identity(1,1),
	nombre nvarchar(50) not null, 
	edad int not null,
	CONSTRAINT pk_clientes_2
	PRIMARY KEY(cliente_id)
);
GO

CREATE TABLE pedidos(
	pedido_id INT not null identity(1,1),
	fecha_pedido DATE not null,
	cliente_id INT,
	CONSTRAINT pk_pedidos
	PRIMARY KEY (pedido_id),
	CONSTRAINT fk_pedidos_clientes
	FOREIGN KEY (cliente_id)
	REFERENCES clientes (cliente_id)
	NO DELETE NO ACTION
	NO UPDATE NO ACTION
);