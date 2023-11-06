DELIMITER //
CREATE PROCEDURE ActualizarCliente(
    IN clienteID INT,
    IN nuevoNombre NVARCHAR(100),
    IN nuevoApellidoPaterno NVARCHAR(100),
    IN nuevoApellidoMaterno NVARCHAR(100),
    IN nuevaFechaNacimiento DATE,
    IN nuevoSexo CHAR
)
BEGIN
    UPDATE clientes
    SET nombre = nuevoNombre,
        apellido_paterno = nuevoApellidoPaterno,
        apellido_materno = nuevoApellidoMaterno,
        fecha_nacimiento = nuevaFechaNacimiento,
        sexo = nuevoSexo
    WHERE no_cliente = clienteID;
END //
DELIMITER ;
