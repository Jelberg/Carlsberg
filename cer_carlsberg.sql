/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     18/12/2016 9:22:35 p.m.                      */
/*==============================================================*/


alter table CATALOGO_PROVEEDOR_EQ
   drop constraint FK_CATALOGO_ES_PROVEI_MAQUINAR;

alter table CATALOGO_PROVEEDOR_EQ
   drop constraint FK_CATALOGO_PROVEE_PROVEEDO;

alter table CATALOGO_PROVEEDOR_MP
   drop constraint FK_CATALOGO_ES_DE_VAR_VARIEDAD;

alter table CATALOGO_PROVEEDOR_MP
   drop constraint FK_CATALOGO_PROPORCIN_PROVEEDO;

alter table CATALOGO_PROVEEDOR_MP
   drop constraint FK_CATALOGO_SE_UBICA_MATERIA_;

alter table CERVEZA
   drop constraint FK_CERVEZA_SE_CLASIF_ESTILO;

alter table CIUDAD
   drop constraint FK_CIUDAD_SE_ENCUEN_PAIS;

alter table COMPOSICION
   drop constraint FK_COMPOSIC_FORMA_MATERIA_;

alter table COMPOSICION
   drop constraint FK_COMPOSIC_RELATIONS_CERVEZA;

alter table COMPOSICION
   drop constraint FK_COMPOSIC_VARIA_VARIEDAD;

alter table CONTRATO
   drop constraint FK_CONTRATO_CONTRATA_EMPRESA;

alter table CONTRATO
   drop constraint FK_CONTRATO_SE_CONTAC_PROVEEDO;

alter table DESCUENTOPEDIDIOPARAPRODUCCION
   drop constraint FK_DESCUENT_ES_DESCON_PRODUCCI;

alter table DESCUENTOPEDIDIOPARAPRODUCCION
   drop constraint FK_DESCUENT_SE_DESCUE_DETALLE_;

alter table DETALLE_PEDIDO
   drop constraint FK_DETALLE__SE_DESGLO_PEDIDO;

alter table DETALLE_PEDIDO
   drop constraint FK_DETALLE__SE_DETALL_PRESENTA;

alter table DETALLE_PEDIDO
   drop constraint FK_DETALLE__SE_ESPECI_CATALOGO;

alter table DISTRIBUCION
   drop constraint FK_DISTRIBU_SE_COMERC_PAIS;

alter table EMPRESA
   drop constraint FK_EMPRESA_ES_DUENO_EMPRESA;

alter table EMPRESA
   drop constraint FK_EMPRESA_OFICINA_P_CIUDAD;

alter table EMPRESA
   drop constraint FK_EMPRESA_SE_UBICA__CIUDAD;

alter table ENVIOS
   drop constraint FK_ENVIOS_ENVIA_PROVEEDO;

alter table ENVIOS
   drop constraint FK_ENVIOS_ES_ENVIAD_CIUDAD;

alter table FABRICA
   drop constraint FK_FABRICA_POSEE_EMPRESA;

alter table FABRICA
   drop constraint FK_FABRICA_SE_LOLALI_CIUDAD;

alter table PAGO
   drop constraint FK_PAGO_SE_CANCEL_PEDIDO;

alter table PEDIDO
   drop constraint FK_PEDIDO_SE_GENERA_CONTRATO;

alter table PRESENTACION
   drop constraint FK_PRESENTA_PRESENTA_CATALOGO;

alter table PRESENTACION_CERVEZA
   drop constraint FK_PRESENTA_SE_PRESEN_CERVEZA;

alter table PRODUCCIONMENSUAL
   drop constraint FK_PRODUCCI_PRODUCE_FABRICA;

alter table PRODUCCIONMENSUAL
   drop constraint FK_PRODUCCI_SE_PRODUC_PRESENTA;

alter table PROVEEDORES
   drop constraint FK_PROVEEDO_ES_DE_PAIS;

alter table VALORACION_PEDIDO
   drop constraint FK_VALORACI_SE_VALORA_DETALLE_;

alter table VARIEDAD
   drop constraint FK_VARIEDAD_RELATIONS_MATERIA_;

alter table V_C
   drop constraint FK_V_C_ES_LOCALI_PAIS;

alter table V_C
   drop constraint FK_V_C_SE__LOCAL_VARIEDAD;

drop index ES_PROVEIDA_FK;

drop index PROVEE_FK;

drop table CATALOGO_PROVEEDOR_EQ cascade constraints;

drop index ES_DE_VARIEDAD_FK;

drop index SE_UBICA_FK;

drop index PROPORCINA_FK;

drop table CATALOGO_PROVEEDOR_MP cascade constraints;

drop index SE_CLASIFICA_FK;

drop table CERVEZA cascade constraints;

drop index SE_ENCUENTRA_FK;

drop table CIUDAD cascade constraints;

drop table COMIDA cascade constraints;

