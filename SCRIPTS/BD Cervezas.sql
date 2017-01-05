/*
//=============================================//
//                                             //
//                    TYPE                     //
//=============================================//
*/

CREATE OR REPLACE TYPE FOTOS AS OBJECT (
FOTOS       BLOB 
);
/
CREATE OR REPLACE TYPE FOTOS_NT AS TABLE OF FOTOS;
/

-----TDA

CREATE OR REPLACE TYPE MEDIDA AS OBJECT(
    ME_VALOR        VARCHAR2(300)     ,
    ME_UNIDAD      VARCHAR2(300)         
);
/

CREATE OR REPLACE TYPE COMIDA AS OBJECT (
    CON_NOMBRE         VARCHAR2(300)            ,
    CON_DESCRIPCION    VARCHAR2(300)             
);
/
CREATE OR REPLACE TYPE PATROCINIO AS OBJECT (
    PATROCINIO_NOMBRE  VARCHAR2(300)             ,
    PATROCINIO_DESCRIPCION VARCHAR2(300)        ,
    PATROCINIO_AÑOS    VARCHAR2(300)             
);
/

CREATE OR REPLACE TYPE DISTRIBUCION AS OBJECT (
DIS_MESAÑO                DATE,
DIS_CANTHECTOLITROS    NUMBER(7)
);
/

CREATE OR REPLACE TYPE DATOSCUENTA AS OBJECT (
    DAC_BANCO          VARCHAR2(300) ,
    DAC_NUMCUENTA      NUMBER(7)   ,
    DAC_NOMBRE         VARCHAR2(300) ,
    DAC_TIPOCUENTA     VARCHAR2(300),
    DAC_EMAIL          VARCHAR2(300)   
);
/

CREATE OR REPLACE TYPE FORMAPAGO AS OBJECT (
    FPAGO_TIPO         VARCHAR2(300),
    FPAGO_DESCRIPCION  VARCHAR2(300) ,
    FPAGO_TIEMPOCUOTAS VARCHAR2(300),
    FPAGO_CANTCUOTAS   NUMBER(7),
    FPAGO_DATOSCUENTAS DATOSCUENTA
);   ---->>> NO SE SI SE PUEDE PONER ASI
/

CREATE OR REPLACE TYPE CONTACTO AS OBJECT (
    CON_NOMBRE         VARCHAR2(300)  ,
    CON_APELLIDO       VARCHAR2(300)   ,
    CON_CARGO          VARCHAR2(300)   ,
    CON_TELEFONO       VARCHAR2(300)    
);
/
-- PARA la palabra clave si es etapa, el atributo etapa estara lleno y actividad que al fin de cuentas en el mismo proeso estara vacio, y si es proceso es lo contrario de lo anterior. Y la palabra clave como tal es es atributo rpb_descripcion
CREATE OR REPLACE TYPE RECETAPROCESOBASICO AS OBJECT (            
    RPB_ETAPA          VARCHAR2(300) ,
    RPB_ACTIVIDAD      VARCHAR2(300) , --- MISMO PROCESO
	RPB_DESCRIPCION    VARCHAR2(100),
	RPB_TEMI           VARCHAR2(300),                                 
	RPB_TEMF           VARCHAR2(300)
);
/


CREATE OR REPLACE TYPE RESUMENHISTORICO AS OBJECT (
    RE_FECHA           DATE                 ,
    RE_HECHO           VARCHAR2(100)                  
);
/

CREATE OR REPLACE TYPE RESULTADOEVALUACION AS OBJECT (
    RES_AÑO            DATE                 ,
    RES_RESULTADO      NUMBER(7)               ,
    RES_POSICION       NUMBER(7)               ,
    RES_IDPRODUCTOR    NUMBER(7)              ,
    RES_RUBRO          VARCHAR2(300)           
);
/


-----NESTED 

CREATE OR REPLACE type DATOS_CUENTA_NT AS TABLE OF DATOSCUENTA;
/

CREATE OR REPLACE TYPE COMIDA_NT AS TABLE OF COMIDA;
/

CREATE OR REPLACE TYPE PATROCINIO_NT AS TABLE OF PATROCINIO;
/

CREATE OR REPLACE TYPE DISTRIBUCION_NT AS TABLE OF DISTRIBUCION;
/

CREATE OR REPLACE TYPE FORMAPAGO_NT AS TABLE OF FORMAPAGO;
/

CREATE OR REPLACE TYPE RESULTADOEVALUACION_NT AS TABLE OF RESULTADOEVALUACION;
/

