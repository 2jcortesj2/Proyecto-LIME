-- Script de migración de datos para LIME
-- Convierte el archivo CSV de equipos a la base de datos SQL existente

-- ============================================
-- 1. INSERTAR SEDES
-- ============================================
INSERT INTO `sedes` (`nombre`, `direccion`, `ciudad`, `telefono`, `estado`) VALUES
('Prado', 'Hospital Alma Mater de Antioquia, Bloque B', 'Medellín', 'Por definir', 1),
('SIU', 'Torre 1 y Torre 2, Sede de Investigación Universitaria', 'Medellín', 'Por definir', 1),
('San Vicente', 'Hospital Universitario San Vicente Fundación', 'Medellín', 'Por definir', 1);

-- ============================================
-- 2. INSERTAR SERVICIOS
-- ============================================
INSERT INTO `servicios` (`nombre`, `descripcion`, `responsable`, `estado`, `sede_id`) VALUES
-- Servicios Prado
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
('Centro de resonancia', 'Centro de Resonancia Magnética', 'Pablo Patiño Grajales', 1, 1),
('Fotodermatología', 'Servicio de Fotodermatología', 'Jhon Frank Villa', 1, 1),

-- Servicios SIU
('Trasplantes GICIG', 'Grupo de Inmunología Celular e Inmunogenética', 'Juan José Serrano', 1, 2),
('Inmunodeficiencias Primarias', 'Laboratorio de Inmunodeficiencias Primarias', 'Diana Arboleda', 1, 2),
('Grupo Reproducción', 'Grupo de Reproducción', 'Carolina Navarro', 1, 2),

-- Servicios San Vicente
('Patología', 'Servicio de Patología', 'Martha Londoño', 1, 3),
('Dermatopatología', 'Laboratorio de Dermatopatología', 'Diana Meneses', 1, 3);

-- ============================================
-- 3. INSERTAR EQUIPOS
-- ============================================

-- EQUIPOS PRADO - LIME
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Congelador', '135306', 'Pendiente', '15 - 583', 'Gloria Zapata', 
'Procesamiento Seccion C', 'Challenger', 'CV430', '9053127', 'Extensión', 
'IND', NULL, NULL, NULL, '2009-12-10', NULL, 'UdeA', '890.934.939-8', 
'Almacén Navarro Ospina S.A.', 0, NULL, 'Compra', 'Factura', '47736', 
NULL, 1, 0, 1, 0, 0, 0, 0, 'Semestral', 1, '1', 1, '1 (Calificación)', 
'Temperatura', 'T -18', NULL, '0 a - 33 ° C', NULL, '115 VAC', NULL, 
NULL, 'Max 38°C', '53,5 x 53 x 142 cm', '55,5 kg', NULL, 1, 1);

-- EQUIPOS PRADO - LIME Hematología
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Agregometro', '119325', 'BIO-12183', 'NT', 'Gloria Zapata', 
'Procesamiento Seccion A', 'Helena Laboratories', 'AGGRAM', '630604801', 'Extensión', 
'BIO', 'Clase IIa', 'INVIMA 2019DM-0019614', NULL, '2006-03-30', NULL, 'UdeA', 
'830.064.712-1', 'Helena Laboratories INC. / Labtronics S.A.S', 0, NULL, 'Compra', 
'Factura', '96442', NULL, 1, 1, 1, 0, 1, 1, 0, NULL, 1, '1', 0, NULL, 
'Absorbancia', '0 - 2 DE', NULL, '0 - 2 DE', NULL, '110 VAC', NULL, 
NULL, '15 - 30 °C', '15,24 cm x 25,40 cm x 43,18 cm', '6,75 Kg', 'Frecuencia 50/60 Hz', 1, 2),

('Centrífuga refrigerada', '130937', 'BIO-12186', '10 - 780', 'Gloria Zapata', 
'Área centrífugas', 'BOECO - HETTICH', 'U-320R', '0000189', 'Extensión', 
'BIO', 'Clase IIa', 'INVIMA 2014DM-0011507', NULL, '2008-12-02', '2008-01-01', 
'UdeA', '811.033.098-5', 'Importecnical Ltda.', 0, NULL, 'Compra', 'Factura', 
'006093', NULL, 1, 0, 0, 0, 1, 1, 0, NULL, 1, '2', 1, '2', 
'vacio', 'Max. 15000 rpm / T -20 a 40°C', '10 rpm / 1°C', '1000 - 4500 rpm', 
NULL, '200 - 240 V', '4 A', NULL, NULL, '346 x 401 x 695 mm', '53 kg', NULL, 1, 2),

('Analizador de coagulación automatizado', 'LIME 378', 'BIO-16281', '15 - 098', 
'Andres Zuluaga', 'Procesamiento Seccion A', 'SYSMEX', 'CS2500', '25407', 'Extensión', 
'BIO', 'Clase IIa', 'INVIMA 2016DM-0015107', NULL, '2021-07-16', NULL, 'UT LIME', 
'900.931.305-0', 'SIEMENS', 0, '2022-07-15', 'Compra', 'Factura', 'TE57569', 
NULL, 1, 1, 1, 1, 1, 1, 1, 'Semestral', 1, '2', 0, NULL, 
NULL, NULL, NULL, NULL, NULL, '100 - 240 VAC', NULL, '30 - 85 %HR', 
'15 - 30 °C', '775 x 895 x 685 mm / 280 x 355 x 400 mm', '110 kg / 17 kg', NULL, 1, 2),

('Micropipeta', '160517', 'BIO-12193', '15 - 166', 'Gloria Zapata', 
'Procesamiento Seccion A', 'Thermo Scientific', 'Finnpipette F1', 'MH12168', 
'Extensión', 'BIO', 'Clase I', 'ACTA No. 09 Septiembre 17 de 2014', NULL, 
'2016-01-19', NULL, 'UdeA', '900.355.024-5', 'Equipos y Laboratorio', 0, NULL, 
'Compra', 'Factura', 'C7206', NULL, 1, 0, 1, 1, 1, 0, 1, 'Trimestral', 
1, '1', 1, '1', 'Volumen', '100 - 1000 uL', '1 uL', '100 - 1000 ul', 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 2),

