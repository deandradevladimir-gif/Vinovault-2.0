-- Datos de ejemplo FICTICIOS para la demo de VinoVault.
-- Ejecutar UNA vez en Supabase > SQL Editor, sobre una base sin productos.
-- No modifica ni borra el usuario administrador existente.
-- Los vendedores de ejemplo tienen contraseñas aleatorias (no se puede iniciar sesión con ellos).

BEGIN;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM productos) THEN
    RAISE EXCEPTION 'Ya hay productos cargados: este script solo se ejecuta sobre una base vacía.';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM usuarios WHERE rol = 'admin') THEN
    RAISE EXCEPTION 'Primero crea el usuario administrador.';
  END IF;
END $$;

-- Vendedores de ejemplo
INSERT INTO usuarios (email, contrasena_hash, nombre_completo, rol) VALUES
  ('martin.acosta@vinovault.demo', extensions.crypt(gen_random_uuid()::text, extensions.gen_salt('bf', 10)), 'Martín Acosta', 'vendedor'),
  ('camila.duarte@vinovault.demo', extensions.crypt(gen_random_uuid()::text, extensions.gen_salt('bf', 10)), 'Camila Duarte', 'vendedor')
ON CONFLICT (email) DO NOTHING;

-- Almacenes (los que falten)
INSERT INTO almacenes (nombre, ubicacion)
SELECT v.nombre, v.ubicacion FROM (VALUES
  ('Depósito Central', 'Ciudad del Este'),
  ('Sucursal Centro', 'Asunción'),
  ('Bodega Frontera', 'Pedro Juan Caballero')
) AS v(nombre, ubicacion)
WHERE NOT EXISTS (SELECT 1 FROM almacenes a WHERE a.nombre = v.nombre);

-- Productos
INSERT INTO productos (sku, nombre, descripcion, precio_compra, precio_venta, imagen_url, fecha_creacion) VALUES
  ('TIN-MAL-001', 'Malbec Reserva', 'Tinto · Mendoza, Argentina · 2020', 12.5, 24.9, 'https://vinovault.vercel.app/demo/tin-mal-001.svg', NOW() - interval '60 days 0 hours 0 minutes'),
  ('TIN-CAB-002', 'Cabernet Sauvignon Gran Reserva', 'Tinto · Valle del Maipo, Chile · 2018', 18, 38.5, 'https://vinovault.vercel.app/demo/tin-cab-002.svg', NOW() - interval '60 days 0 hours 0 minutes'),
  ('TIN-TAN-003', 'Tannat Barrica', 'Tinto · Canelones, Uruguay · 2019', 14, 29.9, 'https://vinovault.vercel.app/demo/tin-tan-003.svg', NOW() - interval '60 days 0 hours 0 minutes'),
  ('TIN-CAR-004', 'Carménère Clásico', 'Tinto · Colchagua, Chile · 2021', 8.5, 16.9, 'https://vinovault.vercel.app/demo/tin-car-004.svg', NOW() - interval '60 days 0 hours 0 minutes'),
  ('TIN-TEM-005', 'Tempranillo Crianza', 'Tinto · Rioja, España · 2019', 13, 27.5, 'https://vinovault.vercel.app/demo/tin-tem-005.svg', NOW() - interval '60 days 0 hours 0 minutes'),
  ('TIN-SYR-006', 'Syrah Selección', 'Tinto · San Juan, Argentina · 2020', 9.5, 19.9, 'https://vinovault.vercel.app/demo/tin-syr-006.svg', NOW() - interval '60 days 0 hours 0 minutes'),
  ('BLA-CHA-007', 'Chardonnay Roble', 'Blanco · Casablanca, Chile · 2022', 10, 21.5, 'https://vinovault.vercel.app/demo/bla-cha-007.svg', NOW() - interval '60 days 0 hours 0 minutes'),
  ('BLA-SAU-008', 'Sauvignon Blanc', 'Blanco · Leyda, Chile · 2023', 7.5, 15.9, 'https://vinovault.vercel.app/demo/bla-sau-008.svg', NOW() - interval '60 days 0 hours 0 minutes'),
  ('BLA-TOR-009', 'Torrontés', 'Blanco · Cafayate, Argentina · 2023', 7, 14.9, 'https://vinovault.vercel.app/demo/bla-tor-009.svg', NOW() - interval '60 days 0 hours 0 minutes'),
  ('ROS-MAL-010', 'Rosé de Malbec', 'Rosado · Valle de Uco, Argentina · 2023', 8, 17.5, 'https://vinovault.vercel.app/demo/ros-mal-010.svg', NOW() - interval '60 days 0 hours 0 minutes'),
  ('ESP-BRU-011', 'Espumante Brut Nature', 'Espumante · Serra Gaúcha, Brasil', 11, 23.9, 'https://vinovault.vercel.app/demo/esp-bru-011.svg', NOW() - interval '60 days 0 hours 0 minutes'),
  ('POR-TAW-012', 'Oporto Tawny 10 Años', 'Fortificado · Douro, Portugal', 22, 45, 'https://vinovault.vercel.app/demo/por-taw-012.svg', NOW() - interval '60 days 0 hours 0 minutes');

