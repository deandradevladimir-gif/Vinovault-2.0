-- Configuración inicial de Supabase para VinoVault.
-- Ejecutar en Supabase > SQL Editor DESPUÉS de schema.sql.

-- 1. Bucket público para las imágenes de productos
INSERT INTO storage.buckets (id, name, public)
VALUES ('vinovault-images', 'vinovault-images', true)
ON CONFLICT (id) DO NOTHING;

-- 2. Políticas: el backend sube y borra imágenes con la clave anon
DROP POLICY IF EXISTS "vinovault images read" ON storage.objects;
DROP POLICY IF EXISTS "vinovault images upload" ON storage.objects;
DROP POLICY IF EXISTS "vinovault images delete" ON storage.objects;

CREATE POLICY "vinovault images read" ON storage.objects
  FOR SELECT TO anon USING (bucket_id = 'vinovault-images');

CREATE POLICY "vinovault images upload" ON storage.objects
  FOR INSERT TO anon WITH CHECK (bucket_id = 'vinovault-images');

CREATE POLICY "vinovault images delete" ON storage.objects
  FOR DELETE TO anon USING (bucket_id = 'vinovault-images');

-- 3. Almacenes (la app no tiene pantalla para crearlos y las ventas necesitan uno)
INSERT INTO almacenes (nombre, ubicacion)
SELECT * FROM (VALUES
  ('Depósito Central', 'Ciudad del Este'),
  ('Sucursal Centro', 'Asunción')
) AS v(nombre, ubicacion)
WHERE NOT EXISTS (SELECT 1 FROM almacenes);