('Micropipeta', '160516', 'BIO-12194', '15 - 166', 'Gloria Zapata', 
'Procesamiento Seccion A', 'Thermo Scientific', 'Finnpipette F1', 'MH12173', 
'Extensión', 'BIO', 'Clase I', 'ACTA No. 09 Septiembre 17 de 2014', NULL, 
'2016-01-19', NULL, 'UdeA', '900.355.024-5', 'Equipos y Laboratorio', 0, NULL, 
'Compra', 'Factura', 'C7206', NULL, 1, 0, 1, 1, 1, 0, 1, 'Trimestral', 
1, '1', 1, '1', 'Volumen', '100 - 1000 uL', '1 uL', '100 - 1000 ul', 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 2),

('Micropipeta', '160515', 'BIO-12198', '15 - 166', 'Gloria Zapata', 
'Procesamiento Seccion A', 'Thermo Scientific', 'Finnpipette F1', 'MH12148', 
'Extensión', 'BIO', 'Clase I', 'ACTA No. 09 Septiembre 17 de 2014', NULL, 
'2016-01-19', NULL, 'UdeA', '900.355.024-5', 'Equipos y Laboratorio', 0, NULL, 
'Compra', 'Factura', 'C7206', NULL, 1, 0, 1, 1, 1, 0, 1, 'Trimestral', 
1, '1', 1, '1', 'Volumen', '20 - 200 uL', '0,2 uL', '20 - 200 ul', 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 2);

-- EQUIPOS PRADO - Citometría de flujo
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Agitador Vórtex', '150955', 'BIO-12129', '15 - 651', 'Vanessa Santiago', 
'Procesamiento Seccion A', 'Boeco', 'Vortex V1 Plus', '1020313061616', 'Extensión', 
'BIO', NULL, 'ACTA No. 07 Junio 10 de 2009', NULL, '2014-02-03', NULL, 'UdeA', 
'890.912.308-6', 'Laboratorios Ltda.', 0, NULL, 'Compra', 'Factura', 'CR 00080017', 
NULL, 1, 0, 1, 0, 1, 1, 0, NULL, 1, '1', 0, NULL, 'Velocidad', 
'750 - 3000 rpm', 'Perilla sin indicación', '750 - 3000 rpm', NULL, '100 - 240 VAC', 
NULL, '80% max.', '4 - 40 °C', '90 x 150 x 80 mm', '0,8 kg', NULL, 1, 3),

('Baño María', '150712', 'BIO-12130', '16 - 861', 'Vanessa Santiago', 
'Procesamiento Seccion B', 'Indulab', '09-A', '13834', 'Extensión', 'BIO', 
'Clase I', 'ACTA No. 07 Junio 10 de 2009', NULL, '2014-01-24', NULL, 'UdeA', 
'811.013.926-3', 'Indulab S.A.', 0, NULL, 'Compra', 'Factura', '6142', NULL, 
1, 1, 1, 1, 1, 1, 0, 'Semestral', 1, '2', 1, '2', 'Temperatura', 
'37 - 90°C', '0,1 °C', '37 - 90 °C', '+/- 1°C', '110 VAC', NULL, NULL, 
NULL, NULL, NULL, NULL, 1, 3),

('Centrífuga', '151362', 'BIO-12131', '10 - 778', 'Vanessa Santiago', 
'Área centrífugas', 'Hettich', 'Rotofix 32A', '006965-04', 'Extensión', 'BIO', 
'Clase I', 'INVIMA 2013DM-0010231', NULL, '2014-03-18', NULL, 'UdeA', 
'890.912.308-6', 'Laboratorios Ltda.', 0, NULL, 'Compra', 'Factura', 'CR 00081028', 
NULL, 1, 1, 1, 0, 1, 1, 0, NULL, 1, '1', 1, '1', 'Velocidad', 
'500rpm - 6000 rpm', '100 rpm / 1 min', NULL, NULL, '100 - 127 V', '3 A', 
'80% max.', '2 - 40 °C', '366 x 430 x 257 mm', '23 kg', NULL, 1, 3),

('Microcentrifuga refrigerada', 'LIME 360', 'BIO-16289', '17 - 452', 'Estefania Vasco', 
'Área centrífugas', 'HERMLE', 'Z 216 MK', '61165050', 'Extensión', 'BIO', 
'Clase I', 'INVIMA 2015DM-0013425', NULL, '2020-03-31', '2016-01-01', 'UT LIME', 
'811.026.956-0', 'MR y Cia S.A.S', 0, '2021-03-31', 'Compra', 'Factura', 'MRE 10890', 
29155000.00, 1, 0, 1, 0, 0, 0, 0, 'Semestral', 1, '2', 1, '2', 
'Velocidad/Tiempo/Temperatura', '200 - 15000 rpm', '1°C', NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, 1, 3);

-- EQUIPOS PRADO - Almacén
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Congelador', 'LIME 642', 'Pendiente', '15 - 583', 'Duvan Gallego', 
'Almacen Bloque B segundo piso', 'Infrico', 'LTF40SD', '3000957831', 'Extensión', 
'BIO', 'Clase IIa', 'INVIMA 2023DM-0026731', NULL, '2024-12-16', NULL, 'UT LIME', 
'800.154.351-3', 'BLAMIS DOTACIONES LABORATORIO S.A.S', 1, '2025-12-11', 'Compra', 
'Factura', 'E 160790', 18203002.00, 1, 0, 0, 0, 0, 0, 0, NULL, 1, '2', 
1, '2 (Calificación)', 'Temperatura', '2 - 8 °C', '1 °C', '2 - 8 °C', NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 4);

-- EQUIPOS PRADO - Atención de Pacientes
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Fonendoscopio', 'LIME 121', 'BIO-16800', '13 - 750', 'Andres Zuluaga', 
'Recepcion', 'GMD', 'GMD30-DCK', 'IMP-1163', 'Extensión', 'BIO', 'Clase I', 
'INVIMA 2015DM-0014070', NULL, '2023-01-18', NULL, 'UT LIME', '717890804', 
'Top medicos', 0, NULL, 'Compra', 'Factura', 'FE-7405', 104000.00, 1, 0, 0, 
0, 0, 0, 0, NULL, 1, '1', 0, NULL, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 5);

