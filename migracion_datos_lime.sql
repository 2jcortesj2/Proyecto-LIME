-- SCRIPT GENERADO AUTOMÁTICAMENTE: FUSIÓN MANUAL + EXCEL
-- Fecha: 2025-11-24 23:35:25.224395

USE `lime_db`;
SET FOREIGN_KEY_CHECKS = 0;

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

SET FOREIGN_KEY_CHECKS = 1;

-- 1. SEDES
INSERT INTO `sedes` (`id`, `nombre`, `direccion`, `ciudad`, `telefono`, `estado`) VALUES
(1, 'Prado', 'Hospital Alma Mater de Antioquia, Bloque B', 'Medellín', 'Por definir', 1),
(2, 'SIU', 'Torre 1 y Torre 2, Sede de Investigación Universitaria', 'Medellín', 'Por definir', 1),
(3, 'San Vicente', 'Hospital Universitario San Vicente Fundación', 'Medellín', 'Por definir', 1);

-- 2. SERVICIOS
INSERT INTO `servicios` (`id`, `nombre`, `descripcion`, `responsable`, `estado`, `sede_id`) VALUES
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
(14, 'Trasplantes GICIG', 'Grupo de Inmunología Celular e Inmunogenética', 'Juan José Serrano', 1, 2),
(15, 'Inmunodeficiencias Primarias', 'Laboratorio de Inmunodeficiencias Primarias', 'Diana Arboleda', 1, 2),
(16, 'Grupo Reproducción', 'Grupo de Reproducción', 'Carolina Navarro', 1, 2),
(17, 'Patología', 'Servicio de Patología', 'Martha Londoño', 1, 3),
(18, 'Dermatopatología', 'Laboratorio de Dermatopatología', 'Diana Meneses', 1, 3);

-- 3. RESPONSABLES
INSERT INTO `responsables_responsable` (`id`, `nombre_completo`, `email`, `telefono`, `rol`) VALUES
(1, 'Gloria Zapata', 'gloria.zapata@udea.edu.co', '555-0101', 'Coordinadora'),
(2, 'Vanessa Santiago', 'vanessa.santiago@udea.edu.co', '555-0102', 'Analista'),
(3, 'Duvan Gallego', 'duvan.gallego@udea.edu.co', '555-0103', 'Auxiliar'),
(4, 'Andrés Zuluaga', 'andres.zuluaga@udea.edu.co', '555-0104', 'Recepcionista'),
(5, 'Carlos Muñetón', 'carlos.muneton@udea.edu.co', '555-0105', 'Investigador'),
(6, 'Ivone Jimenez', 'ivone.jimenez@udea.edu.co', '555-0106', 'Investigadora'),
(7, 'Juan José Serrano', 'juan.serrano@udea.edu.co', '555-0107', 'Investigador');


-- ============================================
-- 4. EQUIPOS MANUALES (Alta Calidad)
-- ============================================

-- EQUIPO 1: Congelador (Ejemplo MultiSelect: Extensión, Docencia)
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES ('Congelador', '135306', 'Pendiente', '15 - 583', 'Procesamiento Seccion C', 'Challenger', 'CV430', '9053127', 'Extensión,Docencia', 'IND', NULL, NULL, NULL, 'Activo', 1, 1, 1);
SET @equipo_id = LAST_INSERT_ID();
INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`) VALUES (@equipo_id, '2009-12-10', NULL, 'UdeA', '890.934.939-8', 'Almacén Navarro Ospina S.A.', 0, NULL, 'Compra', 'Factura', '47736', NULL);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`) VALUES (@equipo_id, 1, 0, 1, 0, 0, 0, 'Semestral');
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, `frecuencia_calibracion`, `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`) VALUES (@equipo_id, 'Temperatura', 'T -18', NULL, '0 a - 33 ° C', NULL, 1, '1', 1, '1 (Calificación)', NULL, NULL, NULL, NULL);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, `dimensiones`, `peso`, `otros`) VALUES (@equipo_id, '115 VAC', NULL, NULL, 'Max 38°C', '53,5 x 53 x 142 cm', '55,5 kg', NULL);
INSERT INTO `historial_mantenimientos` (`equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`, `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`) VALUES (@equipo_id, 'correctivo', 2, 2024, 'Reparación de compresor por ruido excesivo.', 'Técnico UdeA', 120000.00, 'Gloria Zapata', 'Se recomienda monitoreo', NOW());

-- EQUIPO 2: Agregometro (Ejemplo MultiSelect: Apoyo, Investigación)
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES ('Agregometro', '119325', 'BIO-12183', 'NT', 'Procesamiento Seccion A', 'Helena Laboratories', 'AGGRAM', '630604801', 'Apoyo,Investigación', 'BIO', 'IIa', 'INVIMA 2019DM-0019614', NULL, 'Activo', 1, 2, 1);
SET @equipo_id = LAST_INSERT_ID();
INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`) VALUES (@equipo_id, '2006-03-30', NULL, 'UdeA', '830.064.712-1', 'Helena Laboratories INC. / Labtronics S.A.S', 0, NULL, 'Compra', 'Factura', '96442', NULL);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`) VALUES (@equipo_id, 1, 1, 1, 0, 1, 1, NULL);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, `frecuencia_calibracion`, `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`) VALUES (@equipo_id, 'Absorbancia', '0 - 2 DE', NULL, '0 - 2 DE', NULL, 1, '1', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, `dimensiones`, `peso`, `otros`) VALUES (@equipo_id, '110 VAC', NULL, NULL, '15 - 30 °C', '15,24 cm x 25,40 cm x 43,18 cm', '6,75 Kg', 'Frecuencia 50/60 Hz');
INSERT INTO `historial_mantenimientos` (`equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`, `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`) VALUES (@equipo_id, 'calibracion', 12, 2024, 'Calibración de canales de lectura', 'Biocare Médica Ltda.', 420000.00, 'Admin LIME', 'Calibración vencida', '2024-12-01 14:30:00');

-- EQUIPO 3: Centrífuga refrigerada
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES ('Centrífuga refrigerada', '130937', 'BIO-12186', '10 - 780', 'Área centrífugas', 'BOECO - HETTICH', 'U-320R', '0000189', 'Extensión', 'BIO', 'IIa', 'INVIMA 2014DM-0011507', NULL, 'Activo', 1, 2, 1);
SET @equipo_id = LAST_INSERT_ID();
INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`) VALUES (@equipo_id, '2008-12-02', '2008-01-01', 'UdeA', '811.033.098-5', 'Importecnical Ltda.', 0, NULL, 'Compra', 'Factura', '006093', NULL);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`) VALUES (@equipo_id, 1, 0, 0, 0, 1, 1, NULL);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, `frecuencia_calibracion`, `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`) VALUES (@equipo_id, 'vacio', 'Max. 15000 rpm / T -20 a 40°C', '10 rpm / 1°C', '1000 - 4500 rpm', NULL, 1, '2', 1, '2', NULL, NULL, NULL, NULL);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, `dimensiones`, `peso`, `otros`) VALUES (@equipo_id, '200 - 240 V', '4 A', NULL, NULL, '346 x 401 x 695 mm', '53 kg', NULL);
INSERT INTO `historial_mantenimientos` (`equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`, `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`) VALUES (@equipo_id, 'preventivo', 2, 2025, 'Lubricación de componentes mecánicos', 'Tecno Lab SAS', 550000.00, 'Admin LIME', 'Próximo a vencer', '2024-11-20 09:15:00');

