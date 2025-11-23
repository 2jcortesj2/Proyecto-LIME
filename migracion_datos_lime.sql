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
TRUNCATE TABLE `responsables_responsable`;

-- Reactivar validación de foreign keys
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 1. INSERTAR SEDES
-- ============================================
INSERT INTO `sedes` (`id`, `nombre`, `direccion`, `ciudad`, `telefono`, `estado`) VALUES
(1, 'Prado', 'Hospital Alma Mater de Antioquia, Bloque B', 'Medellín', 'Por definir', 1),
(2, 'SIU', 'Torre 1 y Torre 2, Sede de Investigación Universitaria', 'Medellín', 'Por definir', 1),
(3, 'San Vicente', 'Hospital Universitario San Vicente Fundación', 'Medellín', 'Por definir', 1);

-- ============================================
-- 2. INSERTAR SERVICIOS
-- ============================================
INSERT INTO `servicios` (`id`, `nombre`, `descripcion`, `responsable`, `estado`, `sede_id`) VALUES
-- Servicios Prado (sede_id = 1)
(1, 'LIME', 'Laboratorio de Inmunovirología y Medicina Especializada', 'Gloria Zapata', 1, 1),
(2, 'LIME - Hematología', 'Sección de Hematología', 'Gloria Zapata', 1, 1),
(3, 'LIME - Citometría de flujo', 'Sección de Citometría de flujo', 'Vanessa Santiago', 1, 1),
(4, 'LIME - Almacén', 'Almacén de equipos', 'Duvan Gallego', 1, 1),
(5, 'LIME - Atención de Pacientes', 'Área de atención y recepción de pacientes', 'Andrés Zuluaga', 1, 1),
(6, 'LIME - Biología Molecular', 'Sección de Biología Molecular', 'Carlos Muñetón', 1, 1),
(7, 'LIME - BSL3', 'Laboratorio de Bioseguridad Nivel 3', 'Ivone Jimenez', 1, 1),
(8, 'LIME - Citogenómica', 'Sección de Citogenómica', 'Gloria Ramírez', 1, 1),
(9, 'LIME - Microbiología', 'Sección de Microbiología', 'Enith Knuth', 1, 1),
(10, 'LIME - Química e inmunología', 'Sección de Química e Inmunología', 'Juan Carlos Herrera', 1, 1),
(11, 'LIME - Farmacología y Toxicología', 'Sección de Farmacología y Toxicología', 'Andrés Hincapie', 1, 1),
(12, 'Centro de resonancia', 'Centro de Resonancia Magnética', 'Pablo Patiño Grajales', 1, 1),
(13, 'Fotodermatología', 'Servicio de Fotodermatología', 'Jhon Frank Villa', 1, 1),

-- Servicios SIU (sede_id = 2)
(14, 'Trasplantes GICIG', 'Grupo de Inmunología Celular e Inmunogenética', 'Juan José Serrano', 1, 2),
(15, 'Inmunodeficiencias Primarias', 'Laboratorio de Inmunodeficiencias Primarias', 'Diana Arboleda', 1, 2),
(16, 'Grupo Reproducción', 'Grupo de Reproducción', 'Carolina Navarro', 1, 2),

-- Servicios San Vicente (sede_id = 3)
(17, 'Patología', 'Servicio de Patología', 'Martha Londoño', 1, 3),
(18, 'Dermatopatología', 'Laboratorio de Dermatopatología', 'Diana Meneses', 1, 3);

-- ============================================
-- 3. INSERTAR RESPONSABLES
-- ============================================
-- Tabla: responsables_responsable
-- Columnas: id, nombre_completo, email, telefono, rol

INSERT INTO `responsables_responsable` (`id`, `nombre_completo`, `email`, `telefono`, `rol`) VALUES
(1, 'Gloria Zapata', 'gloria.zapata@udea.edu.co', '555-0101', 'Coordinadora'),
(2, 'Vanessa Santiago', 'vanessa.santiago@udea.edu.co', '555-0102', 'Analista'),
(3, 'Duvan Gallego', 'duvan.gallego@udea.edu.co', '555-0103', 'Auxiliar'),
(4, 'Andrés Zuluaga', 'andres.zuluaga@udea.edu.co', '555-0104', 'Recepcionista'),
(5, 'Carlos Muñetón', 'carlos.muneton@udea.edu.co', '555-0105', 'Investigador'),
(6, 'Ivone Jimenez', 'ivone.jimenez@udea.edu.co', '555-0106', 'Investigadora'),
(7, 'Juan José Serrano', 'juan.serrano@udea.edu.co', '555-0107', 'Investigador');

-- ============================================
-- 4. INSERTAR EQUIPOS - EJEMPLOS
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
    1, 1, 1 -- Gloria Zapata
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
    1, 2, 1 -- Gloria Zapata
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
    1, 2, 1 -- Gloria Zapata
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
    1, 2, 4 -- Andrés Zuluaga
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
    1, 2, 1 -- Gloria Zapata
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