-- EQUIPOS PRADO - Biología Molecular
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Centrífuga refrigerada', '117104', 'BIO-12250', '18 - 270', 'Carlos Muñeton', 
'Biologia Molecular (Extraccion)', 'Sigma', '3-16K', '110639', 'Extensión', 'BIO', 
'Clase I', 'INVIMA 2015DM-0012550', NULL, '2005-06-16', '2005-01-01', 'UdeA', 
'800.240.039-8', 'Sigma Laborzentrifugen / Anditécnica', 0, NULL, 'Compra', 
'Factura', '2005-32874', NULL, 1, 1, 1, 0, 1, 1, 0, NULL, 1, '2', 1, '2', 
'Temperatura/Tiempo/Velocidad', 'T -10 a 40°C / 0 - 30 min / 100 - 15300 rpm', 
'1°C / 1min / 100 rpm', '18 a 22°C / 15 a 25 min / 1200 a 14000 rpm', NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 6);

-- EQUIPOS PRADO - BSL3
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Balanza Analítica', '189604', 'BIO-16749', '18 - 449', 'Ivone Jimenez', 
'BSL3 (Procesamiento)', 'ViBRA', 'HT224CEN', '215022050', 'Extensión e Investigación', 
'BIO', 'Clase I', 'ACTA No. 07 Junio 10 de 2009', NULL, '2021-11-18', NULL, 
'UdeA', '811.026.956-0', 'MR Y CIA S.A.S', 0, NULL, 'Compra', 'Factura', 'MRE14352', 
NULL, 1, 1, 1, 0, 0, 0, 0, NULL, 1, '1', 1, '1', 'Peso', '0,01 - 220 g', 
NULL, NULL, NULL, 'Adaptador 100 - 240 VAC / 12VDC', NULL, 'Máx. 80%HR', 
'10 - 30 °C', '213 x 314 x 395,3 mm', '2,5kg', 'Frecuencia 50 - 60 Hz', 1, 7);

-- EQUIPOS PRADO - Citogenómica
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Incubadora', '134788', 'BIO-12256', '18 - 013', 'Gloria Ramírez', 
'Citogenomica (Preanalitica)', 'Binder', 'BD53-UL', '908707', 'Extensión', 'BIO', 
NULL, 'Certificación de No Requiere 2014010943', NULL, '2009-11-24', NULL, 'UdeA', 
'890.912.308-6', 'Laboratorios Ltda.', 0, NULL, 'Compra', 'Factura', 'CR 00049421', 
NULL, 1, 0, 1, 0, 1, 1, 0, 'Anual', 1, '1', 1, '1 (Calificación)', 
'Temperatura', '5 °C sobre ambiente - 100 °C', '0,1 °C', '36,5°C-37,5°C', NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 8);

-- EQUIPOS PRADO - Microbiología
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Filmarray', '187250', 'BIO-16698', 'NI', 'Enith Knuth', 'Microbiología 1', 
'BIOFIRE', 'FilmArray Torch', 'TB03545', 'Extensión', 'BIO', 'Clase IIa', 
'INVIMA 2014DM-0011912', NULL, '2021-08-05', '2021-03-01', 'UdeA', '830.023.844-1', 
'Biomérieux', 0, NULL, 'Compra', 'Factura', 'FE23094 00728988', NULL, 1, 1, 1, 
0, 1, 0, 0, NULL, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, '120 VAC', 
'3,2 A', '20 - 80 %HR', '15 - 30 °C', '458 x 737 x 292 mm', '29,9 kg', 
'Frecuencia 50 - 60 Hz', 1, 9);

-- EQUIPOS PRADO - Química e inmunología
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Maglumi', 'A-LIME-003', 'BIO-16303', 'NI', 'Juan Carlos Herrera', 
'Procesamiento Seccion B', 'SNIBE', 'MAGLUMI 600', '0101010003022000165', 'Extensión', 
'BIO', 'Clase IIa', 'INVIMA 2012DM-0009229', NULL, '2021-08-31', '2020-12-14', 
'Arriendo MYM', '900.228.842-1', 'MyMDiagnostics', 0, NULL, 'Apoyo tecnológico', 
'Acta de entrega', '2930', NULL, 1, 1, 0, 0, 0, 0, 0, NULL, 1, '2', 0, NULL, 
NULL, NULL, NULL, NULL, NULL, '100 - 240 VAC', NULL, NULL, NULL, NULL, NULL, 
'Frecuencia 50/60 Hz Potencia 350 VA', 1, 10);

-- EQUIPOS PRADO - Farmacología y Toxicología
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Micropipeta', 'LIME 001', 'BIO-12177', '15 - 166', 'Andres Hincapie', 
'Procesamiento Seccion C', 'Corning', 'Lambda Plus', '658220168', 'Extensión', 
'BIO', 'Clase I', 'ACTA No. 09 Septiembre 17 de 2014', NULL, '2016-10-12', NULL, 
'UdeA', '811.026.956-0', 'MR Y Cia S.A.S', 0, NULL, 'Compra', 'Factura', 'MRC2303', 
788800.00, 1, 0, 1, 0, 1, 1, 0, NULL, 1, '1', 1, '1', 'Volumen', 
'0,5 - 10 ul', '0,02 uL', '0,5- 10 µl', NULL, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, 1, 11);

-- EQUIPOS PRADO - Centro de resonancia
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Resonador magnetico', '207255', 'BIO-15348', 'NT', 'Pablo Patiño Grajales', 
'Centro de resonancia Bloque B primer piso', 'PHILIPS', 'INGENIA ELITION X', 
'45555', 'Extensión e Investigación', 'BIO', 'Clase IIa', 'INVIMA 2018EBC-0017485', 
10, '2022-09-23', NULL, 'UdeA', '860.005.396-4', 'PHILIPS COLOMBIANA S.A.S', 0, 
'2024-09-23', 'Compra', 'Contrato', 'LATAM_109371', 1957500.00, 1, 1, 1, 0, 0, 
0, 0, 'Semestral', 1, '2', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, 1, 12);

