-- ============================================================================
-- SCRIPT GENERADO AUTOMÁTICAMENTE DESDE EXCEL
-- Fecha de generación: 2025-11-22 23:49:48
-- Total de equipos: 54
-- ============================================================================

USE `lime_db`;

-- Deshabilitar validación de foreign keys temporalmente
SET FOREIGN_KEY_CHECKS = 0;

-- EQUIPO 1: Congelador
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Congelador', NULL, 'Pendiente', '15 - 583',
    'Procesamiento Seccion C', 'Challenger', 'CV430', 9053127,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 1, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 47736, 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura', 'T -18', 'NI', '0 a - 33 ° C',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '115 VAC', 'NI', 'NI', 'Max 38°C',
    '53,5 x 53 x 142 cm', '55,5 kg', 'NI'
);

-- EQUIPO 2: Agregometro
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Agregometro', NULL, 'BIO-12183', 'NT',
    'Procesamiento Seccion A', 'Helena Laboratories', 'AGGRAM', 630604801,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 2, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 96442, 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 1, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Absorbancia', '0 - 2 DE', 'NI', '0 - 2 DE',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '110 VAC', 'NI', 'NI', '15 - 30 °C',
    '15,24 cm x 25,40 cm x 43,18 cm (alto x ancho x profundidad)', '6,75 Kg', 'Frecuencia 50/60 Hz'
);

-- EQUIPO 3: Centrífuga refrigerada
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Centrífuga refrigerada', NULL, 'BIO-12186', '10 - 780',
    'Área centrífugas', 'BOECO - HETTICH', 'U-320R', '0000189',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 2, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', '006093', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'vacio', 'Max. 15000 rpm (según folleto)               Max. 5000 rpm (evidencia)                             T -20 a 40°C', '10 rpm                    1°C', '1000 - 4500 rpm',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '200 - 240 V', '4 A', 'NI', 'NI',
    '346 x 401 x 695 mm', '53 kg', 'NI'
);

-- EQUIPO 4: Analizador de coagulación automatizado - Equipo de Hemostasia
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Analizador de coagulación automatizado - Equipo de Hemostasia', NULL, 'BIO-16281', '15 - 098',
    'Procesamiento Seccion A', 'SYSMEX', 'CS2500', 25407,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 2, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'TE57569', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 1, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '100 - 240 VAC', 'NI', '30 - 85 %HR', '15 - 30 °C',
    'Unidad principal                           775 x 895 x 685 mm                        Unidad neumática                             280 x 355 x 400 mm', 'Unidad principal                           110 kg                                                    Unidad neumática                             17 kg', 'NI'
);

-- EQUIPO 5: Micropipeta
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Micropipeta', NULL, 'BIO-12193', '15 - 166',
    'Procesamiento Seccion A', 'Thermo Scientific', 'Finnpipette F1', 'MH12168',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 2, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'C7206', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Volumen', '100 - 1000 uL', '1 uL', '100 - 1000 ul',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 6: Micropipeta
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Micropipeta', NULL, 'BIO-12194', '15 - 166',
    'Procesamiento Seccion A', 'Thermo Scientific', 'Finnpipette F1', 'MH12173',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 2, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'C7206', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Volumen', '100 - 1000 uL', '1 uL', '100 - 1000 ul',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 7: Micropipeta
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Micropipeta', NULL, 'BIO-12198', '15 - 166',
    'Procesamiento Seccion A', 'Thermo Scientific', 'Finnpipette F1', 'MH12148',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 2, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'C7206', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Volumen', '20 - 200 uL', '0,2 uL', '20 - 200 ul',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 8: Agitador Vórtex
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Agitador Vórtex', NULL, 'BIO-12129', '15 - 651',
    'Procesamiento Seccion A', 'Boeco', 'Vortex V1 Plus', '1020313061616',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 3, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'CR 00080017', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Velocidad', '750 - 3000 rpm', 'Perilla sin indicación', '750 - 3000 rpm',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '100 - 240 VAC', 'NI', '80% max. con T hasta 31°C     50% con T hasta 40°C', '4 - 40 °C',
    '90 x 150 x 80 mm', '0,8 kg', 'NI'
);