drop index RELATIONSHIP_36_FK;

drop index VARIA_FK;

drop index FORMA_FK;

drop table COMPOSICION cascade constraints;

drop table CONTACTO cascade constraints;

drop index SE_CONTACTA_FK;

drop table CONTRATO cascade constraints;

drop table DATOSCUENTA cascade constraints;

drop index ES_DESCONTADO_FK;

drop index SE_DESCUENTA_FK;

drop table DESCUENTOPEDIDIOPARAPRODUCCION cascade constraints;

drop index SE_ESPECIFICA_FK;

drop index SE_DETALLA_FK;

drop index SE_DESGLOSA_FK;

drop table DETALLE_PEDIDO cascade constraints;

drop index SE_COMERCIALIZA_FK;

drop table DISTRIBUCION cascade constraints;

drop index OFICINA_PRINCIPAL_EN_FK;

drop index ES_DUENO_FK;

drop index SE_UBICA_EN_FK;

drop table EMPRESA cascade constraints;

drop index ENVIA_FK;

drop index ES_ENVIADA_FK;

drop table ENVIOS cascade constraints;

drop table ESTILO cascade constraints;

drop index SE_LOLALIZA_FK;

drop index POSEE_FK;

drop table FABRICA cascade constraints;

drop table FOMA_PAGO cascade constraints;

drop table MAQUINARIA cascade constraints;

drop table MATERIA_PRIMA cascade constraints;

drop table MEDIDA cascade constraints;

drop table MUESTRA cascade constraints;

drop index SE_CANCELA_FK;

drop table PAGO cascade constraints;

drop table PAIS cascade constraints;

drop table PATROCINIO cascade constraints;

drop index SE_GENERA_FK;

drop table PEDIDO cascade constraints;

drop index PRESENTA_FK;

drop table PRESENTACION cascade constraints;

drop index SE_PRESENTA_FK;

drop table PRESENTACION_CERVEZA cascade constraints;

drop index SE_PRODUCE_FK;

drop index PRODUCE_FK;

drop table PRODUCCIONMENSUAL cascade constraints;

drop index ES_DE_FK;

drop table PROVEEDORES cascade constraints;

drop table RECETAPROCESOBASICO cascade constraints;

drop table RESULTADOEVALUACION cascade constraints;

drop table RESUMENHISTORICO cascade constraints;

drop index SE_VALORA_FK;

drop table VALORACION_PEDIDO cascade constraints;

drop index RELATIONSHIP_40_FK;

drop table VARIEDAD cascade constraints;

drop index ES_LOCALIZADA_FK;

drop index SE__LOCALIZA_FK;

drop table V_C cascade constraints;

/*==============================================================*/
/* Table: CATALOGO_PROVEEDOR_EQ                                 */
/*==============================================================*/
create table CATALOGO_PROVEEDOR_EQ 
(
   CA_CODIGO            NUMBER               not null,
   CA_NOMBRE            CHAR(256)            not null,
   CA_DESCRIPCION       CLOB                 not null,
   CA_PRECIOUNITARIO    NUMBER               not null,
   CA_ESPECIFICAIONESTECNICAS CLOB                 not null,
   CA_FOTOS             CHAR(10),
   CA_INCLUYE           CLOB,
   PR_ID                NUMBER,
   MA_ID                NUMBER,
   constraint PK_CATALOGO_PROVEEDOR_EQ primary key (CA_CODIGO)
);

/*==============================================================*/
/* Index: PROVEE_FK                                             */
/*==============================================================*/
create index PROVEE_FK on CATALOGO_PROVEEDOR_EQ (
   PR_ID ASC
);

/*==============================================================*/
/* Index: ES_PROVEIDA_FK                                        */
/*==============================================================*/
create index ES_PROVEIDA_FK on CATALOGO_PROVEEDOR_EQ (
   MA_ID ASC
);

/*==============================================================*/
/* Table: CATALOGO_PROVEEDOR_MP                                 */
/*==============================================================*/
create table CATALOGO_PROVEEDOR_MP 
(
   PR_ID                NUMBER               not null,
   MP_ID                NUMBER               not null,
   CP_ID                NUMBER               not null,
   VAR_ID               NUMBER               not null,
   CP_NOMBRE            CHAR(256)            not null,
   CP_DESCRIPCION       CHAR(256)            not null,
   CP_FOTOS             CHAR(10),
   constraint PK_CATALOGO_PROVEEDOR_MP primary key (CP_ID)
);

/*==============================================================*/
/* Index: PROPORCINA_FK                                         */
/*==============================================================*/
create index PROPORCINA_FK on CATALOGO_PROVEEDOR_MP (
   PR_ID ASC
);

/*==============================================================*/
/* Index: SE_UBICA_FK                                           */
/*==============================================================*/
create index SE_UBICA_FK on CATALOGO_PROVEEDOR_MP (
   MP_ID ASC
);