-- Clientes
INSERT INTO clientes (nombre, ruc, telefono, email, es_extranjero, fecha_registro) VALUES
  ('Distribuidora El Lagar S.A.', '80012345-6', '+595 981 234 567', 'compras@ellagar.demo', false, NOW() - interval '45 days 0 hours 0 minutes'),
  ('Restaurante La Parrilla Gaucha', '80023456-1', '+595 983 345 678', 'contacto@parrillagaucha.demo', false, NOW() - interval '35 days 0 hours 0 minutes'),
  ('Hotel Mburucuyá', '80034567-8', '+595 971 456 789', 'eventos@mburucuya.demo', false, NOW() - interval '65 days 0 hours 0 minutes'),
  ('Supermercado Del Este', '80045678-3', '+595 984 567 890', 'proveedores@supereste.demo', false, NOW() - interval '43 days 0 hours 0 minutes'),
  ('Vinoteca Uva & Barrica', '80056789-0', '+595 982 678 901', 'hola@uvaybarrica.demo', false, NOW() - interval '52 days 0 hours 0 minutes'),
  ('Ana Paula Ferreira', 'CPF 123.456.789-00', '+55 45 99876 5432', 'anapaula@correo.demo', true, NOW() - interval '31 days 0 hours 0 minutes'),
  ('Rodrigo Albuquerque', 'CPF 987.654.321-00', '+55 45 99123 4567', 'rodrigo.alb@correo.demo', true, NOW() - interval '57 days 0 hours 0 minutes'),
  ('Bistró Foz Gourmet', 'CNPJ 12.345.678/0001-90', '+55 45 3522 1100', 'compras@fozgourmet.demo', true, NOW() - interval '37 days 0 hours 0 minutes'),
  ('Carlos Giménez', '4.567.890', '+595 985 112 233', 'cgimenez@correo.demo', false, NOW() - interval '83 days 0 hours 0 minutes'),
  ('Sofía Martínez', '5.678.901', '+595 976 223 344', 'sofia.mtz@correo.demo', false, NOW() - interval '90 days 0 hours 0 minutes');

-- Stock inicial
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento) VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-MAL-001'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 149, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-MAL-001'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 47, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-MAL-001'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 54, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 149, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 52, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 29, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 91, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 68, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 67, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 152, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 50, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 33, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 124, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 36, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 68, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 146, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 32, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 63, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 117, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 27, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 26, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 123, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 63, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 63, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 135, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 42, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 51, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 136, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 57, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 58, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 160, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 45, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 29, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 95, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 45, NOW() - interval '50 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 30, NOW() - interval '50 days 0 hours 0 minutes');