-- EQUIPO 4: Analizador de coagulación
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES ('Analizador de coagulación automatizado', 'LIME 378', 'BIO-16281', '15 - 098', 'Procesamiento Seccion A', 'SYSMEX', 'CS2500', '25407', 'Extensión', 'BIO', 'IIa', 'INVIMA 2016DM-0015107', NULL, 'Activo', 1, 2, 4);
SET @equipo_id = LAST_INSERT_ID();
INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`) VALUES (@equipo_id, '2021-07-16', NULL, 'UT LIME', '900.931.305-0', 'SIEMENS', 0, '2022-07-15', 'Compra', 'Factura', 'TE57569', NULL);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`) VALUES (@equipo_id, 1, 1, 1, 1, 1, 1, 'Semestral');
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, `frecuencia_calibracion`, `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`) VALUES (@equipo_id, NULL, NULL, NULL, NULL, NULL, 1, '2', 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, `dimensiones`, `peso`, `otros`) VALUES (@equipo_id, '100 - 240 VAC', NULL, '30 - 85 %HR', '15 - 30 °C', '775 x 895 x 685 mm', '110 kg', NULL);
INSERT INTO `historial_mantenimientos` (`equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`, `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`) VALUES (@equipo_id, 'preventivo', 12, 2025, 'Mantenimiento preventivo completo', 'SYSMEX Colombia', 1200000.00, 'Admin LIME', 'Programado', '2024-11-15 16:20:00');

-- EQUIPO 5: Micropipeta
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES ('Micropipeta', '160517', 'BIO-12193', '15 - 166', 'Procesamiento Seccion A', 'Thermo Scientific', 'Finnpipette F1', 'MH12168', 'Extensión', 'BIO', 'I', 'ACTA No. 09 Septiembre 17 de 2014', NULL, 'Activo', 1, 2, 1);
SET @equipo_id = LAST_INSERT_ID();
INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`) VALUES (@equipo_id, '2016-01-19', NULL, 'UdeA', '900.355.024-5', 'Equipos y Laboratorio', 0, NULL, 'Compra', 'Factura', 'C7206', NULL);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`) VALUES (@equipo_id, 1, 0, 1, 1, 1, 0, 'Trimestral');
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, `frecuencia_calibracion`, `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`) VALUES (@equipo_id, 'Volumen', '100 - 1000 uL', '1 uL', '100 - 1000 ul', NULL, 1, '1', 1, '1', NULL, NULL, NULL, NULL);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, `dimensiones`, `peso`, `otros`) VALUES (@equipo_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `historial_mantenimientos` (`equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`, `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`) VALUES (@equipo_id, 'calibracion', 1, 2025, 'Calibración volumétrica', 'Metrología UdeA', 180000.00, 'Admin LIME', 'Programado', '2024-11-18 11:45:00');

-- EQUIPO 6: Microscopio (Ejemplo MultiSelect: Docencia, Investigación)
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES ('Microscopio', '132498', 'BIO-16761', '12-536', 'SIU Torre 2 Lab 530', 'OLYMPUS', 'CX21FS1', '8D07016', 'Docencia,Investigación', 'BIO', 'I', 'ACTA No. 07 Junio 10 de 2009', NULL, 'Activo', 2, 15, 7);
SET @equipo_id = LAST_INSERT_ID();
INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`) VALUES (@equipo_id, '2009-07-31', NULL, 'UdeA', '811.033.098-5', 'Importecnical', 0, '2010-07-31', 'Compra', 'Factura', '006823', NULL);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`) VALUES (@equipo_id, 1, 0, 1, 1, 1, 0, 'Anual');
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, `frecuencia_calibracion`, `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`) VALUES (@equipo_id, NULL, NULL, NULL, NULL, NULL, 1, '1', 0, NULL, '2024-01-15', '2025-01-15', NULL, NULL);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, `dimensiones`, `peso`, `otros`) VALUES (@equipo_id, '100-120/220-240 VAC', '0,42/0,25 A', '80%HR', '5 - 40 °C', '154 x 391 x 238 mm', '5,9 kg', 'Frecuencia 50/60 Hz');
INSERT INTO `historial_mantenimientos` (`equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`, `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`) VALUES (@equipo_id, 'preventivo', 11, 2024, 'Limpieza de lentes', 'Olympus Service', 380000.00, 'Admin LIME', 'Completado', '2024-11-10 13:00:00');

-- EQUIPO 7: Cabina de extracción
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES ('Cabina de extracción', 'C481', 'BIO-16859', 'NT', 'SIU Torre 1 Lab 410', 'C4', 'CEX 120', '100406', 'Extensión', 'BIO', NULL, 'No requiere', NULL, 'En Mantenimiento', 2, 14, 7);
SET @equipo_id = LAST_INSERT_ID();
INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`) VALUES (@equipo_id, '2005-01-01', NULL, 'UdeA', '805.016.686-2', 'C4 Pascal', 0, NULL, 'Compra', 'Histórico', NULL, NULL);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`) VALUES (@equipo_id, 1, 0, 1, 1, 1, 1, 'Semestral');
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, `frecuencia_calibracion`, `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`) VALUES (@equipo_id, NULL, NULL, NULL, NULL, NULL, 1, '1', 1, '1 (calificación)', '2024-06-10', '2024-12-10', '2024-06-10', '2024-12-10');
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, `dimensiones`, `peso`, `otros`) VALUES (@equipo_id, '110 VAC', NULL, NULL, NULL, '1200 X 1800 X 1519 cm', NULL, 'Frecuencia 50/60 Hz');
INSERT INTO `historial_mantenimientos` (`equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`, `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`) VALUES (@equipo_id, 'preventivo', 6, 2024, 'Limpieza general', 'Ing. Externo - C4 Pascal', 450000.00, 'Juan Jose Serrano', 'Equipo operativo', NOW());

-- EQUIPO 8: Balanza analítica
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES ('Balanza analítica', '135401', 'LAB-20145', '18-442', 'Prado Torre 1 Lab 210', 'OHAUS', 'PA214', 'B512345678', 'Extensión', 'LAB', 'I', '2018DM-0009876', NULL, 'Activo', 1, 1, 1);
SET @equipo_id = LAST_INSERT_ID();
INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`) VALUES (@equipo_id, '2024-12-10', NULL, 'UdeA', '890.123.456-7', 'Lab Equipment SAS', 0, '2025-12-10', 'Compra', 'Factura', 'F-2023-456', 4500000.00);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`) VALUES (@equipo_id, 1, 1, 1, 1, 0, 1, 'Anual');
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, `frecuencia_calibracion`, `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`) VALUES (@equipo_id, 'Masa', '0-210 g', '0.0001 g', '0-200 g', '±0.0002 g', 1, 'Anual', 1, 'Anual', NULL, '2025-12-10', NULL, '2025-12-10');
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, `dimensiones`, `peso`, `otros`) VALUES (@equipo_id, '110-240 VAC', '0.15 A', '80%HR', '10 - 30 °C', '230 x 350 x 340 mm', '4.5 kg', 'Frecuencia 50/60 Hz');

-- EQUIPO 9: Espectrofotómetro
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES ('Espectrofotómetro', '132501', 'LAB-20789', '18-555', 'SIU Torre 2 Lab 520', 'Thermo Scientific', 'Genesys 30', 'GN30-2023-789', 'Extensión', 'LAB', 'IIa', '2019DM-0011234', NULL, 'Activo', 2, 14, 6);
SET @equipo_id = LAST_INSERT_ID();
INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`, `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`, `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`) VALUES (@equipo_id, '2025-01-15', NULL, 'UdeA', '890.234.567-8', 'Scientific Solutions', 0, '2026-01-15', 'Compra', 'Factura', 'F-2023-789', 12000000.00);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`, `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`) VALUES (@equipo_id, 1, 1, 1, 1, 1, 1, 'Anual');
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`, `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`, `frecuencia_calibracion`, `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`) VALUES (@equipo_id, 'Absorbancia', '190-1100 nm', '0.001 Abs', '200-900 nm', '±0.005 Abs', 1, 'Anual', 1, 'Anual', NULL, '2026-01-15', NULL, '2026-01-15');
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`, `dimensiones`, `peso`, `otros`) VALUES (@equipo_id, '100-240 VAC', '1.5 A', '80%HR', '15 - 35 °C', '440 x 510 x 200 mm', '11 kg', 'Frecuencia 50/60 Hz');