-- EQUIPO 6: Microscopio (SIU - Inmunodeficiencias)
-- --------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, 
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, 
    `registro_invima`, `tiempo_vida_util`, `estado`, 
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Microscopio', '132498', 'BIO-16761', '12-536',
    'SIU Torre 2 Lab 530', 'OLYMPUS', 'CX21FS1', '8D07016',
    'Extensión', 'BIO', 'I',
    'ACTA No. 07 Junio 10 de 2009', NULL, 'Activo',
    2, 15, 7 -- Juan José Serrano
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, '2009-07-31', NULL, 'UdeA',
    '811.033.098-5', 'Importecnical', 0, '2010-07-31',
    'Compra', 'Factura', '006823', NULL
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 1, 1, 1, 0, 'Anual'
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 1, '1', 0, NULL,
    '2024-01-15', '2025-01-15', NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '100-120/220-240 VAC', '0,42/0,25 A', '80%HR', '5 - 40 °C',
    '154 x 391 x 238 mm', '5,9 kg', 'Frecuencia 50/60 Hz'
);

-- EQUIPO 7: Cabina de extracción (SIU - Trasplantes)
-- --------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, 
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, 
    `registro_invima`, `tiempo_vida_util`, `estado`, 
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Cabina de extracción', 'C481', 'BIO-16859', 'NT', 
    'SIU Torre 1 Lab 410', 'C4', 'CEX 120', '100406', 
    'Extensión', 'BIO', NULL, 
    'No requiere', NULL, 'En Mantenimiento', 
    2, 14, 7 -- Juan Jose Serrano
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, '2005-01-01', NULL, 'UdeA', 
    '805.016.686-2', 'C4 Pascal', 
    0, NULL, 'Compra', 'Histórico', NULL, NULL
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 1, 1, 1, 1, 'Semestral'
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL, NULL, 
    1, '1', 1, '1 (calificación)', 
    '2024-06-10', '2024-12-10', '2024-06-10', '2024-12-10'
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '110 VAC', NULL, NULL, NULL, 
    '1200 X 1800 X 1519 cm', NULL, 'Frecuencia 50/60 Hz'
);

-- ============================================
-- 5. INSERTAR HISTORIAL DE MANTENIMIENTOS
-- ============================================
-- Tabla: historial_mantenimientos
-- Columnas: id, equipo_id, tipo_mantenimiento, mes_mantenimiento, anio_mantenimiento, 
--           descripcion, realizado_por, costo, usuario_registro, observaciones, created_at

-- Mantenimiento para Equipo 7 (Cabina)
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 6, 2024,
    'Limpieza general, cambio de filtros HEPA y verificación de flujo de aire.',
    'Ing. Externo - C4 Pascal', 450000.00, 'Juan Jose Serrano', 'Equipo operativo', NOW()
);

-- Mantenimiento para Equipo 1 (Congelador)
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    1, 'correctivo', 2, 2024,
    'Reparación de compresor por ruido excesivo.',
    'Técnico UdeA', 120000.00, 'Gloria Zapata', 'Se recomienda monitoreo', NOW()
);

-- EQUIPO 8: Balanza analítica (Prado - Hematología) - Mantenimiento próximo
-- --------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, 
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, 
    `registro_invima`, `tiempo_vida_util`, `estado`, 
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Balanza analítica', '135401', 'LAB-20145', '18-442',
    'Prado Torre 1 Lab 210', 'OHAUS', 'PA214', 'B512345678',
    'Extensión', 'LAB', 'I',
    '2018DM-0009876', NULL, 'Activo',
    1, 1, 1
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, '2024-12-10', NULL, 'UdeA',
    '890.123.456-7', 'Lab Equipment SAS', 0, '2025-12-10',
    'Compra', 'Factura', 'F-2023-456', 4500000.00
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 1, 1, 1, 0, 1, 'Anual'
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Masa', '0-210 g', '0.0001 g', '0-200 g',
    '±0.0002 g', 1, 'Anual', 1, 'Anual',
    NULL, '2025-12-10', NULL, '2025-12-10'
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '110-240 VAC', '0.15 A', '80%HR', '10 - 30 °C',
    '230 x 350 x 340 mm', '4.5 kg', 'Frecuencia 50/60 Hz'
);

-- EQUIPO 9: Espectrofotómetro (SIU - Bioquímica) - Mantenimiento próximo
-- --------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, 
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, 
    `registro_invima`, `tiempo_vida_util`, `estado`, 
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Espectrofotómetro', '132501', 'LAB-20789', '18-555',
    'SIU Torre 2 Lab 520', 'Thermo Scientific', 'Genesys 30', 'GN30-2023-789',
    'Extensión', 'LAB', 'IIa',
    '2019DM-0011234', NULL, 'Activo',
    2, 14, 6
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, '2025-01-15', NULL, 'UdeA',
    '890.234.567-8', 'Scientific Solutions', 0, '2026-01-15',
    'Compra', 'Factura', 'F-2023-789', 12000000.00
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 1, 1, 1, 1, 1, 'Anual'
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Absorbancia', '190-1100 nm', '0.001 Abs', '200-900 nm',
    '±0.005 Abs', 1, 'Anual', 1, 'Anual',
    NULL, '2026-01-15', NULL, '2026-01-15'
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '100-240 VAC', '1.5 A', '80%HR', '15 - 35 °C',
    '440 x 510 x 200 mm', '11 kg', 'Frecuencia 50/60 Hz'
);

