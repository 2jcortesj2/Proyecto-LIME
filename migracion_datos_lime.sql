-- SCRIPT GENERADO AUTOMÁTICAMENTE: FUSIÓN MANUAL + EXCEL
-- Fecha: 2025-11-23 10:50:29.488471

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
    'Micropipeta', NULL, 'BIO-12194', '15 - 166', 'Procesamiento Seccion A', 'Thermo Scientific', 'Finnpipette F1', 'MH12173', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 2, 6
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
    @equipo_id, 'correctivo', 2, 2024,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 1315948, 'Sistema', 'Requiere repuestos', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 10, 2023,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1170821, 'Sistema', 'Equipo operativo', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 6, 2022,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 1560135, 'Sistema', 'Realizado con éxito', NOW()
);

-- Excel Equipo 7: Micropipeta 
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', NULL, 'BIO-12198', '15 - 166', 'Procesamiento Seccion A', 'Thermo Scientific', 'Finnpipette F1', 'MH12148', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 2, 6
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
    @equipo_id, 'correctivo', 11, 2024,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 1212310, 'Sistema', 'Requiere repuestos', NOW()
);

-- Excel Equipo 8: Agitador Vórtex
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Agitador Vórtex', NULL, 'BIO-12129', '15 - 651', 'Procesamiento Seccion A', 'Boeco', 'Vortex V1 Plus', '1020313061616', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 3, 5
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
    @equipo_id, 'calibracion', 6, 2024,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 136315, 'Sistema', 'Equipo operativo', NOW()
);

-- Excel Equipo 9: Baño María
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Baño María', NULL, 'BIO-12130', '16 - 861', 'Procesamiento Seccion B', 'Indulab', '09-A', '13834', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 3, 3
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
    @equipo_id, 'preventivo', 10, 2022,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1913530, 'Sistema', 'Realizado con éxito', NOW()
);

-- Excel Equipo 10: Centrífuga
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Centrífuga', NULL, 'BIO-12131', '10 - 778', 'Área centrífugas', 'Hettich', 'Rotofix 32A', '006965-04', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 3, 6
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
    @equipo_id, 'preventivo', 6, 2024,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 552696, 'Sistema', 'Requiere repuestos', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 9, 2022,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 683380, 'Sistema', 'Requiere repuestos', NOW()
);

-- Excel Equipo 11: Microcentrifuga refrigerada
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Microcentrifuga refrigerada', NULL, 'BIO-16289', '17 - 452', 'Área centrífugas', 'HERMLE', 'Z 216 MK', '61165050', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 1, 3
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
    @equipo_id, 'calibracion', 2, 2022,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 1950576, 'Sistema', 'Realizado con éxito', NOW()
);

-- Excel Equipo 12: Congelador
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Congelador', NULL, 'Pendiente', '15 - 583', 'Hospital Alma Mater de antioquia, sede ambulatoria Prado, Bloque B, segundo piso, Almacen', 'Infrico', 'LTF40SD', '3000957831', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 1, 6
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
    @equipo_id, 'preventivo', 8, 2023,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1922391, 'Sistema', 'Requiere repuestos', NOW()
);

-- Excel Equipo 13: Fonendoscopio
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Fonendoscopio', NULL, 'BIO-16800', '13 - 750', 'Recepcion', 'GMD', 'GMD30-DCK', 'IMP-1163', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 5, 4
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
    @equipo_id, 'correctivo', 2, 2022,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 1810888, 'Sistema', 'Equipo operativo', NOW()
);

-- Excel Equipo 14: Centrífuga refrigerada
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Centrífuga refrigerada', NULL, 'BIO-12250', '18 - 270', 'Biologia Molecular (Extraccion)', 'Sigma', '3-16K', '110639', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 6, 3
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
    @equipo_id, 'preventivo', 3, 2022,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 201446, 'Sistema', 'Realizado con éxito', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 6, 2023,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 472029, 'Sistema', 'Equipo operativo', NOW()
);

-- Excel Equipo 15: Balanza Analítica
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Balanza Analítica', NULL, 'BIO-16749', '18 - 449', 'BSL3 (Procesamiento)', 'ViBRA', 'HT224CEN', '215022050', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 7, 4
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
    @equipo_id, 'correctivo', 11, 2023,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 387601, 'Sistema', 'Realizado con éxito', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 2, 2024,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 1183829, 'Sistema', 'Realizado con éxito', NOW()
);