-- EQUIPO 9: Baño María
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Baño María', NULL, 'BIO-12130', '16 - 861',
    'Procesamiento Seccion B', 'Indulab', '09-A', 13834,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 3, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 6142, 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura', '37 - 90°C', '0,1 °C', '37 - 90 °C',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '110 VAC', 'NI', 'NI', 'NI',
    'NI', 'NI', 'NI'
);

-- EQUIPO 10: Centrífuga
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Centrífuga', NULL, 'BIO-12131', '10 - 778',
    'Área centrífugas', 'Hettich', 'Rotofix 32A', '006965-04',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 3, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'CR 00081028', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 1, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Velocidad', '500rpm - maximo hasta 6000 rpm (depende del rotor)
1 - 99 minutos', '100 rpm
1 min', 'NI',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '100 - 127 V', '3 A', '80% max. con T hasta 31°C     50% con T hasta 40°C', '2 - 40 °C',
    '366 x 430 x 257 mm', '23 kg', 'NI'
);

-- EQUIPO 11: Microcentrifuga refrigerada
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Microcentrifuga refrigerada', NULL, 'BIO-16289', '17 - 452',
    'Área centrífugas', 'HERMLE', 'Z 216 MK', 61165050,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 1, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'MRE 10890', 29155000
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Velocidad/ Tiempo / Temperatura', 'Velocidad: 200 - 15000 rpm (la velocidad maxima varia dependindo del rotor 13500, 14500 o 15000)
Tiempo: 10 seg hasta 99 horas 59 min.
Temperatura: -20°C a +40°C.', 'Temperatura : 1°C', NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 12: Congelador
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Congelador', NULL, 'Pendiente', '15 - 583',
    'Hospital Alma Mater de antioquia, sede ambulatoria Prado, Bloque B, segundo piso, Almacen', 'Infrico', 'LTF40SD', 3000957831,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 1, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'E 160790', 18203002
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura', '2 - 8 °C', '1 °C', '2 - 8 °C',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 13: Fonendoscopio
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Fonendoscopio', NULL, 'BIO-16800', '13 - 750',
    'Recepcion', 'GMD', 'GMD30-DCK', 'IMP-1163',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 5, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'FE-7405', 104000
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 14: Centrífuga refrigerada
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Centrífuga refrigerada', NULL, 'BIO-12250', '18 - 270',
    'Biologia Molecular (Extraccion)', 'Sigma', '3-16K', 110639,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 6, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', '2005-32874', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 1, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura                                           Tiempo                                                Velocidad', 'T -10 a 40°C                                             0 - 30 min/funcionamiento continuo/
operación de corta duración                                        100 - 15300 rpm', '1°C                                                                                                     1min                                                                                            100 rpm', '18 a 22°C                                                          15 a 25 min                                                                     1200 a 14000 rpm',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 15: Balanza Analítica
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Balanza Analítica', NULL, 'BIO-16749', '18 - 449',
    'BSL3 (Procesamiento)', 'ViBRA', 'HT224CEN', 215022050,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 7, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'MRE14352', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 1, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Peso', '0,01 - 220 g', 'NI', 'NI',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, 'Adaptador entreda            100 - 240 VAC                      salida 12VDC', 'NI', 'Máx. 80%HR', '10 - 30 °C',
    '213 x 314 x 395,3 mm (Ancho x Alto x Profundo)', '2,5kg', 'Frecuencia 50 - 60 Hz'
);

-- EQUIPO 16: Incubadora
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Incubadora', NULL, 'BIO-12256', '18 - 013',
    'Citogenomica (Preanalitica)', 'Binder', 'BD53-UL', 908707,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 8, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'CR 00049421', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura', '5 °C por 
encima de la temperatura ambiente - 100 °C', '0,1 °C', '36,5°C-37,5°C',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 17: Filmarray
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Filmarray', NULL, 'BIO-16698', 'NI',
    'Microbiología 1', 'BIOFIRE', 'FilmArray Torch (ref: HTFA-ASY-0104)', 'TB03545',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 9, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura                        Reporte de instalación', 'FE23094 00728988', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 1, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '120 VAC', '3,2 A (2 modulos)', '20 - 80 %HR', '15 - 30 °C',
    '458 x 737 x 292 mm', '29,9 kg', 'Frecuencia 50 - 60 Hz'
);

