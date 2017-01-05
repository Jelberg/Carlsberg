/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     4/1/2017 8:40:21 p.m.                        */
/*==============================================================*/


drop table CATALOGO_PROVEEDOR_EQ cascade constraints;

drop table CATALOGO_PROVEEDOR_MP cascade constraints;

drop table CERVEZA cascade constraints;

drop table CIUDAD cascade constraints;

drop table COMPOSICION cascade constraints;

drop table CONTRATO cascade constraints;

drop table DESCUENTOPEDIDIOPARAPRODUCCION cascade constraints;

drop table DETALLE_PEDIDO cascade constraints;

drop table DISTRIBUCION_CERVEZA cascade constraints;

drop table EMPRESA cascade constraints;

drop table ENVIOS cascade constraints;

drop table ESTILO cascade constraints;

drop table FABRICA cascade constraints;



drop table MAQUINARIA cascade constraints;

drop table MATERIA_PRIMA cascade constraints;

drop table PAGO cascade constraints;

drop table PAIS cascade constraints;

drop table PEDIDO cascade constraints;

drop table PRESENTACION cascade constraints;

drop table PRESENTACION_CERVEZA cascade constraints;

drop table PRODUCCIONMENSUAL cascade constraints;

drop table PROVEEDORES cascade constraints;

drop table VARIEDAD cascade constraints;

drop table V_C cascade constraints;

--TDA

drop type COMIDA force;
drop type COMIDA_NT force;

drop type CONTACTO force;
drop type CONTACTOS_NT force;

drop type DATOSCUENTA force;
drop type DATOS_CUENTA_NT force;

drop type DISTRIBUCION force;
drop type DISTRIBUCION_NT force;

drop type FORMAPAGO force;
drop type FORMAPAGO_NT force;

drop type MEDIDA force;

drop type PATROCINIO force;
drop type PATROCINIO_NT force;

drop type RECETAPROCESOBASICO force;
drop type RECETAPROCESOBASICO_NT force;

drop type RESULTADOEVALUACION force;
drop type RESULTADOEVALUACION_NT force;

drop type RESUMENHISTORICO force;
drop type RESUMENHISTORICO_NT force;

drop type FOTOS force;
drop type FOTOS_NT force;

DROP TYPE FORMAS_ENVIO_VA;
DROP TYPE ce_ibu_va;

---- SEQUENCE

DROP SEQUENCE seq_ci_id;
DROP SEQUENCE seq_pr_id;
DROP SEQUENCE seq_pa_id;
DROP SEQUENCE seq_dis_id;
DROP SEQUENCE seq_en_id;
DROP SEQUENCE seq_em_id;
DROP SEQUENCE seq_fa_id;
DROP SEQUENCE seq_con_numero;
DROP SEQUENCE seq_ma_id;
DROP SEQUENCE seq_ca_codigo;
DROP SEQUENCE seq_mp_id;
DROP SEQUENCE seq_var_id;
DROP SEQUENCE seq_vc_id;
DROP SEQUENCE seq_cp_id;
DROP SEQUENCE seq_pe_id;
DROP SEQUENCE seq_es_id;
DROP SEQUENCE seq_ce_id;
DROP SEQUENCE seq_pc_id;
DROP SEQUENCE seq_c_id;
DROP SEQUENCE seq_pre_id;
DROP SEQUENCE seq_det_id;
DROP SEQUENCE seq_va_id;
DROP SEQUENCE seq_des_id;
DROP SEQUENCE seq_pag_id;