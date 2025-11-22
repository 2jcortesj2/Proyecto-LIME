-- ============================================
-- SCRIPT DE MIGRACIÓN DE DATOS - PROYECTO LIME
-- Sistema de Gestión de Equipos Biomédicos
-- Base de datos: lime_db
-- ============================================
-- VERSIÓN ACTUALIZADA - Compatible con Backend Django
-- Fecha de última actualización: 2025-11-22
-- ============================================

USE `lime_db`;

-- ============================================
-- ADVERTENCIA: Este script elimina TODOS los datos existentes
-- Solo ejecutar en entorno de DESARROLLO o PRUEBAS
-- ============================================

-- Deshabilitar validación de foreign keys temporalmente
SET FOREIGN_KEY_CHECKS = 0;

-- Limpiar tablas en orden correcto (de dependientes a principales)
TRUNCATE TABLE `historial_mantenimientos`;
TRUNCATE TABLE `historial_traslados`;
TRUNCATE TABLE `equipos_condicionesfuncionamiento`;
TRUNCATE TABLE `equipos_informacionmetrologica`;
TRUNCATE TABLE `equipos_documentacionequipo`;
TRUNCATE TABLE `equipos_registroadquisicion`;
TRUNCATE TABLE `equipos_equipo`;
TRUNCATE TABLE `servicios`;
TRUNCATE TABLE `sedes`;
TRUNCATE TABLE `usuarios`;

-- Reactivar validación de foreign keys
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 1. INSERTAR SEDES
-- ============================================
-- Tabla: sedes
-- Columnas Django: id (BigAutoField), nombre, direccion, ciudad, telefono, estado

INSERT INTO `sedes` (`nombre`, `direccion`, `ciudad`, `telefono`, `estado`) VALUES
('Prado', 'Hospital Alma Mater de Antioquia, Bloque B', 'Medellín', 'Por definir', 1),
('SIU', 'Torre 1 y Torre 2, Sede de Investigación Universitaria', 'Medellín', 'Por definir', 1),
('San Vicente', 'Hospital Universitario San Vicente Fundación', 'Medellín', 'Por definir', 1);

-- ============================================
-- 2. INSERTAR SERVICIOS
-- ============================================
-- Tabla: servicios
-- Columnas Django: id (BigAutoField), nombre, sede_id (FK), descripcion, responsable, estado

INSERT INTO `servicios` (`nombre`, `descripcion`, `responsable`, `estado`, `sede_id`) VALUES
-- Servicios Prado (sede_id = 1)
('LIME', 'Laboratorio de Inmunovirología y Medicina Especializada', 'Gloria Zapata', 1, 1),
('LIME - Hematología', 'Sección de Hematología', 'Gloria Zapata', 1, 1),
('LIME - Citometría de flujo', 'Sección de Citometría de flujo', 'Vanessa Santiago', 1, 1),
('LIME - Almacén', 'Almacén de equipos', 'Duvan Gallego', 1, 1),
('LIME - Atención de Pacientes', 'Área de atención y recepción de pacientes', 'Andrés Zuluaga', 1, 1),
('LIME - Biología Molecular', 'Sección de Biología Molecular', 'Carlos Muñetón', 1, 1),
('LIME - BSL3', 'Laboratorio de Bioseguridad Nivel 3', 'Ivone Jimenez', 1, 1),
('LIME - Citogenómica', 'Sección de Citogenómica', 'Gloria Ramírez', 1, 1),
('LIME - Microbiología', 'Sección de Microbiología', 'Enith Knuth', 1, 1),
('LIME - Química e inmunología', 'Sección de Química e Inmunología', 'Juan Carlos Herrera', 1, 1),
('LIME - Farmacología y Toxicología', 'Sección de Farmacología y Toxicología', 'Andrés Hincapie', 1, 1),
('Centro de resonancia', Centro de Resonancia Magnética', 'Pablo Patiño Grajales', 1, 1),
('Fotodermatología', 'Servicio de Fotodermatología', 'Jhon Frank Villa', 1, 1),

-- Servicios SIU (sede_id = 2)
('Trasplantes GICIG', 'Grupo de Inmunología Celular e Inmunogenética', 'Juan José Serrano', 1, 2),
('Inmunodeficiencias Primarias', 'Laboratorio de Inmunodeficiencias Primarias', 'Diana Arboleda', 1, 2),
('Grupo Reproducción', 'Grupo de Reproducción', 'Carolina Navarro', 1, 2),

-- Servicios San Vicente (sede_id = 3)
('Patología', 'Servicio de Patología', 'Martha Londoño', 1, 3),
('Dermatopatología', 'Laboratorio de Dermatopatología', 'Diana Meneses', 1, 3);

-- ============================================
-- 3. INSERTAR EQUIPOS - EJEMPLOS
-- ============================================

-- EQUIPO 1: Congelador (LIME - Prado)
-- --------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, 
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, 
    `registro_invima`, `tiempo_vida_util`, `estado`, 
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Congelador', '135306', 'Pendiente', '15 - 583',
    'Procesamiento Seccion C', 'Challenger', 'CV430', '9053127',
    'Extensión', 'IND', NULL,
    NULL, NULL, 'Activo',
    1, 1, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, '2009-12-10', NULL, 'UdeA',
    '890.934.939-8', 'Almacén Navarro Ospina S.A.', 0, NULL,
    'Compra', 'Factura', '47736', NULL
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 1, 0, 0, 0, 'Semestral'
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura', 'T -18', NULL, '0 a - 33 ° C',
    NULL, 1, '1', 1, '1 (Calificación)',
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '115 VAC', NULL, NULL, 'Max 38°C',
    '53,5 x 53 x 142 cm', '55,5 kg', NULL
);

