-- 1. Limpieza inicial (Cuidado: borra todo si ya existe)
DROP TABLE IF EXISTS venta_items CASCADE;
DROP TABLE IF EXISTS ventas CASCADE;
DROP TABLE IF EXISTS movimientos_stock CASCADE;
DROP TABLE IF EXISTS inventario CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;
DROP TABLE IF EXISTS almacenes CASCADE;

-- 2. Tablas Independientes (No dependen de otras)

CREATE TABLE almacenes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    ubicacion TEXT
);

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    ruc VARCHAR(50),
    telefono VARCHAR(50),
    email VARCHAR(255),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    es_extranjero BOOLEAN DEFAULT false
);

CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    sku VARCHAR(100) NOT NULL UNIQUE, -- El SKU debe ser único
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio_compra NUMERIC(10,2),
    precio_venta NUMERIC(10,2),
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    imagen_url VARCHAR(255)
);

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    contrasena_hash VARCHAR(255) NOT NULL,
    nombre_completo VARCHAR(255),
    rol VARCHAR(50) DEFAULT 'vendedor' NOT NULL,
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Tablas Dependientes (Tienen Foreign Keys)

CREATE TABLE inventario (
    producto_id INTEGER NOT NULL,
    almacen_id INTEGER NOT NULL,
    cantidad INTEGER DEFAULT 0 NOT NULL,
    fecha_actualizacion TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    -- Llave primaria compuesta
    PRIMARY KEY (producto_id, almacen_id),
    -- Relaciones
    CONSTRAINT fk_inventario_producto FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    CONSTRAINT fk_inventario_almacen FOREIGN KEY (almacen_id) REFERENCES almacenes(id) ON DELETE CASCADE
);

CREATE TABLE movimientos_stock (
    id SERIAL PRIMARY KEY,
    producto_id INTEGER NOT NULL,
    almacen_id INTEGER NOT NULL,
    usuario_id INTEGER, -- Puede ser nulo si se borra el usuario
    tipo_movimiento VARCHAR(50) NOT NULL, -- Ejemplo: 'Entrada', 'Salida', 'Ajuste'
    cantidad INTEGER NOT NULL,
    fecha_movimiento TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    -- Relaciones
    CONSTRAINT fk_movimiento_producto FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE SET NULL,
    CONSTRAINT fk_movimiento_almacen FOREIGN KEY (almacen_id) REFERENCES almacenes(id) ON DELETE SET NULL,
    CONSTRAINT fk_movimiento_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
);

CREATE TABLE ventas (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER,
    usuario_id INTEGER,
    almacen_id INTEGER,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    moneda VARCHAR(3) DEFAULT 'USD',
    subtotal NUMERIC(10,2),
    impuesto NUMERIC(10,2),
    total NUMERIC(10,2) NOT NULL,
    estado VARCHAR(50) DEFAULT 'Completada',
    -- Relaciones
    CONSTRAINT fk_ventas_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    CONSTRAINT fk_ventas_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    CONSTRAINT fk_ventas_almacen FOREIGN KEY (almacen_id) REFERENCES almacenes(id)
);

CREATE TABLE venta_items (
    id SERIAL PRIMARY KEY,
    venta_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario NUMERIC(10,2) NOT NULL,
    -- Relaciones
    CONSTRAINT fk_items_venta FOREIGN KEY (venta_id) REFERENCES ventas(id) ON DELETE CASCADE, -- Si borro venta, borro sus items
    CONSTRAINT fk_items_producto FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- 4. Índices para mejorar rendimiento (Opcional pero recomendado)
CREATE INDEX idx_productos_nombre ON productos(nombre);
CREATE INDEX idx_ventas_fecha ON ventas(fecha_venta);
