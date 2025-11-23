"""
Script para fusionar y enriquecer datos de equipos para LIME
Combina datos manuales de alta calidad con datos masivos de Excel,
generando información sintética para pruebas robustas.
Incluye ejemplos de MultiSelectField en 'clasificacion_misional'.
"""

import pandas as pd
import random
from datetime import datetime, timedelta
import sys

# Configuración
EXCEL_FILE = r"c:\Users\jjcor\OneDrive\Documents\Proyecto-LIME\Proyecto-LIME\F-147 INVENTARIO EQUIPOS BIOMÉDICOS, INDUSTRIALES Y GASES V4.xlsx"
OUTPUT_SQL = r"c:\Users\jjcor\OneDrive\Documents\Proyecto-LIME\Proyecto-LIME\migracion_datos_lime.sql"
SKIP_ROWS = 8

# Datos maestros
SEDES = [
    (1, 'Prado', 'Hospital Alma Mater de Antioquia, Bloque B', 'Medellín', 'Por definir', 1),
    (2, 'SIU', 'Torre 1 y Torre 2, Sede de Investigación Universitaria', 'Medellín', 'Por definir', 1),
    (3, 'San Vicente', 'Hospital Universitario San Vicente Fundación', 'Medellín', 'Por definir', 1)
]

SERVICIOS = [
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
    (18, 'Dermatopatología', 'Laboratorio de Dermatopatología', 'Diana Meneses', 1, 3)
]

RESPONSABLES = [
    (1, 'Gloria Zapata', 'gloria.zapata@udea.edu.co', '555-0101', 'Coordinadora'),
    (2, 'Vanessa Santiago', 'vanessa.santiago@udea.edu.co', '555-0102', 'Analista'),
    (3, 'Duvan Gallego', 'duvan.gallego@udea.edu.co', '555-0103', 'Auxiliar'),
    (4, 'Andrés Zuluaga', 'andres.zuluaga@udea.edu.co', '555-0104', 'Recepcionista'),
    (5, 'Carlos Muñetón', 'carlos.muneton@udea.edu.co', '555-0105', 'Investigador'),
    (6, 'Ivone Jimenez', 'ivone.jimenez@udea.edu.co', '555-0106', 'Investigadora'),
    (7, 'Juan José Serrano', 'juan.serrano@udea.edu.co', '555-0107', 'Investigador')
]

# Mapeos
SEDES_MAP = {'Prado': 1, 'SIU': 2, 'San Vicente': 3}
SERVICIOS_MAP = {s[1]: s[0] for s in SERVICIOS}
RESPONSABLES_IDS = [r[0] for r in RESPONSABLES]

# Equipos Manuales (Series para evitar duplicados)
MANUAL_SERIES = [
    '9053127', '630604801', '0000189', '25407', 'MH12168', 
    '8D07016', '100406', 'B512345678', 'GN30-2023-789'
]

# Bloque SQL Manual con ejemplos de MultiSelectField
MANUAL_SQL_BLOCK = """
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
"""

def clean_value(value):
    if pd.isna(value) or value == '' or value == 'N/A' or value == 'NA':
        return 'NULL'
    if isinstance(value, (int, float)):
        return str(value)
    return f"'{str(value).strip().replace("'", "''")}'"

def clean_bool(value):
    if pd.isna(value): return '0'
    val = str(value).upper()
    return '1' if val in ['SI', 'SÍ', 'YES', '1', 'TRUE', 'X'] else '0'

def generate_history(equipo_id, fecha_base=None):
    """Genera historial de mantenimiento sintético"""
    history_sql = []
    
    # Decidir cuántos mantenimientos (1 a 3)
    num_maint = random.randint(1, 3)
    
    tipos = ['preventivo', 'correctivo', 'calibracion']
    estados = ['Realizado con éxito', 'Requiere repuestos', 'Equipo operativo', 'Calibración OK']
    
    current_year = 2024
    
    for _ in range(num_maint):
        tipo = random.choice(tipos)
        mes = random.randint(1, 11)
        anio = current_year - random.randint(0, 2)
        
        desc = f"Mantenimiento {tipo} de rutina."
        costo = random.randint(100000, 2000000)
        obs = random.choice(estados)
        
        sql = f"""INSERT INTO `historial_mantenimientos` (
    `equipo_id`, `tipo_mantenimiento`, `mes_mantenimiento`, `anio_mantenimiento`,
    `descripcion`, `realizado_por`, `costo`, `usuario_registro`, `observaciones`, `created_at`
) VALUES (
    @equipo_id, '{tipo}', {mes}, {anio},
    '{desc}', 'Proveedor Externo', {costo}, 'Sistema', '{obs}', NOW()
);"""
        history_sql.append(sql)
        
    return "\n".join(history_sql)

