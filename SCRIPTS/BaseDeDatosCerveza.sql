create table PAIS 
(
   PA_ID                NUMBER(7)               not null,
   PA_NOMBRE            VARCHAR2(30)   unique   not null,
   PA_CONTINENTE        VARCHAR2(30)            not null,
   constraint PK_PAIS primary key (PA_ID)
);

alter table PAIS
   add constraint CHK_CONTINENTE check (PA_CONTINENTE in ('Africa','Asia','Antartida','Europa','Norteamerica','Oceania','Sudamerica'));

create sequence seq_pa_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

create table CIUDAD 
(
   CI_ID                NUMBER(7)               not null,
   PA_ID                NUMBER(7)               not null,
   CI_NOMBRE            VARCHAR2(30)   unique   not null,
   constraint PK_CIUDAD primary key (CI_ID)
);

alter table CIUDAD
   add constraint FK_PAIS foreign key (PA_ID)
      references PAIS (PA_ID);

create sequence seq_ci_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

create table DISTRIBUCION 
(
   DIS_ID               NUMBER(7)               not null,
   PA_ID                NUMBER(7)               not null,
   DIS_PRESENTACION     VARCHAR2(30)            not null,                                   
   DIS_CANTIDADENELECTROLITOS NUMBER(7)     default 0          not null,
   DIS_FECHAINICION     DATE                 not null,
   DIS_FECHAFIN         DATE,
   constraint PK_DISTRIBUCION primary key (DIS_ID, PA_ID)
);

alter table DISTRIBUCION
   add constraint FK_PAIS foreign key (PA_ID)
      references PAIS(PA_ID);

alter table DISTRIBUCION
   add constraint CHK_PRESENTACION check (DIS_PRESENTACION in ('botella','botella retornable','lata','sifon'));

create sequence seq_dis_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

CREATE OR REPLACE TYPE FORMAPAGO AS OBJECT (
    FPAGO_TIPO         VARCHAR2(30),
    FPAGO_DESCRIPCION  VARCHAR2(30) ,
    FPAGO_TIEMPOCUOTAS VARCHAR2(30),
    FPAGO_CANTCUOTAS   NUMBER(7),
    FPAGO_DATOSCUENTAS VARCHAR2(30)
);

CREATE OR REPLACE TYPE FORMAPAGO_NT AS TABLE OF FOMA_PAGO;

CREATE OR REPLACE TYPE CONTACTO AS OBJECT (
    CON_NOMBRE         VARCHAR2(30)  ,
    CON_APELLIDO       VARCHAR2(30)   ,
    CON_CARGO          VARCHAR2(30)   ,
    CON_TELEFONO       VARCHAR2(30)    
);

CREATE OR REPLACE TYPE RESULTADOEVALUACION AS OBJECT (
    RES_AÑO            DATE                 ,
    RES_RESULTADO      NUMBER(7)               ,
    RES_POSICION       NUMBER(7)               ,
    RES_IDPRODUCTOR    NUMBER(7)              ,
    RED_RUBRO          VARCHAR2(30)           
);

CREATE OR REPLACE TYPE RESULTADOEVALUACION_NT AS TABLE OF RESULTADOEVALUACION;

create table PROVEEDORES 
(
   PR_ID                NUMBER(7)               not null,
   PA_ID                NUMBER(7)               not null,
   PR_NOMBRE            VARCHAR2(30)  unique    not null,
   PR_CORREO            VARCHAR2(30)  unique    not null,
   PR_TELEFONO          NUMBER(7)               not null,
   PR_FORMASENVIO       VARCHAR2(10)            not null,                       ------Esto no se sacaba con la entidad envios?O es un check de envios?
   PR_FORMASPAGO        FORMAPAGO_NT,
   PR_CONTACTOS         CONTACTO,
   PR_RESULTADOEVALUACION RESULTADOEVALUACION_NT,
   PR_WEB               VARCHAR2(30),
   constraint PK_PROVEEDORES primary key (PR_ID)
)nedted table PR_FORMASPAGO store as formasDePago,
 nested table PR_RESULTADOEVALUACION store as resultadosEvaluaciones;