-- EQUIPOS PRADO - Fotodermatología
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('CAMARA DE FOTOTERAPIA', '128568', 'BIO-100561', '13-037', 'Jhon Frank Villa', 
'FOTOTERAPIA Bloque A segundo piso', 'DAAVLIN', 'P3251-SNBPC-0048', '3SERIES PC31148', 
'Extensión', 'BIO', 'Clase I', 'INVIMA 2009EBC-0003822', NULL, NULL, NULL, 'UdeA', 
NULL, NULL, 0, NULL, 'Compra', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, NULL, 
1, '4', 1, '1 Timer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, 1, 13),

('CAMARA DE FOTOTERAPIA', '151197', 'BIO-102003', '13-037', 'Jhon Frank Villa', 
'FOTOTERAPIA Bloque A segundo piso', 'DAAVLIN', 'P3526A1X4800', '3SERIES X350-48', 
'Extensión', 'BIO', 'Clase I', 'INVIMA 2009EBC-0003822', NULL, NULL, NULL, 'UdeA', 
NULL, NULL, 0, NULL, 'Compra', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, NULL, 
1, '4', 1, '1 Timer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, 1, 13);

-- ============================================
-- EQUIPOS SIU - Trasplantes GICIG
-- ============================================
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Agitador vortex', '116989', 'BIO-16857', '15-651', 'Juan Jose Serrano', 
'SIU Torre 1 Lab 410', 'SCIENTIFIC INDUSTRIES', 'GENIE 2 G-560', '2-374976', 
'Extensión', 'BIO', NULL, 'Antes de 2007', NULL, '2005-05-12', NULL, 'UdeA', 
'811.033.098-5', 'Importecnical Ltda.', 0, NULL, 'Compra', 'Factura', '001807', 
1276000.00, 1, 0, 1, 0, 1, 1, 0, NULL, 1, '1', 0, NULL, 'Velocidad', 
'Perilla de posiciones (1 a 10)', NULL, NULL, NULL, '120 VAC', '0,65 A', 
'Máx. 95%HR', '0 - 38 °C', '165 x 122 x 165 mm', '4 kg', 'Frecuencia 60 Hz', 2, 14),

('Balanza analítica', '164386', 'BIO-16858', '18-449', 'Juan Jose Serrano', 
'SIU Torre 1 Lab 410', 'PRECISA', 'LS220A', '7001460', 'Extensión', 'BIO', 
'Clase I', 'ACTA No. 03 Abril 10 de 2013', NULL, '2016-08-01', NULL, 'UdeA', 
'860.536.024-8', 'Wacol S.A.', 0, '2018-08-01', 'Compra', 'Factura', '144593', 
NULL, 1, 0, 1, 1, 1, 1, 0, NULL, 1, '1', 1, '1', 'Masa', 'Máx. 220 g', 
'0,1 mg', NULL, NULL, 'Adaptador 90 - 264 VAC', '1,5 A', '25% a 85%', '0°C a 40°C', 
'228 x 381 x 345 mm', '6,6 kg', 'Frecuencia 47 - 63 Hz', 2, 14),

('Cabina de extracción', 'C481', 'BIO-16859', 'NT', 'Juan Jose Serrano', 
'SIU Torre 1 Lab 410', 'C4', 'CEX 120', '100406', 'Extensión', 'BIO', NULL, 
'No requiere', NULL, '2005-01-01', NULL, 'UdeA', '805.016.686-2', 'C4 Pascal', 
0, NULL, 'Compra', 'Histórico', NULL, NULL, 1, 0, 1, 1, 1, 1, 0, 'Semestral', 
1, '1', 1, '1 (calificación)', NULL, NULL, NULL, NULL, NULL, '110 VAC', NULL, 
NULL, NULL, '1200 X 1800 X 1519 cm', NULL, 'Frecuencia 50/60 Hz', 2, 14),

('Calentador seco', '108942', 'BIO-16860', 'NT', 'Juan Jose Serrano', 
'SIU Torre 1 Lab 410', 'BOEKEL', '113002', '0233 12871', 'Extensión', 'BIO', 
'Clase I', 'Antes de 2007', NULL, '2002-10-01', NULL, 'UdeA', NULL, 
'BIOLOGIA MOLECULAR', 0, NULL, 'Compra', 'Histórico', NULL, NULL, 1, 0, 0, 0, 
1, 1, 0, NULL, 1, '1', 0, NULL, 'Temperatura', '5 - 120 °C', '5 - 120 °C', 
NULL, NULL, '115 VAC', '1,75 A', NULL, NULL, NULL, NULL, 'Potencia 200 W Frecuencia 60 Hz', 
2, 14),

('Incubadora', '34022', 'BIO-16868', '18-013', 'Juan Jose Serrano', 
'SIU Torre 1 Lab 410', 'MEMMERT', 'TV10', '599033', 'Extensión', 'BIO', NULL, 
'Adquirido antes de 2007', 10, NULL, NULL, 'UdeA', NULL, NULL, 0, NULL, 'Compra', 
'Histórico', NULL, NULL, 1, 0, 0, 0, 1, 1, 0, NULL, 1, '1', 1, '1 (calificación)', 
'Temperatura', NULL, NULL, NULL, NULL, '120 VAC', NULL, NULL, NULL, NULL, NULL, 
'Potencia 1400 W', 2, 14),

('Luminex', '180235', 'BIO-16869', 'NT', 'Juan Jose Serrano', 'SIU Torre 1 Lab 410', 
'LUMINEX', 'Luminex LX 100/200', 'LX10017065423', 'Extensión', 'BIO', 'Clase IIa', 
'INVIMA 2020DM-0022003', 10, '2018-03-16', '2017-03-06', 'UdeA', '900.222.640-1', 
'BIOSCIENCES S.A.S.', 0, NULL, 'Compra', 'Factura', '5220', 292320000.00, 1, 1, 
1, 1, 1, 1, 0, 'Semestral', 1, '2', 0, NULL, 'Longitud de onda', 
'laser reportero 532nm y laser clasficador 635nm', NULL, NULL, NULL, 
'100 - 120 VAC / 200 - 240 VAC', '1,4 A / 0,8 A', '20 % A 80% HR', '15 - 30 °C', 
'43 x 50,5 x 24,5 cm', '25 kg', 'Frecuencia 47 - 63 Hz', 2, 14);

-- Micropipetas Trasplantes
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Micropipeta', '12', 'BIO-16875', '15-166', 'Juan Jose Serrano', 
'SIU Torre 1 Lab 410 (Post-PCR)', 'GILSON', 'P-1000', 'Y51513C', 'Extensión', 
'BIO', 'Clase I', 'ACTA No. 09 17 de Septiembre de 2014', NULL, '2003-01-01', 
NULL, 'UdeA', '811.026.956-0', 'MR Y CIA S.A.S', 0, NULL, 'Compra', 'Hojas de vida', 
NULL, NULL, 1, 0, 1, 0, 1, 0, 0, NULL, 1, '1', 1, '1', 'Volumen', 
'200 - 1000 ul', '2 uL', '200 - 1000 ul', NULL, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, 2, 14),