-- ============================================
-- 5. EQUIPOS IMPORTADOS DESDE EXCEL (Enriquecidos)
-- ============================================
-- Excel Equipo 6: Micropipeta 
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', 160516, 'BIO-12194', '15 - 166', 'Procesamiento Seccion A', 'Thermo Scientific', 'Finnpipette F1', 'MH12173', 'Extensión', 'BIO', 'I', 'ACTA No. 09 Septiembre 17 de 2014', 'NI', 'Activo', 1, 2, 3
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Trimestral', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 8, 2025,
    'Certificación de calibración anual.', 'Proveedor Externo', 1173053, 'Sistema', 'Requiere repuestos', '2025-08-20 14:15:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 9, 2025,
    'Certificación de calibración anual.', 'Servicio Especializado', 1838455, 'Sistema', 'Pendiente de revisión', '2025-09-02 12:15:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 4, 2025,
    'Ajuste de parámetros de medición.', 'Mantenimiento Interno', 307810, 'Sistema', 'Realizado con éxito', '2025-04-23 14:30:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-05-23 13:15:00', 2, 1,
    5, 4, 'Consolidación de equipos en nueva ubicación', 'Admin LIME', '2024-05-23 13:15:00'
);

-- Excel Equipo 7: Micropipeta 
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', 160515, 'BIO-12198', '15 - 166', 'Procesamiento Seccion A', 'Thermo Scientific', 'Finnpipette F1', 'MH12148', 'Extensión', 'BIO', 'I', 'ACTA No. 09 Septiembre 17 de 2014', 'NI', 'Activo', 1, 2, 2
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Semestral', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 6, 2024,
    'Reemplazo de componente defectuoso.', 'Servicio Especializado', 385186, 'Sistema', 'Requiere repuestos', '2024-06-25 09:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 10, 2025,
    'Revisión de sistemas mecánicos y eléctricos.', 'Técnico UdeA', 871002, 'Sistema', 'Equipo operativo', '2025-10-02 09:45:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 2, 2025,
    'Revisión de sistemas mecánicos y eléctricos.', 'Servicio Especializado', 752055, 'Sistema', 'Equipo operativo', '2025-02-20 17:45:00'
);

-- Excel Equipo 8: Agitador Vórtex
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Agitador Vórtex', 150955, 'BIO-12129', '15 - 651', 'Procesamiento Seccion A', 'Boeco', 'Vortex V1 Plus', '1020313061616', 'Extensión', 'BIO', NULL, 'ACTA No. 07 Junio 10 de 2009 indica que no requiere registro sanitario, y se rectifica en ACTA No. 03 Abril 10 de 2013', 'NI', 'Activo', 1, 3, 4
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Anual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 5, 2024,
    'Certificación de calibración anual.', 'Técnico UdeA', 496660, 'Sistema', 'Requiere repuestos', '2024-05-20 12:00:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 3, 2025,
    'Reemplazo de componente defectuoso.', 'Técnico UdeA', 1080765, 'Sistema', 'Requiere repuestos', '2025-03-10 13:00:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-11-13 11:00:00', 1, 3,
    11, 14, 'Reubicación por reorganización de espacios', 'Coordinador Técnico', '2023-11-13 11:00:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-02-11 10:15:00', 2, 3,
    3, 10, 'Consolidación de equipos en nueva ubicación', 'Admin LIME', '2024-02-11 10:15:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-03-09 10:15:00', 2, 3,
    16, 13, 'Cambio de servicio por necesidades operativas', 'Admin LIME', '2025-03-09 10:15:00'
);

-- Excel Equipo 9: Baño María
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Baño María', 150712, 'BIO-12130', '16 - 861', 'Procesamiento Seccion B', 'Indulab', '09-A', '13834', 'Extensión', 'BIO', 'I', 'ACTA No. 07 Junio 10 de 2009 indica que no requiere registro sanitario, y se rectifica en ACTA No. 03 Abril 10 de 2013', 'NI', 'Activo', 1, 3, 5
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Anual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 3, 2025,
    'Verificación de exactitud y precisión.', 'Mantenimiento Interno', 1023851, 'Sistema', 'Pendiente de revisión', '2025-03-10 13:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 5, 2024,
    'Revisión de sistemas mecánicos y eléctricos.', 'Técnico UdeA', 258989, 'Sistema', 'Realizado con éxito', '2024-05-15 11:45:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-09-13 09:15:00', 3, 2,
    10, 2, 'Préstamo temporal a otro servicio', 'Responsable de Equipos', '2024-09-13 09:15:00'
);

-- Excel Equipo 10: Centrífuga
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Centrífuga', 151362, 'BIO-12131', '10 - 778', 'Área centrífugas', 'Hettich', 'Rotofix 32A', '006965-04', 'Extensión', 'BIO', 'I', 'INVIMA 2013DM-0010231', 'NI', 'Activo', 1, 3, 7
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Anual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 5, 2025,
    'Ajuste de parámetros de medición.', 'Mantenimiento Interno', 624357, 'Sistema', 'Pendiente de revisión', '2025-05-23 17:00:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 4, 2025,
    'Solución de problema reportado por usuario.', 'Mantenimiento Interno', 151790, 'Sistema', 'Calibración OK', '2025-04-02 15:15:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-02-20 12:30:00', 3, 2,
    5, 13, 'Optimización de recursos entre sedes', 'Admin LIME', '2025-02-20 12:30:00'
);

-- Excel Equipo 11: Microcentrifuga refrigerada
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Microcentrifuga refrigerada', 'LIME 360', 'BIO-16289', '17 - 452', 'Área centrífugas', 'HERMLE', 'Z 216 MK', '61165050', 'Extensión', 'BIO', 'I', 'INVIMA 2015DM-0013425', 'NI', 'Activo', 1, 1, 5
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Trimestral', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 1, 2025,
    'Limpieza general y verificación de componentes.', 'Servicio Especializado', 1567210, 'Sistema', 'Equipo operativo', '2025-01-25 10:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 2, 2024,
    'Certificación de calibración anual.', 'Técnico UdeA', 886545, 'Sistema', 'Realizado con éxito', '2024-02-20 11:45:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-09-04 12:15:00', 3, 2,
    1, 7, 'Traslado temporal para mantenimiento', 'Coordinador Técnico', '2023-09-04 12:15:00'
);

-- Excel Equipo 12: Congelador
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Congelador', 'LIME 642', 'Pendiente', '15 - 583', 'Hospital Alma Mater de antioquia, sede ambulatoria Prado, Bloque B, segundo piso, Almacen', 'Infrico', 'LTF40SD', '3000957831', 'Extensión', 'BIO', 'IIa', 'INVIMA 2023DM-0026731', 'NI', 'Activo', 1, 1, 2
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Trimestral', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 3, 2025,
    'Calibración y ajuste de parámetros operativos.', 'Proveedor Externo', 699958, 'Sistema', 'Calibración OK', '2025-03-17 15:45:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 9, 2024,
    'Revisión de sistemas mecánicos y eléctricos.', 'Técnico UdeA', 683203, 'Sistema', 'Calibración OK', '2024-09-07 09:00:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-04-21 16:15:00', 2, 3,
    11, 1, 'Reubicación por reorganización de espacios', 'Admin LIME', '2024-04-21 16:15:00'
);