def main():
    print("Iniciando fusión de datos...")
    
    # 1. Leer Excel
    try:
        df = pd.read_excel(EXCEL_FILE, sheet_name='Hoja1', skiprows=SKIP_ROWS)
        print(f"Leídos {len(df)} registros del Excel")
    except Exception as e:
        print(f"Error leyendo Excel: {e}")
        return
    
    with open(OUTPUT_SQL, 'w', encoding='utf-8') as f:
        # Header
        f.write("-- SCRIPT GENERADO AUTOMÁTICAMENTE: FUSIÓN MANUAL + EXCEL\n")
        f.write(f"-- Fecha: {datetime.now()}\n\n")
        f.write("USE `lime_db`;\nSET FOREIGN_KEY_CHECKS = 0;\n\n")
        
        # Truncates
        tables = ['historial_mantenimientos', 'historial_traslados', 
                 'equipos_condicionesfuncionamiento', 'equipos_informacionmetrologica',
                 'equipos_documentacionequipo', 'equipos_registroadquisicion',
                 'equipos_equipo', 'servicios', 'sedes', 'responsables_responsable']
        for t in tables:
            f.write(f"TRUNCATE TABLE `{t}`;\n")
        
        f.write("\nSET FOREIGN_KEY_CHECKS = 1;\n\n")
        
        # 2. Insertar Maestros
        f.write("-- 1. SEDES\n")
        f.write("INSERT INTO `sedes` (`id`, `nombre`, `direccion`, `ciudad`, `telefono`, `estado`) VALUES\n")
        values = [f"({s[0]}, '{s[1]}', '{s[2]}', '{s[3]}', '{s[4]}', {s[5]})" for s in SEDES]
        f.write(",\n".join(values) + ";\n\n")
        
        f.write("-- 2. SERVICIOS\n")
        f.write("INSERT INTO `servicios` (`id`, `nombre`, `descripcion`, `responsable`, `estado`, `sede_id`) VALUES\n")
        values = [f"({s[0]}, '{s[1]}', '{s[2]}', '{s[3]}', {s[4]}, {s[5]})" for s in SERVICIOS]
        f.write(",\n".join(values) + ";\n\n")
        
        f.write("-- 3. RESPONSABLES\n")
        f.write("INSERT INTO `responsables_responsable` (`id`, `nombre_completo`, `email`, `telefono`, `rol`) VALUES\n")
        values = [f"({r[0]}, '{r[1]}', '{r[2]}', '{r[3]}', '{r[4]}')" for r in RESPONSABLES]
        f.write(",\n".join(values) + ";\n\n")
        
        # 3. Insertar Equipos Manuales (Desde bloque embebido)
        f.write(f"\n-- ============================================\n-- 4. EQUIPOS MANUALES (Alta Calidad)\n-- ============================================\n")
        f.write(MANUAL_SQL_BLOCK)
        
        # 4. Procesar Excel (Filtrando duplicados y enriqueciendo)
        f.write("\n-- ============================================\n-- 5. EQUIPOS IMPORTADOS DESDE EXCEL (Enriquecidos)\n-- ============================================\n")
        
        count_excel = 0
        for idx, row in df.iterrows():
            serie = str(row.get('Serie', '')).strip()
            
            # Filtrar duplicados
            if serie in MANUAL_SERIES:
                print(f"Saltando duplicado manual: {serie}")
                continue
                
            # Datos básicos
            nombre = clean_value(row.get('Nombre del equipo', ''))
            if nombre == 'NULL': continue
            
            sede_id = SEDES_MAP.get(row.get('Sede', ''), 1)
            servicio_id = SERVICIOS_MAP.get(row.get('Proceso', ''), 1)
            
            # Asignar responsable aleatorio si no existe
            resp_id = random.choice(RESPONSABLES_IDS)
            
            f.write(f"-- Excel Equipo {idx+1}: {row.get('Nombre del equipo')}\n")
            f.write("INSERT INTO `equipos_equipo` (`nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`, `ubicacion_fisica`, `marca`, `modelo`, `serie`, `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`, `registro_invima`, `tiempo_vida_util`, `estado`, `sede_id`, `servicio_id`, `responsable_id`) VALUES (\n")
            
            vals = [
                nombre,
                clean_value(row.get('Código de inventario interno del laboratorio y/o a', '')),
                clean_value(row.get('Código IPS', '')),
                clean_value(row.get('Código ECRI', '')),
                clean_value(row.get('Ubicación física', '')),
                clean_value(row.get('Marca', '')),
                clean_value(row.get('Modelo', '')),
                clean_value(serie),
                clean_value(row.get('Clasificación misional', 'Extensión')),
                clean_value(row.get('Clasificación IPS', '')),
                clean_value(row.get('Clasificación de riesgo', '')),
                clean_value(row.get('Registro INVIMA', '')),
                clean_value(row.get('Tiempo de vida útil', '')),
                "'Activo'",
                str(sede_id), str(servicio_id), str(resp_id)
            ]
            f.write("    " + ", ".join(vals) + "\n);\n")
            f.write("SET @equipo_id = LAST_INSERT_ID();\n\n")
            
            # Tablas relacionadas (simplificadas con datos del Excel o defaults)
            # Adquisición
            f.write("INSERT INTO `equipos_registroadquisicion` (`equipo_id`, `fecha_adquisicion`, `propietario`, `forma_adquisicion`, `en_garantia`) VALUES (@equipo_id, NULL, 'UdeA', 'Compra', 0);\n")
            
            # Documentación
            f.write(f"INSERT INTO `equipos_documentacionequipo` (`equipo_id`, `hoja_vida`, `manual_operacion`) VALUES (@equipo_id, {clean_bool(row.get('Hoja de vida'))}, {clean_bool(row.get('Manual de operación'))});\n")
            
            # Metrología
            f.write("INSERT INTO `equipos_informacionmetrologica` (`equipo_id`, `requiere_mantenimiento`, `frecuencia_mantenimiento`, `requiere_calibracion`) VALUES (@equipo_id, 1, 'Anual', 0);\n")
            
            # Condiciones
            f.write("INSERT INTO `equipos_condicionesfuncionamiento` (`equipo_id`, `voltaje`) VALUES (@equipo_id, '110V');\n")
            
            # HISTORIAL SINTÉTICO
            f.write(generate_history(None) + "\n\n")
            
            count_excel += 1
            
        print(f"Procesados {count_excel} equipos nuevos del Excel")

if __name__ == "__main__":
    main()