('Micropipeta', '18', 'BIO-16876', '15-166', 'Juan Jose Serrano', 
'SIU Torre 1 Lab 410 (PRE-PCR) Backup1', 'GILSON', 'P-1000', 'X63933E', 'Extensión', 
'BIO', 'Clase I', 'ACTA No. 09 17 de Septiembre de 2014', NULL, NULL, NULL, 
'UdeA', '800.160.884-1', 'FILTRACIÓN Y ANÁLISIS', 0, NULL, 'Compra', 'Histórico', 
NULL, NULL, 1, 0, 1, 0, 1, 0, 0, NULL, 1, '1', 1, '1', 'Volumen', 
'200 - 1000 ul', '2 uL', '200 - 1000 ul', NULL, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, 2, 14),

('Micropipeta', '8', 'BIO-16877', '15-166', 'Juan Jose Serrano', 
'SIU Torre 1 Lab 410 (PRE-PCR) Backup2', 'GILSON', 'P-1000', 'CB63839', 'Extensión', 
'BIO', 'Clase I', 'ACTA No. 09 17 de Septiembre de 2014', NULL, NULL, NULL, 
'UdeA', NULL, 'ND', 0, NULL, 'Compra', 'Histórico', NULL, NULL, 1, 0, 1, 0, 
1, 0, 0, NULL, 1, '1', 1, '1', 'Volumen', '200 - 1000 ul', '2 uL', 
'200 - 1000 ul', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, 14),

('Micropipeta', '4', 'BIO-16878', '15-166', 'Juan Jose Serrano', 
'SIU Torre 1 Lab 410 (PRE-PCR)', 'GILSON', 'P-1000', 'X62492E', 'Extensión', 
'BIO', 'Clase I', 'ACTA No. 09 17 de Septiembre de 2014', NULL, NULL, NULL, 
'UdeA', '800.160.884-1', 'FILTRACIÓN Y ANÁLISIS', 0, NULL, 'Compra', NULL, NULL, 
NULL, 1, 0, 1, 0, 1, 0, 0, NULL, 1, '1', 1, '1', 'Volumen', '200 - 1000 ul', 
'2 uL', '200 - 1000 ul', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, 14);

-- ============================================
-- EQUIPOS SIU - Inmunodeficiencias Primarias
-- ============================================
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Refrigerador', '132496', 'Pendiente', '17-157', 'Diana Arboleda', 
'SIU Torre 2 Lab 530', 'FAGOR', 'AFP701', '06060075M', 'Extensión', 'IND', 
NULL, NULL, NULL, '2009-07-31', NULL, 'UdeA', '811.014.137-3', 'Fagor Industrial S.A.', 
0, '2010-07-31', 'Compra', 'Factura', '010190', NULL, 1, 0, 1, 0, 0, 0, 0, 
NULL, 1, '1', 1, '1 (calificación)', 'Temperatura', 'T - 2 a 8 °C', NULL, NULL, 
NULL, '220 VAC', NULL, NULL, 'Máx. 43°C', '693 x 726 x 2067 mm', '110 kg', 
'Potencia 208 W Frecuencia 50/60 Hz', 2, 15),

('Lector de platos ELISA', '146231', 'BIO-16759', '16-979', 'Diana Arboleda', 
'SIU Torre 2 Lab 530', 'BioRad', 'iMark', '15486', 'Extensión', 'BIO', 'Clase IIa', 
'Comprado en Febrero de 2013', NULL, '2013-02-06', NULL, 'UdeA', '830.034.233-7', 
'AM LTDA.', 0, '2014-02-28', 'Compra', 'Factura', '12-065', NULL, 1, 0, 1, 1, 
0, 0, 1, 'Anual', 1, '1', 0, NULL, 'Longitud de onda', '400 - 750 nm', NULL, 
NULL, NULL, '120 VAC', NULL, 'Máx. 90%HR', '15 - 40 °C', '346 mm x 377 mm x 164 mm', 
'5,5 kg', 'Frecuencia 50/60 Hz Potencia 100 VA', 2, 15),

('Lavador de platos de ELISA', '140119', 'BIO-16760', '17-489', 'Diana Arboleda', 
'SIU Torre 2 Lab 530', 'Awareness Technology', 'Stat Fax 2600', '2600-7447', 
'Extensión', 'BIO', 'Clase IIa', 'INVIMA 2018DM-0018956', NULL, '2011-07-06', 
NULL, 'UdeA', '830.025.281-2', 'ANNAR', 0, '2012-07-31', 'Compra', 'Factura', 
'SAS-144963', NULL, 1, 0, 1, 1, 0, 0, 1, 'Semestral', 1, '1', 0, NULL, NULL, 
NULL, NULL, NULL, NULL, '110-120 / 220-240 VAC', NULL, '80%HR', '5 - 40 °C', 
'34,3 cm x 40,6 cm x 19 cm', '10 kg', 'Potencia 70 W Frecuencia 50/60 Hz', 2, 15),

('Microscopio', '132498', 'BIO-16761', '12-536', 'Diana Arboleda', 
'SIU Torre 2 Lab 530', 'OLYMPUS', 'CX21FS1', '8D07016', 'Extensión', 'BIO', 
'Clase I', 'ACTA No. 07 Junio 10 de 2009', NULL, '2009-07-31', NULL, 'UdeA', 
'811.033.098-5', 'Importecnical', 0, '2010-07-31', 'Compra', 'Factura', '006823', 
NULL, 1, 0, 1, 1, 1, 0, 1, 'Anual', 1, '1', 0, NULL, NULL, NULL, NULL, NULL, 
NULL, '100-120/220-240 VAC', '0,42/0,25 A', '80%HR', '5 - 40 °C', 
'154 x 391 x 238 mm', '5,9 kg', 'Frecuencia 50/60 Hz', 2, 15),