-- Excel Equipo 13: Fonendoscopio
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Fonendoscopio', 'LIME 121', 'BIO-16800', '13 - 750', 'Recepcion', 'GMD', 'GMD30-DCK', 'IMP-1163', 'Extensión', 'BIO', 'I', 'INVIMA 2015DM-0014070', 'NI', 'Activo', 1, 5, 2
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Mensual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 1, 2024,
    'Ajuste de parámetros de medición.', 'Mantenimiento Interno', 1609746, 'Sistema', 'Pendiente de revisión', '2024-01-06 14:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 5, 2024,
    'Limpieza general y verificación de componentes.', 'Proveedor Externo', 655629, 'Sistema', 'Realizado con éxito', '2024-05-11 17:15:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 2, 2024,
    'Limpieza general y verificación de componentes.', 'Técnico UdeA', 1095824, 'Sistema', 'Calibración OK', '2024-02-28 13:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 3, 2025,
    'Reemplazo de componente defectuoso.', 'Proveedor Externo', 1407746, 'Sistema', 'Realizado con éxito', '2025-03-26 16:00:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-05-14 12:00:00', 3, 2,
    14, 7, 'Traslado temporal para mantenimiento', 'Admin LIME', '2025-05-14 12:00:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-07-14 14:00:00', 3, 1,
    2, 11, 'Optimización de recursos entre sedes', 'Coordinador Técnico', '2024-07-14 14:00:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-11-18 17:45:00', 3, 2,
    1, 14, 'Optimización de recursos entre sedes', 'Jefe de Servicio', '2023-11-18 17:45:00'
);

-- Excel Equipo 14: Centrífuga refrigerada
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Centrífuga refrigerada', 117104, 'BIO-12250', '18 - 270', 'Biologia Molecular (Extraccion)', 'Sigma', '3-16K', '110639', 'Extensión', 'BIO', 'I', 'INVIMA 2015DM-0012550', 'NI', 'Activo', 1, 6, 7
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 0, 'Anual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

-- Excel Equipo 15: Balanza Analítica
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Balanza Analítica', 189604, 'BIO-16749', '18 - 449', 'BSL3 (Procesamiento)', 'ViBRA', 'HT224CEN', '215022050', 'Extensión e Investigación', 'BIO', 'I', 'ACTA No. 07 Junio 10 de 2009', 'NI', 'Activo', 1, 7, 4
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 0, 'Anual', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-09-01 10:30:00', 1, 2,
    14, 16, 'Traslado temporal para mantenimiento', 'Responsable de Equipos', '2024-09-01 10:30:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-04-11 10:30:00', 1, 3,
    8, 3, 'Préstamo temporal a otro servicio', 'Responsable de Equipos', '2023-04-11 10:30:00'
);

-- Excel Equipo 16: Incubadora
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Incubadora', 134788, 'BIO-12256', '18 - 013', 'Citogenomica (Preanalitica)', 'Binder', 'BD53-UL', '908707', 'Extensión', 'BIO', NULL, 'Certificación de No Requiere 2014010943', 'NI', 'Activo', 1, 8, 4
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Mensual', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 11, 2025,
    'Verificación de exactitud y precisión.', 'Mantenimiento Interno', 2090547, 'Sistema', 'Realizado con éxito', '2025-11-25 13:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 5, 2024,
    'Revisión de sistemas mecánicos y eléctricos.', 'Proveedor Externo', 1464362, 'Sistema', 'Calibración OK', '2024-05-04 13:15:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 6, 2025,
    'Solución de problema reportado por usuario.', 'Mantenimiento Interno', 990844, 'Sistema', 'Realizado con éxito', '2025-06-18 14:00:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-10-25 16:00:00', 1, 2,
    12, 17, 'Préstamo temporal a otro servicio', 'Jefe de Servicio', '2023-10-25 16:00:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-04-07 13:00:00', 2, 3,
    17, 9, 'Consolidación de equipos en nueva ubicación', 'Responsable de Equipos', '2023-04-07 13:00:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-05-17 12:00:00', 1, 2,
    17, 9, 'Consolidación de equipos en nueva ubicación', 'Coordinador Técnico', '2024-05-17 12:00:00'
);

-- Excel Equipo 17: Filmarray
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Filmarray', 187250, 'BIO-16698', 'NI', 'Microbiología 1', 'BIOFIRE', 'FilmArray Torch (ref: HTFA-ASY-0104)', 'TB03545', 'Extensión', 'BIO', 'IIa', 'INVIMA 2014DM-0011912', 'NI', 'Activo', 1, 9, 1
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Trimestral', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 7, 2025,
    'Corrección de desviación en parámetros.', 'Técnico UdeA', 1249279, 'Sistema', 'Realizado con éxito', '2025-07-03 10:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 7, 2024,
    'Limpieza general y verificación de componentes.', 'Mantenimiento Interno', 840515, 'Sistema', 'Requiere repuestos', '2024-07-16 17:00:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 7, 2024,
    'Calibración y ajuste de parámetros operativos.', 'Proveedor Externo', 1933780, 'Sistema', 'Calibración OK', '2024-07-14 15:00:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 2, 2024,
    'Reemplazo de componente defectuoso.', 'Mantenimiento Interno', 238030, 'Sistema', 'Requiere repuestos', '2024-02-26 08:00:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-01-19 09:30:00', 1, 2,
    6, 2, 'Cambio de servicio por necesidades operativas', 'Responsable de Equipos', '2025-01-19 09:30:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-08-02 17:15:00', 2, 3,
    7, 15, 'Traslado temporal para mantenimiento', 'Admin LIME', '2023-08-02 17:15:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-02-22 12:45:00', 1, 3,
    10, 1, 'Traslado temporal para mantenimiento', 'Admin LIME', '2023-02-22 12:45:00'
);

-- Excel Equipo 18: Maglumi
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Maglumi', 'A-LIME-003', 'BIO-16303', 'NI', 'Procesamiento Seccion B', 'SNIBE', 'MAGLUMI 600', '0101010003022000165', 'Extensión', 'BIO', 'IIa', 'INVIMA 2012DM-0009229', 'NI', 'Activo', 1, 10, 3
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 0, 'Trimestral', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

-- Excel Equipo 19: Micropipeta
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', 'LIME 001', 'BIO-12177', '15 - 166', 'Procesamiento Seccion C', 'Corning', 'Lambda Plus', '658220168', 'Extensión', 'BIO', 'I', 'ACTA No. 09 Septiembre 17 de 2014', 'NI', 'Activo', 1, 11, 7
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 0, 'Mensual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-10-27 09:00:00', 2, 3,
    12, 4, 'Optimización de recursos entre sedes', 'Admin LIME', '2023-10-27 09:00:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-06-28 10:00:00', 3, 1,
    7, 8, 'Traslado temporal para mantenimiento', 'Jefe de Servicio', '2025-06-28 10:00:00'
);

-- Excel Equipo 20: Resonador magnetico
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Resonador magnetico', 207255, 'BIO-15348', 'NT', 'Hospital Alma Mater de Antioquia, Bloque B, primer piso, Centro de resonancia', 'PHILIPS', 'INGENIA ELITION X', '45555', 'Extensión e Investigación', 'BIO', 'IIa', 'INVIMA 2018EBC-0017485', '10 años', 'Activo', 1, 12, 7
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Semestral', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 9, 2024,
    'Calibración y ajuste de parámetros operativos.', 'Mantenimiento Interno', 1937063, 'Sistema', 'Requiere repuestos', '2024-09-22 13:15:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-09-19 16:30:00', 2, 1,
    14, 2, 'Cambio de servicio por necesidades operativas', 'Coordinador Técnico', '2025-09-19 16:30:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-01-18 15:45:00', 1, 2,
    11, 8, 'Traslado temporal para mantenimiento', 'Jefe de Servicio', '2024-01-18 15:45:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-12-17 09:00:00', 3, 1,
    13, 7, 'Traslado temporal para mantenimiento', 'Coordinador Técnico', '2023-12-17 09:00:00'
);