-- EQUIPO 18: Maglumi
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Maglumi', NULL, 'BIO-16303', 'NI',
    'Procesamiento Seccion B', 'SNIBE', 'MAGLUMI 600', '0101010003022000165',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 10, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, '2020-12-14', 'UdeA',
    NULL, NULL, 0, NULL,
    'Apoyo tecnológico', 'Acta de entrega', 2930, 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 1, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '100 - 240 VAC', NULL, NULL, NULL,
    NULL, NULL, 'Frecuencia 50/60 Hz Potencia 350 VA'
);

-- EQUIPO 19: Micropipeta
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Micropipeta', NULL, 'BIO-12177', '15 - 166',
    'Procesamiento Seccion C', 'Corning', 'Lambda Plus', 658220168,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 11, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'MRC2303', 788800
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Volumen', '0,5 - 10 ul', '0,02 uL', '0,5- 10 µl',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 20: Resonador magnetico
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Resonador magnetico', NULL, 'BIO-15348', 'NT',
    'Hospital Alma Mater de Antioquia, Bloque B, primer piso, Centro de resonancia', 'PHILIPS', 'INGENIA ELITION X', 45555,
    'Extensión', NULL, NULL,
    NULL, '10 años', 'Activo',
    1, 12, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Contrato y Acta de entrega del bien mueble', 'LATAM_109371', '$1.957.500 USD más IVA'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 1, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 21: CAMARA DE FOTOTERAPIA
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'CAMARA DE FOTOTERAPIA', NULL, 'BIO-100561', '13-037',
    'Hospital Alma Mater de Antioquia, Bloque A, segundo piso, FOTOTERAPIA', 'DAAVLIN', 'P3251-SNBPC-0048', '3SERIES PC31148',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 13, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'NI', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 0, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 22: CAMARA DE FOTOTERAPIA
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'CAMARA DE FOTOTERAPIA', NULL, 'BIO-102003', '13-037',
    'Hospital Alma Mater de Antioquia, Bloque A, segundo piso, FOTOTERAPIA', 'DAAVLIN', 'P3526A1X4800', '3SERIES X350-48',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    1, 13, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'NI', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 0, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 23: Agitador vortex
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Agitador vortex', NULL, 'BIO-16857', '15-651',
    'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'SCIENTIFIC INDUSTRIES /GENIE 2', 'G-560', '2-374976',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 14, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', '001807', 1276000
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Velocidad', 'Perilla de posiciones (1 a 10)', 'NI', 'NI',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '120 VAC', '0,65 A', 'Máx. 95%HR', '0 - 38 °C',
    '165 x 122 x 165 mm (profundo x ancho x alto)', '4 kg', 'Frecuencia 60 Hz'
);

-- EQUIPO 24: Balanza analítica
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Balanza analítica', NULL, 'BIO-16858', '18-449',
    'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'PRECISA', 'LS220A', 7001460,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 14, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 144593, 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Masa', 'Máx. 220 g', '0,1 mg', 'NI',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, 'Entrada adaptador 90 - 264 VAC Entrada equipo desde adaptador 12 VDC', 'Entrada equipo desde adaptador 1,5 A', '25% a 85% (sin condensar)', '0°C a 40°C',
    '228 x 381 x 345 mm (ancho x largox alto)', '6,6 kg', 'Frecuencia de entrada a adaptador 47 - 63 Hz'
);

-- EQUIPO 25: Cabina de extracción
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Cabina de extracción', NULL, 'BIO-16859', 'NT',
    'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'C4', 'CEX 120', 100406,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 14, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Histórico de reportes de mantenimiento', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '110 VAC', 'NI', 'NI', 'NI',
    '1200 X 1800 X 1519 cm 
(ancho x fondo x alto)', 'NI', 'Frecuencia 50 / 60 Hz'
);

-- EQUIPO 26: Calentador seco
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Calentador seco', NULL, 'BIO-16860', 'NT',
    'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'BOEKEL', 113002, '0233 12871',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 14, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Histórico de reportes de mantenimiento y hojas de vida anteriores', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura', '5 - 120 °C', '5 - 120 °C', 'NI',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '115 VAC', '1,75 A', 'NI', 'NI',
    'NI', 'NI', 'Potencia 200 W Frecuencia 60 Hz'
);