-- Ventas (los importes se guardan en USD, igual que la app)
WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Carlos Giménez'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '0 days 5 hours 35 minutes', 'USD', 107.40, 10.74, 118.14)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-MAL-001'), 1, 24.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 3, 27.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Carlos Giménez'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '0 days 6 hours 11 minutes', 'USD', 250.50, 25.05, 275.55)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), 3, 38.5),
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), 3, 45)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Supermercado Del Este'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '0 days 3 hours 42 minutes', 'USD', 269.10, 26.91, 296.01)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), 9, 29.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Hotel Mburucuyá'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '0 days 5 hours 29 minutes', 'USD', 672.30, 67.23, 739.53)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 9, 17.5),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), 7, 23.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), 4, 38.5),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 9, 21.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Bistró Foz Gourmet'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '0 days 6 hours 25 minutes', 'USD', 52.50, 0.00, 52.50)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 3, 17.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Hotel Mburucuyá'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '31 days 1 hours 23 minutes', 'USD', 464.80, 46.48, 511.28)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), 6, 29.9),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 5, 21.5),
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 3, 27.5),
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), 6, 15.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Bistró Foz Gourmet'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '13 days 2 hours 35 minutes', 'USD', 55.00, 0.00, 55.00)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 2, 27.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Sofía Martínez'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '40 days 2 hours 55 minutes', 'USD', 33.80, 3.38, 37.18)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), 2, 16.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Bistró Foz Gourmet'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '14 days 9 hours 58 minutes', 'USD', 122.40, 0.00, 122.40)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), 1, 14.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 2, 27.5),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 3, 17.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Rodrigo Albuquerque'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '0 days 4 hours 18 minutes', 'USD', 104.50, 0.00, 104.50)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), 2, 14.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-MAL-001'), 3, 24.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Ana Paula Ferreira'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), NOW() - interval '27 days 9 hours 44 minutes', 'USD', 150.20, 0.00, 150.20)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 1, 17.5),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 2, 21.5),
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), 3, 29.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Supermercado Del Este'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '0 days 6 hours 26 minutes', 'USD', 220.00, 22.00, 242.00)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 8, 27.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Hotel Mburucuyá'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '0 days 1 hours 6 minutes', 'USD', 500.40, 50.04, 550.44)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), 9, 45),
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), 6, 15.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Carlos Giménez'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '25 days 2 hours 54 minutes', 'USD', 109.40, 10.94, 120.34)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), 1, 15.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), 1, 38.5),
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 2, 27.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Hotel Mburucuyá'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '30 days 6 hours 49 minutes', 'USD', 276.70, 27.67, 304.37)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), 8, 14.9),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 9, 17.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Bistró Foz Gourmet'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), NOW() - interval '5 days 8 hours 57 minutes', 'USD', 131.80, 0.00, 131.80)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 3, 21.5),
  ((SELECT id FROM productos WHERE sku = 'TIN-MAL-001'), 2, 24.9),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 1, 17.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Rodrigo Albuquerque'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '9 days 9 hours 40 minutes', 'USD', 178.00, 0.00, 178.00)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), 1, 45),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), 3, 38.5),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 1, 17.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Carlos Giménez'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), NOW() - interval '4 days 7 hours 52 minutes', 'USD', 207.00, 20.70, 227.70)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), 2, 45),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 3, 21.5),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 3, 17.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Vinoteca Uva & Barrica'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '12 days 7 hours 14 minutes', 'USD', 79.60, 7.96, 87.56)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), 4, 19.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Hotel Mburucuyá'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '31 days 6 hours 13 minutes', 'USD', 625.20, 62.52, 687.72)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 7, 27.5),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), 4, 38.5),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), 5, 23.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), 8, 19.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Hotel Mburucuyá'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), NOW() - interval '8 days 7 hours 17 minutes', 'USD', 95.60, 9.56, 105.16)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), 4, 23.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Carlos Giménez'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '6 days 3 hours 55 minutes', 'USD', 266.80, 26.68, 293.48)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), 3, 19.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-MAL-001'), 3, 24.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), 3, 38.5),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), 1, 16.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Carlos Giménez'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '35 days 6 hours 3 minutes', 'USD', 234.60, 23.46, 258.06)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), 2, 29.9),
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), 3, 45),
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), 2, 19.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Ana Paula Ferreira'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '26 days 1 hours 3 minutes', 'USD', 82.50, 0.00, 82.50)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 3, 27.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Sofía Martínez'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '19 days 2 hours 55 minutes', 'USD', 145.70, 14.57, 160.27)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 1, 27.5),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 2, 17.5),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), 1, 38.5),
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), 3, 14.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Bistró Foz Gourmet'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '22 days 7 hours 27 minutes', 'USD', 51.40, 0.00, 51.40)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 1, 21.5),
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), 1, 29.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Vinoteca Uva & Barrica'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '0 days 5 hours 21 minutes', 'USD', 371.70, 37.17, 408.87)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 11, 21.5),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), 8, 16.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Vinoteca Uva & Barrica'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '2 days 5 hours 12 minutes', 'USD', 446.50, 44.65, 491.15)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 12, 17.5),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 11, 21.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Ana Paula Ferreira'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '5 days 3 hours 53 minutes', 'USD', 205.50, 0.00, 205.50)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), 2, 45),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), 3, 38.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Rodrigo Albuquerque'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '31 days 9 hours 33 minutes', 'USD', 154.20, 0.00, 154.20)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 3, 27.5),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), 3, 23.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Restaurante La Parrilla Gaucha'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '6 days 6 hours 9 minutes', 'USD', 122.50, 12.25, 134.75)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 7, 17.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Distribuidora El Lagar S.A.'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '22 days 7 hours 7 minutes', 'USD', 578.90, 57.89, 636.79)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 6, 27.5),
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), 5, 45),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 5, 17.5),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), 6, 16.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Hotel Mburucuyá'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '6 days 8 hours 47 minutes', 'USD', 273.90, 27.39, 301.29)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-MAL-001'), 11, 24.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Supermercado Del Este'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), NOW() - interval '15 days 4 hours 54 minutes', 'USD', 223.00, 22.30, 245.30)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), 4, 19.9),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), 6, 23.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Restaurante La Parrilla Gaucha'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '44 days 3 hours 35 minutes', 'USD', 239.00, 23.90, 262.90)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), 10, 23.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Distribuidora El Lagar S.A.'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '22 days 4 hours 14 minutes', 'USD', 261.70, 26.17, 287.87)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), 3, 29.9),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 8, 21.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Distribuidora El Lagar S.A.'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), NOW() - interval '8 days 0 hours 52 minutes', 'USD', 416.10, 41.61, 457.71)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 5, 17.5),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 4, 21.5),
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), 9, 15.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), 5, 19.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Sofía Martínez'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '20 days 5 hours 54 minutes', 'USD', 103.50, 10.35, 113.85)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), 3, 23.9),
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), 2, 15.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Bistró Foz Gourmet'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '7 days 7 hours 48 minutes', 'USD', 57.30, 0.00, 57.30)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), 2, 14.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 1, 27.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Supermercado Del Este'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '35 days 4 hours 20 minutes', 'USD', 727.20, 72.72, 799.92)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 8, 27.5),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), 9, 16.9),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 4, 21.5),
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), 9, 29.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Carlos Giménez'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '44 days 1 hours 41 minutes', 'USD', 127.90, 12.79, 140.69)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 3, 27.5),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 1, 21.5),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), 1, 23.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Restaurante La Parrilla Gaucha'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '22 days 1 hours 43 minutes', 'USD', 119.50, 11.95, 131.45)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), 5, 23.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Bistró Foz Gourmet'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '38 days 2 hours 7 minutes', 'USD', 45.00, 0.00, 45.00)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), 1, 45)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Sofía Martínez'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '7 days 7 hours 54 minutes', 'USD', 159.20, 15.92, 175.12)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), 3, 15.9),
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), 2, 45),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 1, 21.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Distribuidora El Lagar S.A.'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '12 days 2 hours 50 minutes', 'USD', 174.90, 17.49, 192.39)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), 11, 15.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Ana Paula Ferreira'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '13 days 8 hours 27 minutes', 'USD', 158.80, 0.00, 158.80)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 1, 17.5),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), 3, 23.9),
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), 2, 14.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), 2, 19.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Sofía Martínez'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '30 days 2 hours 10 minutes', 'USD', 94.40, 9.44, 103.84)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 2, 21.5),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), 1, 23.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 1, 27.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Bistró Foz Gourmet'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '12 days 5 hours 30 minutes', 'USD', 112.30, 0.00, 112.30)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 3, 27.5),
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), 2, 14.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Carlos Giménez'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), NOW() - interval '8 days 5 hours 25 minutes', 'USD', 56.70, 5.67, 62.37)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-MAL-001'), 1, 24.9),
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), 1, 14.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), 1, 16.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Supermercado Del Este'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '7 days 0 hours 24 minutes', 'USD', 651.50, 65.15, 716.65)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), 10, 16.9),
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), 8, 45),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 7, 17.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Rodrigo Albuquerque'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '34 days 7 hours 58 minutes', 'USD', 120.00, 0.00, 120.00)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 2, 21.5),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), 2, 38.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Sofía Martínez'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '28 days 3 hours 27 minutes', 'USD', 126.10, 12.61, 138.71)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), 1, 16.9),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 3, 21.5),
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), 3, 14.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Restaurante La Parrilla Gaucha'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '25 days 2 hours 34 minutes', 'USD', 479.20, 47.92, 527.12)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), 8, 15.9),
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), 4, 45),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 3, 17.5),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), 5, 23.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Supermercado Del Este'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '18 days 4 hours 43 minutes', 'USD', 330.00, 33.00, 363.00)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), 12, 27.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Restaurante La Parrilla Gaucha'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '16 days 9 hours 33 minutes', 'USD', 573.10, 57.31, 630.41)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), 4, 14.9),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), 12, 23.9),
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), 8, 15.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), 5, 19.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Hotel Mburucuyá'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), NOW() - interval '7 days 9 hours 17 minutes', 'USD', 470.70, 47.07, 517.77)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-MAL-001'), 11, 24.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), 9, 16.9),
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), 3, 14.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Vinoteca Uva & Barrica'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '28 days 5 hours 46 minutes', 'USD', 458.90, 45.89, 504.79)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), 7, 29.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), 4, 38.5),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), 4, 23.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Rodrigo Albuquerque'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '4 days 7 hours 50 minutes', 'USD', 107.50, 0.00, 107.50)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), 1, 17.5),
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), 2, 45)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Sofía Martínez'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '1 days 2 hours 52 minutes', 'USD', 135.00, 13.50, 148.50)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), 3, 45)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Supermercado Del Este'), (SELECT id FROM usuarios WHERE email = 'martin.acosta@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '43 days 3 hours 47 minutes', 'USD', 518.50, 51.85, 570.35)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), 9, 38.5),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), 8, 21.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Restaurante La Parrilla Gaucha'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), NOW() - interval '24 days 3 hours 34 minutes', 'USD', 672.50, 67.25, 739.75)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), 11, 38.5),
  ((SELECT id FROM productos WHERE sku = 'TIN-MAL-001'), 10, 24.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Hotel Mburucuyá'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '6 days 1 hours 59 minutes', 'USD', 526.80, 52.68, 579.48)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-MAL-001'), 3, 24.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), 6, 29.9),
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), 3, 15.9),
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), 5, 45)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Hotel Mburucuyá'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '36 days 5 hours 7 minutes', 'USD', 930.80, 93.08, 1023.88)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), 12, 38.5),
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), 9, 19.9),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), 10, 23.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), 3, 16.9)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

