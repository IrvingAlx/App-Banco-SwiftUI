USE bancoibero;
DELIMITER //
CREATE PROCEDURE cambiar_nip (IN tarjeta INT, IN nip_anterior CHAR(4) , IN nip_nuevo CHAR(4))
BEGIN
	DECLARE nip_actual CHAR(4);
    SET nip_actual = (SELECT nip FROM tarjetas WHERE no_tarjeta = tarjeta);
    IF (nip_actual = nip_anterior) 
    THEN
		UPDATE tarjetas SET nip=nip_nuevo WHERE no_tarjeta = tarjeta;
    ELSE
		SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = '¡ERROR AL INTENTAR CAMBIAR EL NIP!';
    END IF;
END 
// DELIMITER ;