alter table PROVEEDORES
   add constraint FK_PAIS foreign key (PA_ID)
   references PAIS(PA_ID);

create sequence seq_pr_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

create table ENVIOS 
(
   EN_ID                NUMBER(7)               not null,
   CI_ID                NUMBER(7)               not null,
   PR_ID                NUMBER(7)               not null,
   EN_COSTO             NUMBER(7)               not null,
   EN_TIEMPO_HORAS      NUMBER(7)                  not null,                                   ----Este tiempo cual es?
   constraint PK_ENVIOS primary key (EN_ID,CI_ID, PR_ID)
);

alter table ENVIOS
   add constraint FK_PROVEEDOR foreign key (PR_ID)
   references PROVEEDORES(PR_ID);

alter table ENVIOS
   add constraint FK_CIUDAD foreign key (CI_ID)
   references CIUDAD(CI_ID);

create sequence seq_en_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

CREATE OR REPLACE TYPE PATROCINIO AS OBJECT (
    PATROCINIO_NOMBRE  VARCHAR2(30)             ,
    PATROCINIO_DESCRIPCION VARCHAR2(30)        ,
    PATROCINIO_AÑOS    VARCHAR2(30)             
);

CREATE OR REPLACE TYPE PATROCINIO_NT AS TABLE OF PATROCINIO;

CREATE OR REPLACE TYPE RECETAPROCESOBASICO AS OBJECT (
    RPB_ETAPA          VARCHAR2(30) ,
    RPB_ACTIVIDAD      VARCHAR2(30) 
);

CREATE OR REPLACE TYPE RECETAPROCESOBASICO_NT AS TABLE OF RECETAPROCESOBASICO;

CREATE OR REPLACE TYPE RESUMENHISTORICO AS OBJECT (
    RE_FECHA           DATE                 ,
    RE_HECHO           VARCHAR2(30)                  
);

CREATE OR REPLACE TYPE RESUMENHISTORICO_NT AS TABLE OF RESUMENHISTORICO;​

create table EMPRESA 
(
   EM_ID                NUMBER(7)               not null,
   CI_ID                NUMBER(7)               not null,
   EM_NOMBRE            VARCHAR2(30)  unique    not null,
   EM_FECHAAPERTURA     DATE                 not null,
   EM_RESUMENH          RESUMENHISTORICO_NT,                                     ------Esto no deberia de ser un LOB, CLOO o algo asi?
   EM_LOGO              BLOB             not null,                                    ------Esto no deberia de ser un LOB, CLOO o algo asi?
   EM_PATROCINIO        PATROCINIO_NT,
   EM_RECETAPROCESOBASICO RECETAPROCESOBASICO_NT,
   EMP_EM_ID            NUMBER(7),
   CIU_CI_ID            NUMBER(7),
   constraint PK_EMPRESA primary key (EM_ID)
)nested table EM_PATROCINIO store as patrocinios,
 nested table EM_RESUMENH store as resumeneshistoricos,
 nested table EM_RECETAPROCESOBASICO store as recetasprocesosbasicos;

alter table EMPRESA
   add constraint FK_CIUDAD_UBICACION foreign key (CI_ID)
   references CIUDAD(CI_ID);

alter table EMPRESA
   add constraint FK_CIUDAD_PRINCIPAL foreign key (CIU_CI_ID)
   references CIUDAD(CI_ID);

alter table EMPRESA
   add constraint FK_DUEÑO foreign key (EMP_EM_ID)
   references EMPRESA(EMP_EM_ID);

   create sequence seq_em_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