CREATE OR REPLACE TYPE RECETAPROCESOBASICO_NT AS TABLE OF RECETAPROCESOBASICO;
/

CREATE OR REPLACE TYPE RESUMENHISTORICO_NT AS TABLE OF RESUMENHISTORICO
/

CREATE OR REPLACE TYPE CONTACTOS_NT AS TABLE OF CONTACTO;
/

-----VARRAY


CREATE OR REPLACE TYPE FORMAS_ENVIO_VA AS VARRAY(6) OF VARCHAR2(300);
/
create or replace type ce_ibu_va as Varray(2) of varchar2(7);
/

/*
//=============================================//
//                                             //
//                    CREATE                   //
//=============================================//
*/

create table PAIS 
(
   PA_ID                NUMBER(7)               not null,
   PA_NOMBRE            VARCHAR2(300)   unique   not null,
   PA_CONTINENTE        VARCHAR2(300)            not null,
   constraint PK_PAIS primary key (PA_ID)
);

create table CIUDAD 
(
   CI_ID                NUMBER(7)               not null,
   PA_ID                NUMBER(7)               not null,
   CI_NOMBRE            VARCHAR2(300)   unique   not null,
   constraint PK_CIUDAD primary key (CI_ID)
);


create table ESTILO 
(
   ES_ID                NUMBER(7)               not null,
   ES_NOMBRE            VARCHAR2(300)            not null,
   ES_DESCRIPCION       VARCHAR2(300)            not null,
   ES_COMIDA            COMIDA_NT,
   ES_IBU               VARCHAR2(10)             not null,
   ES_NOMBRETEMPORADA   VARCHAR2(300),
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
   CE_MARCA             VARCHAR2(300)            not null,
   CE_NOMBREINGLES      VARCHAR2(300)            not null,
   CE_IBU               VARCHAR2(10)             not null,
   CE_ABV               VARCHAR2(10)             not null,
   CE_TEMPORADA         VARCHAR2(300)            not null
      constraint CHC_CE_TEMPORADA_CERVEZA check (CE_TEMPORADA in ('clasica','temporada')),
   CE_FOTOS             BLOB,                                                                         -- CONJUNTO DE FOTOS
   CE_DESCRIPCION       VARCHAR2(100),                                                                          --POR QUE CLOB??
   CE_PAGINAWEB         VARCHAR2(300),
   CE_SABOR             VARCHAR2(10),
   constraint PK_CERVEZA primary key (CE_ID)
)nested table CE_PATROCINIO store as patrocinios;


create table PRESENTACION_CERVEZA 
(
   PC_ID                NUMBER(7)               not null,
   CE_ID                NUMBER(7)               not null,
   PC_TIPO              VARCHAR2(300)            not null
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
   PR_NOMBRE            VARCHAR2(300)  unique    not null,
   PR_CORREO            VARCHAR2(300)  unique    not null,
  -- PR_TELEFONO          TELEFONO_VA                     ,  -- >>>NO VA POR, QUE YA ESTA EN CONTACTO
   PR_FORMASENVIO       FORMAS_ENVIO_VA           ,                       ------Esto no se sacaba con la entidad envios?O es un check de envios?
   PR_FORMASPAGO        FORMAPAGO_NT,                                                                 -----YO CREO QUE FORMAS DE ENVIO ES UN VARRAY ---LO QUE NO SE ES DONDE SE VE ESO EN EL CONTRATO
   PR_CONTACTOS         CONTACTO,                                                                     ----- AUNQUE AUN ASI NO LE VEO LA UTILIDAD PORQUE TAMBIEN SE PUEDE USAR LA ENTIDAD ENVIOS AGREGANDO ATRIBUTO TIPOO_ENVIO
   PR_RESULTADOEVALUACION RESULTADOEVALUACION_NT,
   PR_WEB               VARCHAR2(300),
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
   EM_NOMBRE            VARCHAR2(300)  unique    not null,
   EM_FECHAAPERTURA     DATE                    not null,
   EM_RESUMENH          RESUMENHISTORICO_NT             ,                                    
   EM_LOGO              BLOB                    not null,                                    
   EM_PATROCINIO        PATROCINIO_NT                   ,
   EM_RECETAPROCESOBASICO RECETAPROCESOBASICO_NT        ,
   EMP_EM_ID            NUMBER(7)                       ,
   constraint PK_EMPRESA primary key (EM_ID)
)nested table EM_PATROCINIO store as PATROCINADORES
 nested table EM_RESUMENH store as RESUMENES
 nested table EM_RECETAPROCESOBASICO store as RECETAS_DE_PROCESOS;


