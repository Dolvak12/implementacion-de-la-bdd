DROP TABLE IF EXISTS detalle_pedidos, cabecera_pedidos, detalle_ventas, cabecera_ventas, historial_stock, productos, proveedores, tipos_documentos, categorias, unidades_medida, categorias_unidad_medida, estados_pedido CASCADE;

-- Creacion de la tabla categorías
CREATE TABLE categorias (
    codigo_cat SERIAL NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    categoria_padre INT,
    CONSTRAINT categorias_pk PRIMARY KEY (codigo_cat),
    CONSTRAINT categorias_fk FOREIGN KEY (categoria_padre)
        REFERENCES categorias (codigo_cat)
);

-- Tabla de categorias de unidad de medida
CREATE TABLE categorias_unidad_medida (
    codigo_udm VARCHAR(1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT categorias_unidad_medida_pk PRIMARY KEY (codigo_udm)
);

-- Tabla de unidades de medida
CREATE TABLE unidades_medida (
    codigo_udm VARCHAR(1) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    categorias_udm_fk VARCHAR(1) NOT NULL,
    CONSTRAINT unidades_medida_pk PRIMARY KEY (codigo_udm),
    CONSTRAINT unidades_medida_fk FOREIGN KEY (categorias_udm_fk)
        REFERENCES categorias_unidad_medida (codigo_udm)
);

-- Tabla de productos
CREATE TABLE productos (
    codigo_producto SERIAL NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    udm_fk VARCHAR(1) NOT NULL,
    precio_de_venta DECIMAL NOT NULL,
    tiene_iva BOOLEAN NOT NULL,
    costes DECIMAL NOT NULL,
    categoria_fk INT NOT NULL,
    stock INT NOT NULL,
    CONSTRAINT productos_pk PRIMARY KEY (codigo_producto),
    CONSTRAINT productos_udm_fk FOREIGN KEY (udm_fk)
        REFERENCES unidades_medida (codigo_udm),
    CONSTRAINT productos_categoria_fk FOREIGN KEY (categoria_fk)
        REFERENCES categorias (codigo_cat)
);

-- Tabla de historial de stock
CREATE TABLE historial_stock (
    codigo INT NOT NULL,
    fecha TIMESTAMP NOT NULL,
    referencia VARCHAR(100),
    producto_fk INT NOT NULL,
    cantidad INT NOT NULL,
    CONSTRAINT historial_stock_pk PRIMARY KEY (codigo),
    CONSTRAINT historial_stock_producto_fk FOREIGN KEY (producto_fk)
        REFERENCES productos (codigo_producto)
);

-- Tabla de tipos de documentos
CREATE TABLE tipos_documentos (
    codigo CHAR(1) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT tipos_documentos_pk PRIMARY KEY (codigo)
);

-- Tabla de proveedores
CREATE TABLE proveedores (
    identificador VARCHAR(20) NOT NULL,
    tipo_de_documento CHAR(1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(5),
    correo VARCHAR(100),
    direccion VARCHAR(200),
    CONSTRAINT proveedores_pk PRIMARY KEY (identificador),
    CONSTRAINT proveedores_documento_fk FOREIGN KEY (tipo_de_documento)
        REFERENCES tipos_documentos (codigo)
);

-- Tabla de estados de pedido
CREATE TABLE estados_pedido (
    codigo CHAR(1) NOT NULL,
    descripcion VARCHAR(100),
    CONSTRAINT estados_pedido_pk PRIMARY KEY (codigo)
);

-- Tabla de cabecera de pedidos
CREATE TABLE cabecera_pedidos (
    numero SERIAL NOT NULL,
    proveedor_fk VARCHAR(20),
    fecha DATE NOT NULL,
    CONSTRAINT cabecera_pedidos_pk PRIMARY KEY (numero),
    CONSTRAINT cabecera_pedidos_proveedor_fk FOREIGN KEY (proveedor_fk)
        REFERENCES proveedores (identificador)
);

-- Tabla de detalle de pedidos
CREATE TABLE detalle_pedidos (
    codigo SERIAL NOT NULL,
    cabecera_pedido_fk INT NOT NULL,
    producto_fk INT NOT NULL,
    cantidad INT NOT NULL,
    subtotal DECIMAL NOT NULL,
    CONSTRAINT detalle_pedidos_pk PRIMARY KEY (codigo),
    CONSTRAINT detalle_pedidos_cabecera_fk FOREIGN KEY (cabecera_pedido_fk)
        REFERENCES cabecera_pedidos (numero),
    CONSTRAINT detalle_pedidos_producto_fk FOREIGN KEY (producto_fk)
        REFERENCES productos (codigo_producto)
);

-- Tabla de cabecera de ventas
CREATE TABLE cabecera_ventas (
    codigo INT NOT NULL,
    fecha TIMESTAMP NOT NULL,
    total_sin_iva DECIMAL NOT NULL,
    iva DECIMAL NOT NULL,
    total DECIMAL NOT NULL,
    CONSTRAINT cabecera_ventas_pk PRIMARY KEY (codigo)
);

-- Tabla de detalle de ventas
CREATE TABLE detalle_ventas (
    codigo INT NOT NULL,
    cabecera_venta_fk INT NOT NULL,
    producto_fk INT NOT NULL,
    cantidad INT NOT NULL,
    precio_venta DECIMAL NOT NULL,
    subtotal_con_iva DECIMAL NOT NULL,
    CONSTRAINT detalle_ventas_pk PRIMARY KEY (codigo),
    CONSTRAINT detalle_ventas_cabecera_fk FOREIGN KEY (cabecera_venta_fk)
        REFERENCES cabecera_ventas (codigo),
    CONSTRAINT detalle_ventas_producto_fk FOREIGN KEY (producto_fk)
        REFERENCES productos (codigo_producto)
);

-- Inserción inicial de datos de ejemplo
INSERT INTO categorias (nombre, categoria_padre) VALUES ('Materia prima', NULL);
INSERT INTO categorias (nombre, categoria_padre) VALUES ('Proteina', 1);
INSERT INTO categorias (nombre, categoria_padre) VALUES ('Salsas', 1);
INSERT INTO categorias (nombre, categoria_padre) VALUES ('Punto de Venta', NULL);
INSERT INTO categorias (nombre, categoria_padre) VALUES ('Bebidas', 4);
INSERT INTO categorias (nombre, categoria_padre) VALUES ('Con alcohol', 5);
INSERT INTO categorias (nombre, categoria_padre) VALUES ('Sin alcohol', 5);

SELECT * FROM categorias;