/*==============================================================*/
/* Index: ES_DE_VARIEDAD_FK                                     */
/*==============================================================*/
create index ES_DE_VARIEDAD_FK on CATALOGO_PROVEEDOR_MP (
   VAR_ID ASC
);

/*==============================================================*/
/* Table: CERVEZA                                               */
/*==============================================================*/
create table CERVEZA 
(
   CE_ID                NUMBER               not null,
   ES_ID                NUMBER               not null,
   CE_FECHACREACION     DATE                 not null,
   CE_PORCETAJEALC      NUMBER               not null,
   CE_CALORIAS          NUMBER               not null,
   CE_MUESTRA           CHAR(10)             not null,
   CE_PATROCINIO        CHAR(10)             not null,
   CE_MARCA             CHAR(256)            not null,
   CE_NOMBREINGLES      CHAR(256)            not null,
   CE_IBU               CHAR(10)             not null,
   CE_ABU               CHAR(10)             not null,
   CE_TEMPORADA         CHAR(256)            not null
      constraint CKC_CE_TEMPORADA_CERVEZA check (CE_TEMPORADA in ('clasica','temporada')),
   CE_FOTOS             CHAR(10),
   CE_DESCRIPCION       CLOB,
   CE_PAGINAWEB         CHAR(256),
   CE_SABOR             CHAR(10),
   constraint PK_CERVEZA primary key (CE_ID)
);

/*==============================================================*/
/* Index: SE_CLASIFICA_FK                                       */
/*==============================================================*/
create index SE_CLASIFICA_FK on CERVEZA (
   ES_ID ASC
);

/*==============================================================*/
/* Table: CIUDAD                                                */
/*==============================================================*/
create table CIUDAD 
(
   CI_ID                NUMBER               not null,
   PA_ID                NUMBER               not null,
   CI_NOMBRE            CHAR(256)            not null,
   constraint PK_CIUDAD primary key (CI_ID)
);

/*==============================================================*/
/* Index: SE_ENCUENTRA_FK                                       */
/*==============================================================*/
create index SE_ENCUENTRA_FK on CIUDAD (
   PA_ID ASC
);

/*==============================================================*/
/* Table: COMIDA                                                */
/*==============================================================*/
create table COMIDA 
(
   COM_NOMBRE           CHAR(256)            not null,
   COM_DESCRIPCION      CHAR(256)            not null
);

/*==============================================================*/
/* Table: COMPOSICION                                           */
/*==============================================================*/
create table COMPOSICION 
(
   CE_ID                NUMBER               not null,
   C_ID                 NUMBER               not null,
   C_PROPORCION         NUMBER               not null,
   VAR_ID               NUMBER               not null,
   MP_ID                NUMBER               not null,
   C_DESCRIPCION        CLOB,
   constraint PK_COMPOSICION primary key (C_ID, CE_ID)
);

/*==============================================================*/
/* Index: FORMA_FK                                              */
/*==============================================================*/
create index FORMA_FK on COMPOSICION (
   MP_ID ASC
);

/*==============================================================*/
/* Index: VARIA_FK                                              */
/*==============================================================*/
create index VARIA_FK on COMPOSICION (
   VAR_ID ASC
);

/*==============================================================*/
/* Index: RELATIONSHIP_36_FK                                    */
/*==============================================================*/
create index RELATIONSHIP_36_FK on COMPOSICION (
   CE_ID ASC
);

/*==============================================================*/
/* Table: CONTACTO                                              */
/*==============================================================*/
create table CONTACTO 
(
   CON_NOMBRE           CHAR(256)            not null,
   CON_APELLIDO         CHAR(256)            not null,
   CON_CARGO            CHAR(256)            not null,
   CON_TELEFONO         CHAR(256)            not null
);

/*==============================================================*/
/* Table: CONTRATO                                              */
/*==============================================================*/
create table CONTRATO 
(
   CON_NUMERO           NUMBER               not null,
   PR_ID                NUMBER               not null,
   CON_FECHAEMISION     DATE                 not null,
   CON_CONDICIONESADICIONALES CLOB,
   constraint PK_CONTRATO primary key (CON_NUMERO)
);

/*==============================================================*/
/* Index: SE_CONTACTA_FK                                        */
/*==============================================================*/
create index SE_CONTACTA_FK on CONTRATO (
   PR_ID ASC
);

/*==============================================================*/
/* Table: DATOSCUENTA                                           */
/*==============================================================*/
create table DATOSCUENTA 
(
   DAC_BANCO            CHAR(256)            not null,
   DAC_NUMCUENTA        NUMBER               not null,
   DAC_NOMBRE           CHAR(256)            not null,
   DAC_TIPOCUENTA       CHAR(256)            not null,
   DAC_EMAIL            CHAR(256)            not null
);