create table FABRICA 
(
   FA_ID                NUMBER(7)               not null,
   EM_ID                NUMBER(7)               not null,
   CI_ID                NUMBER(7)               not null,
   FA_NOMBRE            VARCHAR2(300) unique,
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
   MA_NOMBRE            VARCHAR2(300)            not null,
   MA_PALABRACLV        RECETAPROCESOBASICO_NT            ,           ---- Esto deberia de seer un check -- RECETAPROCESOBASICO_NT
   MA_DESCRIPCION_      VARCHAR2(100)                  not null,
   constraint PK_MAQUINARIA primary key (MA_ID)
)NESTED TABLE MA_PALABRACLV STORE AS ACTIVIDAD_PROCESO;  


create table CATALOGO_PROVEEDOR_EQ 
(
   CA_CODIGO            NUMBER(7)               not null,
   CA_NOMBRE            VARCHAR2(300)            not null,
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
   MP_NOMBRE            VARCHAR2(300)            not null,
   MP_DESCRIPCION       VARCHAR2(50)                not null,                                                    --POR QUE CLOB?
   MP_FORMASDISLUPULO   VARCHAR2(300),
   constraint PK_MATERIA_PRIMA primary key (MP_ID)
);


create table VARIEDAD 
(
   VAR_ID               NUMBER(7)               not null,
   MP_ID                NUMBER(7)               not null,
   VAR_TIPO             VARCHAR2(300)            not null
      constraint CHC_VAR_TIPO_VARIEDAD check (VAR_TIPO in ('base','coloreada')),
   VAR_NOMBRE           VARCHAR2(300)            not null,
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
   CP_NOMBRE            VARCHAR2(300)            not null,
   CP_DESCRIPCION       VARCHAR2(300)            not null,
   CP_FOTOS             FOTOS_NT,                                                                              --CONJUTO DE FOTOS
   constraint PK_CATALOGO_PROVEEDOR_MP primary key (CP_ID)
) NESTED TABLE CP_FOTOS STORE AS FOTOS_MATERIA_P;