-- EQUIPO 27: Incubadora
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Incubadora', NULL, 'BIO-16868', '18-013',
    'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'MEMMERT', 'TV10', 599033,
    'Extensión', NULL, NULL,
    NULL, '10 años', 'Activo',
    2, 14, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Histórico de reportes de mantenimiento', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura', NULL, NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '120 VAC', 'NI', 'NI', 'NI',
    'NI', 'NI', 'Potencia 1400 W'
);

-- EQUIPO 28: Luminex
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Luminex', NULL, 'BIO-16869', 'NT',
    'SIU - Laboratorio trasplantes - Torre 1, Lab 410', 'LUMINEX', 'Luminex LX 100/ 200', 'LX10017065423',
    'Extensión', NULL, NULL,
    NULL, '10 años', 'Activo',
    2, 14, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, '2017-03-06', 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 5220, 292320000
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 1, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Longitud de onda', 'laser reportero 532nm y laser clasficador 635nm', 'NI', 'NI',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '100 - 120 VAC / 200 - 240 VAC', '1,4 A / 0,8 A', '20 % A 80% HR, sin condensación', '15 - 30 °C',
    '43 x 50,5 x 24,5 cm (ancho x profundidad x alto)', '25 kg', 'Frecuencia 47 - 63 Hz'
);

-- EQUIPO 29: Micropipeta
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Micropipeta', NULL, 'BIO-16875', '15-166',
    'SIU - Laboratorio trasplantes - Torre 1, Lab 410 - (Post-PCR)', 'GILSON', 'P-1000', 'Y51513C',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 14, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Hojas de vida anteriores', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Volumen', '200 - 1000 ul', '2 uL', '200 - 1000 ul',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 30: Micropipeta
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Micropipeta', NULL, 'BIO-16876', '15-166',
    'SIU - Laboratorio trasplantes - Torre 1, Lab 410 - (PRE-PCR) Backup1', 'GILSON', 'P-1000', 'X63933E',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 14, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Histórico de reportes de mantenimiento', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Volumen', '200 - 1000 ul', '2 uL', '200 - 1000 ul',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 31: Micropipeta
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Micropipeta', NULL, 'BIO-16877', '15-166',
    'SIU - Laboratorio trasplantes - Torre 1, Lab 410 - (PRE-PCR) Backup2', 'GILSON', 'P-1000', 'CB63839',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 14, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Histórico de reportes de mantenimiento', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Volumen', '200 - 1000 ul', '2 uL', '200 - 1000 ul',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 32: Micropipeta
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Micropipeta', NULL, 'BIO-16878', '15-166',
    'SIU - Laboratorio trasplantes - Torre 1, Lab 410 -  (PRE-PCR)', 'GILSON', 'P-1000', 'X62492E',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 14, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'NI', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Volumen', '200 - 1000 ul', '2 uL', '200 - 1000 ul',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 33: Refrigerador
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Refrigerador', NULL, 'Pendiente', '17-157',
    'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'FAGOR', 'AFP701', '06060075M',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 15, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', '010190', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura', 'T - 2 a 8 °C', 'NI', 'NI',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '220 VAC', 'NI', 'NI', 'Máx. 43°C',
    '693 x 726 x 2067 mm', '110 kg', 'Potencia 208 W Frecuencia 50/60 Hz'
);

-- EQUIPO 34: Lector de platos ELISA
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Lector de platos ELISA', NULL, 'BIO-16759', '16-979',
    'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'BioRad', 'iMark', 15486,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 15, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', '12-065', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Longitud de onda', '400 - 750 nm', NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '120 VAC', 'NI', 'Máx. 90%HR', '15 - 40 °C',
    '346 mm x 377 mm x 164 mm (ancho x profundidad x altura)', '5,5 kg', 'Frecuencia 50/60 Hz Potencia 100 VA'
);