/*==============================================================*/
/* Table: DESCUENTOPEDIDIOPARAPRODUCCION                        */
/*==============================================================*/
create table DESCUENTOPEDIDIOPARAPRODUCCION 
(
   PRO_FECHA            DATE                 not null,
   FA_ID                NUMBER               not null,
   EM_ID                NUMBER               not null,
   PC_ID                NUMBER               not null,
   CE_ID                NUMBER               not null,
   DET_ID               NUMBER               not null,
   PE_ID                NUMBER               not null,
   DES_CANTIDAD         NUMBER               not null
);

/*==============================================================*/
/* Index: SE_DESCUENTA_FK                                       */
/*==============================================================*/
create index SE_DESCUENTA_FK on DESCUENTOPEDIDIOPARAPRODUCCION (
   DET_ID ASC,
   PE_ID ASC
);

/*==============================================================*/
/* Index: ES_DESCONTADO_FK                                      */
/*==============================================================*/
create index ES_DESCONTADO_FK on DESCUENTOPEDIDIOPARAPRODUCCION (
   PRO_FECHA ASC,
   FA_ID ASC,
   EM_ID ASC,
   PC_ID ASC,
   CE_ID ASC
);

/*==============================================================*/
/* Table: DETALLE_PEDIDO                                        */
/*==============================================================*/
create table DETALLE_PEDIDO 
(
   DET_ID               NUMBER               not null,
   PE_ID                NUMBER               not null,
   PRE_ID               NUMBER               not null,
   CA_CODIGO            NUMBER               not null,
   DET_CANTIDAD         NUMBER               not null,
   constraint PK_DETALLE_PEDIDO primary key (DET_ID, PE_ID)
);

/*==============================================================*/
/* Index: SE_DESGLOSA_FK                                        */
/*==============================================================*/
create index SE_DESGLOSA_FK on DETALLE_PEDIDO (
   PE_ID ASC
);

/*==============================================================*/
/* Index: SE_DETALLA_FK                                         */
/*==============================================================*/
create index SE_DETALLA_FK on DETALLE_PEDIDO (
   PRE_ID ASC
);

/*==============================================================*/
/* Index: SE_ESPECIFICA_FK                                      */
/*==============================================================*/
create index SE_ESPECIFICA_FK on DETALLE_PEDIDO (
   CA_CODIGO ASC
);

/*==============================================================*/
/* Table: DISTRIBUCION                                          */
/*==============================================================*/
create table DISTRIBUCION 
(
   DIS_ID               CHAR(10)             not null,
   PA_ID                NUMBER               not null,
   DIS_PRESENTACION     CHAR(256)            not null,
   DIS_CANTIDADENELECTROLITOS NUMBER               not null,
   DIS_FECHAINICION     DATE                 not null,
   DIS_FECHAFIN         DATE,
   constraint PK_DISTRIBUCION primary key (DIS_ID, PA_ID)
);

/*==============================================================*/
/* Index: SE_COMERCIALIZA_FK                                    */
/*==============================================================*/
create index SE_COMERCIALIZA_FK on DISTRIBUCION (
   PA_ID ASC
);

/*==============================================================*/
/* Table: EMPRESA                                               */
/*==============================================================*/
create table EMPRESA 
(
   EM_ID                NUMBER               not null,
   CI_ID                NUMBER               not null,
   EM_NOMBRE            CHAR(256)            not null,
   EM_FECHAAPERTURA     DATE                 not null,
   EM_RESUMENH          CHAR(10)             not null,
   EM_LOGO              CHAR(10)             not null,
   EM_PATROCINIO        CHAR(10)             not null,
   EM_RECETAPROCESOBASICO CHAR(10)             not null,
   EMP_EM_ID            NUMBER,
   CIU_CI_ID            NUMBER,
   constraint PK_EMPRESA primary key (EM_ID)
);

/*==============================================================*/
/* Index: SE_UBICA_EN_FK                                        */
/*==============================================================*/
create index SE_UBICA_EN_FK on EMPRESA (
   CI_ID ASC
);

/*==============================================================*/
/* Index: ES_DUENO_FK                                           */
/*==============================================================*/
create index ES_DUENO_FK on EMPRESA (
   EMP_EM_ID ASC
);

/*==============================================================*/
/* Index: OFICINA_PRINCIPAL_EN_FK                               */
/*==============================================================*/
create index OFICINA_PRINCIPAL_EN_FK on EMPRESA (
   CIU_CI_ID ASC
);

/*==============================================================*/
/* Table: ENVIOS                                                */
/*==============================================================*/
create table ENVIOS 
(
   CI_ID                NUMBER               not null,
   PR_ID                NUMBER               not null,
   EN_COSTO             NUMBER               not null,
   EN_TIEMPO            TIMESTAMP            not null,
   constraint PK_ENVIOS primary key (CI_ID, PR_ID)
);

