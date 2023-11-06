CREATE DATABASE bancoibero;
USE  bancoibero;
CREATE TABLE clientes(
	no_cliente			INT AUTO_INCREMENT
	,nombre				NVARCHAR(100)	NOT NULL			-- Unicode VARCHAR
	,apellido_paterno	NVARCHAR(100)	NOT NULL
	,apellido_materno	NVARCHAR(100)
	,fecha_nacimiento	DATE
	,sexo				CHAR
	,PRIMARY KEY(no_cliente)
);
ALTER TABLE clientes AUTO_INCREMENT=10001;
CREATE TABLE cuentas(
	no_cuenta			INT AUTO_INCREMENT
	,tipo				VARCHAR(10)		CHECK (tipo IN ('Ahorros','Nomina','Cheques'))   DEFAULT 'Ahorros'
	,saldo				DECIMAL(13, 4)  DEFAULT 0
	,moneda				CHAR(3)			CHECK (moneda IN('MXN','USD','EUR'))			DEFAULT 'MXN'
	,estatus			BIT				DEFAULT		1
	,cliente			INT
	,PRIMARY KEY (no_cuenta)
	,FOREIGN KEY (cliente)  REFERENCES clientes(no_cliente)
);
ALTER TABLE cuentas AUTO_INCREMENT=50001;
CREATE TABLE tarjetas(
	no_tarjeta			INT AUTO_INCREMENT
	,cvv				CHAR(3)			DEFAULT '000'
	,nip				CHAR(4)			DEFAULT '1234'
	,marca				VARCHAR(10)		CHECK (marca in ('VISA','Mastercard','Amex'))	DEFAULT 'VISA'
	,fecha_expiracion	DATE			
	,estatus			BIT				DEFAULT  1
	,cuenta				INT
	,PRIMARY KEY(no_tarjeta)
	,FOREIGN KEY(cuenta)	REFERENCES cuentas(no_cuenta)
);
ALTER TABLE tarjetas AUTO_INCREMENT=90001;
CREATE TABLE movimientos(

	no_mov			INT		AUTO_INCREMENT
	,num_cuenta		INT
	,deposito		DECIMAL(13, 4) 	DEFAULT 0
	,retiro			DECIMAL(13, 4) 	DEFAULT 0
	,fecha_mov		DATETIME
	,descripcion	VARCHAR(100)
	,PRIMARY KEY(no_mov, num_cuenta)
	,FOREIGN KEY(num_cuenta) REFERENCES cuentas(no_cuenta)
);
