DELIMITER //
CREATE PROCEDURE buscar_movimientos_por_tarjeta(IN numero_tarjeta INT)
BEGIN
    DECLARE numero_cuenta INT;

    -- Busca el número de cuenta asociado a la tarjeta
    SELECT cuenta INTO numero_cuenta FROM tarjetas WHERE no_tarjeta = numero_tarjeta;

    -- Verifica si se encontró el número de cuenta
    IF numero_cuenta IS NOT NULL THEN
        -- Realiza la consulta de movimientos
        SELECT m.no_mov, m.deposito, m.retiro, m.fecha_mov, m.descripcion
        FROM movimientos m
        WHERE m.num_cuenta = numero_cuenta;
    ELSE
        -- No se encontró el número de cuenta asociado a la tarjeta
        SELECT 'Número de tarjeta no válido' AS mensaje;
    END IF;
END;
//
DELIMITER ;