/*==============================================================*/
/* Index: ES_ENVIADA_FK                                         */
/*==============================================================*/
create index ES_ENVIADA_FK on ENVIOS (
   CI_ID ASC
);

/*==============================================================*/
/* Index: ENVIA_FK                                              */
/*==============================================================*/
create index ENVIA_FK on ENVIOS (
   PR_ID ASC
);

/*==============================================================*/
/* Table: ESTILO                                                */
/*==============================================================*/
create table ESTILO 
(
   ES_ID                NUMBER               not null,
   ES_NOMBRE            CHAR(256)            not null,
   ES_DESCRIPCION       CHAR(256)            not null,
   ES_COMIDA            COMIDA               not null,
   ES_IBU               CHAR(10)             not null,
   ES_NOMBRETEMPORADA   CHAR(256),
   constraint PK_ESTILO primary key (ES_ID)
);

/*==============================================================*/
/* Table: FABRICA                                               */
/*==============================================================*/
create table FABRICA 
(
   FA_ID                NUMBER               not null,
   EM_ID                NUMBER               not null,
   CI_ID                NUMBER               not null,
   FA_NOMBRE            CHAR(256),
   FA_FECHAAPERTURA     DATE                 not null,
   constraint PK_FABRICA primary key (FA_ID, EM_ID)
);

/*==============================================================*/
/* Index: POSEE_FK                                              */
/*==============================================================*/
create index POSEE_FK on FABRICA (
   EM_ID ASC
);

/*==============================================================*/
/* Index: SE_LOLALIZA_FK                                        */
/*==============================================================*/
create index SE_LOLALIZA_FK on FABRICA (
   CI_ID ASC
);

/*==============================================================*/
/* Table: FOMA_PAGO                                             */
/*==============================================================*/
create table FOMA_PAGO 
(
   FPAGO_TIPO           CHAR(256)            not null,
   FPAGO_DESCRIPCION    CHAR(256)            not null,
   FPAGO_TIEMPOCUOTAS   CHAR(256),
   FPAGO_CANTCUOTAS     NUMBER,
   FPAGO_DATOSCUENTAS   CHAR(256)
);

/*==============================================================*/
/* Table: MAQUINARIA                                            */
/*==============================================================*/
create table MAQUINARIA 
(
   MA_ID                NUMBER               not null,
   MA_NOMBRE            CHAR(256)            not null,
   MA_PALABRACLV        CHAR(10)             not null,
   MA_DESCRIPCION_      CLOB                 not null,
   MA_TIPO              CHAR(256)            not null,
   constraint PK_MAQUINARIA primary key (MA_ID)
);

/*==============================================================*/
/* Table: MATERIA_PRIMA                                         */
/*==============================================================*/
create table MATERIA_PRIMA 
(
   MP_ID                NUMBER               not null,
   MP_NOMBRE            CHAR(256)            not null,
   MP_DESCRIPCION       CLOB                 not null,
   MP_FORMASDISLUPULO   CHAR(256),
   constraint PK_MATERIA_PRIMA primary key (MP_ID)
);

/*==============================================================*/
/* Table: MEDIDA                                                */
/*==============================================================*/
create table MEDIDA 
(
   ME_CANTIDAD          NUMBER               not null,
   ME_TIPOMEDIDA        CHAR(256)            not null
);

/*==============================================================*/
/* Table: MUESTRA                                               */
/*==============================================================*/
create table MUESTRA 
(
   MUES_TIPOBOTELLA     CHAR(256)            not null,
   MUES_CAPACIDAD       NUMBER               not null
);

/*==============================================================*/
/* Table: PAGO                                                  */
/*==============================================================*/
create table PAGO 
(
   PA_ID                NUMBER               not null,
   PE_ID                NUMBER               not null,
   PA_TIPOPAGO          CHAR(256)            not null,
   PA_MONTO             NUMBER               not null,
   PA_FECHA             DATE                 not null,
   PA_CUENTA            CHAR(10)             not null,
   PA_CUOTA             NUMBER,
   constraint PK_PAGO primary key (PA_ID)
);

/*==============================================================*/
/* Index: SE_CANCELA_FK                                         */
/*==============================================================*/
create index SE_CANCELA_FK on PAGO (
   PE_ID ASC
);

/*==============================================================*/
/* Table: PAIS                                                  */
/*==============================================================*/
create table PAIS 
(
   PA_ID                NUMBER               not null,
   PA_NOMBRE            CHAR(256)            not null,
   PA_CONTINENTE        CHAR(256)            not null,
   constraint PK_PAIS primary key (PA_ID)
);

/*==============================================================*/
/* Table: PATROCINIO                                            */
/*==============================================================*/
create table PATROCINIO 
(
   PATROCINIO_NOMBRE    CHAR(256)            not null,
   PATROCINO_DESCRIPCION CHAR(256)            not null,
   PATROCINIO_ANOS      NUMBER               not null
);