create table FABRICA 
(
   FA_ID                NUMBER(7)               not null,
   EM_ID                NUMBER(7)               not null,
   CI_ID                NUMBER(7)               not null,
   FA_NOMBRE            VARCHAR2(30) unique,
   FA_FECHAAPERTURA     DATE                 not null,
   constraint PK_FABRICA primary key (FA_ID, EM_ID)
);

alter table FABRICA
   add constraint FK_EMPRESA foreign key (EM_ID)
   references EMPRESA(EM_ID);

alter table FABRICA
   add constraint FK_CIUDAD foreign key (CI_ID)
   references CIUDAD(CI_ID);

create sequence seq_fa_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

create table CONTRATO 
(
   CON_NUMERO           NUMBER(7)               not null,
   PR_ID                NUMBER(7)               not null,
   CON_FECHAEMISION     DATE                 not null,
   EM_ID                NUMBER(7)               not null,
   CON_CONDICIONESADICIONALES CLOB,
   constraint PK_CONTRATO primary key (CON_NUMERO)
);

alter table CONTRATO
   add constraint FK_EMPRESA foreign key (EM_ID)
   references EMPRESA(EM_ID);

alter table CONTRATO
   add constraint FK_PROVEEDOR foreign key (PR_ID)
   references PROVEEDORES(PR_ID);

create sequence seq_con_numero
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

create table MAQUINARIA 
(
   MA_ID                NUMBER(7)               not null,
   MA_NOMBRE            VARCHAR2(30)            not null,
   MA_PALABRACLV        VARCHAR2(10)             not null,                                           ---- Esto deberia de seer un check -- CONJUNTO DE VARCHAR2
   MA_DESCRIPCION_      CLOB                 not null,
   --MA_TIPO              VARCHAR2(30)            not null,                                           ---- Que es tipo?
   constraint PK_MAQUINARIA primary key (MA_ID)
);  

create sequence seq_ma_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

create table CATALOGO_PROVEEDOR_EQ 
(
   CA_CODIGO            NUMBER(7)               not null,
   CA_NOMBRE            VARCHAR2(30)            not null,
   CA_DESCRIPCION       VARCHAR2(50)                 not null,                                           -- PORQUE CLOB?
   CA_PRECIOUNITARIO    NUMBER(7)               not null,
   CA_ESPECIFICAIONESTECNICAS CLOB                 not null,
   CA_FOTOS             BLOB,                                                                     --CONJUTO DE FOTOS 
   CA_INCLUYE           CLOB,
   PR_ID                NUMBER(7),
   MA_ID                NUMBER(7),
   constraint PK_CATALOGO_PROVEEDOR_EQ primary key (CA_CODIGO)
);

alter table CATALOGO_PROVEEDOR_EQ
   add constraint FK_PROVEEDOR foreign key (PR_ID)
   references PROVEEDORES(PR_ID);

alter table CATALOGO_PROVEEDOR_EQ
   add constraint FK_MAQUINARIA foreign key (MA_ID)
   references MAQUINARIA(MA_ID);

create sequence seq_ca_codigo
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

create table MATERIA_PRIMA 
(
   MP_ID                NUMBER(7)               not null,
   MP_NOMBRE            VARCHAR2(30)            not null,
   MP_DESCRIPCION       VARCHAR2(50)                not null,                                                    --POR QUE CLOB?
   MP_FORMASDISLUPULO   VARCHAR2(30),
   constraint PK_MATERIA_PRIMA primary key (MP_ID)
);

alter table MATERIA_PRIMA
   add constraint CHK_FORMASDISLUPULO check (MP_FORMASDISLUPULO in ('seco','plug','rehidratado'));

create sequence seq_mp_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