create table PEDIDO 
(
   PE_ID                NUMBER(7)               not null,
   CON_NUMERO           NUMBER(7)               not null,
   PE_FECHAPEDIDO       DATE                 not null,
   PE_STATUS            VARCHAR2(300)            not null,
   PE_FECHAENTREGA      DATE                 not null,
   PE_TIPO              VARCHAR2(300)            not null,
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
   PRE_TIPO             VARCHAR2(300)            not null
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

/*
//=============================================//
//                                             //
//                    ALTER                    //
//=============================================//
*/

------------PAIS

alter table PAIS
   add constraint CHK_CONTINENTE check (PA_CONTINENTE in ('Africa','Asia','Antartida','Europa','Norteamerica','Oceania','Sudamerica'));

------------CIUDAD   

alter table CIUDAD
   add constraint FK_CI_PAIS foreign key (PA_ID)
     references PAIS (PA_ID);
	 
------------ESTILO	 

alter table estilo drop column es_nombretemporada;

-------------CERVEZA
   
alter table CERVEZA
   add constraint FK_CER_ESTILO foreign key (ES_ID)
   references ESTILO(ES_ID);

alter table CERVEZA
   add constraint CHK_PORCENTAJEALC check (CE_PORCETAJEALC between 0 and 100);
   
ALTER TABLE cerveza DROP COLUMN ce_ibu;

alter table cerveza add ce_ibu ce_ibu_va not null;

-------------PRESENTACION DE CERVEZA
   
alter table PRESENTACION_CERVEZA
   add constraint FK_PC_CERVEZA foreign key (CE_ID)
   references CERVEZA(CE_ID);
   
-------------DISTRIBUCION_CERVEZA 

ALTER TABLE DISTRIBUCION_CERVEZA DROP PRIMARY KEY;
 
alter table DISTRIBUCION_CERVEZA
   add constraint FK_DC_PRESENTACION_CERVEZA foreign key (PC_ID, CE_ID)
      references PRESENTACION_CERVEZA(PC_ID, CE_ID);	 
	 
alter table DISTRIBUCION_CERVEZA
   add constraint FK_DC_PAIS foreign key (PA_ID)
      references PAIS(PA_ID);
	  
ALTER TABLE DISTRIBUCION_CERVEZA 
   ADD CONSTRAINT PK_DC PRIMARY KEY (PC_ID,CE_ID,PA_ID);

--------------PROVEEDORES

alter table PROVEEDORES
   add constraint FK__PR_PAIS foreign key (PA_ID)
   references PAIS(PA_ID);
   
--------------ENVIOS
   
alter table ENVIOS
   add constraint FK__EN_PROVEEDOR foreign key (PR_ID)
   references PROVEEDORES(PR_ID);

alter table ENVIOS
   add constraint FK__EN_CIUDAD foreign key (CI_ID)
   references CIUDAD(CI_ID);

   ALTER TABLE ENVIOS DROP PRIMARY KEY;

   ALTER TABLE ENVIOS DROP COLUMN EN_ID ;         -------POR QUE NO TIENE ID PROPPIA
   
   ALTER TABLE ENVIOS 
   ADD CONSTRAINT PK_ENVIOS PRIMARY KEY (PR_ID,CI_ID);
   
--------------EMPRESA
   
alter table EMPRESA
   add constraint FK__EM_CIUDAD_UBICACION foreign key (CI_ID)
   references CIUDAD(CI_ID);

alter table EMPRESA
   add constraint FK_DUEÑO foreign key (EMP_EM_ID)
   references EMPRESA(EM_ID);

alter table empresa 
modify EM_FECHAAPERTURA  number(4) ;
  
--------------FABRICA 

alter table FABRICA
   add constraint FK__FA_EMPRESA foreign key (EM_ID)
   references EMPRESA(EM_ID);

alter table FABRICA
   add constraint FK__FA_CIUDAD foreign key (CI_ID)
   references CIUDAD(CI_ID);
   
-------------CONTRATO

alter table CONTRATO
   add constraint FK_CON_EMPRESA foreign key (EM_ID)
   references EMPRESA(EM_ID);

alter table CONTRATO
   add constraint FK_CON_PROVEEDOR foreign key (PR_ID)
   references PROVEEDORES(PR_ID);
   
------------CATALOGO DE EQUIPOS
   
alter table CATALOGO_PROVEEDOR_EQ
   add constraint FK_CP_PROVEEDOR foreign key (PR_ID)
   references PROVEEDORES(PR_ID);

alter table CATALOGO_PROVEEDOR_EQ
   add constraint FK_CP_MAQUINARIA foreign key (MA_ID)
   references MAQUINARIA(MA_ID);
   
------------MATERIA PRIMA
   
alter table MATERIA_PRIMA
   add constraint CHK_FORMASDISLUPULO check (MP_FORMASDISLUPULO in ('seco','plug','rehidratado'));
   
------------VARIEDAD

alter table VARIEDAD
   add constraint FK_VA_MATERIAPRIMA foreign key (MP_ID)
   references MATERIA_PRIMA(MP_ID);
   
------------VARIEDAD PAIS
   
alter table V_C
   add constraint FK_VC_VARIEDAD foreign key (VAR_ID)
   references VARIEDAD(VAR_ID);

alter table V_C
   add constraint FK_VC_PAIS foreign key (PA_ID)
   references  PAIS(PA_ID);
   
------------CATALOGO MATERIA PRIMA

alter table CATALOGO_PROVEEDOR_MP
   add constraint FK__CP_MATERIAPRIMA foreign key (MP_ID)
   references MATERIA_PRIMA(MP_ID);

alter table CATALOGO_PROVEEDOR_MP
   add constraint FK_CPMP_PROVEEDOR foreign key (PR_ID)
   references PROVEEDORES(PR_ID);

alter table CATALOGO_PROVEEDOR_MP
   add constraint FK_CP_VARIEDAD foreign key (VAR_ID)
   references VARIEDAD(VAR_ID);
   
------------PEDIDOS

alter table PEDIDO
   add constraint CHK_STATUS check (PE_STATUS in ('en proceso','cancelada','rechazada por proveedor','finalizada'));

alter table PEDIDO
   add constraint CHK_TIPOPEDIDO check (PE_TIPO IN ('materia prima','equipo'));

alter table PEDIDO
   add constraint FK_PE_CONTRATO foreign key (CON_NUMERO)
   references CONTRATO(CON_NUMERO);
   
------------PAGO
   
alter table PAGO
   add constraint FK_PA_PEDIDO foreign key (PE_ID)
   references PEDIDO(PE_ID);

--ALteR table PAGO                                         VA EN TDA
  --Add constraint CHK_TIPOPAGO check (PA_TIPOPAGO in ('efectivo','transferencia','deposito','cheque'));
   
------------COMPASICION

alter table COMPOSICION
   add constraint FK_COM_CERVEZA foreign key (CE_ID)
   references CERVEZA(CE_ID);

alter table COMPOSICION
   add constraint CHK_PROPORCION check (C_PROPORCION between 1 and 100);

alter table COMPOSICION
   add constraint FK_COM_VARIABLE foreign key (VAR_ID)
   references VARIEDAD(VAR_ID);

alter table COMPOSICION
   add constraint FK_COM_MATERIAPRIMA foreign key (MP_ID)     
   references MATERIA_PRIMA(MP_ID);
   
------------PRODUCCION MENSUAL
   
alter table PRODUCCIONMENSUAL
   add constraint FK_PRO_FABRICA foreign key (FA_ID,EM_ID)
   references FABRICA(FA_ID,EM_ID);

alter table PRODUCCIONMENSUAL
   add constraint FK_PRO_PRESENTACION_CERVEZA foreign key (PC_ID,CE_ID)
   references PRESENTACION_CERVEZA(PC_ID,CE_ID);

   
--------------PRESENTACION 
   
alter table PRESENTACION
   add constraint FK_PRE_CATALOGO_PROVEEDOR_MP foreign key (CP_ID)
   references CATALOGO_PROVEEDOR_MP(CP_ID);
   
-------------- DETALLE PEDIDO 
   
alter table DETALLE_PEDIDO
   add constraint FK_DP_CATALOGO_PROVEEDOR_EQ foreign key (CA_CODIGO)  -- EQUIPO
   references CATALOGO_PROVEEDOR_EQ(CA_CODIGO);

alter table DETALLE_PEDIDO
   add constraint FK_DP_PEDIDO foreign key (PE_ID)
   references PEDIDO(PE_ID);

alter table DETALLE_PEDIDO
   add constraint FK_DP_PRESENTACION foreign key (PRE_ID)    -- MATERI PRIMA
   references PRESENTACION(PRE_ID);
   

-----------------DESCUENTO DEL PEDIDO PARA PRODUCCION 
   
alter table DESCUENTOPEDIDIOPARAPRODUCCION
   add constraint FK_DES_PRODUCCION_MENSUAL foreign key (PRO_FECHA,FA_ID,EM_ID,PC_ID,CE_ID)
   references PRODUCCIONMENSUAL(PRO_FECHA,FA_ID,EM_ID,PC_ID,CE_ID);


alter table DESCUENTOPEDIDIOPARAPRODUCCION
   add constraint FK_DES_DETALLE_PEDIDO foreign key (DET_ID,PE_ID)
   references DETALLE_PEDIDO(DET_ID,PE_ID);


---- Estos alter son por que falto poner clave compuesta en catalogo_proveedor_EQ

alter table Detalle_pedido drop column ca_codigo;

alter table catalogo_proveedor_EQ drop primary key;

alter table catalogo_proveedor_EQ
add constraint PK_CatalogoEQ primary key (ca_codigo,pr_id);

alter table Detalle_pedido
add ca_codigo number(7);

alter table Detalle_pedido
add pr_id number(7);

alter table detalle_pedido
add constraint fk_dp_catalogoEQ foreign key (ca_codigo,pr_id)
references catalogo_proveedor_EQ (ca_codigo,pr_id);

---------------Este alter es por el not null que esta mal colocado en pedido

alter table pedido modify pe_fechasolicitada date not null ;

alter table pedido drop column pe_fechaentrega;

alter table pedido
add pe_fechaentrega date;

/*
//=============================================//
//                                             //
//                  SEQUENCE                   //
//=============================================//
*/

create sequence seq_ci_id
   start with 1
   increment by 1
  ;
  
create sequence seq_pr_id
   start with 1
   increment by 1
 ;

create sequence seq_pa_id
   start with 1
   increment by 1
   
   ;
   
create sequence seq_dis_id
   start with 1
   increment by 1
   
   ;
   
create sequence seq_en_id
   start with 1
   increment by 1
   
   ;
   
  create sequence seq_em_id
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_fa_id
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_con_numero
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_ma_id
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_ca_codigo
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_mp_id
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_var_id
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_vc_id
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_cp_id
   start with 1
   increment by 1
   
   ;

   create sequence seq_pe_id
   start with 1
   increment by 1
   
   ;
   
   
   create sequence seq_es_id
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_ce_id
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_pc_id
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_c_id
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_pre_id
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_det_id
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_va_id
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_des_id
   start with 1
   increment by 1
   
   ;
   
   create sequence seq_pag_id
   start with 1
   increment by 1
   
   ;

