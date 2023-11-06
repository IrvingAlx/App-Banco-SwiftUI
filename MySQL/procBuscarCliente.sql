USE bancoibero;

DELIMITER //

CREATE PROCEDURE ObtenerInfoClienteCompleto3(IN cliente_id INT)
BEGIN
    SELECT
        c.no_cliente,
        c.nombre,
        c.apellido_paterno,
        IFNULL(c.apellido_materno, '') AS apellido_materno,
        GROUP_CONCAT(cu.no_cuenta) AS numeros_de_cuenta
    FROM
        clientes c
    LEFT JOIN cuentas cu ON c.no_cliente = cu.cliente
    WHERE c.no_cliente = cliente_id
    GROUP BY c.no_cliente;
END;
//

DELIMITER ;