create table VARIEDAD 
(
   VAR_ID               NUMBER(7)               not null,
   MP_ID                NUMBER(7)               not null,
   VAR_TIPO             VARCHAR2(30)            not null
      constraint CHC_VAR_TIPO_VARIEDAD check (VAR_TIPO in ('base','coloreada')),
   VAR_NOMBRE           VARCHAR2(30)            not null,
   VAR_MAX_USO          NUMBER(7)               default 0 not null
      constraint CHC_VAR_MAX_USO_VARIEDAD check (VAR_MAX_USO between 1 and 100),
   VAR_COLOREBCRANGOI         NUMBER(7)               not null,
   VAR_COLOREBCRANGOF         NUMBER(7)               not null,
   constraint PK_VARIEDAD primary key (VAR_ID)
);

alter table VARIEDAD
   add constraint FK_MATERIAPRIMA foreign key (MP_ID)
   references MATERIA_PRIMA(MP_ID);

create sequence seq_var_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;


create table V_C 
(
   VC_ID                NUMBER(7)               not null,
   VAR_ID               NUMBER(7)               not null,
   PA_ID                NUMBER(7)               not null,
   constraint PK_V_C primary key (VC_ID,VAR_ID, PA_ID)
);

alter table V_C
   add constraint FK_VARIEDAD foreign key (VAR_ID)
   references VARIEDAD(VAR_ID);

alter table V_C
   add constraint FK_PAIS foreign key (PA_ID)
   references  PAIS(PA_ID);

create sequence seq_vc_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

create table CATALOGO_PROVEEDOR_MP 
(
   PR_ID                NUMBER(7)               not null,
   MP_ID                NUMBER(7)             ,
   CP_ID                NUMBER(7)               not null,
   VAR_ID               NUMBER(7)             ,
   CP_NOMBRE            VARCHAR2(30)            not null,
   CP_DESCRIPCION       VARCHAR2(30)            not null,
   CP_FOTOS             BLOB,                                                                              --CONJUTO DE FOTOS
   constraint PK_CATALOGO_PROVEEDOR_MP primary key (CP_ID)
);

alter table CATALOGO_PROVEEDOR_MP
   add constraint FK_MATERIAPRIMA foreign key (MP_ID)
   references MATERIA_PRIMA(MP_ID);

alter table CATALOGO_PROVEEDOR_MP
   add constraint FK_PROVEEDOR foreign key (PR_ID)
   references PROVEEDORES(PR_ID);

alter table CATALOGO_PROVEEDOR_MP
   add constraint FK_VARIEDAD foreign key (VAR_ID)
   references VARIEDAD(VAR_ID);

create sequence seq_cp_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

create table PEDIDO 
(
   PE_ID                NUMBER(7)               not null,
   CON_NUMERO           NUMBER(7)               not null,
   PE_FECHAPEDIDO       DATE                 not null,
   PE_STATUS            VARCHAR2(30)            not null,
   PE_FECHAENTREGA      DATE                 not null,
   PE_TIPO              VARCHAR2(30)            not null,
   PE_NUMFACTURA        NUMBER(7),
   PE_TOTAL             NUMBER(7),
   PE_FECHASOLICITADA   DATE,
   constraint PK_PEDIDO primary key (PE_ID)
);

alter table PEDIDO
   add constraint CHK_STATUS check (PE_STATUS in ('en proceso','cancelada','rechazada por proveedor','finalizada'));

alter table PEDIDO
   add constraint CHK_TIPO check (PE_TIPO IN ('materia prima','equipo'));

alter table PEDIDO
   add constraint FK_CONTRATO foreign key (CON_NUMERO)
   references CONTRATO(CON_NUMERO);

create sequence seq_pe_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

--No estoy muy seguro de pago y cuentas

CREATE OR REPLACE TYPE DATOSCUENTA AS OBJECT (
    DAC_BANCO          VARCHAR2(30) ,
    DAC_NUMCUENTA      NUMBER(7)   ,
    DAC_NOMBRE         VARCHAR2(30) ,
    DAC_TIPOCUENTA     VARCHAR2(30),
    DAC_EMAIL          VARCHAR2(30)   
);

