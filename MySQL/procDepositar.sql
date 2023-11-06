USE bancoibero;
DELIMITER //
CREATE PROCEDURE depositar (IN cuenta INT, IN monto	DECIMAL(13, 4), IN motivo	VARCHAR(100))
BEGIN
	INSERT INTO movimientos(num_cuenta,deposito,descripcion,fecha_mov) VALUES (cuenta,monto,motivo,NOW());
	UPDATE cuentas SET saldo= saldo + monto  WHERE no_cuenta = cuenta;
END 
// DELIMITER ;