-- Excel Equipo 16: Incubadora
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Incubadora', NULL, 'BIO-12256', '18 - 013', 'Citogenomica (Preanalitica)', 'Binder', 'BD53-UL', '908707', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 8, 1
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
    @equipo_id, 'preventivo', 3, 2023,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 535390, 'Sistema', 'Realizado con éxito', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 2, 2024,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 747838, 'Sistema', 'Realizado con éxito', NOW()
);

-- Excel Equipo 17: Filmarray
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Filmarray', NULL, 'BIO-16698', 'NI', 'Microbiología 1', 'BIOFIRE', 'FilmArray Torch (ref: HTFA-ASY-0104)', 'TB03545', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 9, 4
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
    @equipo_id, 'correctivo', 2, 2024,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 162476, 'Sistema', 'Requiere repuestos', NOW()
);

-- Excel Equipo 18: Maglumi
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Maglumi', NULL, 'BIO-16303', 'NI', 'Procesamiento Seccion B', 'SNIBE', 'MAGLUMI 600', '0101010003022000165', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 10, 4
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
    @equipo_id, 'calibracion', 6, 2024,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 303314, 'Sistema', 'Calibración OK', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 8, 2022,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 1584582, 'Sistema', 'Requiere repuestos', NOW()
);

-- Excel Equipo 19: Micropipeta
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', NULL, 'BIO-12177', '15 - 166', 'Procesamiento Seccion C', 'Corning', 'Lambda Plus', '658220168', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 11, 4
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
    @equipo_id, 'correctivo', 6, 2023,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 1597069, 'Sistema', 'Equipo operativo', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 2, 2023,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1988660, 'Sistema', 'Equipo operativo', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 6, 2022,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1793318, 'Sistema', 'Realizado con éxito', NOW()
);

-- Excel Equipo 20: Resonador magnetico
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Resonador magnetico', NULL, 'BIO-15348', 'NT', 'Hospital Alma Mater de Antioquia, Bloque B, primer piso, Centro de resonancia', 'PHILIPS', 'INGENIA ELITION X', '45555', 'Extensión', NULL, NULL, NULL, '10 años', 'Activo', 1, 12, 5
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
    @equipo_id, 'preventivo', 6, 2023,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 277433, 'Sistema', 'Calibración OK', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 8, 2023,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 529512, 'Sistema', 'Requiere repuestos', NOW()
);

-- Excel Equipo 21: CAMARA DE FOTOTERAPIA
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'CAMARA DE FOTOTERAPIA', NULL, 'BIO-100561', '13-037', 'Hospital Alma Mater de Antioquia, Bloque A, segundo piso, FOTOTERAPIA', 'DAAVLIN', 'P3251-SNBPC-0048', '3SERIES PC31148', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 13, 3
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
    @equipo_id, 'preventivo', 4, 2024,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1591694, 'Sistema', 'Requiere repuestos', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 9, 2023,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 479252, 'Sistema', 'Equipo operativo', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 3, 2022,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 612570, 'Sistema', 'Requiere repuestos', NOW()
);

-- Excel Equipo 22: CAMARA DE FOTOTERAPIA
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'CAMARA DE FOTOTERAPIA', NULL, 'BIO-102003', '13-037', 'Hospital Alma Mater de Antioquia, Bloque A, segundo piso, FOTOTERAPIA', 'DAAVLIN', 'P3526A1X4800', '3SERIES X350-48', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 1, 13, 4
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
    @equipo_id, 'correctivo', 9, 2022,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 312709, 'Sistema', 'Equipo operativo', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 8, 2024,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1887606, 'Sistema', 'Equipo operativo', NOW()
);

-- Excel Equipo 23: Agitador vortex
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Agitador vortex', NULL, 'BIO-16857', '15-651', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'SCIENTIFIC INDUSTRIES /GENIE 2', 'G-560', '2-374976', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 14, 5
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
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 721842, 'Sistema', 'Requiere repuestos', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 10, 2023,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1598996, 'Sistema', 'Equipo operativo', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 11, 2023,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1599923, 'Sistema', 'Equipo operativo', NOW()
);

-- Excel Equipo 24: Balanza analítica
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Balanza analítica', NULL, 'BIO-16858', '18-449', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'PRECISA', 'LS220A', '7001460', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 14, 6
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
    @equipo_id, 'preventivo', 2, 2022,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1791702, 'Sistema', 'Calibración OK', NOW()
);

-- Excel Equipo 26: Calentador seco
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Calentador seco', NULL, 'BIO-16860', 'NT', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'BOEKEL', 113002, '0233 12871', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 14, 2
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
    @equipo_id, 'correctivo', 3, 2022,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 266441, 'Sistema', 'Realizado con éxito', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 3, 2022,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1934535, 'Sistema', 'Realizado con éxito', NOW()
);

