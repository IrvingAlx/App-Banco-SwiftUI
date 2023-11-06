from datetime import datetime
from flask import *
import mysql.connector

class Cliente:
    def __init__(self, noCliente, nombre, apellidoPaterno, apellidoMaterno, fechaNacimiento, sexo):
        self.noCliente = noCliente
        self.nombre = nombre
        self.apellidoPaterno = apellidoPaterno
        self.apellidoMaterno = apellidoMaterno
        self.fechaNacimiento = fechaNacimiento
        self.sexo = sexo

app = Flask(__name__)

conexion = mysql.connector.connect(
    host="localhost",
    port="3306",
    user="root",
    database="bancoibero"
)

cursor = conexion.cursor(dictionary=True)

def formato_fecha(fecha):
    return fecha.strftime('%Y-%m-%d')

@app.route('/')
def hola():
    return '<html><body bgcolor=#EFE4B0><h1>Servidor Banco Ibero en Flask</h1></body><html>'

@app.route('/clientes_numeros', methods=['GET'])
def obtener_numeros_de_clientes():
    cursor.execute("SELECT no_cliente FROM clientes")
    numeros_de_clientes = [cliente['no_cliente'] for cliente in cursor.fetchall()]
    return jsonify(numeros_de_clientes)


@app.route('/clientes', methods=['GET'])
def obtener_clientes():
    cursor.execute("SELECT * FROM clientes")
    clientes = cursor.fetchall()
    for cli in clientes:
        cli['fecha_nacimiento']=cli['fecha_nacimiento'].strftime('%Y-%m-%d')
    return jsonify(clientes)

@app.route('/cliente', methods=['POST'])
def crear_cliente():
    datos = request.get_json()
    cursor.execute("INSERT INTO clientes (nombre, apellido_paterno, apellido_materno, fecha_nacimiento, sexo) VALUES (%s, %s, %s, %s, %s)",
                   (datos['nombre'], datos['apellido_paterno'], datos['apellido_materno'], datos['fecha_nacimiento'], datos['sexo']))

    conexion.commit()
    return jsonify({'message': 'Cliente creado correctamente'}), 201

@app.route('/cliente_buscar/<int:cliente_id>', methods=['GET'])
def obtener_informacion_cliente(cliente_id):
    cursor.execute("SELECT nombre, apellido_paterno, apellido_materno, fecha_nacimiento, sexo FROM clientes WHERE no_cliente = %s", (cliente_id,))
    cliente = cursor.fetchone()
    if cliente:
        print("Información del cliente encontrada:", cliente)
        return jsonify(cliente)
    else:
        print("Cliente no encontrado")
        return jsonify({'message': 'Cliente no encontrado'}), 404