-- Excel Equipo 21: CAMARA DE FOTOTERAPIA
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'CAMARA DE FOTOTERAPIA', 128568, 'BIO-100561', '13-037', 'Hospital Alma Mater de Antioquia, Bloque A, segundo piso, FOTOTERAPIA', 'DAAVLIN', 'P3251-SNBPC-0048', '3SERIES PC31148', 'Extensión', 'BIO', 'I', 'INVIMA 2009EBC-0003822', 'NI', 'Activo', 1, 13, 7
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 0, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Semestral', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 10, 2025,
    'Corrección de desviación en parámetros.', 'Mantenimiento Interno', 1644809, 'Sistema', 'Pendiente de revisión', '2025-10-08 12:45:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 5, 2024,
    'Limpieza general y verificación de componentes.', 'Técnico UdeA', 1833587, 'Sistema', 'Realizado con éxito', '2024-05-17 09:30:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-11-15 14:30:00', 2, 3,
    7, 9, 'Reubicación por reorganización de espacios', 'Jefe de Servicio', '2023-11-15 14:30:00'
);

-- Excel Equipo 22: CAMARA DE FOTOTERAPIA
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'CAMARA DE FOTOTERAPIA', 151197, 'BIO-102003', '13-037', 'Hospital Alma Mater de Antioquia, Bloque A, segundo piso, FOTOTERAPIA', 'DAAVLIN', 'P3526A1X4800', '3SERIES X350-48', 'Extensión', 'BIO', 'I', 'INVIMA 2009EBC-0003822', 'NI', 'Activo', 1, 13, 4
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 0, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 0, 'Trimestral', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

-- Excel Equipo 23: Agitador vortex
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Agitador vortex', '116989 / 008819', 'BIO-16857', '15-651', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'SCIENTIFIC INDUSTRIES /GENIE 2', 'G-560', '2-374976', 'Extensión', 'BIO', NULL, 'Antes de 2007', 'NI', 'Activo', 2, 14, 4
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Semestral', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 12, 2024,
    'Solución de problema reportado por usuario.', 'Proveedor Externo', 623587, 'Sistema', 'Requiere repuestos', '2024-12-10 13:00:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 3, 2024,
    'Reparación de falla detectada durante operación.', 'Mantenimiento Interno', 1443896, 'Sistema', 'Requiere repuestos', '2024-03-10 13:30:00'
);

-- Excel Equipo 24: Balanza analítica
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Balanza analítica', 164386, 'BIO-16858', '18-449', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'PRECISA', 'LS220A', '7001460', 'Extensión', 'BIO', 'I', 'ACTA No. 03 Abril 10 de 2013', 'NI', 'Activo', 2, 14, 5
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Anual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 4, 2024,
    'Solución de problema reportado por usuario.', 'Servicio Especializado', 1722991, 'Sistema', 'Pendiente de revisión', '2024-04-09 17:30:00'
);

-- Excel Equipo 26: Calentador seco
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Calentador seco', '108942 / 008843', 'BIO-16860', 'NT', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'BOEKEL', 113002, '0233 12871', 'Extensión', 'BIO', 'I', 'Antes de 2007', 'NI', 'Activo', 2, 14, 3
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 0, 'Trimestral', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-04-28 15:30:00', 2, 1,
    2, 3, 'Cambio de servicio por necesidades operativas', 'Jefe de Servicio', '2023-04-28 15:30:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-01-27 14:15:00', 1, 2,
    7, 14, 'Traslado temporal para mantenimiento', 'Responsable de Equipos', '2023-01-27 14:15:00'
);

-- Excel Equipo 27: Incubadora
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Incubadora', '34022 / 008808', 'BIO-16868', '18-013', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'MEMMERT', 'TV10', '599033', 'Extensión', 'BIO', NULL, 'Adquirido antes de 2007', '10 años', 'Activo', 2, 14, 7
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 0, 'Semestral', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-03-19 17:00:00', 1, 2,
    9, 5, 'Reubicación por reorganización de espacios', 'Jefe de Servicio', '2025-03-19 17:00:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-09-10 10:30:00', 2, 3,
    9, 12, 'Optimización de recursos entre sedes', 'Jefe de Servicio', '2024-09-10 10:30:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-10-27 17:45:00', 1, 2,
    11, 4, 'Reubicación por reorganización de espacios', 'Admin LIME', '2024-10-27 17:45:00'
);

-- Excel Equipo 28: Luminex
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Luminex', '180235 / 008811', 'BIO-16869', 'NT', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'LUMINEX', 'Luminex LX 100/ 200', 'LX10017065423', 'Extensión', 'BIO', 'IIa', 'INVIMA 2020DM-0022003', '10 años', 'Activo', 2, 14, 4
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Anual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 8, 2025,
    'Verificación de exactitud y precisión.', 'Proveedor Externo', 2294974, 'Sistema', 'Pendiente de revisión', '2025-08-18 12:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 5, 2024,
    'Reemplazo de componente defectuoso.', 'Mantenimiento Interno', 2358530, 'Sistema', 'Equipo operativo', '2024-05-08 14:00:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 4, 2025,
    'Calibración metrológica según normas ISO.', 'Mantenimiento Interno', 907152, 'Sistema', 'Equipo operativo', '2025-04-19 16:00:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 7, 2025,
    'Corrección de desviación en parámetros.', 'Proveedor Externo', 2104383, 'Sistema', 'Realizado con éxito', '2025-07-07 10:45:00'
);

-- Excel Equipo 29: Micropipeta
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', '12 / 3 - 058976 - 02', 'BIO-16875', '15-166', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410 - (Post-PCR)', 'GILSON', 'P-1000', 'Y51513C', 'Extensión', 'BIO', 'I', 'ACTA No. 09 17 de Septiembre de 2014', 'NI', 'Activo', 2, 14, 2
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Anual', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 7, 2024,
    'Verificación de exactitud y precisión.', 'Técnico UdeA', 1766713, 'Sistema', 'Pendiente de revisión', '2024-07-03 09:00:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 7, 2025,
    'Ajuste de parámetros de medición.', 'Mantenimiento Interno', 1482843, 'Sistema', 'Pendiente de revisión', '2025-07-19 08:45:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 12, 2024,
    'Certificación de calibración anual.', 'Servicio Especializado', 288509, 'Sistema', 'Pendiente de revisión', '2024-12-14 09:45:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-08-01 14:00:00', 1, 3,
    3, 3, 'Cambio de servicio por necesidades operativas', 'Jefe de Servicio', '2024-08-01 14:00:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-06-03 13:30:00', 3, 1,
    8, 17, 'Cambio de servicio por necesidades operativas', 'Jefe de Servicio', '2025-06-03 13:30:00'
);

-- Excel Equipo 30: Micropipeta
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', '18 / 59470', 'BIO-16876', '15-166', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410 - (PRE-PCR) Backup1', 'GILSON', 'P-1000', 'X63933E', 'Extensión', 'BIO', 'I', 'ACTA No. 09 17 de Septiembre de 2014', 'NI', 'Activo', 2, 14, 1
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Mensual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 3, 2024,
    'Reparación de falla detectada durante operación.', 'Servicio Especializado', 1728699, 'Sistema', 'Realizado con éxito', '2024-03-25 13:45:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-10-20 09:45:00', 1, 3,
    2, 6, 'Traslado temporal para mantenimiento', 'Coordinador Técnico', '2025-10-20 09:45:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-06-04 10:00:00', 1, 2,
    1, 9, 'Consolidación de equipos en nueva ubicación', 'Admin LIME', '2024-06-04 10:00:00'
);