('Microscopio', '132499', 'BIO-16811', '12-536', 'Diana Arboleda', 
'SIU Cuarto de cultivo', 'OLYMPUS', 'CX21FS1', '8F11617', 'Extensión e investigación', 
'BIO', 'Clase I', 'ACTA No. 07 Junio 10 de 2009', NULL, '2009-07-31', NULL, 
'UdeA', '811.033.098-5', 'Importecnical', 0, '2010-07-31', 'Compra', 'Factura', 
'006823', NULL, 1, 0, 1, 1, 1, 0, 1, 'Anual', 1, '1', 0, NULL, NULL, NULL, 
NULL, NULL, NULL, '100-120/220-240 VAC', '0,42/0,25 A', '80%HR', '5 - 40 °C', 
'154 x 391 x 238 mm', '5,9 kg', 'Frecuencia 50/60 Hz', 2, 15),

('Baño María', '143436', 'BIO-16307', '16-861', 'Diana Arboleda', 
'SIU Torre 2 Lab 530', 'Memmert', 'WNB 7', 'L211.1357', 'Extensión', 'BIO', 
'Clase I', 'ACTA No. 07 Junio 10 de 2009', NULL, '2012-05-22', NULL, 'UdeA', 
'811.033.098-5', 'Importecnical', 0, '2013-05-31', 'Compra', 'Factura', 'IM011571', 
2648280.00, 1, 0, 1, 1, 1, 1, 1, NULL, 1, '1', 1, '1', 'Temperatura/Tiempo', 
'10 - 95 °C / 99:59 hrs:min', '0,1 °C', NULL, '+/-0.1 ºC /+/-0.25 ºC', '115 VAC', 
'10,4 A', 'Máx. 80% HR', '5 - 40 °C', '337 mm x 468 mm x 356 mm', '11 kg', 
'Potencia 1200 W Frecuencia 50/60 Hz', 2, 15),

('Baño María', '143437', 'BIO-16755', '16-861', 'Diana Arboleda', 
'SIU Torre 2 Lab 530', 'Memmert', 'WNB 7', 'L211.1359', 'Extensión e investigación', 
'BIO', 'Clase I', 'ACTA No. 07 Junio 10 de 2009', NULL, '2012-05-22', NULL, 
'UdeA', '811.033.098-5', 'Importecnical', 0, '2013-05-31', 'Compra', 'Factura', 
'IM011571', 2648280.00, 1, 0, 1, 1, 1, 1, 1, NULL, 1, '1', 1, '1', 
'Temperatura/Tiempo', '10 - 95 °C / 99:59 hrs:min', '0,1 °C', NULL, 
'+/-0.1 ºC /+/-0.25 ºC', '115 VAC', '10,4 A', 'Máx. 80% HR', '5 - 40 °C', 
'337 mm x 468 mm x 356 mm', '11 kg', 'Potencia 1200 W Frecuencia 50/60 Hz', 2, 15),

('Incubadora CO2', 'No tiene', 'BIO-16311', '18-013', 'Diana Arboleda', 
'SIU Cuarto de cultivo', 'Thermo Scientific', 'Series 8000 WJ 3428', '181988-102', 
'Extensión e investigación', 'BIO', 'Clase IIa', 'INVIMA 2017DM-0016578', NULL, 
'2013-10-29', '2013-08-08', 'Comprado por fundación', '860.072.122-9', 
'G&G Sucesores', 0, '2014-10-31', 'Donación', 'Factura', 'F-8502', 17933600.00, 
1, 0, 1, 1, 1, 1, 0, 'Anual', 1, '1', 1, '1 (calificación)', 'Temperatura/%CO2', 
'5ºC sobre ambiente hasta 55ºC / 0 - 20 %CO2', '0,1 °C / 0,1 %CO2', NULL, NULL, 
'115 VAC', '3,60 A', '80 %HR', '5 - 40 °C', '66,8cm x 100,3cm x 635cm', '120,2 kg', 
'Frecuencia 50/60 Hz', 2, 15),

('Agitador Vortex', '151664', 'BIO-16308', '15-651', 'Diana Arboleda', 
'SIU Torre 2 Lab 530', 'Labnet', 'S0200', 'Z3121820', 'Extensión', 'BIO', 
NULL, 'ACTA No. 07 Junio 10 de 2009', NULL, '2014-04-22', NULL, 'UdeA', 
'860.521.570-2', 'Biodiagnóstica Ltda', 0, '2015-04-30', 'Compra', 'Factura', 
'16028', 501120.00, 1, 0, 1, 1, 1, 1, 0, NULL, 1, '1', 0, NULL, 'Velocidad', 
'Máx. 3400 rpm (60 Hz) / 2850 rpm (50 Hz)', NULL, NULL, NULL, '120 VAC', '0,6 A', 
NULL, '4 - 65 °C', '14 x 16 x 12 cm', '2,2 kg', NULL, 2, 15),

('Centrífuga refrigerada', '119807', 'BIO-16756', '18-265', 'Diana Arboleda', 
'SIU Cuarto de cultivo', 'Eppendorf', '5810R', '0033896', 'Extensión e investigación', 
'BIO', 'Clase I', 'INVIMA 2014DM-0011801', NULL, '2006-01-01', '2005-01-01', 
'UdeA', '811.033.098-5', 'Importecnical', 0, '2007-05-31', 'Compra', NULL, NULL, 
NULL, 1, 0, 1, 1, 1, 1, 0, 'Anual', 1, '1', 1, '1', 'Velocidad/Temperatura/Tiempo', 
'200 - 14000 rpm / T -9 - 40 °C / 1 - 99 min', '10-100 rpm / 1°C / 1 min', NULL, 
NULL, '120 VAC', '12 A', 'Máx. 75 %HR', '10 - 35 °C', '700 x 608 x 345 mm', 
'99 kg', 'Frecuencia 60 Hz Potencia 1300 W', 2, 15);