create table PAGO 
(
   PA_ID                NUMBER(7)               not null,
   PE_ID                NUMBER(7)               not null,
   PA_TIPOPAGO          VARCHAR2(30)            not null,
   PA_MONTO             NUMBER(7)               not null,
   PA_FECHA             DATE                 not null,
   PA_CUENTA            DATOSCUENTA,
   PA_CUOTA             NUMBER(7),
   constraint PK_PAGO primary key (PA_ID)
);

alter table PAGO
   add constraint FK_PEDIDO foreign key (PE_ID)
   references PEDIDO(PE_ID);

alter table PAGO
   add constraint CHK_TIPOPAGO check (PA_TIPOPAGO in ('efectivo','transferencia','deposito','cheque'));

create sequence seq_pa_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

CREATE OR REPLACE TYPE COMIDA AS OBJECT (
    CON_NOMBRE         VARCHAR2(30)            ,
    CON_DESCRIPCION    VARCHAR2(30)             
);

CREATE OR REPLACE TYPE COMIDA_NT AS TABLE OF COMIDA;

CREATE OR REPLACE TYPE MEDIDA (
    ME_CANTIDAD        VARCHAR2(30)     ,
    ME_TIPOMEDIDA      VARCHAR2(30)         
);


create table ESTILO 
(
   ES_ID                NUMBER(7)               not null,
   ES_NOMBRE            VARCHAR2(30)            not null,
   ES_DESCRIPCION       VARCHAR2(30)            not null,
   ES_COMIDA            COMIDA_NT,
   ES_IBU               VARCHAR2(10)             not null,
   ES_NOMBRETEMPORADA   VARCHAR2(30),
   ES_TEMPERATURA       MEDIDA
   constraint PK_ESTILO primary key (ES_ID)
)nested table ES_COMIDA store as comidas;

alter table ESTILO
   add constraint CHK_TEMPORADA check (ES_NOMBRETEMPORADA in ('navidad','pascua','halloween','otra'))

create sequence seq_es_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

CREATE OR REPLACE TYPE PATROCINIO AS OBJECT (
    PATROCINIO_NOMBRE  VARCHAR2(30)             ,
    PATROCINIO_DESCRIPCION VARCHAR2(30)        ,
    PATROCINIO_AÑOS    VARCHAR2(30)             
);

CREATE OR REPLACE TYPE PATROCINIO_NT AS TABLE OF PATROCINIO;
--- que es abu?
create table CERVEZA 
(
   CE_ID                NUMBER(7)               not null,
   ES_ID                NUMBER(7)               not null,
   CE_FECHACREACION     DATE                 not null,
   CE_PORCETAJEALC      NUMBER(7)               not null,
   CE_CALORIAS          NUMBER(7)   default 0   not null,
   CE_PATROCINIO        PATROCINIO_NT,
   CE_MARCA             VARCHAR2(30)            not null,
   CE_NOMBREINGLES      VARCHAR2(30)            not null,
   CE_IBU               VARCHAR2(10)             not null,
   CE_ABU               VARCHAR2(10)             not null,
   CE_TEMPORADA         VARCHAR2(30)            not null
      constraint CKC_CE_TEMPORADA_CERVEZA check (CE_TEMPORADA in ('clasica','temporada')),
   CE_FOTOS             BLOB,                                                                         -- CONJUNTO DE FOTOS
   CE_DESCRIPCION       CLOB,                                                                          --POR QUE CLOB??
   CE_PAGINAWEB         VARCHAR2(30),
   CE_SABOR             VARCHAR2(10),
   constraint PK_CERVEZA primary key (CE_ID)
)nested table CE_PATROCINIO store as patrocinios;

alter table CERVEZA
   add constraint FK_ESTILO foreign key (ES_ID)
   references ESTILO(ES_ID);

alter table CERVEZA
   add constraint CHK_PORCENTAJEALC check (CE_PORCETAJEALC between 0 and 100);