-- Excel Equipo 27: Incubadora
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Incubadora', NULL, 'BIO-16868', '18-013', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'MEMMERT', 'TV10', '599033', 'Extensión', NULL, NULL, NULL, '10 años', 'Activo', 2, 14, 5
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
    @equipo_id, 'preventivo', 11, 2024,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1028485, 'Sistema', 'Calibración OK', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 4, 2022,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 1130506, 'Sistema', 'Calibración OK', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 4, 2022,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 698513, 'Sistema', 'Equipo operativo', NOW()
);

-- Excel Equipo 28: Luminex
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Luminex', NULL, 'BIO-16869', 'NT', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'LUMINEX', 'Luminex LX 100/ 200', 'LX10017065423', 'Extensión', NULL, NULL, NULL, '10 años', 'Activo', 2, 14, 3
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
    @equipo_id, 'preventivo', 10, 2022,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1697033, 'Sistema', 'Requiere repuestos', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 3, 2024,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 833609, 'Sistema', 'Calibración OK', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 1, 2023,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 799461, 'Sistema', 'Equipo operativo', NOW()
);

-- Excel Equipo 29: Micropipeta
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', NULL, 'BIO-16875', '15-166', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410 - (Post-PCR)', 'GILSON', 'P-1000', 'Y51513C', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 14, 6
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
    @equipo_id, 'correctivo', 1, 2022,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 794422, 'Sistema', 'Calibración OK', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 1, 2022,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 1210395, 'Sistema', 'Requiere repuestos', NOW()
);

-- Excel Equipo 30: Micropipeta
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', NULL, 'BIO-16876', '15-166', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410 - (PRE-PCR) Backup1', 'GILSON', 'P-1000', 'X63933E', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 14, 5
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
    @equipo_id, 'correctivo', 5, 2023,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 1840805, 'Sistema', 'Equipo operativo', NOW()
);

-- Excel Equipo 31: Micropipeta
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', NULL, 'BIO-16877', '15-166', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410 - (PRE-PCR) Backup2', 'GILSON', 'P-1000', 'CB63839', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 14, 3
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
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 183266, 'Sistema', 'Realizado con éxito', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 6, 2023,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1682986, 'Sistema', 'Equipo operativo', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 3, 2023,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 1057177, 'Sistema', 'Requiere repuestos', NOW()
);

-- Excel Equipo 32: Micropipeta
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', NULL, 'BIO-16878', '15-166', 'SIU - Laboratorio trasplantes - Torre 1, Lab 410 -  (PRE-PCR)', 'GILSON', 'P-1000', 'X62492E', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 14, 2
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
    @equipo_id, 'correctivo', 5, 2022,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 1072847, 'Sistema', 'Calibración OK', NOW()
);

-- Excel Equipo 33: Refrigerador
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Refrigerador', NULL, 'Pendiente', '17-157', 'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'FAGOR', 'AFP701', '06060075M', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 15, 6
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
    @equipo_id, 'correctivo', 8, 2023,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 1929990, 'Sistema', 'Requiere repuestos', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 4, 2022,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 520602, 'Sistema', 'Requiere repuestos', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 8, 2023,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 1246770, 'Sistema', 'Realizado con éxito', NOW()
);

-- Excel Equipo 34: Lector de platos ELISA
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Lector de platos ELISA', NULL, 'BIO-16759', '16-979', 'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'BioRad', 'iMark', '15486', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 15, 1
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
    @equipo_id, 'preventivo', 10, 2024,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1999145, 'Sistema', 'Calibración OK', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 10, 2024,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 372317, 'Sistema', 'Requiere repuestos', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 9, 2024,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 119489, 'Sistema', 'Calibración OK', NOW()
);

-- Excel Equipo 35: Lavador de platos de ELISA
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Lavador de platos de ELISA', NULL, 'BIO-16760', '17-489', 'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'Awareness Technology', 'Stat Fax 2600', '2600-7447', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 15, 7
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
    @equipo_id, 'correctivo', 6, 2024,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 1213631, 'Sistema', 'Equipo operativo', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 11, 2023,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1541833, 'Sistema', 'Realizado con éxito', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 7, 2022,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 822447, 'Sistema', 'Equipo operativo', NOW()
);