-- Excel Equipo 31: Micropipeta
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', '8 / 3.060881.00', 'BIO-16877', '15-166', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410 - (PRE-PCR) Backup2', 'GILSON', 'P-1000', 'CB63839', 'Extensión', 'BIO', 'I', 'ACTA No. 09 17 de Septiembre de 2014', 'NI', 'Activo', 2, 14, 7
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Mensual', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 12, 2024,
    'Verificación de exactitud y precisión.', 'Mantenimiento Interno', 1367311, 'Sistema', 'Realizado con éxito', '2024-12-03 10:00:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 12, 2024,
    'Mantenimiento preventivo programado según plan anual.', 'Proveedor Externo', 263318, 'Sistema', 'Pendiente de revisión', '2024-12-02 11:15:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 11, 2025,
    'Mantenimiento preventivo programado según plan anual.', 'Mantenimiento Interno', 1246917, 'Sistema', 'Equipo operativo', '2025-11-22 13:00:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 6, 2025,
    'Mantenimiento preventivo programado según plan anual.', 'Mantenimiento Interno', 378078, 'Sistema', 'Requiere repuestos', '2025-06-17 17:30:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-02-21 16:45:00', 3, 2,
    16, 2, 'Reubicación por reorganización de espacios', 'Coordinador Técnico', '2025-02-21 16:45:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-11-06 12:45:00', 1, 2,
    6, 14, 'Optimización de recursos entre sedes', 'Responsable de Equipos', '2024-11-06 12:45:00'
);

-- Excel Equipo 32: Micropipeta
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', '4 / 3 - 059471 - 00 / 011919', 'BIO-16878', '15-166', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410 -  (PRE-PCR)', 'GILSON', 'P-1000', 'X62492E', 'Extensión', 'BIO', 'I', 'ACTA No. 09 17 de Septiembre de 2014', 'NI', 'Activo', 2, 14, 1
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Semestral', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 7, 2024,
    'Mantenimiento preventivo programado según plan anual.', 'Servicio Especializado', 1565556, 'Sistema', 'Requiere repuestos', '2024-07-01 16:15:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-09-09 12:15:00', 2, 1,
    4, 13, 'Reubicación por reorganización de espacios', 'Admin LIME', '2024-09-09 12:15:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-02-15 13:30:00', 3, 2,
    1, 12, 'Traslado temporal para mantenimiento', 'Coordinador Técnico', '2025-02-15 13:30:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-03-13 12:00:00', 2, 3,
    9, 17, 'Reubicación por reorganización de espacios', 'Admin LIME', '2024-03-13 12:00:00'
);

-- Excel Equipo 33: Refrigerador
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Refrigerador', '132496 / 008721', 'Pendiente', '17-157', 'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'FAGOR', 'AFP701', '06060075M', 'Extensión', 'IND', NULL, NULL, 'NI', 'Activo', 2, 15, 7
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 0, 'Mensual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-06-23 09:45:00', 3, 2,
    12, 14, 'Cambio de servicio por necesidades operativas', 'Responsable de Equipos', '2023-06-23 09:45:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-01-20 14:30:00', 3, 2,
    3, 2, 'Cambio de servicio por necesidades operativas', 'Coordinador Técnico', '2023-01-20 14:30:00'
);

-- Excel Equipo 34: Lector de platos ELISA
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Lector de platos ELISA', 146231, 'BIO-16759', '16-979', 'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'BioRad', 'iMark', '15486', 'Extensión', 'BIO', 'IIa', 'Comprado en Febrero de 2013 y el INVIMA lo clasificó como dispositivo médico en Acta No. 08 septiembre 11 de  2013', 'NI', 'Activo', 2, 15, 2
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Trimestral', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 10, 2024,
    'Verificación de exactitud y precisión.', 'Técnico UdeA', 1999392, 'Sistema', 'Calibración OK', '2024-10-07 15:45:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 2, 2025,
    'Ajuste de parámetros de medición.', 'Proveedor Externo', 795840, 'Sistema', 'Equipo operativo', '2025-02-09 17:00:00'
);

-- Excel Equipo 35: Lavador de platos de ELISA
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Lavador de platos de ELISA', '140119 / 008685', 'BIO-16760', '17-489', 'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'Awareness Technology', 'Stat Fax 2600', '2600-7447', 'Extensión', 'BIO', 'IIa', 'INVIMA 2018DM-0018956', 'NI', 'Activo', 2, 15, 6
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Mensual', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 7, 2025,
    'Solución de problema reportado por usuario.', 'Técnico UdeA', 228031, 'Sistema', 'Pendiente de revisión', '2025-07-16 10:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 11, 2024,
    'Solución de problema reportado por usuario.', 'Proveedor Externo', 1492662, 'Sistema', 'Requiere repuestos', '2024-11-22 16:15:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 10, 2025,
    'Reemplazo de componente defectuoso.', 'Técnico UdeA', 925732, 'Sistema', 'Equipo operativo', '2025-10-20 11:45:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-09-01 13:15:00', 2, 3,
    13, 12, 'Traslado temporal para mantenimiento', 'Admin LIME', '2025-09-01 13:15:00'
);

-- Excel Equipo 37: Microscopio
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Microscopio', '132499 / 008680', 'BIO-16811', '12-536', 'SIU - Cuarto de cultivo', 'OLYMPUS', 'CX21FS1', '8F11617', 'Extensión e investigación', 'BIO', 'I', 'ACTA No. 07 Junio 10 de 2009, en esta acta el Invima indica que los microscopios no requieren registro sanitario, hasta el ACTA No. 09 Octubre 17 de 2012 donde indica que ya si lo requiere.', 'NI', 'Activo', 2, 15, 6
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Anual', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 2, 2025,
    'Verificación de exactitud y precisión.', 'Mantenimiento Interno', 760284, 'Sistema', 'Equipo operativo', '2025-02-19 12:15:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 3, 2025,
    'Limpieza general y verificación de componentes.', 'Servicio Especializado', 1045094, 'Sistema', 'Pendiente de revisión', '2025-03-04 15:30:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-03-16 17:15:00', 1, 2,
    5, 9, 'Cambio de servicio por necesidades operativas', 'Jefe de Servicio', '2024-03-16 17:15:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-10-18 11:45:00', 2, 1,
    15, 5, 'Traslado temporal para mantenimiento', 'Admin LIME', '2025-10-18 11:45:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-10-19 14:15:00', 2, 3,
    7, 13, 'Reubicación por reorganización de espacios', 'Admin LIME', '2025-10-19 14:15:00'
);

-- Excel Equipo 38: Baño María
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Baño María', '143436 / 008689', 'BIO-16307', '16-861', 'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'Memmert', 'WNB 7', 'L211.1357', 'Extensión', 'BIO', 'I', 'ACTA No. 07 Junio 10 de 2009 indica que no requiere registro sanitario, y se rectifica en ACTA No. 09 Octubre 17 de 2012', 'NI', 'Activo', 2, 15, 7
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Anual', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 3, 2024,
    'Ajuste de parámetros de medición.', 'Mantenimiento Interno', 2387240, 'Sistema', 'Calibración OK', '2024-03-09 11:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 3, 2024,
    'Revisión de sistemas mecánicos y eléctricos.', 'Técnico UdeA', 1371062, 'Sistema', 'Requiere repuestos', '2024-03-12 08:15:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 1, 2025,
    'Reparación de falla detectada durante operación.', 'Servicio Especializado', 2479603, 'Sistema', 'Requiere repuestos', '2025-01-26 08:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 11, 2024,
    'Certificación de calibración anual.', 'Proveedor Externo', 426925, 'Sistema', 'Realizado con éxito', '2024-11-08 15:45:00'
);

