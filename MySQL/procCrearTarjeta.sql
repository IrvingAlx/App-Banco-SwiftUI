USE bancoibero;

DELIMITER //

CREATE PROCEDURE CrearTarjeta2(
    IN p_csv CHAR(16),
    IN p_marca VARCHAR(10),
    IN p_cuenta INT
)
BEGIN
    DECLARE v_fecha_expiracion DATE;
    SET v_fecha_expiracion = DATE_ADD(CURDATE(), INTERVAL 5 YEAR);

    INSERT INTO tarjetas (cvv, marca, fecha_expiracion, cuenta)
    VALUES (p_csv, p_marca, v_fecha_expiracion, p_cuenta);
END //

DELIMITER ;