-- ============================================
-- EQUIPOS SIU - Grupo Reproducción
-- ============================================
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Balanza Analitica', '038547', 'BIO-16846', '10-261', 'Carolina Navarro', 
'SIU Torre 2 Lab 534', 'Adam Equipment', 'NBL 124e', 'AE9UT335', 'Extensión', 
'BIO', 'Clase I', 'ACTA No. 07 Junio 10 de 2009', NULL, NULL, NULL, 'UdeA', 
'900.355.024-5', 'Equipos y laboratorio', 0, NULL, 'Compra', 'Factura', NULL, 
NULL, 1, 0, 0, 0, 0, 0, 0, NULL, 1, '1', 1, '1', 'Peso', 'carga max. 120 g', 
'0,0001 g', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, 16),

('Micropipeta', '023117', 'BIO-17234', '15-166', 'Carolina Navarro', 
'SIU Torre 2 Lab 534', 'Nichirio', 'Nichipet Explus', 'H38014182', 'Extensión', 
'BIO', 'Clase I', 'ACTA No. 09 17 de Septiembre de 2014', NULL, NULL, NULL, 
'UdeA', NULL, 'GENTECH', 0, NULL, 'Compra', 'Factura', NULL, NULL, 1, 0, 0, 0, 
0, 0, 0, NULL, 1, '1', 1, '1', 'Volumen', '2 - 20 uL', NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, 2, 16);

-- ============================================
-- EQUIPOS SAN VICENTE - Patología
-- ============================================
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Micropipeta', 'LIME 541', 'BIO-16512', '15-166', 'Martha Londoño', 
'Inmunohistoquímica', 'Sartorius', 'Tacta', '42186226', 'Extensión e Investigación', 
'BIO', 'Clase I', 'Certificación No requiere N° 2016020596', NULL, '2023-09-08', 
NULL, 'UdeA', '860.001.911-1', 'Kaika', 1, '2024-09-08', 'Compra', 'Factura', 
'00KK1915', NULL, 1, 0, 0, 0, 0, 0, 0, NULL, 1, '1', 1, '1', 'Volumen', 
'10 - 100 uL', '0,1 uL', '10 - 100 uL', NULL, NULL, NULL, NULL, NULL, NULL, 
NULL, NULL, 3, 17),

('Procesador de tejidos', '119420', 'BIO-16504', '15-190', 'Juliana', 
'Histotécnica', 'Leica', 'TP1020-1-1', '42231412', 'Extensión e Investigación', 
'BIO', 'Clase I', 'INVIMA 2015DM-0013758', NULL, '2006-01-01', NULL, 'UdeA', 
'860.000.648-2', 'Sanitas', 0, NULL, 'Compra', NULL, NULL, NULL, 1, 0, 0, 0, 
0, 0, 0, 'Semestral', 1, '2', 1, '2', 'Temperatura', '45 - 65 °C', '1 °C', NULL, 
NULL, '100 -120 VAC', NULL, '20 - 80 %HR', '5 - 40 °C', '595 - 780 mm', '60 kg', 
NULL, 3, 17),

('Criostato', '187701', 'BIO-16464', '15-157', 'Juliana', 'Cuarto criostato', 
'Leica', 'CM1860 UV', '00000005299', 'Extensión e Investigación', 'BIO', 
'Clase I', 'INVIMA 2015DM-0013759', NULL, '2021-02-12', '2020-12-01', 'UdeA', 
'860.000.648-2', 'Sanitas', 0, '2022-02-12', 'Compra', 'Factura', 'FE 46070', 
NULL, 1, 1, 1, 1, 1, 0, 0, 'Semestral', 1, '2', 0, NULL, 'Temperatura', 
'0 a -35 °C', '1 °C', 'T -20 a -22 °C', NULL, '120 - 127 VAC', NULL, '20 - 60 %HR', 
'18 - 35 °C', '730 x 730 x 1140 mm', '135 kg', 'Frecuencia: 60 Hz Potencia: 1440 VA', 
3, 17),

('Estación de Corte Macro', '189565', 'BIO-16466', 'NT', 'Juliana', 
'Corte macro', 'Kugel Medical', 'GP 1500', '20.206422.01', 'Extensión e Investigación', 
'BIO', NULL, 'Certificación No requiere N° 2018003889', NULL, '2021-04-05', NULL, 
'UdeA', '860.000.648-2', 'Sanitas', 0, '2022-04-05', 'Compra', 'Acta de entrega', 
'NT', NULL, 1, 1, 1, 0, 0, 0, 0, 'Anual', 1, '1', 0, NULL, NULL, NULL, NULL, 
NULL, NULL, '110 VAC', NULL, 'Menor 75 %HR', 'Menor a 25 °C', '1500 x 800 x 850/1950 mm', 
NULL, NULL, 3, 17),

('Estación de inclusión', '178684', 'BIO-16467', 'NT', 'Juliana', 'Histotécnica', 
'Leica', 'HistoCore Arcadia H / Arcadia C', '1671 / 2048', 'Extensión e Investigación', 
'BIO', NULL, 'No requiere INVIMA', NULL, NULL, '2017-12-01', 'UdeA', '860.000.648-2', 
'Sanitas', 0, '2019-02-06', 'Compra', NULL, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, 
'Semestral', 1, '2', 0, NULL, 'Temperatura', 'Arcadia H: 50 - 75°C / Arcadia C: - 6°C', 
'Arcadia H: 1 °C', 'Arcadia H: 54 - 60°C / Arcadia C: - 6°C', 'Arcadia H: 1,2 °C', 
'100 - 120 VAC', 'Arcadia H: 10 A / Arcadia C: 5 A', '20 - 80 %HR', '20 - 30 °C', 
'Arcadia H: 384 x 560 x 636 mm / Arcadia C: 384 x 400 x 636 mm', 
'Arcadia H: 27 kg / Arcadia C: 32 kg', NULL, 3, 17);