/*==============================================================*/
/* Table: PEDIDO                                                */
/*==============================================================*/
create table PEDIDO 
(
   PE_ID                NUMBER               not null,
   CON_NUMERO           NUMBER               not null,
   PE_FECHAPEDIDO       DATE                 not null,
   PE_STATUS            CHAR(256)            not null,
   PE_FECHAENTREGA      DATE                 not null,
   PE_TIPO              CHAR(256)            not null,
   PE_NUMFACTURA        NUMBER,
   PE_TOTAL             NUMBER,
   PE_FECHASOLICITADA   DATE,
   constraint PK_PEDIDO primary key (PE_ID)
);

/*==============================================================*/
/* Index: SE_GENERA_FK                                          */
/*==============================================================*/
create index SE_GENERA_FK on PEDIDO (
   CON_NUMERO ASC
);

/*==============================================================*/
/* Table: PRESENTACION                                          */
/*==============================================================*/
create table PRESENTACION 
(
   PRE_ID               NUMBER               not null,
   CP_ID                NUMBER               not null,
   PRE_MEDIDA           CHAR(10)             not null,
   PRE_TIPO             CHAR(256)            not null
      constraint CKC_PRE_TIPO_PRESENTA check (PRE_TIPO in ('bolsa','saco','caja','sachet','otros')),
   PRE_PRECIOU          NUMBER               not null,
   PRE_DESCRIPCION      CLOB,
   constraint PK_PRESENTACION primary key (PRE_ID)
);

/*==============================================================*/
/* Index: PRESENTA_FK                                           */
/*==============================================================*/
create index PRESENTA_FK on PRESENTACION (
   CP_ID ASC
);

/*==============================================================*/
/* Table: PRESENTACION_CERVEZA                                  */
/*==============================================================*/
create table PRESENTACION_CERVEZA 
(
   PC_ID                NUMBER               not null,
   CE_ID                NUMBER               not null,
   PC_TIPO              CHAR(256)            not null
      constraint CKC_PC_TIPO_PRESENTA check (PC_TIPO in ('botella','botella retornable','lata','sifon')),
   PC_CANTIDAD          NUMBER               not null,
   constraint PK_PRESENTACION_CERVEZA primary key (PC_ID, CE_ID)
);

/*==============================================================*/
/* Index: SE_PRESENTA_FK                                        */
/*==============================================================*/
create index SE_PRESENTA_FK on PRESENTACION_CERVEZA (
   CE_ID ASC
);

/*==============================================================*/
/* Table: PRODUCCIONMENSUAL                                     */
/*==============================================================*/
create table PRODUCCIONMENSUAL 
(
   PRO_FECHA            DATE                 not null,
   FA_ID                NUMBER               not null,
   EM_ID                NUMBER               not null,
   PC_ID                NUMBER               not null,
   CE_ID                NUMBER               not null,
   PRO_CANTIDADENML     NUMBER               not null,
   constraint PK_PRODUCCIONMENSUAL primary key (PRO_FECHA, FA_ID, EM_ID, PC_ID, CE_ID)
);

/*==============================================================*/
/* Index: PRODUCE_FK                                            */
/*==============================================================*/
create index PRODUCE_FK on PRODUCCIONMENSUAL (
   FA_ID ASC,
   EM_ID ASC
);

/*==============================================================*/
/* Index: SE_PRODUCE_FK                                         */
/*==============================================================*/
create index SE_PRODUCE_FK on PRODUCCIONMENSUAL (
   PC_ID ASC,
   CE_ID ASC
);

/*==============================================================*/
/* Table: PROVEEDORES                                           */
/*==============================================================*/
create table PROVEEDORES 
(
   PR_ID                NUMBER               not null,
   PA_ID                NUMBER               not null,
   PR_NOMBRE            CHAR(256)            not null,
   PR_CORREO            CHAR(256)            not null,
   PR_TELEFONO          NUMBER               not null,
   PR_FORMASENVIO       CHAR(10)             not null,
   PR_FORMASPAGO        CHAR(10)             not null,
   PR_CONTACTOS         CHAR(10)             not null,
   PR_RESULTADOEVALUACION NUMBER,
   PR_WEB               CHAR(256),
   constraint PK_PROVEEDORES primary key (PR_ID)
);

/*==============================================================*/
/* Index: ES_DE_FK                                              */
/*==============================================================*/
create index ES_DE_FK on PROVEEDORES (
   PA_ID ASC
);

/*==============================================================*/
/* Table: RECETAPROCESOBASICO                                   */
/*==============================================================*/
create table RECETAPROCESOBASICO 
(
   RPB_                 CHAR(256)            not null,
   RPB_ACTIVIDAD        CHAR(256)            not null
);