WITH v AS (
  INSERT INTO ventas (cliente_id, usuario_id, almacen_id, fecha_venta, moneda, subtotal, impuesto, total)
  VALUES ((SELECT id FROM clientes WHERE nombre = 'Distribuidora El Lagar S.A.'), (SELECT id FROM usuarios WHERE email = 'camila.duarte@vinovault.demo'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), NOW() - interval '28 days 6 hours 57 minutes', 'USD', 305.50, 30.55, 336.05)
  RETURNING id, fecha_venta, usuario_id, almacen_id
), items(producto_id, cantidad, precio) AS (VALUES
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), 5, 14.9),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), 6, 38.5)
), vi AS (
  INSERT INTO venta_items (venta_id, producto_id, cantidad, precio_unitario)
  SELECT v.id, items.producto_id, items.cantidad, items.precio FROM v, items
)
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento)
SELECT items.producto_id, v.almacen_id, v.usuario_id, 'Salida por Venta', -items.cantidad, v.fecha_venta FROM v, items;

-- Ajustes manuales
INSERT INTO movimientos_stock (producto_id, almacen_id, usuario_id, tipo_movimiento, cantidad, fecha_movimiento) VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 48, NOW() - interval '5 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 24, NOW() - interval '10 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Ajuste', -1, NOW() - interval '19 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 48, NOW() - interval '11 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 48, NOW() - interval '12 days 0 hours 0 minutes'),
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), (SELECT id FROM usuarios WHERE rol = 'admin' ORDER BY id LIMIT 1), 'Entrada Manual', 36, NOW() - interval '6 days 0 hours 0 minutes');