-- Excel Equipo 39: Baño María
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Baño María', '143437 / 040042', 'BIO-16755', '16-861', 'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'Memmert', 'WNB 7', 'L211.1359', 'Extensión e investigación', 'BIO', 'I', 'ACTA No. 07 Junio 10 de 2009 indica que no requiere registro sanitario, y se rectifica en ACTA No. 09 Octubre 17 de 2012', 'NI', 'Activo', 2, 15, 2
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Mensual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 3, 2024,
    'Solución de problema reportado por usuario.', 'Proveedor Externo', 776671, 'Sistema', 'Calibración OK', '2024-03-26 13:15:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 9, 2024,
    'Solución de problema reportado por usuario.', 'Técnico UdeA', 2445542, 'Sistema', 'Realizado con éxito', '2024-09-11 16:45:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 8, 2024,
    'Calibración y ajuste de parámetros operativos.', 'Técnico UdeA', 206285, 'Sistema', 'Equipo operativo', '2024-08-16 14:15:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 9, 2025,
    'Certificación de calibración anual.', 'Servicio Especializado', 168798, 'Sistema', 'Requiere repuestos', '2025-09-19 09:30:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-03-04 14:00:00', 1, 2,
    2, 2, 'Préstamo temporal a otro servicio', 'Coordinador Técnico', '2024-03-04 14:00:00'
);

-- Excel Equipo 40: Incubadora CO2
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Incubadora CO2', 'No tiene', 'BIO-16311', '18-013', 'SIU - Cuarto de cultivo', 'Thermo Scientific', 'Series 8000 WJ 3428', '181988-102', 'Extensión e investigación', 'BIO', 'IIa', 'INVIMA 2017DM-0016578', 'NI', 'Activo', 2, 15, 1
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Mensual', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 8, 2024,
    'Calibración y ajuste de parámetros operativos.', 'Técnico UdeA', 169399, 'Sistema', 'Pendiente de revisión', '2024-08-14 11:30:00'
);

-- Excel Equipo 41: Agitador Vortex
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Agitador Vortex', 151664, 'BIO-16308', '15-651', 'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'Labnet', 'S0200', 'Z3121820', 'Extensión', 'BIO', NULL, 'ACTA No. 07 Junio 10 de 2009 indica que no requiere registro sanitario, y se rectifica en ACTA No. 03 Abril 10 de 2013', 'NI', 'Activo', 2, 15, 3
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 0, 'Mensual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-02-23 08:30:00', 3, 2,
    18, 14, 'Optimización de recursos entre sedes', 'Responsable de Equipos', '2024-02-23 08:30:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-11-24 14:45:00', 3, 2,
    3, 4, 'Préstamo temporal a otro servicio', 'Jefe de Servicio', '2024-11-24 14:45:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-09-05 17:15:00', 1, 3,
    12, 6, 'Consolidación de equipos en nueva ubicación', 'Admin LIME', '2024-09-05 17:15:00'
);

-- Excel Equipo 42: Centrífuga refrigerada
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Centrífuga refrigerada', '119807 / 000791', 'BIO-16756', '18-265', 'SIU - Cuarto de cultivo', 'Eppendorf', '5810R', '0033896', 'Extensión e investigación', 'BIO', 'I', 'INVIMA 2014DM-0011801', 'NI', 'Activo', 2, 15, 1
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Mensual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 3, 2024,
    'Ajuste de parámetros de medición.', 'Mantenimiento Interno', 1369735, 'Sistema', 'Requiere repuestos', '2024-03-28 09:00:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 2, 2024,
    'Mantenimiento preventivo programado según plan anual.', 'Técnico UdeA', 1220495, 'Sistema', 'Calibración OK', '2024-02-14 11:15:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 11, 2024,
    'Certificación de calibración anual.', 'Mantenimiento Interno', 1233489, 'Sistema', 'Calibración OK', '2024-11-27 15:45:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 7, 2025,
    'Calibración y ajuste de parámetros operativos.', 'Mantenimiento Interno', 2307952, 'Sistema', 'Requiere repuestos', '2025-07-10 16:45:00'
);

-- Excel Equipo 43: Balanza Analitica
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Balanza Analitica', '038547', 'BIO-16846', '10-261', 'SIU - Laboratorio Reproducción - Torre 2, Lab 534', 'Adam Equipment', 'NBL 124e', 'AE9UT335', 'Extensión', 'BIO', 'I', 'ACTA No. 07 Junio 10 de 2009', 'NI', 'Activo', 2, 16, 7
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 0, 'Trimestral', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

-- Excel Equipo 44: Micropipeta
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', '023117', 'BIO-17234', '15-166', 'SIU - Laboratorio Reproducción - Torre 2, Lab 534', 'Nichirio', 'Nichipet Explus', 'H38014182', 'Extensión', 'BIO', 'I', 'ACTA No. 09 17 de Septiembre de 2014', 'NI', 'Activo', 2, 16, 7
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 0, 'Anual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-08-21 08:30:00', 3, 2,
    13, 18, 'Cambio de servicio por necesidades operativas', 'Jefe de Servicio', '2025-08-21 08:30:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-09-07 11:45:00', 3, 1,
    5, 7, 'Traslado temporal para mantenimiento', 'Admin LIME', '2024-09-07 11:45:00'
);

-- Excel Equipo 45: Micropipeta
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', 'LIME 541', 'BIO-16512', '15-166', 'Inmunohistoquímica', 'Sartorius', 'Tacta', '42186226', 'Extensión e Investigación', 'BIO', 'I', 'Certificación No requiere N° 2016020596', 'NI', 'Activo', 3, 17, 6
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Mensual', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 10, 2025,
    'Solución de problema reportado por usuario.', 'Servicio Especializado', 1663718, 'Sistema', 'Realizado con éxito', '2025-10-06 11:00:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 5, 2025,
    'Mantenimiento preventivo programado según plan anual.', 'Técnico UdeA', 2218032, 'Sistema', 'Calibración OK', '2025-05-15 08:15:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-06-16 08:00:00', 2, 3,
    11, 14, 'Optimización de recursos entre sedes', 'Coordinador Técnico', '2024-06-16 08:00:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-07-18 13:00:00', 1, 2,
    10, 14, 'Consolidación de equipos en nueva ubicación', 'Jefe de Servicio', '2023-07-18 13:00:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-07-18 09:30:00', 2, 1,
    7, 2, 'Reubicación por reorganización de espacios', 'Jefe de Servicio', '2023-07-18 09:30:00'
);

-- Excel Equipo 46: Procesador de tejidos
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Procesador de tejidos', 119420, 'BIO-16504', '15-190', 'Histotécnica', 'Leica', 'TP1020-1-1', '42231412', 'Extensión e Investigación', 'BIO', 'I', 'INVIMA 2015DM-0013758', 'NI', 'Activo', 3, 17, 5
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Semestral', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 6, 2024,
    'Verificación de exactitud y precisión.', 'Mantenimiento Interno', 2397699, 'Sistema', 'Requiere repuestos', '2024-06-21 14:00:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 9, 2024,
    'Reparación de falla detectada durante operación.', 'Mantenimiento Interno', 1070620, 'Sistema', 'Calibración OK', '2024-09-13 10:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 5, 2024,
    'Calibración metrológica según normas ISO.', 'Proveedor Externo', 1194829, 'Sistema', 'Calibración OK', '2024-05-16 15:00:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 3, 2025,
    'Calibración metrológica según normas ISO.', 'Mantenimiento Interno', 1081018, 'Sistema', 'Requiere repuestos', '2025-03-10 11:00:00'
);

-- Excel Equipo 47: Criostato
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Criostato', 187701, 'BIO-16464', '15-157', 'Cuarto criostato', 'Leica', 'CM1860 UV', '00000005299', 'Extensión e Investigación', 'BIO', 'I', 'INVIMA 2015DM-0013759', 'NI', 'Activo', 3, 17, 6
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 0, 'Anual', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

-- Excel Equipo 48: Estación de Corte Macro
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Estación de Corte Macro', 189565, 'BIO-16466', 'NT', 'Corte macro', 'Kugel Medical', 'GP 1500', '20.206422.01', 'Extensión e Investigación', 'BIO', NULL, 'Certificación No requiere N° 2018003889', 'NI', 'Activo', 3, 17, 1
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Semestral', 1);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 4, 2025,
    'Solución de problema reportado por usuario.', 'Proveedor Externo', 751621, 'Sistema', 'Calibración OK', '2025-04-14 16:15:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 8, 2024,
    'Calibración y ajuste de parámetros operativos.', 'Servicio Especializado', 1557677, 'Sistema', 'Equipo operativo', '2024-08-11 14:45:00'
);