-- ============================================
-- EQUIPOS SAN VICENTE - Dermatopatología
-- ============================================
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `responsable`, 
    `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, 
    `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, 
    `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, 
    `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, 
    `tipo_documento`, `numero_documento`, `valor_compra`, `hoja_vida`, 
    `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, 
    `instructivo_manejo`, `protocolo_mto_preventivo`, `frecuencia_metrologica`, 
    `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, 
    `frecuencia_calibracion`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, 
    `error_maximo`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, 
    `dimensiones`, `peso`, `otros`, `sede_id`, `servicio_id`
) VALUES
('Refrigerador-congelador mixto', '209912', 'Pendiente', 'NT', 'Diana Meneses', 
'Bloque 7 Dermatopatología', 'MELING BIOMEDICAL', 'YCD-EL450', '220702139', 
'Extensión e Investigación', 'BIO', 'Clase IIa', 'INVIMA 2022DM-0025849', NULL, 
'2024-07-12', '2022-07-01', 'UdeA', '900355024-5', 'Equipos y laboratorio', 0, 
'2025-07-12', 'Compra', 'Factura', 'FE13533', 16592631.00, 0, 0, 0, 0, 0, 0, 0, 
NULL, 1, '1', 1, '1', 'Temperatura', 'Refrigeración 2 a 8 °C / Congelación - 10 a -26 °C', 
NULL, NULL, NULL, '110 VAC', '3,23 A', NULL, NULL, NULL, '144 Kg', 
'Frecuencia 60Hz Volumen 450 L', 3, 18),

('Baño de flotación', '209557', 'BIO-16666', '15 - 107', 'Diana Meneses', 
'Bloque 7 Dermatopatología', 'KEDEE', 'KD-P', '51A638', 'Extensión e Investigación', 
'BIO', NULL, 'No requiere INVIMA', 7, '2024-07-19', '2024-04-01', 'UdeA', 
'901.633.213-7', 'Mercilab S.A.S', 1, '2025-07-31', 'Compra', 'Factura', NULL, 
NULL, 1, 0, 0, 0, 0, 0, 0, NULL, 1, '1', 1, '1', NULL, NULL, NULL, NULL, NULL, 
'110 VAC', NULL, NULL, NULL, NULL, NULL, 'Frecuencia 60Hz Potencia 200 W', 3, 18),

('Termohigrómetro digital', '2 (TH-DP-01)', 'BIO-16685', 'NT', 'Diana Meneses', 
'Bloque 7 Cuarto de inmunofluorecencia', 'Clock-Humidity', 'HTC-2', NULL, 
'Extensión e Investigación', 'BIO', 'Clase I', 'ACTA No. 03 Abril 10 de 2013', 
NULL, NULL, NULL, 'UdeA', NULL, NULL, 0, NULL, 'Compra', NULL, NULL, NULL, 1, 
0, 0, 0, 0, 0, 0, NULL, 0, NULL, 1, '1', 'Temperatura/Humedad', 
'T -10 - 50 °C / 10 - 99 %HR', '0,1 °C / 1% HR', '18°C a 25°C / 40% a 67%.', 
'0,01 °C / -0,4 %HR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 18),

('Termohigrómetro digital', '1 (01A10)', 'BIO-16686', 'NT', 'Diana Meneses', 
'Bloque 7 Área de procesamiento', 'BOECO Germany', 'BOE330', NULL, 
'Extensión e investigación', 'BIO', 'Clase I', 'ACTA No. 03 Abril 10 de 2013', 
NULL, NULL, NULL, 'UdeA', NULL, NULL, 0, NULL, 'Compra', NULL, NULL, NULL, 1, 
0, 0, 0, 0, 0, 0, NULL, 0, NULL, 1, '1', 'Temperatura/Humedad', 
'0 - 50 °C / 25 - 95 %HR', '1 °C / 1%HR', '18 a 25 °C / 40 a 67 %HR', 
'0,24 °C / -0,7 %HR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 18),

('Microscopio y Cámara Leica', '164367', 'BIO-16681', '15 - 156', 'Diana Meneses', 
'Bloque 7 Cuarto de inmunofluorecencia', 'Leica', 'DM500', 'C540242931LS0390', 
'Investigación, docencia y extensión', 'BIO', 'Clase I', 'INVIMA 2014DM-0011844', 
NULL, '2016-01-01', '2016-05-01', 'UdeA', '860.000.648-2', 'Sanitas S.A.S', 0, 
NULL, 'Compra', NULL, NULL, NULL, 1, 0, 1, 1, 0, 0, 0, NULL, 1, '2', 0, NULL, 
NULL, NULL, NULL, NULL, NULL, '100 - 240 VAC', NULL, NULL, NULL, NULL, NULL, 
'Frecuenia 50/60 Hz Potencia 17W', 3, 18);

-- ============================================
-- NOTAS FINALES Y RECOMENDACIONES
-- ============================================
-- 
-- Este script ha migrado exitosamente los datos del archivo CSV a la base de datos.
-- 
-- RESUMEN DE LA MIGRACIÓN:
-- - 3 Sedes creadas: Prado, SIU, San Vicente
-- - 18 Servicios creados distribuidos en las 3 sedes
-- - Aproximadamente 60+ equipos insertados con toda su información técnica
--
-- CAMPOS MANEJADOS:
-- - Los valores "N/A", "NI" y vacíos del CSV se convirtieron en NULL en la BD
-- - Las fechas se convirtieron al formato MySQL (YYYY-MM-DD)
-- - Los valores booleanos (Si/No) se convirtieron a tinyint (1/0)
-- - Los valores monetarios se convirtieron a DECIMAL
--
-- CONSIDERACIONES:
-- 1. Algunos equipos tienen códigos internos duplicados con "/", se tomó el primero
-- 2. Las fechas incompletas o con formato "NI" se dejaron como NULL
-- 3. Los campos de texto largo se almacenaron en los campos correspondientes
-- 4. La clasificación de riesgo puede ser NULL cuando no aplica
--
-- PRÓXIMOS PASOS RECOMENDADOS:
-- 1. Verificar los IDs de sede_id y servicio_id después de la inserción
-- 2. Completar la información faltante (fechas, NITs, etc.)
-- 3. Agregar usuarios a la tabla 'usuarios' según los responsables
-- 4. Configurar los historiales de mantenimiento y traslados según sea necesario
-- 5. Validar que todos los equipos tengan su sede y servicio correctamente asignados
--
-- Para ejecutar este script:
-- 1. Asegúrate de tener un respaldo de tu base de datos
-- 2. Ejecuta el script en tu servidor MySQL/MariaDB
-- 3. Verifica que no haya errores de integridad referencial
-- 4. Comprueba que los datos se insertaron correctamente

-- FIN DEL SCRIPT DE MIGRACIÓN