-- Inventario resultante
INSERT INTO inventario (producto_id, almacen_id, cantidad) VALUES
  ((SELECT id FROM productos WHERE sku = 'TIN-MAL-001'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), 142),
  ((SELECT id FROM productos WHERE sku = 'TIN-MAL-001'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), 23),
  ((SELECT id FROM productos WHERE sku = 'TIN-MAL-001'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), 40),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), 103),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), 32),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAB-002'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), 29),
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), 55),
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), 97),
  ((SELECT id FROM productos WHERE sku = 'TIN-TAN-003'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), 112),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), 120),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), 42),
  ((SELECT id FROM productos WHERE sku = 'TIN-CAR-004'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), 23),
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), 84),
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), 8),
  ((SELECT id FROM productos WHERE sku = 'TIN-TEM-005'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), 68),
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), 124),
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), 69),
  ((SELECT id FROM productos WHERE sku = 'TIN-SYR-006'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), 54),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), 52),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), 26),
  ((SELECT id FROM productos WHERE sku = 'BLA-CHA-007'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), 38),
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), 95),
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), 43),
  ((SELECT id FROM productos WHERE sku = 'BLA-SAU-008'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), 54),
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), 125),
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), 20),
  ((SELECT id FROM productos WHERE sku = 'BLA-TOR-009'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), 3),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), 93),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), 36),
  ((SELECT id FROM productos WHERE sku = 'ROS-MAL-010'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), 48),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), 116),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), 20),
  ((SELECT id FROM productos WHERE sku = 'ESP-BRU-011'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), 67),
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), (SELECT id FROM almacenes WHERE nombre = 'Depósito Central'), 57),
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), (SELECT id FROM almacenes WHERE nombre = 'Sucursal Centro'), 2),
  ((SELECT id FROM productos WHERE sku = 'POR-TAW-012'), (SELECT id FROM almacenes WHERE nombre = 'Bodega Frontera'), 28);

COMMIT;