-- Excel Equipo 37: Microscopio
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Microscopio', NULL, 'BIO-16811', '12-536', 'SIU - Cuarto de cultivo', 'OLYMPUS', 'CX21FS1', '8F11617', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 15, 5
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
    @equipo_id, 'calibracion', 7, 2023,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 103480, 'Sistema', 'Realizado con éxito', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 9, 2024,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 1200882, 'Sistema', 'Calibración OK', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 6, 2022,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1656370, 'Sistema', 'Realizado con éxito', NOW()
);

-- Excel Equipo 38: Baño María
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Baño María', NULL, 'BIO-16307', '16-861', 'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'Memmert', 'WNB 7', 'L211.1357', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 15, 7
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
    @equipo_id, 'preventivo', 7, 2023,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1075665, 'Sistema', 'Equipo operativo', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 1, 2022,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 663949, 'Sistema', 'Equipo operativo', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 4, 2024,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 752040, 'Sistema', 'Realizado con éxito', NOW()
);

-- Excel Equipo 39: Baño María
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Baño María', NULL, 'BIO-16755', '16-861', 'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'Memmert', 'WNB 7', 'L211.1359', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 15, 3
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
    @equipo_id, 'preventivo', 11, 2024,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1674804, 'Sistema', 'Requiere repuestos', NOW()
);

-- Excel Equipo 40: Incubadora CO2
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Incubadora CO2', NULL, 'BIO-16311', '18-013', 'SIU - Cuarto de cultivo', 'Thermo Scientific', 'Series 8000 WJ 3428', '181988-102', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 15, 4
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
    @equipo_id, 'preventivo', 11, 2024,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1149090, 'Sistema', 'Equipo operativo', NOW()
);

-- Excel Equipo 41: Agitador Vortex
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Agitador Vortex', NULL, 'BIO-16308', '15-651', 'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'Labnet', 'S0200', 'Z3121820', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 15, 6
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
    @equipo_id, 'calibracion', 3, 2024,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 554160, 'Sistema', 'Realizado con éxito', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 2, 2022,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 193870, 'Sistema', 'Realizado con éxito', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 4, 2022,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 474104, 'Sistema', 'Requiere repuestos', NOW()
);

-- Excel Equipo 42: Centrífuga refrigerada
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Centrífuga refrigerada', NULL, 'BIO-16756', '18-265', 'SIU - Cuarto de cultivo', 'Eppendorf', '5810R', '0033896', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 15, 5
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
    @equipo_id, 'correctivo', 6, 2022,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 183855, 'Sistema', 'Equipo operativo', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 3, 2023,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 871341, 'Sistema', 'Calibración OK', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 7, 2024,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 1498000, 'Sistema', 'Requiere repuestos', NOW()
);

-- Excel Equipo 43: Balanza Analitica
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Balanza Analitica', NULL, 'BIO-16846', '10-261', 'SIU - Laboratorio Reproducción - Torre 2, Lab 534', 'Adam Equipment', 'NBL 124e', 'AE9UT335', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 16, 1
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
    @equipo_id, 'calibracion', 9, 2023,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 896380, 'Sistema', 'Equipo operativo', NOW()
);

-- Excel Equipo 44: Micropipeta
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', NULL, 'BIO-17234', '15-166', 'SIU - Laboratorio Reproducción - Torre 2, Lab 534', 'Nichirio', 'Nichipet Explus', 'H38014182', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 2, 16, 5
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
    @equipo_id, 'calibracion', 11, 2024,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 1815293, 'Sistema', 'Equipo operativo', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 4, 2022,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 600429, 'Sistema', 'Realizado con éxito', NOW()
);

-- Excel Equipo 45: Micropipeta
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Micropipeta', NULL, 'BIO-16512', '15-166', 'Inmunohistoquímica', 'Sartorius', 'Tacta', '42186226', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 3, 17, 1
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
    @equipo_id, 'calibracion', 1, 2024,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 1395812, 'Sistema', 'Requiere repuestos', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 4, 2024,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 515095, 'Sistema', 'Realizado con éxito', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 5, 2024,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 625197, 'Sistema', 'Calibración OK', NOW()
);

-- Excel Equipo 46: Procesador de tejidos
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Procesador de tejidos', NULL, 'BIO-16504', '15-190', 'Histotécnica', 'Leica', 'TP1020-1-1', '42231412', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 3, 17, 4
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
    @equipo_id, 'preventivo', 11, 2023,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 382590, 'Sistema', 'Calibración OK', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 11, 2024,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 1157900, 'Sistema', 'Requiere repuestos', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 9, 2024,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 685313, 'Sistema', 'Equipo operativo', NOW()
);