-- EQUIPO 35: Lavador de platos de ELISA
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Lavador de platos de ELISA', NULL, 'BIO-16760', '17-489',
    'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'Awareness Technology', 'Stat Fax 2600', '2600-7447',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 15, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'SAS-144963', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '110-120 / 220-240 VAC', 'NI', '80%HR para temperaturas de hasta 31 ° C, disminuyendo linealmente a 50%HR a 40°C', '5 - 40 °C',
    '34,3 cm x 40,6 cm x 19 cm', '10 kg', 'Potencia 70 W Frecuencia 50/60 Hz'
);

-- EQUIPO 36: Microscopio
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Microscopio', NULL, 'BIO-16761', '12-536',
    'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'OLYMPUS', 'CX21FS1', '8D07016',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 15, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', '006823', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '100-120/220-240 VAC', '0,42/0,25 A', '80%HR para temperaturas de hasta 31 ° C, disminuyendo linealmente a 50%HR a 40°C', '5 - 40 °C',
    '154 x 391 x 238 mm', '5,9 kg', 'Frecuencia 50/60 Hz'
);

-- EQUIPO 37: Microscopio
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Microscopio', NULL, 'BIO-16811', '12-536',
    'SIU - Cuarto de cultivo', 'OLYMPUS', 'CX21FS1', '8F11617',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 15, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', '006823', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '100-120/220-240 VAC', '0,42/0,25 A', '80%HR para temperaturas de hasta 31 ° C, disminuyendo linealmente a 50%HR a 40°C', '5 - 40 °C',
    '154 x 391 x 238 mm', '5,9 kg', 'Frecuencia 50/60 Hz'
);

-- EQUIPO 38: Baño María
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Baño María', NULL, 'BIO-16307', '16-861',
    'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'Memmert', 'WNB 7', 'L211.1357',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 15, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'IM011571', 2648280
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura         Tiempo', '10 - 95 °C         99:59 hrs:min', '0,1 °C', 'NI',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '115 VAC', '10,4 A', 'Máx. 80% HR', '5 - 40 °C',
    'Altura 337 mm X  Largo 468 mm X Ancho 356 mm', '11 kg', 'Potencia 1200 W                                                                              Frecuencia 50/60 Hz'
);

-- EQUIPO 39: Baño María
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Baño María', NULL, 'BIO-16755', '16-861',
    'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'Memmert', 'WNB 7', 'L211.1359',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 15, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'IM011571', 2648280
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura         Tiempo', '10 - 95 °C         99:59 hrs:min', '0,1 °C', 'NI',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '115 VAC', '10,4 A', 'Máx. 80% HR', '5 - 40 °C',
    'Altura 337 mm X  Largo 468 mm X Ancho 356 mm', '11 kg', 'Potencia 1200 W                                                                              Frecuencia 50/60 Hz'
);

-- EQUIPO 40: Incubadora CO2
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Incubadora CO2', NULL, 'BIO-16311', '18-013',
    'SIU - Cuarto de cultivo', 'Thermo Scientific', 'Series 8000 WJ 3428', '181988-102',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 15, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, '2013-08-08', 'UdeA',
    NULL, NULL, 0, NULL,
    'Donación', 'Factura', 'F-8502', 17933600
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura         %CO2', '5ºC sobre la temperatura ambiente hasta 55ºC                             0 - 20 %CO2', '0,1 °C / 0,1 %CO2', 'NI',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '115 VAC', '3,60 A', '80 %HR hasta 31 °C, decreciendo linealmente hasta 50 %HR a 40°C', '5 - 40 °C',
    '66,8cm x 100,3cm x 635cm', '120,2 kg', 'Frecuencia 50/60 Hz'
);

-- EQUIPO 41: Agitador Vortex
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Agitador Vortex', NULL, 'BIO-16308', '15-651',
    'SIU - Laboratorio de Inmunodeficiencias primarias - Torre 2, Lab 530', 'Labnet', 'S0200', 'Z3121820',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 15, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 16028, 501120
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Velocidad', 'Máx. 3400 rpm (60 Hz) / 2850 rpm (50 Hz)', 'NI', 'NI',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '120 VAC', '0,6 A', 'NI', '4 - 65 °C',
    '14 x 16 x 12 cm', '2,2 kg', 'Frecuencia 60 Hz'
);