-- ============================================
-- 5. INSERTAR REGISTROS DE MANTENIMIENTO
-- ============================================
-- Ejemplos de mantenimientos: vencidos, próximos y normales

-- Mantenimiento VENCIDO para Congelador (equipo_id = 1)
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    1, 'preventivo', 6, 2024,
    'Limpieza general del sistema de refrigeración, verificación de temperatura y sellado de puertas',
    'TecnoFrío SAS', 250000.00, 'Admin LIME',
    'Mantenimiento vencido - requiere programación inmediata',
    '2024-06-15 10:00:00'
);

-- Mantenimiento VENCIDO para Agregómetro (equipo_id = 2)
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    2, 'calibracion', 12, 2024,
    'Calibración de canales de lectura, limpieza óptica y verificación de precisión',
    'Biocare Médica Ltda.', 420000.00, 'Admin LIME',
    'Calibración vencida - equipo requiere atención',
    '2024-12-01 14:30:00'
);

-- Mantenimiento PRÓXIMO A VENCER para Centrífuga (equipo_id = 3)
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    3, 'preventivo', 2, 2025,
    'Lubricación de componentes mecánicos, verificación de velocidades y balance del rotor',
    'Tecno Lab SAS', 550000.00, 'Admin LIME',
    'Próximo a vencer en 3 meses',
    '2024-11-20 09:15:00'
);

-- Mantenimiento PRÓXIMO A VENCER para Micropipeta (equipo_id = 5)
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    5, 'calibracion', 1, 2025,
    'Calibración volumétrica y verificación de precisión según normas ISO',
    'Metrología UdeA', 180000.00, 'Admin LIME',
    'Programado para enero 2025',
    '2024-11-18 11:45:00'
);

-- Mantenimiento NORMAL para Analizador de coagulación (equipo_id = 4)
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    4, 'preventivo', 12, 2025,
    'Mantenimiento preventivo completo, limpieza de sistema óptico y verificación de reactivos',
    'SYSMEX Colombia', 1200000.00, 'Admin LIME',
    'Programado para diciembre 2025',
    '2024-11-15 16:20:00'
);

-- Mantenimiento COMPLETADO RECIENTEMENTE para Microscopio (equipo_id = 6)
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    6, 'preventivo', 11, 2024,
    'Limpieza de lentes, ajuste de sistema óptico y verificación de iluminación',
    'Olympus Service', 380000.00, 'Admin LIME',
    'Mantenimiento completado satisfactoriamente',
    '2024-11-10 13:00:00'
);

-- ============================================
-- RESUMEN DE MIGRACIÓN
-- ============================================
--
-- DATOS INSERTADOS:
-- ✓ 3 Sedes (Prado, SIU, San Vicente)
-- ✓ 18 Servicios (distribuidos en las 3 sedes)
-- ✓ 7 Responsables (Usuarios del sistema)
-- ✓ 7 Equipos de muestra (con información completa)
-- ✓ 6 Registros de historial de mantenimiento (vencidos, próximos y normales)
--
-- ESTRUCTURA DE BASE DE DATOS (Tablas Django):
--
-- Tablas Principales:
-- • sedes - Información de sedes/ubicaciones físicas
-- • servicios - Servicios/departamentos en cada sede
-- • responsables_responsable - Usuarios/Responsables del sistema
-- • equipos_equipo - Tabla principal de equipos (FK a responsable)
--
-- Tablas Relacionadas One-to-One con Equipo:
-- • equipos_registroadquisicion - Datos de compra y adquisición
-- • equipos_documentacionequipo - Documentación disponible del equipo
-- • equipos_informacionmetrologica - Info de mantenimiento y calibración
-- • equipos_condicionesfuncionamiento - Especificaciones técnicas
--
-- Tablas de Historial (Many-to-One con Equipo):
-- • historial_mantenimientos - Registros de mantenimiento (usa mes/año)
-- • historial_traslados - Registros de traslados
--
-- NOTAS IMPORTANTES:
-- 1. Todos los modelos Django tienen un campo 'id' (BigAutoField) autogenerado
-- 2. Las tablas de historial tienen campo 'created_at' (DateTimeField con auto_now_add)
-- 3. HistorialMantenimiento usa 'mes_mantenimiento' (int) y 'anio_mantenimiento' (int)
-- 4. Los campos NULL son aceptados en la mayoría de campos opcionales
--
-- CÓMO EJECUTAR ESTE SCRIPT:
--
-- Opción 1 - Línea de comandos MySQL:
--   mysql -u root -p lime_db < migracion_datos_lime.sql
--
-- Opción 2 - MySQL Workbench:
--   File > Run SQL Script > Seleccionar migracion_datos_lime.sql
--
-- ============================================