-- Excel Equipo 47: Criostato
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Criostato', NULL, 'BIO-16464', '15-157', 'Cuarto criostato', 'Leica', 'CM1860 UV', '00000005299', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 3, 17, 6
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
    @equipo_id, 'preventivo', 8, 2024,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 518852, 'Sistema', 'Realizado con éxito', NOW()
);

-- Excel Equipo 48: Estación de Corte Macro
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Estación de Corte Macro', NULL, 'BIO-16466', 'NT', 'Corte macro', 'Kugel Medical', 'GP 1500', '20.206422.01', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 3, 17, 2
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
    @equipo_id, 'correctivo', 6, 2023,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 181020, 'Sistema', 'Requiere repuestos', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'correctivo', 11, 2023,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 604129, 'Sistema', 'Realizado con éxito', NOW()
);

-- Excel Equipo 49: Estación de inclusión
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Estación de inclusión', NULL, 'BIO-16467', 'NT', 'Histotécnica', 'Leica', 'HistoCore Arcadia H / Arcadia C', '1671 / 2048', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 3, 17, 7
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
    @equipo_id, 'calibracion', 9, 2022,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 1509652, 'Sistema', 'Realizado con éxito', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 5, 2022,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 979384, 'Sistema', 'Calibración OK', NOW()
);

-- Excel Equipo 50: Refrigerador-congelador mixto
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Refrigerador-congelador mixto', NULL, 'Pendiente', 'NT', 'Hospital Universitario San Vicente Fundación, Bloque 7, Laboratorio de Dermatopatología, Área de procesamiento - Baño de flotación', 'MELING BIOMEDICAL', 'YCD-EL450', '220702139', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 3, 18, 2
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
    @equipo_id, 'preventivo', 3, 2023,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 527854, 'Sistema', 'Calibración OK', NOW()
);

-- Excel Equipo 51: Baño de flotación
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Baño de flotación', NULL, 'BIO-16666', '15 - 107', 'Hospital Universitario San Vicente Fundación, Bloque 7, Laboratorio de Dermatopatología, Área de procesamiento - Baño de flotación', 'KEDEE', 'KD-P', '51A638', 'Extensión', NULL, NULL, NULL, '7 Años', 'Activo', 3, 18, 5
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
    @equipo_id, 'calibracion', 1, 2023,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 246310, 'Sistema', 'Calibración OK', NOW()
);

-- Excel Equipo 52: Termohigrómetro digital
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Termohigrómetro digital', NULL, 'BIO-16685', 'NT', 'Hospital Universitario San Vicente Fundación, Bloque 7, Laboratorio de Dermatopatología, Cuarto de inmunofluorecencia', 'Clock-Humidity', 'HTC-2', 'N/I', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 3, 18, 1
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
    @equipo_id, 'correctivo', 6, 2023,
    'Mantenimiento correctivo de rutina.', 'Proveedor Externo', 204131, 'Sistema', 'Realizado con éxito', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 8, 2022,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 672898, 'Sistema', 'Requiere repuestos', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 3, 2024,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 1302931, 'Sistema', 'Calibración OK', NOW()
);

-- Excel Equipo 53: Termohigrómetro digital
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Termohigrómetro digital', NULL, 'BIO-16686', 'NT', 'Hospital Universitario San Vicente Fundación, Bloque 7, Laboratorio de Dermatopatología, Área de procesamiento', 'BOECO Germany', 'BOE330', 'N/I', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 3, 18, 7
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
    @equipo_id, 'preventivo', 1, 2024,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1374615, 'Sistema', 'Calibración OK', NOW()
);

-- Excel Equipo 54: Microscopio y Cámara Leica
INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (
    'Microscopio y Cámara Leica', NULL, 'BIO-16681', '15 - 156', 'Hospital Universitario San Vicente Fundación, Bloque 7, Laboratorio de Dermatopatología, Cuarto de inmunofluorecencia', 'Leica', 'DM500', 'C540242931LS0390', 'Extensión', NULL, NULL, NULL, 'NI', 'Activo', 3, 18, 7
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
    @equipo_id, 'preventivo', 6, 2024,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1353869, 'Sistema', 'Requiere repuestos', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'preventivo', 9, 2023,
    'Mantenimiento preventivo de rutina.', 'Proveedor Externo', 1091702, 'Sistema', 'Requiere repuestos', NOW()
);
INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, 'calibracion', 4, 2022,
    'Mantenimiento calibracion de rutina.', 'Proveedor Externo', 206730, 'Sistema', 'Requiere repuestos', NOW()
);

