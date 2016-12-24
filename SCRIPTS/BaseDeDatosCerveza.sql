create table PAIS 
(
   PA_ID                NUMBER(7)               not null,
   PA_NOMBRE            VARCHAR2(30)   unique   not null,
   PA_CONTINENTE        VARCHAR2(30)            not null,
   constraint PK_PAIS primary key (PA_ID)
);

create table CIUDAD 
(
   CI_ID                NUMBER(7)               not null,
   PA_ID                NUMBER(7)               not null,
   CI_NOMBRE            VARCHAR2(30)   unique   not null,
   constraint PK_CIUDAD primary key (CI_ID)
);

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

--- que es abu? ABV 
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
   CE_ABV               VARCHAR2(10)             not null,
   CE_TEMPORADA         VARCHAR2(30)            not null
      constraint CHC_CE_TEMPORADA_CERVEZA check (CE_TEMPORADA in ('clasica','temporada')),
   CE_FOTOS             BLOB,                                                                         -- CONJUNTO DE FOTOS
   CE_DESCRIPCION       CLOB,                                                                          --POR QUE CLOB??
   CE_PAGINAWEB         VARCHAR2(30),
   CE_SABOR             VARCHAR2(10),
   constraint PK_CERVEZA primary key (CE_ID)
)nested table CE_PATROCINIO store as patrocinios;


create table PRESENTACION_CERVEZA 
(
   PC_ID                NUMBER(7)               not null,
   CE_ID                NUMBER(7)               not null,
   PC_TIPO              VARCHAR2(30)            not null
      constraint CHC_PC_TIPO_PRESENTA check (PC_TIPO in ('botella','botella retornable','lata','sifon')),
   PC_CANTIDAD          NUMBER(7)               not null,
   constraint PK_PRESENTACION_CERVEZA primary key (PC_ID, CE_ID)
);

CREATE OR REPLACE TYPE DISTRIBUCION AS OBJECT (
DIS_MES                DATE,
DIS_AÑO                DATE,
DIS_CANTHECTOLITROS    NUMBER(7)
);

CREATE OR REPLACE TYPE DISTRIBUCION_NT AS TABLE OF DISTRIBUCION;

create table DISTRIBUCION_CERVEZA
(
   PA_ID                NUMBER(7)               not null,
   PC_ID                NUMBER(7)               not null,
   CE_ID                NUMBER(7)               not null,
   DIS_CER_DISTRIBUCION DISTRIBUCION_NT
   constraint PK_DISTRIBUCION primary key (PA_ID,PC_ID,CE_ID)
)
NESTED TABLE DIS_CER_DISTRIUCION STORE AS DISTRIBUCION;


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

create table ENVIOS 
(
   EN_ID                NUMBER(7)               not null,
   CI_ID                NUMBER(7)               not null,
   PR_ID                NUMBER(7)               not null,
   EN_COSTO             NUMBER(7)               not null,
   EN_TIEMPO_HORAS      NUMBER(7)                  not null,                                   ----Este tiempo cual es?
   constraint PK_ENVIOS primary key (EN_ID,CI_ID, PR_ID)
);

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


create table FABRICA 
(
   FA_ID                NUMBER(7)               not null,
   EM_ID                NUMBER(7)               not null,
   CI_ID                NUMBER(7)               not null,
   FA_NOMBRE            VARCHAR2(30) unique,
   FA_FECHAAPERTURA     DATE                 not null,
   constraint PK_FABRICA primary key (FA_ID, EM_ID)
);


create table CONTRATO 
(
   CON_NUMERO           NUMBER(7)               not null,
   PR_ID                NUMBER(7)               not null,
   CON_FECHAEMISION     DATE                 not null,
   EM_ID                NUMBER(7)               not null,
   CON_CONDICIONESADICIONALES CLOB,
   constraint PK_CONTRATO primary key (CON_NUMERO)
);


create table MAQUINARIA 
(
   MA_ID                NUMBER(7)               not null,
   MA_NOMBRE            VARCHAR2(30)            not null,
   MA_PALABRACLV        VARCHAR2(10)             not null,                                           ---- Esto deberia de seer un check -- CONJUNTO DE VARCHAR2
   MA_DESCRIPCION_      CLOB                 not null,
   --MA_TIPO              VARCHAR2(30)            not null,                                           ---- Que es tipo?
   constraint PK_MAQUINARIA primary key (MA_ID)
);  


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

create table MATERIA_PRIMA 
(
   MP_ID                NUMBER(7)               not null,
   MP_NOMBRE            VARCHAR2(30)            not null,
   MP_DESCRIPCION       VARCHAR2(50)                not null,                                                    --POR QUE CLOB?
   MP_FORMASDISLUPULO   VARCHAR2(30),
   constraint PK_MATERIA_PRIMA primary key (MP_ID)
);


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


create table V_C 
(
   VC_ID                NUMBER(7)               not null,
   VAR_ID               NUMBER(7)               not null,
   PA_ID                NUMBER(7)               not null,
   constraint PK_V_C primary key (VC_ID,VAR_ID, PA_ID)
);


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




CREATE OR REPLACE TYPE PATROCINIO AS OBJECT (
    PATROCINIO_NOMBRE  VARCHAR2(30)             ,
    PATROCINIO_DESCRIPCION VARCHAR2(30)        ,
    PATROCINIO_AÑOS    VARCHAR2(30)             
);

CREATE OR REPLACE TYPE PATROCINIO_NT AS TABLE OF PATROCINIO;


---- El TDA muestra hay que eliminarlo



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

create table DETALLE_PEDIDO 
(
   DET_ID               NUMBER(7)               not null,
   PE_ID                NUMBER(7)               not null,
   PRE_ID               NUMBER(7)               ,
   CA_CODIGO            NUMBER(7)              ,
   DET_CANTIDAD         NUMBER(7)               not null,
   constraint PK_DETALLE_PEDIDO primary key (DET_ID, PE_ID)
);


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
   constraint PK_DESCUENTOPRODUCCIONPRODUCCION primary key (DES_ID)     -- PORQUE TIENE ID PROPIA??
);























