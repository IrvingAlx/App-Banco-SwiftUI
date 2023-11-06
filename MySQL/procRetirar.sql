USE bancoibero;
DELIMITER //
CREATE PROCEDURE retirar (IN cuenta INT, IN monto	DECIMAL(13, 4), IN motivo	VARCHAR(100))
BEGIN
	DECLARE saldo_actual DECIMAL(13, 4);
    SET saldo_actual = (SELECT saldo FROM cuentas WHERE no_cuenta = cuenta);
    If (monto<= saldo_actual)
    THEN
		INSERT INTO movimientos(num_cuenta,retiro,descripcion,fecha_mov) VALUES (cuenta,monto,motivo,NOW());
		UPDATE cuentas SET saldo= saldo - monto  WHERE no_cuenta = cuenta;
	ELSE
		SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = '¡FONDOS INSUFICIENTES!';
    END IF;
END 
// DELIMITER ;