-- EQUIPO 42: Centrífuga refrigerada
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Centrífuga refrigerada', NULL, 'BIO-16756', '18-265',
    'SIU - Cuarto de cultivo', 'Eppendorf', '5810R', '0033896',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 15, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'NI', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Velocidad         Temperatura      Tiempo', '200 - 14000 rpm                                                T -9 - 40 °C                                                    1 - 99 min', '10 rpm hasta 5000 rpm, en adelante 100 rpm                                           1°C                                                                                                     1 min', 'NI',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '120 VAC', '12 A', 'Máx. 75 %HR', '10 - 35 °C',
    '700 x 608 x 345 mm', '99 kg', 'Frecuencia 60 Hz  Potencia 1300 W'
);

-- EQUIPO 43: Balanza Analitica
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Balanza Analitica', NULL, 'BIO-16846', '10-261',
    'SIU - Laboratorio Reproducción - Torre 2, Lab 534', 'Adam Equipment', 'NBL 124e', 'AE9UT335',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 16, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Peso', 'carga max. 120 g', '0,0001 g', NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 44: Micropipeta
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Micropipeta', NULL, 'BIO-17234', '15-166',
    'SIU - Laboratorio Reproducción - Torre 2, Lab 534', 'Nichirio', 'Nichipet Explus', 'H38014182',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    2, 16, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Volumen', '2 - 20 uL', NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 45: Micropipeta
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Micropipeta', NULL, 'BIO-16512', '15-166',
    'Inmunohistoquímica', 'Sartorius', 'Tacta', 42186226,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    3, 17, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', '00KK1915', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Volumen', '10 - 100 uL', '0,1 uL', '10 - 100 uL',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 46: Procesador de tejidos
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Procesador de tejidos', NULL, 'BIO-16504', '15-190',
    'Histotécnica', 'Leica', 'TP1020-1-1', 42231412,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    3, 17, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'NI', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura', '45 - 65 °C', '1 °C', NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '100 -120 VAC', NULL, '20 - 80 %HR', '5 - 40 °C',
    'Altura 595 - 780 mm            Diametro tapa 820 mm', '60 kg', NULL
);

-- EQUIPO 47: Criostato
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Criostato', NULL, 'BIO-16464', '15-157',
    'Cuarto criostato', 'Leica', 'CM1860 UV', '00000005299',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    3, 17, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'FE 46070', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 1, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura', '0 a -35 °C', '1 °C', 'T -20 a -22 °C',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '120 - 127 VAC', 'NI', '20 - 60 %HR', '18 - 35 °C',
    '730 x 730 x 1140 mm', '135 kg', 'Frecuencia: 60 Hz  Potencia: 1440 VA'
);

-- EQUIPO 48: Estación de Corte Macro
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Estación de Corte Macro', NULL, 'BIO-16466', 'NT',
    'Corte macro', 'Kugel Medical', 'GP 1500', '20.206422.01',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    3, 17, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Acta de entrega', 'NT', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 1, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '110 VAC', NULL, 'Menor 75 %HR', 'Menor a 25 °C',
    '1500 x 800 x 850/1950 mm', NULL, NULL
);

-- EQUIPO 49: Estación de inclusión
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Estación de inclusión', NULL, 'BIO-16467', 'NT',
    'Histotécnica', 'Leica', 'HistoCore Arcadia H / Arcadia C', '1671 / 2048',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    3, 17, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'NI', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura', 'Arcadia H: 50 - 75°C                                            Arcadia C: - 6°C', 'Arcadia H: 1 °C', 'Arcadia H: 54 - 60°C                                           Arcadia C: - 6°C',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '100 - 120 VAC', 'Arcadia H: 10 A máx.                         Arcadia C: 5 A  máx.', '20 - 80 %HR', '20 - 30 °C',
    'Arcadia H: 384 x 560 x 636 mm Arcadia C: 384 x 400 x 636 mm (Alto x Ancho x Profundo)', 'Arcadia H: 27 kg Arcadia C: 32 kg', NULL
);