/*==============================================================*/
/* Table: RESULTADOEVALUACION                                   */
/*==============================================================*/
create table RESULTADOEVALUACION 
(
   RES_ANO              DATE                 not null,
   RES_RESULTADO        NUMBER               not null,
   RES_POSICION         NUMBER               not null,
   RES_IDPRODUCTOR      NUMBER               not null,
   RES_RUBRO            CHAR(256)            not null
);

/*==============================================================*/
/* Table: RESUMENHISTORICO                                      */
/*==============================================================*/
create table RESUMENHISTORICO 
(
   RE_FECHA             DATE                 not null,
   RE_HECHO             DATE                 not null
);

/*==============================================================*/
/* Table: VALORACION_PEDIDO                                     */
/*==============================================================*/
create table VALORACION_PEDIDO 
(
   VA_ID                NUMBER               not null,
   DET_ID               NUMBER               not null,
   PE_ID                NUMBER               not null,
   VA_FECHA             DATE                 not null,
   VA_CALIDAD           CHAR(256)            not null,
   VA_COSTO             NUMBER               not null,
   constraint PK_VALORACION_PEDIDO primary key (VA_ID)
);

/*==============================================================*/
/* Index: SE_VALORA_FK                                          */
/*==============================================================*/
create index SE_VALORA_FK on VALORACION_PEDIDO (
   DET_ID ASC,
   PE_ID ASC
);

/*==============================================================*/
/* Table: VARIEDAD                                              */
/*==============================================================*/
create table VARIEDAD 
(
   VAR_ID               NUMBER               not null,
   MP_ID                NUMBER               not null,
   VAR_TIPO             CHAR(256)            not null
      constraint CKC_VAR_TIPO_VARIEDAD check (VAR_TIPO in ('base','coloreada')),
   VAR_NOMBRE           CHAR(256)            not null,
   VAR_MAX_USO          NUMBER               default 0 not null
      constraint CKC_VAR_MAX_USO_VARIEDAD check (VAR_MAX_USO between 1 and 100),
   VAR_COLOREBC         NUMBER               not null,
   constraint PK_VARIEDAD primary key (VAR_ID)
);

/*==============================================================*/
/* Index: RELATIONSHIP_40_FK                                    */
/*==============================================================*/
create index RELATIONSHIP_40_FK on VARIEDAD (
   MP_ID ASC
);

/*==============================================================*/
/* Table: V_C                                                   */
/*==============================================================*/
create table V_C 
(
   VAR_ID               NUMBER               not null,
   PA_ID                NUMBER               not null,
   constraint PK_V_C primary key (VAR_ID, PA_ID)
);

/*==============================================================*/
/* Index: SE__LOCALIZA_FK                                       */
/*==============================================================*/
create index SE__LOCALIZA_FK on V_C (
   VAR_ID ASC
);

/*==============================================================*/
/* Index: ES_LOCALIZADA_FK                                      */
/*==============================================================*/
create index ES_LOCALIZADA_FK on V_C (
   PA_ID ASC
);

alter table CATALOGO_PROVEEDOR_EQ
   add constraint FK_CATALOGO_ES_PROVEI_MAQUINAR foreign key (MA_ID)
      references MAQUINARIA (MA_ID);

alter table CATALOGO_PROVEEDOR_EQ
   add constraint FK_CATALOGO_PROVEE_PROVEEDO foreign key (PR_ID)
      references PROVEEDORES (PR_ID);

alter table CATALOGO_PROVEEDOR_MP
   add constraint FK_CATALOGO_ES_DE_VAR_VARIEDAD foreign key (VAR_ID)
      references VARIEDAD (VAR_ID);

alter table CATALOGO_PROVEEDOR_MP
   add constraint FK_CATALOGO_PROPORCIN_PROVEEDO foreign key (PR_ID)
      references PROVEEDORES (PR_ID);

alter table CATALOGO_PROVEEDOR_MP
   add constraint FK_CATALOGO_SE_UBICA_MATERIA_ foreign key (MP_ID)
      references MATERIA_PRIMA (MP_ID);

alter table CERVEZA
   add constraint FK_CERVEZA_SE_CLASIF_ESTILO foreign key (ES_ID)
      references ESTILO (ES_ID);

alter table CIUDAD
   add constraint FK_CIUDAD_SE_ENCUEN_PAIS foreign key (PA_ID)
      references PAIS (PA_ID);

alter table COMPOSICION
   add constraint FK_COMPOSIC_FORMA_MATERIA_ foreign key (MP_ID)
      references MATERIA_PRIMA (MP_ID);

alter table COMPOSICION
   add constraint FK_COMPOSIC_RELATIONS_CERVEZA foreign key (CE_ID)
      references CERVEZA (CE_ID);

alter table COMPOSICION
   add constraint FK_COMPOSIC_VARIA_VARIEDAD foreign key (VAR_ID)
      references VARIEDAD (VAR_ID);

alter table CONTRATO
   add constraint FK_CONTRATO_CONTRATA_EMPRESA foreign key (CON_NUMERO)
      references EMPRESA (EM_ID);