@app.route('/cliente_datos/<int:cliente_id>', methods=['GET'])
def obtener_cliente_datos(cliente_id):
    try:
        cursor.callproc('ObtenerInfoClienteCompleto3', (cliente_id,))
        for result in cursor.stored_results():
            cliente_info = result.fetchall()
            if cliente_info and cliente_info[0]['no_cliente'] == cliente_id:
                numeros_de_cuenta = cliente_info[0]['numeros_de_cuenta']
                if numeros_de_cuenta is not None:
                    numeros_de_cuenta = numeros_de_cuenta.split(',')
                response_data = {
                    "no_cliente": cliente_info[0]['no_cliente'],
                    "nombre": cliente_info[0]['nombre'],
                    "apellido_paterno": cliente_info[0]['apellido_paterno'],
                    "apellido_materno": cliente_info[0]['apellido_materno'],
                    "cuentas": numeros_de_cuenta if numeros_de_cuenta is not None else []
                }
                print("Información del cliente encontrada:", response_data)
                return jsonify(response_data)

        print("Cliente no encontrado")
        return jsonify({'message': 'Cliente no encontrado'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/crear_cuenta', methods=['POST'])
def crear_cuenta_para_cliente():
    datos = request.get_json()
    cliente_id = datos['cliente_id']
    tipo_cuenta = datos['tipo_cuenta']
    moneda = datos['moneda']
    
    # Imprimir los datos recibidos en la consola del servidor
    print("Datos recibidos:")
    print("cliente_id:", cliente_id)
    print("tipo_cuenta:", tipo_cuenta)

    try:
        cursor.callproc('CrearCuentaParaCliente3', (cliente_id, tipo_cuenta, moneda))
        conexion.commit()
        return jsonify({'message': 'Cuenta creada correctamente'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/crear_tarjeta', methods=['POST'])
def crear_tarjeta():
    datos = request.get_json()
    cvv = datos['csv']
    marca = datos['marca']
    cuenta = datos['cuenta']

    # Llama al procedimiento almacenado para crear la tarjeta
    try:
        cursor.callproc('CrearTarjeta2', (cvv, marca, cuenta))
        conexion.commit()
        return jsonify({'message': 'Tarjeta creada correctamente'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/numeros_de_cuenta', methods=['GET'])
def obtener_numeros_de_cuenta():
    cursor.execute("SELECT no_cuenta FROM cuentas WHERE estatus = 1")
    numeros_de_cuenta = [str(cuenta['no_cuenta']) for cuenta in cursor.fetchall()]
    return jsonify(numeros_de_cuenta)

@app.route('/verificar_tarjeta', methods=['POST'])
def verificar_tarjeta():
    datos = request.get_json()
    numero_tarjeta = datos.get('numero_tarjeta', '')
    
    # Realiza la búsqueda en la base de datos para verificar si la tarjeta existe y está activa
    cursor.execute("SELECT no_tarjeta, estatus FROM tarjetas WHERE no_tarjeta = %s", (numero_tarjeta,))
    tarjeta = cursor.fetchone()
    
    if tarjeta:
        # La tarjeta existe en la base de datos
        if tarjeta['estatus'] == 1:
            return jsonify({'message': 'La tarjeta existe y está activa'}), 200
        else:
            return jsonify({'message': 'La tarjeta existe pero está deshabilitada'}), 403
    else:
        # La tarjeta no existe en la base de datos
        return jsonify({'message': 'La tarjeta no existe'}), 404


@app.route('/verificar_tarjeta_nip', methods=['POST'])
def verificar_tarjeta_nip():
    datos = request.get_json()
    numero_tarjeta = datos.get('numero_tarjeta', '')
    nip = datos.get('nip', '')
    print(datos)
    # Realiza la búsqueda en la base de datos para verificar si la tarjeta y el NIP coinciden
    cursor.execute("SELECT no_tarjeta FROM tarjetas WHERE no_tarjeta = %s AND nip = %s", (numero_tarjeta, nip))
    tarjeta = cursor.fetchone()
    
    if tarjeta:
        # La tarjeta y el NIP coinciden en la base de datos
        return jsonify({'message': 'Tarjeta y NIP válidos'}), 200
    else:
        # La tarjeta o el NIP no coinciden en la base de datos
        return jsonify({'message': 'Tarjeta o NIP inválidos'}), 404

@app.route('/numeros_de_tarjeta', methods=['GET'])
def obtener_numeros_de_tarjeta():
    cursor.execute("SELECT no_tarjeta FROM tarjetas")
    numeros_de_tarjeta = [str(tarjeta['no_tarjeta']) for tarjeta in cursor.fetchall()]
    return jsonify(numeros_de_tarjeta)

@app.route('/cambiar_estado_tarjeta', methods=['POST'])
def cambiar_estado_tarjeta():
    datos = request.get_json()
    numero_tarjeta = datos.get('numero_tarjeta', '')

    # Realiza una consulta en la base de datos para obtener el estado de la tarjeta
    cursor.execute("SELECT estatus FROM tarjetas WHERE no_tarjeta = %s", (numero_tarjeta,))
    resultado = cursor.fetchone()

    if resultado:
        estatus = resultado['estatus']
        if estatus == 1:
            # La tarjeta está habilitada, desactívala
            try:
                cursor.execute("UPDATE tarjetas SET estatus = 0 WHERE no_tarjeta = %s", (numero_tarjeta,))
                conexion.commit()
                return jsonify({'message': 'Tarjeta cambiada a estado desactivado'}), 200
            except Exception as e:
                return jsonify({'error': str(e)}), 500
        else:
            # La tarjeta está deshabilitada, actívala
            try:
                cursor.execute("UPDATE tarjetas SET estatus = 1 WHERE no_tarjeta = %s", (numero_tarjeta,))
                conexion.commit()
                return jsonify({'message': 'Tarjeta cambiada a estado activado'}), 200
            except Exception as e:
                return jsonify({'error': str(e)}), 500
    else:
        return jsonify({'message': 'La tarjeta no existe'}), 404


@app.route('/bloquear_tarjeta', methods=['POST'])
def bloquear_tarjeta():
    datos = request.get_json()
    numero_tarjeta = datos.get('numero_tarjeta', '')
    
    try:
        # Realiza una consulta para actualizar el campo 'estatus' a 0 (deshabilitado)
        cursor.execute("UPDATE tarjetas SET estatus = 0 WHERE no_tarjeta = %s", (numero_tarjeta,))
        conexion.commit()
        return jsonify({'message': 'Tarjeta bloqueada correctamente'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/activar_tarjeta', methods=['POST'])
def activar_tarjeta():
    datos = request.get_json()
    numero_tarjeta = datos.get('numero_tarjeta', '')
    
    try:
        # Realiza una consulta para actualizar el campo 'estatus' a 1 (habilitado)
        cursor.execute("UPDATE tarjetas SET estatus = 1 WHERE no_tarjeta = %s", (numero_tarjeta,))
        conexion.commit()
        return jsonify({'message': 'Tarjeta activada correctamente'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/estado_tarjeta', methods=['POST'])
def obtener_estado_tarjeta():
    datos = request.get_json()
    numero_tarjeta = datos.get('numero_tarjeta', '')

    # Realiza una consulta en la base de datos para obtener el estado de la tarjeta
    cursor.execute("SELECT estatus FROM tarjetas WHERE no_tarjeta = %s", (numero_tarjeta,))
    resultado = cursor.fetchone()

    if resultado:
        estatus = resultado['estatus']
        if estatus == 1:
            return jsonify({'message': 'La tarjeta está habilitada'}), 200
        else:
            return jsonify({'message': 'La tarjeta está deshabilitada'}), 200
    else:
        return jsonify({'message': 'La tarjeta no existe'}), 404

@app.route('/consultar_saldo', methods=['POST'])
def consultar_saldo():
    datos = request.get_json()
    numero_tarjeta = datos.get('numero_tarjeta', '')

    # Realiza una consulta para obtener el saldo de la tarjeta
    cursor.execute("SELECT saldo FROM cuentas c INNER JOIN tarjetas t ON c.no_cuenta = t.cuenta WHERE t.no_tarjeta = %s", (numero_tarjeta,))
    saldo = cursor.fetchone()

    if saldo:
        # Se encontró el saldo de la tarjeta
        print("Saldo:", saldo['saldo'])  # Imprime el saldo en la terminal
        return jsonify({'saldo': saldo['saldo']}), 200
    else:
        # La tarjeta no existe o no se encontró el saldo
        return jsonify({'message': 'Tarjeta no encontrada o saldo no disponible'}), 404

@app.route('/retirar', methods=['POST'])
def retirar_fondos():
    datos = request.get_json()
    numero_tarjeta = datos.get('numero_tarjeta', '')
    monto = datos.get('monto', 0)
    motivo = datos.get('motivo', '')

    # Busca el número de cuenta asociado al número de tarjeta
    cursor.execute("SELECT cuenta FROM tarjetas WHERE no_tarjeta = %s", (numero_tarjeta,))
    cuenta = cursor.fetchone()

    if cuenta:
        # Se encontró el número de cuenta
        cuenta = cuenta['cuenta']

        try:
            # Llama al procedimiento almacenado 'retirar' en la base de datos
            cursor.callproc('retirar', (cuenta, monto, motivo))
            conexion.commit()
            mensaje = {'message': 'Retiro exitoso'}
            print("Mensaje del servidor:", mensaje)  # Imprime el mensaje en la terminal del servidor
            return jsonify(mensaje), 200
        except mysql.connector.Error as err:
            if err.errno == 1644:
                mensaje = {'error': '¡FONDOS INSUFICIENTES!'}
                print("Mensaje del servidor:", mensaje)  # Imprime el mensaje en la terminal del servidor
                return jsonify(mensaje), 400
            else:
                mensaje = {'error': str(err)}
                print("Mensaje del servidor:", mensaje)  # Imprime el mensaje en la terminal del servidor
                return jsonify(mensaje), 500
    else:
        mensaje = {'error': 'Tarjeta no encontrada'}
        print("Mensaje del servidor:", mensaje)  # Imprime el mensaje en la terminal del servidor
        return jsonify(mensaje), 404

@app.route('/depositar', methods=['POST'])
def depositar_fondos():
    datos = request.get_json()
    numero_tarjeta = datos.get('numero_tarjeta', '')
    monto = datos.get('monto', 0)
    motivo = datos.get('motivo', '')

    # Busca el número de cuenta asociado al número de tarjeta
    cursor.execute("SELECT cuenta FROM tarjetas WHERE no_tarjeta = %s", (numero_tarjeta,))
    cuenta = cursor.fetchone()

    if cuenta:
        # Se encontró el número de cuenta
        cuenta = cuenta['cuenta']

        try:
            # Llama al procedimiento almacenado 'depositar' en la base de datos
            cursor.callproc('depositar', (cuenta, monto, motivo))
            conexion.commit()
            mensaje = {'message': 'Depósito exitoso'}
            print("Mensaje del servidor:", mensaje)  # Imprime el mensaje en la terminal del servidor
            return jsonify(mensaje), 200
        except mysql.connector.Error as err:
            mensaje = {'error': str(err)}
            print("Mensaje del servidor:", mensaje)  # Imprime el mensaje en la terminal del servidor
            return jsonify(mensaje), 500
    else:
        mensaje = {'error': 'Tarjeta no encontrada'}
        print("Mensaje del servidor:", mensaje)  # Imprime el mensaje en la terminal del servidor
        return jsonify(mensaje), 404

def convertir_fecha(fecha):
    fecha_obj = datetime.strptime(fecha, '%a, %d %b %Y %H:%M:%S GMT')
    return fecha_obj.strftime('%Y-%m-%d')

@app.route('/movimientos_por_tarjeta', methods=['POST'])
def obtener_movimientos_por_tarjeta():
    datos = request.get_json()
    numero_tarjeta = datos.get('numero_tarjeta', '')

    print("Número de tarjeta recibido:", numero_tarjeta)  # Imprime el número de tarjeta recibido

    # Llama al procedimiento almacenado 'buscar_movimientos_por_tarjeta' en la base de datos
    try:
        cursor.callproc('buscar_movimientos_por_tarjeta', (numero_tarjeta,))
        for result in cursor.stored_results():
            movimientos = result.fetchall()

        if movimientos:
            # Se encontraron movimientos asociados a la tarjeta
            print("Movimientos encontrados:", movimientos)  # Imprime los movimientos en la terminal del servidor
            return jsonify(movimientos), 200
        else:
            # No se encontraron movimientos asociados a la tarjeta
            mensaje = [{'message': 'No se encontraron movimientos para la tarjeta'}]
            print("Mensaje del servidor:", mensaje)  # Imprime el mensaje en la terminal del servidor
            return jsonify(mensaje), 404
    except Exception as e:
        print("Error en la función obtener_movimientos_por_tarjeta:", str(e))  # Imprime el error
        mensaje = [{'error': str(e)}]
        print("Mensaje del servidor:", mensaje)  # Imprime el mensaje en la terminal del servidor
        return jsonify(mensaje), 500

@app.route('/cambiar_nip', methods=['POST'])
def cambiar_nip():
    datos = request.get_json()
    numero_tarjeta = datos.get('numero_tarjeta', '')
    nip_anterior = datos.get('nip_anterior', '')
    nip_nuevo = datos.get('nip_nuevo', '')

    # Realiza la búsqueda en la base de datos para verificar si la tarjeta y el NIP coinciden
    cursor.execute("SELECT no_tarjeta FROM tarjetas WHERE no_tarjeta = %s AND nip = %s", (numero_tarjeta, nip_anterior))
    tarjeta = cursor.fetchone()

    if tarjeta:
        # La tarjeta y el NIP coinciden en la base de datos, procede a cambiar el NIP
        try:
            cursor.callproc('cambiar_nip', (numero_tarjeta, nip_anterior, nip_nuevo))
            conexion.commit()
            return jsonify({'message': 'NIP cambiado exitosamente'}), 200
        except Exception as e:
            return jsonify({'error': str(e)}), 500
    else:
        # La tarjeta o el NIP no coinciden en la base de datos
        return jsonify({'message': 'Tarjeta o NIP inválidos, no se puede cambiar el NIP'}), 400


@app.route('/actualizar_cliente/<int:cliente_id>', methods=['POST'])
def actualizar_cliente(cliente_id):
    datos = request.get_json()
    print("Received Data:", datos)

    nuevo_nombre = datos['nombre']
    nuevo_apellido_paterno = datos['apellido_paterno']
    nuevo_apellido_materno = datos['apellido_materno']
    nueva_fecha_nacimiento = datos['fecha_nacimiento']
    nuevo_sexo = datos['sexo']

    try:
        cursor.callproc('ActualizarCliente', (cliente_id, nuevo_nombre, nuevo_apellido_paterno, nuevo_apellido_materno, nueva_fecha_nacimiento, nuevo_sexo))
        conexion.commit()
        return jsonify({'message': 'Cliente actualizado correctamente'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True,port=8000)