-- EQUIPO 50: Refrigerador-congelador mixto
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Refrigerador-congelador mixto', NULL, 'Pendiente', 'NT',
    'Hospital Universitario San Vicente Fundación, Bloque 7, Laboratorio de Dermatopatología, Área de procesamiento - Baño de flotación', 'MELING BIOMEDICAL', 'YCD-EL450', 220702139,
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    3, 18, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'FE13533', 16592631
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 0, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura', 'Refrigeración 
2 a 8 °C
Congelación
- 10 a -26 °C', NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '110 VAC', '3,23 A', NULL, NULL,
    NULL, '144 Kg', 'Frecuencia  60Hz
Volumen 450 L'
);

-- EQUIPO 51: Baño de flotación
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Baño de flotación', NULL, 'BIO-16666', '15 - 107',
    'Hospital Universitario San Vicente Fundación, Bloque 7, Laboratorio de Dermatopatología, Área de procesamiento - Baño de flotación', 'KEDEE', 'KD-P', '51A638',
    'Extensión', NULL, NULL,
    NULL, '7 Años', 'Activo',
    3, 18, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'Factura', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '110 VAC', NULL, NULL, NULL,
    NULL, NULL, 'Frecuencia  60Hz
Potencia 200 W'
);

-- EQUIPO 52: Termohigrómetro digital
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Termohigrómetro digital', NULL, 'BIO-16685', 'NT',
    'Hospital Universitario San Vicente Fundación, Bloque 7, Laboratorio de Dermatopatología, Cuarto de inmunofluorecencia', 'Clock-Humidity', 'HTC-2', 'N/I',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    3, 18, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'NI', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura/Humedad', 'T -10 - 50 °C / 10 - 99 %HR', '0,1 °C / 1% HR', '18°C a 25°C / 40% a 67%.',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 53: Termohigrómetro digital
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Termohigrómetro digital', NULL, 'BIO-16686', 'NT',
    'Hospital Universitario San Vicente Fundación, Bloque 7, Laboratorio de Dermatopatología, Área de procesamiento', 'BOECO Germany', 'BOE330', 'N/I',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    3, 18, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'NI', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, 'Temperatura/Humedad', '0 - 50 °C / 25 - 95 %HR', '1 °C / 1%HR', '18 a 25 °C / 40 a 67 %HR',
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL
);

-- EQUIPO 54: Microscopio y Cámara Leica
-- ----------------------------------------------------------------------------
INSERT INTO `equipos_equipo` (
    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,
    `ubicacion_fisica`, `marca`, `modelo`, `serie`,
    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,
    `registro_invima`, `tiempo_vida_util`, `estado`,
    `sede_id`, `servicio_id`, `responsable_id`
) VALUES (
    'Microscopio y Cámara Leica', NULL, 'BIO-16681', '15 - 156',
    'Hospital Universitario San Vicente Fundación, Bloque 7, Laboratorio de Dermatopatología, Cuarto de inmunofluorecencia', 'Leica', 'DM500', 'C540242931LS0390',
    'Extensión', NULL, NULL,
    NULL, 'NI', 'Activo',
    3, 18, NULL
);

SET @equipo_id = LAST_INSERT_ID();

INSERT INTO `equipos_registroadquisicion` (
    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,
    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,
    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`
) VALUES (
    @equipo_id, NULL, NULL, 'UdeA',
    NULL, NULL, 0, NULL,
    'Compra', 'NI', 'NI', 'NI'
);

INSERT INTO `equipos_documentacionequipo` (
    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,
    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`
) VALUES (
    @equipo_id, 1, 0, 0,
    0, 0, 0, NULL
);

INSERT INTO `equipos_informacionmetrologica` (
    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,
    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,
    `requiere_calibracion`, `frecuencia_calibracion`,
    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`
) VALUES (
    @equipo_id, NULL, NULL, NULL, NULL,
    NULL, 0, NULL,
    0, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO `equipos_condicionesfuncionamiento` (
    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,
    `dimensiones`, `peso`, `otros`
) VALUES (
    @equipo_id, '100 - 240 VAC', NULL, NULL, NULL,
    NULL, NULL, 'Frecuenia 50/60 Hz
Potencia 17W'
);

-- Reactivar validación de foreign keys
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- TOTAL DE EQUIPOS INSERTADOS: 54
-- ============================================================================
