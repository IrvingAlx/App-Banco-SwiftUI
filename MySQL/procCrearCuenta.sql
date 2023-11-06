DELIMITER //

CREATE PROCEDURE CrearCuentaParaCliente3(
    IN clienteID INT,
    IN tipoCuenta VARCHAR(10),
    IN monedaIngresada VARCHAR(4)
)
BEGIN
    DECLARE nuevaCuentaID INT;
    
    -- Insertar una nueva fila en la tabla de cuentas
    INSERT INTO cuentas (cliente,tipo,moneda)
    VALUES (clienteID,tipoCuenta,monedaIngresada);
    
    -- Obtener el ID de la nueva cuenta creada
    SELECT LAST_INSERT_ID() INTO nuevaCuentaID;
    
    -- Insertar una fila en la tabla de tarjetas para la nueva cuenta
    INSERT INTO tarjetas (cuenta)
    VALUES (nuevaCuentaID);
END //

DELIMITER ;