-- EQUIPO 2: Agregometro (Hematología - Prado)
-- --------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, 
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, 
    `registro_invima`, `tiempo_vida_util`, `estado`, 
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Agregometro', '119325', 'BIO-12183', 'NT',
    'Procesamiento Seccion A', 'Helena Laboratories', 'AGGRAM', '630604801',
    'Extensión', 'BIO', 'IIa',
    'INVIMA 2019DM-0019614', NULL, 'Activo',
    1, 2, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, '2006-03-30', NULL, 'UdeA',
    '830.064.712-1', 'Helena Laboratories INC. / Labtronics S.A.S', 0, NULL,
    'Compra', 'Factura', '96442', NULL
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 1, 1, 0, 1, 1, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Absorbancia', '0 - 2 DE', NULL, '0 - 2 DE',
    NULL, 1, '1', 0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '110 VAC', NULL, NULL, '15 - 30 °C',
    '15,24 cm x 25,40 cm x 43,18 cm', '6,75 Kg', 'Frecuencia 50/60 Hz'
);

-- EQUIPO 3: Centrífuga refrigerada (Hematología - Prado)
-- --------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, 
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, 
    `registro_invima`, `tiempo_vida_util`, `estado`, 
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Centrífuga refrigerada', '130937', 'BIO-12186', '10 - 780',
    'Área centrífugas', 'BOECO - HETTICH', 'U-320R', '0000189',
    'Extensión', 'BIO', 'IIa',
    'INVIMA 2014DM-0011507', NULL, 'Activo',
    1, 2, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, '2008-12-02', '2008-01-01', 'UdeA',
    '811.033.098-5', 'Importecnical Ltda.', 0, NULL,
    'Compra', 'Factura', '006093', NULL
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0, 0, 1, 1, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'vacio', 'Max. 15000 rpm / T -20 a 40°C', '10 rpm / 1°C', '1000 - 4500 rpm',
    NULL, 1, '2', 1, '2',
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '200 - 240 V', '4 A', NULL, NULL,
    '346 x 401 x 695 mm', '53 kg', NULL
);

-- EQUIPO 4: Analizador de coagulación (Hematología - Prado)
-- --------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, 
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, 
    `registro_invima`, `tiempo_vida_util`, `estado`, 
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Analizador de coagulación automatizado', 'LIME 378', 'BIO-16281', '15 - 098',
    'Procesamiento Seccion A', 'SYSMEX', 'CS2500', '25407',
    'Extensión', 'BIO', 'IIa',
    'INVIMA 2016DM-0015107', NULL, 'Activo',
    1, 2, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, '2021-07-16', NULL, 'UT LIME',
    '900.931.305-0', 'SIEMENS', 0, '2022-07-15',
    'Compra', 'Factura', 'TE57569', NULL
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 1, 1, 1, 1, 1, 'Semestral'
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 1, '2', 0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '100 - 240 VAC', NULL, '30 - 85 %HR', '15 - 30 °C',
    '775 x 895 x 685 mm / 280 x 355 x 400 mm', '110 kg / 17 kg', NULL
);