-- Excel Equipo 49: Estación de inclusión
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Estación de inclusión', '178684 / 061551', 'BIO-16467', 'NT', 'Histotécnica', 'Leica', 'HistoCore Arcadia H / Arcadia C', '1671 / 2048', 'Extensión e Investigación', 'BIO', NULL, 'No requiere INVIMA', 'NI', 'Activo', 3, 17, 5
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Anual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 2, 2024,
    'Calibración metrológica según normas ISO.', 'Proveedor Externo', 192558, 'Sistema', 'Realizado con éxito', '2024-02-08 17:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 4, 2024,
    'Calibración metrológica según normas ISO.', 'Mantenimiento Interno', 1292180, 'Sistema', 'Realizado con éxito', '2024-04-08 12:00:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 8, 2025,
    'Calibración y ajuste de parámetros operativos.', 'Técnico UdeA', 2182357, 'Sistema', 'Requiere repuestos', '2025-08-04 08:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 2, 2024,
    'Mantenimiento preventivo programado según plan anual.', 'Mantenimiento Interno', 1191170, 'Sistema', 'Realizado con éxito', '2024-02-11 13:15:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-05-10 11:00:00', 2, 3,
    18, 11, 'Optimización de recursos entre sedes', 'Admin LIME', '2024-05-10 11:00:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-08-14 17:15:00', 2, 1,
    3, 1, 'Préstamo temporal a otro servicio', 'Responsable de Equipos', '2024-08-14 17:15:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-01-08 11:00:00', 1, 2,
    7, 15, 'Optimización de recursos entre sedes', 'Admin LIME', '2025-01-08 11:00:00'
);

-- Excel Equipo 50: Refrigerador-congelador mixto
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Refrigerador-congelador mixto', 209912, 'Pendiente', 'NT', 'Hospital Universitario San Vicente Fundación, Bloque 7, Laboratorio de Dermatopatología, Área de procesamiento - Baño de flotación', 'MELING BIOMEDICAL', 'YCD-EL450', '220702139', 'Extensión e Investigación', 'BIO', 'IIa', 'INVIMA 2022DM-0025849', 'NI', 'Activo', 3, 18, 1
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 0, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Anual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 8, 2025,
    'Certificación de calibración anual.', 'Proveedor Externo', 1583092, 'Sistema', 'Calibración OK', '2025-08-20 08:00:00'
);

-- Excel Equipo 51: Baño de flotación
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Baño de flotación', 209557, 'BIO-16666', '15 - 107', 'Hospital Universitario San Vicente Fundación, Bloque 7, Laboratorio de Dermatopatología, Área de procesamiento - Baño de flotación', 'KEDEE', 'KD-P', '51A638', 'Extensión e Investigación', 'BIO', NULL, 'No requiere INVIMA', '7 Años', 'Activo', 3, 18, 3
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Trimestral', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 2, 2025,
    'Verificación de exactitud y precisión.', 'Mantenimiento Interno', 631870, 'Sistema', 'Equipo operativo', '2025-02-08 12:45:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 12, 2024,
    'Revisión de sistemas mecánicos y eléctricos.', 'Servicio Especializado', 141651, 'Sistema', 'Calibración OK', '2024-12-07 10:15:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 11, 2024,
    'Reparación de falla detectada durante operación.', 'Servicio Especializado', 1281057, 'Sistema', 'Calibración OK', '2024-11-21 17:45:00'
);

-- Excel Equipo 52: Termohigrómetro digital
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Termohigrómetro digital', '2 (TH-DP-01)', 'BIO-16685', 'NT', 'Hospital Universitario San Vicente Fundación, Bloque 7, Laboratorio de Dermatopatología, Cuarto de inmunofluorecencia', 'Clock-Humidity', 'HTC-2', 'N/I', 'Extensión e Investigación', 'BIO', 'I', 'ACTA No. 03 Abril 10 de 2013', 'NI', 'Activo', 3, 18, 5
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 0, 'Semestral', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-04-15 09:45:00', 1, 2,
    18, 7, 'Reubicación por reorganización de espacios', 'Admin LIME', '2023-04-15 09:45:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-06-18 13:45:00', 2, 3,
    16, 15, 'Cambio de servicio por necesidades operativas', 'Jefe de Servicio', '2025-06-18 13:45:00'
);

-- Excel Equipo 53: Termohigrómetro digital
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Termohigrómetro digital', '1 (01A10)', 'BIO-16686', 'NT', 'Hospital Universitario San Vicente Fundación, Bloque 7, Laboratorio de Dermatopatología, Área de procesamiento', 'BOECO Germany', 'BOE330', 'N/I', 'Extensión e investigación', 'BIO', 'I', 'ACTA No. 03 Abril 10 de 2013', 'NI', 'Activo', 3, 18, 7
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Trimestral', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 2, 2024,
    'Limpieza general y verificación de componentes.', 'Mantenimiento Interno', 1151523, 'Sistema', 'Pendiente de revisión', '2024-02-11 10:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 6, 2024,
    'Calibración metrológica según normas ISO.', 'Mantenimiento Interno', 2459599, 'Sistema', 'Equipo operativo', '2024-06-26 15:15:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-01-21 14:15:00', 2, 3,
    14, 15, 'Préstamo temporal a otro servicio', 'Coordinador Técnico', '2024-01-21 14:15:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-03-03 15:45:00', 1, 3,
    9, 16, 'Consolidación de equipos en nueva ubicación', 'Admin LIME', '2023-03-03 15:45:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-10-01 10:00:00', 3, 1,
    5, 7, 'Cambio de servicio por necesidades operativas', 'Jefe de Servicio', '2024-10-01 10:00:00'
);

-- Excel Equipo 54: Microscopio y Cámara Leica
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Microscopio y Cámara Leica', 164367, 'BIO-16681', '15 - 156', 'Hospital Universitario San Vicente Fundación, Bloque 7, Laboratorio de Dermatopatología, Cuarto de inmunofluorecencia', 'Leica', 'DM500', 'C540242931LS0390', 'Investigación, docencia y extensión', 'BIO', 'I', 'INVIMA 2014DM-0011844', 'NI', 'Activo', 3, 18, 4
);
SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);
INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, 1, 0);
INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Anual', 0);
INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');

INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 3, 2024,
    'Revisión de sistemas mecánicos y eléctricos.', 'Mantenimiento Interno', 1066033, 'Sistema', 'Requiere repuestos', '2024-03-09 10:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 5, 2024,
    'Calibración y ajuste de parámetros operativos.', 'Mantenimiento Interno', 1544443, 'Sistema', 'Requiere repuestos', '2024-05-27 08:30:00'
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 3, 2024,
    'Revisión de sistemas mecánicos y eléctricos.', 'Servicio Especializado', 1419137, 'Sistema', 'Pendiente de revisión', '2024-03-02 15:45:00'
);

INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2023-04-04 16:30:00', 3, 1,
    11, 12, 'Préstamo temporal a otro servicio', 'Responsable de Equipos', '2023-04-04 16:30:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2024-01-11 17:00:00', 2, 1,
    14, 2, 'Reubicación por reorganización de espacios', 'Jefe de Servicio', '2024-01-11 17:00:00'
);
INSERT INTO `historial_traslados` (
    `equipo_id`, `fecha_traslado`, `sede_origen_id`, `sede_destino_id`,
    `servicio_origen_id`, `servicio_destino_id`, `justificacion`, `usuario_registro`, `created_at`
) VALUES (
    @equipo_id, '2025-05-14 13:00:00', 1, 2,
    9, 15, 'Cambio de servicio por necesidades operativas', 'Coordinador Técnico', '2025-05-14 13:00:00'
);