alter table CONTRATO
   add constraint FK_CONTRATO_SE_CONTAC_PROVEEDO foreign key (PR_ID)
      references PROVEEDORES (PR_ID);

alter table DESCUENTOPEDIDIOPARAPRODUCCION
   add constraint FK_DESCUENT_ES_DESCON_PRODUCCI foreign key (PRO_FECHA, FA_ID, EM_ID, PC_ID, CE_ID)
      references PRODUCCIONMENSUAL (PRO_FECHA, FA_ID, EM_ID, PC_ID, CE_ID);

alter table DESCUENTOPEDIDIOPARAPRODUCCION
   add constraint FK_DESCUENT_SE_DESCUE_DETALLE_ foreign key (DET_ID, PE_ID)
      references DETALLE_PEDIDO (DET_ID, PE_ID);

alter table DETALLE_PEDIDO
   add constraint FK_DETALLE__SE_DESGLO_PEDIDO foreign key (PE_ID)
      references PEDIDO (PE_ID);

alter table DETALLE_PEDIDO
   add constraint FK_DETALLE__SE_DETALL_PRESENTA foreign key (PRE_ID)
      references PRESENTACION (PRE_ID);

alter table DETALLE_PEDIDO
   add constraint FK_DETALLE__SE_ESPECI_CATALOGO foreign key (CA_CODIGO)
      references CATALOGO_PROVEEDOR_EQ (CA_CODIGO);

alter table DISTRIBUCION
   add constraint FK_DISTRIBU_SE_COMERC_PAIS foreign key (PA_ID)
      references PAIS (PA_ID);

alter table EMPRESA
   add constraint FK_EMPRESA_ES_DUENO_EMPRESA foreign key (EMP_EM_ID)
      references EMPRESA (EM_ID);

alter table EMPRESA
   add constraint FK_EMPRESA_OFICINA_P_CIUDAD foreign key (CIU_CI_ID)
      references CIUDAD (CI_ID);

alter table EMPRESA
   add constraint FK_EMPRESA_SE_UBICA__CIUDAD foreign key (CI_ID)
      references CIUDAD (CI_ID);

alter table ENVIOS
   add constraint FK_ENVIOS_ENVIA_PROVEEDO foreign key (PR_ID)
      references PROVEEDORES (PR_ID);

alter table ENVIOS
   add constraint FK_ENVIOS_ES_ENVIAD_CIUDAD foreign key (CI_ID)
      references CIUDAD (CI_ID);

alter table FABRICA
   add constraint FK_FABRICA_POSEE_EMPRESA foreign key (EM_ID)
      references EMPRESA (EM_ID);

alter table FABRICA
   add constraint FK_FABRICA_SE_LOLALI_CIUDAD foreign key (CI_ID)
      references CIUDAD (CI_ID);

alter table PAGO
   add constraint FK_PAGO_SE_CANCEL_PEDIDO foreign key (PE_ID)
      references PEDIDO (PE_ID);

alter table PEDIDO
   add constraint FK_PEDIDO_SE_GENERA_CONTRATO foreign key (CON_NUMERO)
      references CONTRATO (CON_NUMERO);

alter table PRESENTACION
   add constraint FK_PRESENTA_PRESENTA_CATALOGO foreign key (CP_ID)
      references CATALOGO_PROVEEDOR_MP (CP_ID);

alter table PRESENTACION_CERVEZA
   add constraint FK_PRESENTA_SE_PRESEN_CERVEZA foreign key (CE_ID)
      references CERVEZA (CE_ID);

alter table PRODUCCIONMENSUAL
   add constraint FK_PRODUCCI_PRODUCE_FABRICA foreign key (FA_ID, EM_ID)
      references FABRICA (FA_ID, EM_ID);

alter table PRODUCCIONMENSUAL
   add constraint FK_PRODUCCI_SE_PRODUC_PRESENTA foreign key (PC_ID, CE_ID)
      references PRESENTACION_CERVEZA (PC_ID, CE_ID);

alter table PROVEEDORES
   add constraint FK_PROVEEDO_ES_DE_PAIS foreign key (PA_ID)
      references PAIS (PA_ID);

alter table VALORACION_PEDIDO
   add constraint FK_VALORACI_SE_VALORA_DETALLE_ foreign key (DET_ID, PE_ID)
      references DETALLE_PEDIDO (DET_ID, PE_ID);

alter table VARIEDAD
   add constraint FK_VARIEDAD_RELATIONS_MATERIA_ foreign key (MP_ID)
      references MATERIA_PRIMA (MP_ID);

alter table V_C
   add constraint FK_V_C_ES_LOCALI_PAIS foreign key (PA_ID)
      references PAIS (PA_ID);

alter table V_C
   add constraint FK_V_C_SE__LOCAL_VARIEDAD foreign key (VAR_ID)
      references VARIEDAD (VAR_ID);

