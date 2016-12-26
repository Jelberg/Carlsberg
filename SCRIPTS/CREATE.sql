
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


create table ESTILO 
(
   ES_ID                NUMBER(7)               not null,
   ES_NOMBRE            VARCHAR2(30)            not null,
   ES_DESCRIPCION       VARCHAR2(30)            not null,
   ES_COMIDA            COMIDA_NT,
   ES_IBU               VARCHAR2(10)             not null,
   ES_NOMBRETEMPORADA   VARCHAR2(30),
   ES_TEMPERATURA       MEDIDA,
   constraint PK_ESTILO primary key (ES_ID)
)nested table ES_COMIDA store as comidas;                         --los nombres no pueden ser iguales, genera error


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
   CE_DESCRIPCION       VARCHAR2(100),                                                                          --POR QUE CLOB??
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


create table DISTRIBUCION_CERVEZA
(
   PA_ID                NUMBER(7)               not null,
   PC_ID                NUMBER(7)               not null,
   CE_ID                NUMBER(7)               not null,
   DIS_CER_DISTRIBUCION DISTRIBUCION_NT,
   constraint PK_DISTRIBUCION primary key (PA_ID,PC_ID,CE_ID)
)
NESTED TABLE DIS_CER_DISTRIBUCION STORE AS DISTRI;


--CREATE OR REPLACE TYPE TELEFONO_VA AS VARRAY(5) OF VARCHAR2(15);


create table PROVEEDORES 
(
   PR_ID                NUMBER(7)               not null,
   PA_ID                NUMBER(7)               not null,
   PR_NOMBRE            VARCHAR2(30)  unique    not null,
   PR_CORREO            VARCHAR2(30)  unique    not null,
  -- PR_TELEFONO          TELEFONO_VA                     ,  -- >>>NO VA POR, QUE YA ESTA EN CONTACTO
   PR_FORMASENVIO       FORMAS_ENVIO_VA           ,                       ------Esto no se sacaba con la entidad envios?O es un check de envios?
   PR_FORMASPAGO        FORMAPAGO_NT,                                                                 -----YO CREO QUE FORMAS DE ENVIO ES UN VARRAY ---LO QUE NO SE ES DONDE SE VE ESO EN EL CONTRATO
   PR_CONTACTOS         CONTACTO,                                                                     ----- AUNQUE AUN ASI NO LE VEO LA UTILIDAD PORQUE TAMBIEN SE PUEDE USAR LA ENTIDAD ENVIOS AGREGANDO ATRIBUTO TIPOO_ENVIO
   PR_RESULTADOEVALUACION RESULTADOEVALUACION_NT,
   PR_WEB               VARCHAR2(30),
   constraint PK_PROVEEDORES primary key (PR_ID)
)nested table PR_FORMASPAGO store as formasDePago
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

create table EMPRESA 
(
   EM_ID                NUMBER(7)               not null,
   CI_ID                NUMBER(7)               not null,
   EM_NOMBRE            VARCHAR2(30)  unique    not null,
   EM_FECHAAPERTURA     DATE                 not null,
   EM_RESUMENH          RESUMENHISTORICO_NT,                                    
   EM_LOGO              BLOB             not null,                                    
   EM_PATROCINIO        PATROCINIO_NT,
   EM_RECETAPROCESOBASICO RECETAPROCESOBASICO_NT,
   EMP_EM_ID            NUMBER(7),
   constraint PK_EMPRESA primary key (EM_ID)
)nested table EM_PATROCINIO store as patrocinios
 nested table EM_RESUMENH store as resumeneshistoricos
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
   MA_PALABRACLV        RECETAPROCESOBASICO_NT            ,           ---- Esto deberia de seer un check -- RECETAPROCESOBASICO_NT
   MA_DESCRIPCION_      VARCHAR2(100)                  not null,
   constraint PK_MAQUINARIA primary key (MA_ID)
)NESTED TABLE MA_PALABRACLV STORE AS ACTIVIDAD_PROCESO;  


create table CATALOGO_PROVEEDOR_EQ 
(
   CA_CODIGO            NUMBER(7)               not null,
   CA_NOMBRE            VARCHAR2(30)            not null,
   CA_DESCRIPCION       VARCHAR2(50)                 not null,                                           -- PORQUE CLOB?
   CA_PRECIOUNITARIO    NUMBER(7)               not null,
   CA_ESPECIFICAIONESTECNICAS CLOB                 not null,
   CA_FOTOS             FOTOS_NT ,                                                                     
   CA_INCLUYE           CLOB,
   PR_ID                NUMBER(7),
   MA_ID                NUMBER(7),
   constraint PK_CATALOGO_PROVEEDOR_EQ primary key (CA_CODIGO)
)NESTED TABLE CA_FOTOS STORE AS FOTOS_MAQUINARIA;

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
   --VC_ID                NUMBER(7)               not null,  -- NO TIENE ID PROPIA 
   VAR_ID               NUMBER(7)               not null,
   PA_ID                NUMBER(7)               not null,
   constraint PK_V_C primary key (VAR_ID, PA_ID)
);


create table CATALOGO_PROVEEDOR_MP 
(
   PR_ID                NUMBER(7)               not null,
   MP_ID                NUMBER(7)             ,
   CP_ID                NUMBER(7)               not null,
   VAR_ID               NUMBER(7)             ,
   CP_NOMBRE            VARCHAR2(30)            not null,
   CP_DESCRIPCION       VARCHAR2(30)            not null,
   CP_FOTOS             FOTOS_NT,                                                                              --CONJUTO DE FOTOS
   constraint PK_CATALOGO_PROVEEDOR_MP primary key (CP_ID)
) NESTED TABLE CP_FOTOS STORE AS FOTOS_MATERIA_P;


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
--LO QUE CREO ES QUE TIPOPAGO ES TABLA ANIDADA, ORQUE SI NO,NO LE VEO EL USO 


create table PAGO 
(
   PA_ID                NUMBER(7)               not null,
   PE_ID                NUMBER(7)               not null,
   PA_TIPOPAGO          FORMAPAGO_NT,
   PA_MONTO             NUMBER(7)               not null,
   PA_FECHA             DATE                 not null,
  -- PA_CUENTA            DATOSCUENTA,
   PA_CUOTA             NUMBER(7),
   constraint PK_PAGO primary key (PA_ID)
)nested table PA_TIPOPAGO STORE AS TIPOS_DE_PAGO;



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
   PRE_MEDIDA           MEDIDA             not null,
   PRE_TIPO             VARCHAR2(30)            not null
      constraint CKC_PRE_TIPO_PRESENTA check (PRE_TIPO in ('bolsa','saco','caja','sachet','otros')),
   PRE_PRECIOU          NUMBER(7)               not null,
   PRE_DESCRIPCION      VARCHAR2(40),                                                               -- PORQUE CLOB?
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
   --DES_ID               NUMBER(7)               not null,
   PRO_FECHA            DATE                 not null,
   FA_ID                NUMBER(7)               not null,
   EM_ID                NUMBER(7)               not null,
   PC_ID                NUMBER(7)               not null,
   CE_ID                NUMBER(7)               not null,
   DET_ID               NUMBER(7)               not null,
   PE_ID                NUMBER(7)               not null,
   DES_CANTIDAD         NUMBER(7)               not null,
   constraint PK_DESCUENTO primary key (PRO_FECHA,FA_ID,EM_ID,PC_ID,CE_ID,DET_ID,PE_ID)     -- PORQUE TIENE ID PROPIA??
);