create sequence seq_ce_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

---- El TDA muestra hay que eliminarlo

create table PRESENTACION_CERVEZA 
(
   PC_ID                NUMBER(7)               not null,
   CE_ID                NUMBER(7)               not null,
   PC_TIPO              VARCHAR2(30)            not null
      constraint CHC_PC_TIPO_PRESENTA check (PC_TIPO in ('botella','botella retornable','lata','sifon')),
   PC_CANTIDAD          NUMBER(7)               not null,
   constraint PK_PRESENTACION_CERVEZA primary key (PC_ID, CE_ID)
);

alter table PRESENTACION_CERVEZA
   add constraint FK_CERVEZA foreign key (CE_ID)
   references CERVEZA(CE_ID);

create sequence seq_pc_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

create table COMPOSICION 
(
   CE_ID                NUMBER(7)               not null,
   C_ID                 NUMBER(7)               not null,
   C_PROPORCION         NUMBER(7)               not null,
   VAR_ID               NUMBER(7)               ,
   MP_ID                NUMBER(7)               ,
   C_DESCRIPCION        CLOB,
   constraint PK_COMPOSICION primary key (C_ID, CE_ID)
);

alter table COMPOSICION
   add constraint FK_CERVEZA foreign key (CE_ID)
   references CERVEZA(CE_ID);

alter table COMPOSICION
   add constraint CHK_PROPORCION check (C_PROPORCION between 1 and 100);

alter table COMPOSICION
   add constraint FK_VARIABLE foreign key (VAR_ID)
   references VARIEDAD(VAR_ID);

alter table MATERIA_PRIMA
   add constraint FK_MATERIAPRIMA foreign key (MP_ID)
   references MATERIA_PRIMA(MA_ID);

create sequence seq_c_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

create table PRODUCCIONMENSUAL 
(
   PRO_FECHA            DATE                 not null,
   FA_ID                NUMBER(7)               not null,
   PC_ID                NUMBER(7)               not null,
   CE_ID                NUMBER(7)               not null,
   EM_ID                NUMBER(7)               not null,
   PRO_CANTIDADENML     NUMBER(7)    default 0  not null,
   constraint PK_PRODUCCIONMENSUAL primary key (PRO_FECHA,FA_ID,EM_ID,PC_ID,CE_ID)
);

alter table PRODUCCIONMENSUAL
   add constraint FK_FABRICA foreign key (FA_ID)
   references FABRICA(FA_ID);

alter table PRODUCCIONMENSUAL
   add constraint FK_FABRICA2 foreign key (EM_ID)
   references FABRICA(EM_ID);

alter table PRODUCCIONMENSUAL
   add constraint FK_PRESENTACION_CERNEZA foreign key (PC_ID)
   references PRESENTACION_CERVEZA(PC_ID);

alter table PRODUCCIONMENSUAL
   add constraint FK_PRESENTACION_CERNEZA2 foreign key (CE_ID)
   references PRESENTACION_CERVEZA(CE_ID);

create table PRESENTACION 
(
   PRE_ID               NUMBER(7)               not null,
   CP_ID                NUMBER(7)               not null,
   PRE_MEDIDA           CHAR(10)             not null,
   PRE_TIPO             VARCHAR2(30)            not null
      constraint CKC_PRE_TIPO_PRESENTA check (PRE_TIPO in ('bolsa','saco','caja','sachet','otros')),
   PRE_PRECIOU          NUMBER(7)               not null,
   PRE_DESCRIPCION      CLOB,
   constraint PK_PRESENTACION primary key (PRE_ID)
);

alter table PRESENTACION
   add constraint FK_CATALOGO_PROVEEDOR_MP foreign key (CP_ID)
   references CATALOGO_PROVEEDOR_MP(CP_ID);

create sequence seq_pre_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;
   