-- EQUIPO 5: Micropipeta (Hematología - Prado)
-- --------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, 
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, 
    `registro_invima`, `tiempo_vida_util`, `estado`, 
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Micropipeta', '160517', 'BIO-12193', '15 - 166',
    'Procesamiento Seccion A', 'Thermo Scientific', 'Finnpipette F1', 'MH12168',
    'Extensión', 'BIO', 'I',
    'ACTA No. 09 Septiembre 17 de 2014', NULL, 'Activo',
    1, 2, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, '2016-01-19', NULL, 'UdeA',
    '900.355.024-5', 'Equipos y Laboratorio', 0, NULL,
    'Compra', 'Factura', 'C7206', NULL
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 1, 1, 1, 0, 'Trimestral'
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Volumen', '100 - 1000 uL', '1 uL', '100 - 1000 ul',
    NULL, 1, '1', 1, '1',
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- ============================================
-- RESUMEN DE MIGRACIÓN
-- ============================================
--
-- DATOS INSERTADOS:
-- ✓ 3 Sedes (Prado, SIU, San Vicente)
-- ✓ 18 Servicios (distribuidos en las 3 sedes)
-- ✓ 5 Equipos de muestra (con información completa)
--
-- ESTRUCTURA DE BASE DE DATOS (Tablas Django):
--
-- Tablas Principales:
-- • sedes - Información de sedes/ubicaciones físicas
-- • servicios - Servicios/departamentos en cada sede
-- • usuarios - Usuarios del sistema (admin, técnicos, etc.)
-- • equipos_equipo - Tabla principal de equipos
--
-- Tablas Relacionadas One-to-One con Equipo:
-- • equipos_registroadquisicion - Datos de compra y adquisición
-- • equipos_documentacionequipo - Documentación disponible del equipo
-- • equipos_informacionmetrologica - Info de mantenimiento y calibración
-- • equipos_condicionesfuncionamiento - Especificaciones técnicas
--
-- Tablas de Historial (Many-to-One con Equipo):
-- • historial_mantenimientos - Registros de mantenimiento (tiene created_at)
-- • historial_traslados - Registros de traslados (tiene created_at)
--
-- NOTAS IMPORTANTES:
-- 1. Todos los modelos Django tienen un campo 'id' (BigAutoField) autogenerado
-- 2. Las tablas de historial tienen campo 'created_at' (DateTimeField con auto_now_add)
-- 3. Los campos NULL son aceptados en la mayoría de campos opcionales
-- 4. Las fechas usan formato DATE 'YYYY-MM-DD'
-- 5. Los timestamps usan formato DATETIME 'YYYY-MM-DD HH:MM:SS'
--
-- VALORES PERMITIDOS:
-- • clasificacion_riesgo:  'I', 'IIa', 'IIb', 'III'
-- • clasificacion_misional: 'Docencia', 'Investigación', 'Extensión', 'Mixto'
-- • clasificacion_ips: 'IND', 'BIO', 'GASES'
-- • estado (equipo): 'Activo', 'Inactivo', 'Baja', 'En Mantenimiento'
-- • forma_adquisicion: 'Compra', 'Apoyo Tecnológico', 'Donación', 'Convenio'
-- • tipo_mantenimiento: 'preventivo', 'correctivo', 'calibracion', 
--                       'calificacion', 'verificacion'
--
-- CÓMO EJECUTAR ESTE SCRIPT:
--
-- Opción 1 - Línea de comandos MySQL:
--   mysql -u root -p lime_db < migracion_datos_lime.sql
--
-- Opción 2 - MySQL Workbench:
--   File > Run SQL Script > Seleccionar migracion_datos_lime.sql
--
-- Opción 3 - Shell de MySQL:
--   mysql -u root -p
--   USE lime_db;
--   SOURCE /ruta/completa/migracion_datos_lime.sql;
--
-- ============================================