create table DETALLE_PEDIDO 
(
   DET_ID               NUMBER(7)               not null,
   PE_ID                NUMBER(7)               not null,
   PRE_ID               NUMBER(7)               ,
   CA_CODIGO            NUMBER(7)              ,
   DET_CANTIDAD         NUMBER(7)               not null,
   constraint PK_DETALLE_PEDIDO primary key (DET_ID, PE_ID)
);

alter table DETALLE_PEDIDO
   add constraint FK_CATALOGO_PROVEEDOR_EQ foreign key (CA_CODIGO)
   references CATALOGO_PROVEEDOR_EQ(CA_CODIGO);

alter table DETALLE_PEDIDO
   add constraint FK_PEDIDO foreign key (PE_ID)
   references PEDIDO(PE_ID);

alter table DETALLE_PEDIDO
   add constraint FK_PRESENTACION foreign key (PRE_ID)
   references PRESENTACION(PRE_ID);

create sequence seq_det_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

create table VALORACION_PEDIDO 
(
   VA_ID                NUMBER(7)               not null,
   DET_ID               NUMBER(7)               not null,
   PE_ID                NUMBER(7)               not null,
   VA_FECHA             DATE                 not null,
   VA_CALIDAD           VARCHAR2(30)            not null,
   VA_COSTO             NUMBER(7)               not null,
   constraint PK_VALORACION_PEDIDO primary key (VA_ID)
);

alter table VALORACION_PEDIDO
   add constraint FK_DETALLE_PEDIDO foreign key (DET_ID)
   refernces DETALLE_PEDIDO(DET_ID);

alter table VALORACION_PEDIDO
   add constraint FK_DETALLE_PEDIDO2 foreign key (PE_ID)
   references DETALLE_PEDIDO(PE_ID);

create sequence seq_va_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;

create table DESCUENTOPEDIDIOPARAPRODUCCION 
(
   DES_ID               NUMBER(7)               not null,
   PRO_FECHA            DATE                 not null,
   FA_ID                NUMBER(7)               not null,
   EM_ID                NUMBER(7)               not null,
   PC_ID                NUMBER(7)               not null,
   CE_ID                NUMBER(7)               not null,
   DET_ID               NUMBER(7)               not null,
   PE_ID                NUMBER(7)               not null,
   DES_CANTIDAD         NUMBER(7)               not null,
   constraint PK_DESCUENTOPRODUCCIONPRODUCCION primary key (DES_ID)
);

alter table DESCUENTOPEDIDIOPARAPRODUCCION
   add constraint FK_PRODUCCION_MENSUAL foreign key (PRO_FECHA)
   references PRODUCCIONMENSUAL(PRO_FECHA);

alter table DESCUENTOPEDIDIOPARAPRODUCCION
   add constraint FK_FABRICA foreign key (FA_ID)
   references PRODUCCIONMENSUAL(FA_ID);

alter table DESCUENTOPEDIDIOPARAPRODUCCION
   add constraint FK_EMPRESA foreign key (EMP_ID)
   references PRODUCCIONMENSUAL(EM_ID);

alter table DESCUENTOPEDIDIOPARAPRODUCCION
   add constraint FK_PRESENTACION_CERVEZA foreign key (PC_ID)
   references PRODUCCIONMENSUAL(PC_ID);

alter table DESCUENTOPEDIDIOPARAPRODUCCION
   add constraint FK_CERVEZA foreign key (CE_ID)
   references PRODUCCIONMENSUAL(CE_ID);

alter table DESCUENTOPEDIDIOPARAPRODUCCION
   add constraint FK_DETALLE_PEDIDO foreign key (DET_ID)
   references DETALLE_PEDIDO(DET_ID);

alter table DESCUENTOPEDIDIOPARAPRODUCCION
   add constraint FK_PEDIDO foreign key (PE_ID)
   references DETALLE_PEDIDO(PE_ID);

create sequence seq_des_id
   start with 1
   increment by 1
   maxvalue 1
   minvalue 1;























