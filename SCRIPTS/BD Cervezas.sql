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
);
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
    RE_HECHO           VARCHAR2(500)                  
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
   CE_MARCA             VARCHAR2(300)            not null,
   CE_NOMBREINGLES      VARCHAR2(300)            not null,
   CE_IBU               VARCHAR2(10)             not null,
   CE_ABV               VARCHAR2(10)             not null,
   CE_TEMPORADA         VARCHAR2(300)            not null
      constraint CHC_CE_TEMPORADA_CERVEZA check (CE_TEMPORADA in ('clasica','temporada')),
   CE_FOTOS             BLOB,                                                                        
   CE_DESCRIPCION       VARCHAR2(100),                                                                          
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





create table PROVEEDORES 
(
   PR_ID                NUMBER(7)               not null,
   PA_ID                NUMBER(7)               not null,
   PR_NOMBRE            VARCHAR2(300)  unique    not null,
   PR_CORREO            VARCHAR2(300)  unique    not null,
   PR_FORMASENVIO       FORMAS_ENVIO_VA           ,                       
   PR_FORMASPAGO        FORMAPAGO_NT,                                                               
   PR_CONTACTOS         CONTACTO,                                                                    
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
   EN_TIEMPO_HORAS      NUMBER(7)                  not null,                                   
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
   MA_PALABRACLV        RECETAPROCESOBASICO_NT            ,           
   MA_DESCRIPCION_      VARCHAR2(100)                  not null,
   constraint PK_MAQUINARIA primary key (MA_ID)
)NESTED TABLE MA_PALABRACLV STORE AS ACTIVIDAD_PROCESO;  


create table CATALOGO_PROVEEDOR_EQ 
(
   CA_CODIGO            NUMBER(7)               not null,
   CA_NOMBRE            VARCHAR2(300)            not null,
   CA_DESCRIPCION       VARCHAR2(50)                 not null,                                           
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
   MP_DESCRIPCION       VARCHAR2(50)                not null,                                                    
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
   CP_FOTOS             FOTOS_NT,                                                                             
   constraint PK_CATALOGO_PROVEEDOR_MP primary key (CP_ID)
) NESTED TABLE CP_FOTOS STORE AS FOTOS_MATERIA_P;


create table PEDIDO 
(
   PE_ID                NUMBER(7)               not null,
   CON_NUMERO           NUMBER(7)               not null,
   PE_FECHAPEDIDO       DATE                 not null,
   PE_STATUS            VARCHAR2(300)            not null,
   PE_FECHAENTREGA      DATE                 ,
   PE_TIPO              VARCHAR2(300)            not null,
   PE_NUMFACTURA        NUMBER(7),
   PE_TOTAL             NUMBER(7),
   PE_FECHASOLICITADA   DATE                   not null,
   constraint PK_PEDIDO primary key (PE_ID)
);



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
   PRE_DESCRIPCION      VARCHAR2(40),                                                              
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

/*create table DESCUENTOPEDIDIOPARAPRODUCCION 
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
   constraint PK_DESCUENTO primary key (PRO_FECHA,FA_ID,EM_ID,PC_ID,CE_ID,DET_ID,PE_ID)     
   
);*/

create table DESCUENTOPEDIDIOPARAPRODUCCION 
(
   DES_ID               NUMBER(7)               not null,
   PRO_FECHA            DATE                 ,
   FA_ID                NUMBER(7)              ,
   EM_ID                NUMBER(7)               not null,
   PC_ID                NUMBER(7)               ,
   CE_ID                NUMBER(7)               ,
   DET_ID               NUMBER(7)               not null,
   PE_ID                NUMBER(7)               not null,
   DES_CANTIDAD         NUMBER(7)               not null,
   constraint PK_DESCUENTO primary key (des_id)     
   
);

create table false_tab_receta(
false_id  number(7),
nombre_mp varchar2(50),
cantidad_ml number(9,2),
cantidad_producible number(9)
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
   
alter table PRODUCCIONMENSUAL
   alter column pro_cantidadenml number(12,0);

   
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
    create sequence seq_des_pred_id
   start with 1
   increment by 1
   
   ;
 
    create sequence seq_false_id
   start with 1
   increment by 1
   maxvalue 60
   cycle
   ;
   
   /*
//=============================================//
//                                             //
//                 TRIGGER                   //
//=============================================//
*/

create or replace trigger tr_actualiza_descuento
after insert on detalle_pedido
declare 
id_pedido   pedido.pe_id%type ;
id_detalle  detalle_pedido.det_id%type;
id_contrato contrato.con_numero%type;
id_empresa   empresa.em_id%type;
begin

select det_id into  id_detalle from (Select det_id from detalle_pedido order by det_id desc) where rownum=1;
  select p.pe_id into id_pedido from pedido p, detalle_pedido dp where p.pe_id= dp.pe_id and det_id = id_detalle;
  
  select c.con_numero into id_contrato from contrato c, pedido p where p.con_numero=c.con_numero and p.pe_id= id_pedido;
  select e.em_id into id_empresa from empresa e, contrato c where c.em_id=e.em_id and c.con_numero= id_contrato;
  
insert into descuentopedidioparaproduccion (DES_ID,pro_fecha,fa_id,em_id,pc_id,ce_id,det_id,pe_id,des_cantidad) 
values (seq_des_pred_id.nextval,null,null,id_empresa,null,null,id_detalle,id_pedido,0);

end;

/
/*
//=============================================//
//                                             //
//                  Proceso de evaluacion                 //
//=============================================//
*/

-->>>>>>>>>>>>>>>>>>>>>>>>>EVALUACION A PROVEEDORES<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

-------------------FUNCTION 

create or replace function fn_nested_evaluacion_vacio (ids proveedores.PR_id%type) return number is
rgistro RESULTADOEVALUACION_NT := RESULTADOEVALUACION_NT();
rg RESULTADOEVALUACION_NT := RESULTADOEVALUACION_NT();
begin 
select PR_RESULTADOEVALUACION into rgistro from proveedores where pr_id = ids;

if rgistro.last = rg.last then return 1;   -->> si esta vacio
else return 0;  -->> Si esta lleno
end if;

EXCEPTION
WHEN OTHERS THEN
return 1;    -->> es atrapado por la excepcion si esta vacio 
end;
/
create or replace function fn_resultado_rubro_1(id_proveedor proveedores.pr_id%type, id_empresa empresa.em_id%type) return number is -- pais del proveedor que realiza la evaluacion
pais_empresa varchar2(30);
pais_proveedor varchar2(30);                                           
resultado number (7);
begin 
select p.pa_nombre into pais_empresa
from pais p, empresa e, ciudad c
where e.em_id=id_empresa and e.ci_id=c.ci_id and c.pa_id=p.pa_id;

select p.pa_nombre into pais_proveedor
from pais p, proveedores pr
where pr.pr_id=id_proveedor and pr.pa_id=p.pa_id;

if pais_empresa = pais_proveedor then resultado:= 0;
else resultado:= -5;
end if;
return resultado ;

end;
/
create or replace function fn_resultado_rubro_2(id_proveedor proveedores.pr_id%type) return number is
fecha_ultimo_contrato date;
id_ultimo_contrato number;
cont_pedidos_tardios number;
cont_pedidos_notardios number;
BEGIN 
--DEVUELVE EL ULTIMO CONTRATO
Select con_fechaemision, con_numero into fecha_ultimo_contrato, id_ultimo_contrato          
from (Select con_numero, con_fechaemision 
from contrato c
where pr_id=id_proveedor
order by c.con_fechaemision desc) 
where rownum =1;

-- no se si se hacen entregas si el estatus es 'en proceso'

select count(pe_id) into cont_pedidos_tardios
from pedido where PE_STATUS = 'finalizada' and con_numero=id_ultimo_contrato and 
(TO_NUMBER(TO_CHAR(TO_DATE(PE_FECHASOLICITADA,'DD-mm-yyyy'),'ddmmYYYY'),99999999) < 
TO_NUMBER(TO_CHAR(TO_DATE(PE_FECHAENTREGA,'DD-mm-yyyy'),'ddmmYYYY'),99999999));

select count(pe_id) into cont_pedidos_notardios
from pedido where PE_STATUS = 'finalizada' and con_numero=id_ultimo_contrato and 
(TO_NUMBER(TO_CHAR(TO_DATE(PE_FECHASOLICITADA,'DD-mm-yyyy'),'ddmmYYYY'),99999999) >= 
TO_NUMBER(TO_CHAR(TO_DATE(PE_FECHAENTREGA,'DD-mm-yyyy'),'ddmmYYYY'),99999999));

if cont_pedidos_notardios >= cont_pedidos_tardios then return 0;
else return -10;
end if;

END;
/
create or replace function fn_resultado_rubro_3(id_proveedor proveedores.pr_id%type) return number is
contador_variedad_mp number;

BEGIN 

select count(cp.cp_id) into contador_variedad_mp
from CATALOGO_PROVEEDOR_MP cp, proveedores p
where cp.pr_id = p.pr_id and p.pr_id=id_proveedor;

return contador_variedad_mp;

END;
/
create or replace function fn_resultado_rubro_3_EQ(id_proveedor proveedores.pr_id%type) return number is
contador_variedad_eq number;

BEGIN 

select count(ca.ca_codigo) into contador_variedad_eq
from CATALOGO_PROVEEDOR_EQ ca, proveedores p
where ca.pr_id = p.pr_id and p.pr_id=id_proveedor;

return contador_variedad_eq;
end;

/
create or replace function fn_resultado_rubro_4(id_proveedor proveedores.pr_id%type) return number is
id_contrato number(7);
fecha_emision date;
fecha_tres_y date;
fecha_seis_y date;

begin 
Select con_numero, con_fechaemision into id_contrato, fecha_emision
from (Select con_numero, con_fechaemision 
from contrato c
where pr_id=id_proveedor
order by c.con_fechaemision desc) 
where rownum =1;

SELECT to_date(sysdate,'dd-mm-yyyy')-1095 into fecha_tres_y FROM CONTRATO where con_numero = id_contrato;
SELECT to_date(sysdate,'dd-mm-yyyy')-2190 into fecha_seis_y FROM CONTRATO where con_numero = id_contrato;

if TO_NUMBER(TO_CHAR(TO_DATE(fecha_tres_y,'DD-mm-yyyy'),'YYYY'),99999999) <= 
TO_NUMBER(TO_CHAR(TO_DATE(fecha_emision,'DD-mm-yyyy'),'YYYY'),99999999) then return 0;

elsif TO_NUMBER(TO_CHAR(TO_DATE(fecha_seis_y,'DD-mm-yyyy'),'YYYY'),99999999) > 
TO_NUMBER(TO_CHAR(TO_DATE(fecha_emision,'DD-mm-yyyy'),'YYYY'),99999999) then return -25;

else return -15;


end if;
end;
/
create or replace function fn_resultado_rubro_5(id_proveedor proveedores.pr_id%type) return number is
cont_formas_envio number ;
va_formas_envio PROVEEDORES.PR_FORMASENVIO%type;
begin 
Select PR_FORMASENVIO into va_formas_envio
from proveedores
where pr_id = id_proveedor;
cont_formas_envio:= va_formas_envio.count();

if cont_formas_envio = 1 then return -20;
elsif cont_formas_envio = 2 then return -15;
else return 0;
end if;
end;
/
create or replace function fn_resultado_rubro_6(id_proveedor proveedores.pr_id%type) return number is
cont_formas_pago number;
begin 
select count(n.FPAGO_TIPO) into cont_formas_pago
from proveedores p , table(p.PR_FORMASpago) n
where p.pr_id= id_proveedor;

if cont_formas_pago = 1 then return -20;
elsif cont_formas_pago = 2 then return -15;
else return 0; 
end if;

end;

/


-------------------PROCEDURE PARA MATERIA PRIMA

create or replace procedure PR_resultado_evaluacion_pc(id_empresa empresa.em_id%type) is --Proveedores conocidos

resultado_1 number;
resultado_2 number;
resultado_3 number;
resultado_4 number;
resultado_5 number;
resultado_6 number;

position number :=0;

cursor proveedores_conocidos is 
Select distinct p.pr_id from proveedores p, contrato c, catalogo_proveedor_mp mp where p.pr_id = c.pr_id and p.pr_id=mp.pr_id; 

REGISTRO number;
begin

	OPEN proveedores_conocidos;

	LOOP
		FETCH proveedores_conocidos into REGISTRO;

		resultado_1 := fn_resultado_rubro_1(REGISTRO,id_empresa);
                              -- solo ocurre una vez este if
		if fn_nested_evaluacion_vacio(REGISTRO) = 0 THEN 
			insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_1,null,id_empresa,'1 MATERIA PRIMA');
		ELSE 
			UPDATE PROVEEDORES SET PR_RESULTADOEVALUACION = RESULTADOEVALUACION_NT(RESULTADOEVALUACION(SYSDATE,resultado_1,NULL,id_empresa,'1 MATERIA PRIMA')) WHERE PR_ID = REGISTRO; 
		END IF;
		
		resultado_2:= fn_resultado_rubro_2(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_2,null,id_empresa,'2 MATERIA PRIMA');
		
		resultado_3:= fn_resultado_rubro_3(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_3,null,id_empresa,'3 MATERIA PRIMA');
		
		resultado_4:= fn_resultado_rubro_4(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_4,null,id_empresa,'4 MATERIA PRIMA');
		
		resultado_5:= fn_resultado_rubro_5(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_5,null,id_empresa,'5 MATERIA PRIMA');
		
		resultado_6:= fn_resultado_rubro_6(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_6,null,id_empresa,'6 MATERIA PRIMA');
		
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,(100+resultado_1+resultado_2
		+resultado_3+resultado_4+resultado_5+resultado_6),null,id_empresa,'TOTAL MATERIA PRIMA');
		 
		
		EXIT WHEN proveedores_conocidos%NOTFOUND ;

	END LOOP;

	close proveedores_conocidos;
	
COMMIT;
end;
/



create or replace procedure PR_Resultado_eval_nc(id_empresa empresa.em_id%type) is --Proveedores no conocidos

resultado_1 number;

resultado_3 number;

resultado_5 number;
resultado_6 number;

position number :=0;

cursor proveedores_no_conocidos is 
Select distinct p.pr_id from proveedores p, catalogo_proveedor_mp mp where  p.pr_id not in (Select c.pr_id from contrato c) and p.pr_id=mp.pr_id;  

REGISTRO number;
begin

	OPEN proveedores_no_conocidos;

	LOOP
		FETCH proveedores_no_conocidos into REGISTRO;

		resultado_1 := fn_resultado_rubro_1(REGISTRO,id_empresa);
                              -- solo ocurre una vez este if
		if fn_nested_evaluacion_vacio(REGISTRO) = 0 THEN 
			insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_1,null,id_empresa,'1 MATERIA PRIMA');
		ELSE 
			UPDATE PROVEEDORES SET PR_RESULTADOEVALUACION = RESULTADOEVALUACION_NT(RESULTADOEVALUACION(SYSDATE,resultado_1,NULL,id_empresa,'1 MATERIA PRIMA')) WHERE PR_ID = REGISTRO; 
		END IF;
		
		
		resultado_3:= fn_resultado_rubro_3(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_3,null,id_empresa,'3 MATERIA PRIMA');
		
	
		resultado_5:= fn_resultado_rubro_5(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_5,null,id_empresa,'5 MATERIA PRIMA');
		
		resultado_6:= fn_resultado_rubro_6(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_6,null,id_empresa,'6 MATERIA PRIMA');
		
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,(65+resultado_1
		+resultado_3+resultado_5+resultado_6)*1.54,null,id_empresa,'TOTAL MATERIA PRIMA');
	
		EXIT WHEN proveedores_no_conocidos%NOTFOUND ;

	END LOOP;

	close proveedores_no_conocidos;
	
COMMIT;
end;
/

create or replace PROCEDURE pr_agrega_posicion_mp IS     -- PARA PONER LA POSICION 

position number :=0;

cursor actualiza_posicion is 
select distinct p.pr_id, n.res_resultado
from proveedores p, table(p.pr_resultadoevaluacion) n 
where n.res_rubro = upper('TOTAL MATERIA PRIMA')
and to_char(n.res_año,'dd-mm-yyyy')= to_char(sysdate,'dd-mm-yyyy')
order by n.res_resultado desc;

REGISTRO NUMBER;
RESULTADO_EVA NUMBER;
BEGIN

	OPEN actualiza_posicion;
	LOOP
		FETCH actualiza_posicion into REGISTRO, RESULTADO_EVA;
			update table (select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) n 
			set n.RES_POSICION = position + 1 where n.res_rubro = upper('total materia prima');
			EXIT WHEN actualiza_posicion%NOTFOUND ;
      position:= position +1;
	END LOOP;
	CLOSE actualiza_posicion;
COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE PR_EVALUACION_A_PROVEEDORES_MP(id_empresa empresa.em_id%type) IS
BEGIN 
PR_RESULTADO_EVALUACION_PC(id_empresa);
PR_Resultado_eval_nc(id_empresa);
PR_AGREGA_POSICION_mp;
END;
/

------------- PROCEDURE PARA EQUIPOS 

create or replace procedure PR_resultado_evaluacion_pc_EQ(id_empresa empresa.em_id%type) is --Proveedores conocidos

resultado_1 number;
resultado_2 number;
resultado_3_EQ number;
resultado_4 number;
resultado_5 number;
resultado_6 number;

position number :=0;

cursor proveedores_conocidos is 
Select distinct p.pr_id from proveedores p, contrato c, catalogo_proveedor_eq e where p.pr_id = c.pr_id and p.pr_id=e.pr_id; 

REGISTRO number;
begin

	OPEN proveedores_conocidos;

	LOOP
		FETCH proveedores_conocidos into REGISTRO;

		resultado_1 := fn_resultado_rubro_1(REGISTRO,id_empresa);
                              -- solo ocurre una vez este if
		if fn_nested_evaluacion_vacio(REGISTRO) = 0 THEN 
			insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_1,null,id_empresa,'1 EQUIPO');
		ELSE 
			UPDATE PROVEEDORES SET PR_RESULTADOEVALUACION = RESULTADOEVALUACION_NT(RESULTADOEVALUACION(SYSDATE,resultado_1,NULL,id_empresa,'1 EQUIPO')) WHERE PR_ID = REGISTRO; 
		END IF;
		
		resultado_2:= fn_resultado_rubro_2(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_2,null,id_empresa,'2 EQUIPO');
		
		resultado_3_EQ:= fn_resultado_rubro_3_EQ(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_3_EQ,null,id_empresa,'3 EQUIPO');
		
		resultado_4:= fn_resultado_rubro_4(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_4,null,id_empresa,'4 EQUIPO');
		
		resultado_5:= fn_resultado_rubro_5(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_5,null,id_empresa,'5 EQUIPO');
		
		resultado_6:= fn_resultado_rubro_6(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_6,null,id_empresa,'6 EQUIPO');
		
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,(100+resultado_1+resultado_2
		+resultado_3_EQ+resultado_4+resultado_5+resultado_6),null,id_empresa,'TOTAL EQUIPO');
		
		-- FALTA PONER LA POSICION PERO NO SE COMO 
		
		EXIT WHEN proveedores_conocidos%NOTFOUND ;

	END LOOP;

	close proveedores_conocidos;
	
COMMIT;
end;

/
create or replace procedure PR_Resultado_eval_nc_eq(id_empresa empresa.em_id%type) is --Proveedores no conocidos

resultado_1 number;

resultado_3 number;

resultado_5 number;
resultado_6 number;

position number :=0;

cursor proveedores_no_conocidos is 
Select distinct p.pr_id from proveedores p, catalogo_proveedor_eq mp where  p.pr_id not in (Select c.pr_id from contrato c) and p.pr_id=mp.pr_id;  

REGISTRO number;
begin

	OPEN proveedores_no_conocidos;

	LOOP
		FETCH proveedores_no_conocidos into REGISTRO;

		resultado_1 := fn_resultado_rubro_1(REGISTRO,id_empresa);
                              -- solo ocurre una vez este if
		if fn_nested_evaluacion_vacio(REGISTRO) = 0 THEN 
			insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_1,null,id_empresa,'1 EQUIPO');
		ELSE 
			UPDATE PROVEEDORES SET PR_RESULTADOEVALUACION = RESULTADOEVALUACION_NT(RESULTADOEVALUACION(SYSDATE,resultado_1,NULL,id_empresa,'1 EQUIPO')) WHERE PR_ID = REGISTRO; 
		END IF;
		
		
		resultado_3:= fn_resultado_rubro_3_EQ(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_3,null,id_empresa,'3 EQUIPO');
		
	
		resultado_5:= fn_resultado_rubro_5(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_5,null,id_empresa,'5 EQUIPO');
		
		resultado_6:= fn_resultado_rubro_6(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_6,null,id_empresa,'6 EQUIPO');
		
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,(65+resultado_1
		+resultado_3+resultado_5+resultado_6)*1.54,null,id_empresa,'TOTAL EQUIPO');
	
		EXIT WHEN proveedores_no_conocidos%NOTFOUND ;

	END LOOP;

	close proveedores_no_conocidos;
	
COMMIT;
end;


/

create or replace PROCEDURE pr_agrega_posicion_EQ IS     -- PARA PONER LA POSICION 

position number :=0;

cursor actualiza_posicion is 
select distinct p.pr_id, n.res_resultado
from proveedores p, table(p.pr_resultadoevaluacion) n 
where n.res_rubro = upper('TOTAL EQUIPO')
and to_char(n.res_año,'dd-mm-yyyy')= to_char(sysdate,'dd-mm-yyyy')
order by n.res_resultado desc;

REGISTRO NUMBER;
RESULTADO_EVA NUMBER;
BEGIN

	OPEN actualiza_posicion;
	LOOP
		FETCH actualiza_posicion into REGISTRO, RESULTADO_EVA;
			update table (select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) n 
			set n.RES_POSICION = position + 1 where n.res_rubro = upper('total equipo');
			EXIT WHEN actualiza_posicion%NOTFOUND ;
      position:= position +1;
	END LOOP;
	CLOSE actualiza_posicion;
COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE PR_EVALUACION_A_PROVEEDORES_EQ(id_empresa empresa.em_id%type) IS
BEGIN 
PR_RESULTADO_EVALUACION_PC_EQ(id_empresa);
PR_Resultado_eval_nc_eq(id_empresa);
PR_AGREGA_POSICION_EQ;
END;
/
/*
//=============================================//
//                                             //
//              proceso de produccion mensual//
//=============================================//
*/

--tabla falsa que guarda la receta de la cerveza segun su presentacion_cerveza

create or replace procedure pr_llena_tabla_receta(cerveza cerveza.ce_nombreingles%type, 
id_presentacion_cer presentacion_cerveza.pc_id%type) is

cursor lista_receta  is
select c.ce_nombreingles, mp.mp_nombre, ((com.c_proporcion/100)*pc.pc_cantidad) cantidad_ml 
from cerveza c, composicion com ,materia_prima mp, presentacion_cerveza pc
where c.ce_id = com.ce_id and mp.mp_id = com.mp_id and upper(c.ce_nombreingles) = upper(cerveza) and 
pc.ce_id=c.ce_id and pc.pc_id= id_presentacion_cer;

nombre_ce varchar2(50);
nombre_mp varchar2(50);
cantidad number(8,2);

begin 
open lista_receta;
	loop
	fetch lista_receta INTO nombre_ce, nombre_mp, cantidad;
    insert into false_tab_receta values (seq_false_id.nextval,nombre_mp,cantidad, null);
    exit when lista_receta%NOTFOUND;
	end loop;
close lista_receta;
end;
/

--- De la misma tabla verifica con en inventario, y actualiza las cantidades producibles

create or replace procedure pr_llena_cantidad_producible(empresa empresa.em_nombre%type, id_receta FALSE_TAB_RECETA.FALSE_ID%type ) is

cursor inventario is 
select (sum(dp.det_cantidad)- sum(des.des_cantidad)) cantidas_inventario, m.MP_NOMBRE as nombre_inv, pre.pre_medida.me_unidad as unidad
from detalle_pedido dp, pedido p, presentacion pre, catalogo_proveedor_mp mp, DESCUENTOPEDIDIOPARAPRODUCCION des, 
empresa e, contrato c, materia_prima m
where   
dp.PRE_ID=pre.pre_id 
and e.em_id=des.EM_ID
and dp.pe_id = p.pe_id
and pre.CP_ID=mp.cp_id
and des.pe_id=dp.PE_ID
and m.mp_id= mp.mp_id
and p.PE_STATUS = 'finalizada'
and upper(e.EM_NOMBRE)= upper(empresa)
group by  m.MP_NOMBRE,pre.pre_medida.me_unidad;


registro_2 inventario%rowtype;

producible number(10,2):=0;


valor_nombre FALSE_TAB_RECETA.NOMBRE_MP%type;
valor_ml   FALSE_TAB_RECETA.CANTIDAD_ML%type;


begin 	


 open inventario;
     loop
       fetch inventario into registro_2;
              select nombre_mp, cantidad_ml into valor_nombre, valor_ml from false_tab_receta where false_id = id_receta; 
            
				if registro_2.nombre_inv = valor_nombre then 
						   if registro_2.unidad = 'ml' or registro_2.unidad = 'ML' OR registro_2.unidad = 'mililitro' or registro_2.unidad = 'mililitros' then
								producible := (registro_2.cantidas_inventario/valor_ml);
								DBMS_OUTPUT.PUT_LINE(producible);
								if (producible > 0) then 
									update false_tab_receta set cantidad_producible = producible 
									where upper(nombre_mp) = upper(valor_nombre) ;
									producible:=0;
								end if;
								
							elsif registro_2.unidad = 'l' or registro_2.unidad = 'L' OR registro_2.unidad = 'litro' or registro_2.unidad = 'litros' then
								producible := ((registro_2.cantidas_inventario)*1000/valor_ml);
								DBMS_OUTPUT.PUT_LINE(producible);
								if (producible > 0) then 
									update false_tab_receta set cantidad_producible = producible 
									where upper(nombre_mp) = upper(valor_nombre) ;
									producible:=0;
								end if;
								
							elsif registro_2.unidad = 'kg' or registro_2.unidad = 'KG' OR registro_2.unidad = 'kilogramo' or registro_2.unidad = 'kilogramos' then
								producible := (((registro_2.cantidas_inventario)/0.001)/valor_ml);
								DBMS_OUTPUT.PUT_LINE(producible);
								if (producible > 0) then 
									update false_tab_receta set cantidad_producible = producible 
									where upper(nombre_mp) = upper(valor_nombre) ;
									producible:=0;
								end if;
							elsif registro_2.unidad = 'gr' or registro_2.unidad = 'GR' OR registro_2.unidad = 'gramo' or registro_2.unidad = 'gramos' then
								producible := ((registro_2.cantidas_inventario)*0.001/valor_ml);
								DBMS_OUTPUT.PUT_LINE(producible);
								if (producible > 0) then 
									update false_tab_receta set cantidad_producible = producible 
									where upper(nombre_mp) = upper(valor_nombre) ;
									producible:=0;
								end if;
							end if;
			    end if;
                exit when inventario%NOTFOUND;
end loop;
close inventario;

END;


/

create or replace procedure pr_llena_tabla_receta_2(empresa empresa.em_nombre%type) is

id_receta number (7);
mx_val number(7);
min_val number(7);
cont number(7);

begin 

 Select false_id into min_val from false_tab_receta where rownum =1 order by false_id;
  Select false_id into mx_val from (Select false_id from false_tab_receta order by false_id desc) where rownum=1;
  cont := min_val;
  
  while( cont <= mx_val) loop
  DBMS_OUTPUT.PUT_LINE(cont);
  pr_llena_cantidad_producible(empresa,cont);
  cont:= cont + 1;
  DBMS_OUTPUT.PUT_LINE(cont);
  DBMS_OUTPUT.PUT_LINE(mx_val);
	end loop;

end;

/

create or replace procedure AutoProduccionMensual(cerveza cerveza.ce_nombreingles%type,presentacionCerveza presentacion_cerveza.pc_id%type, fabrica varchar2,fecha date) is
menorValor number;
idFabrica number;
idEmpresa number;
idCerveza number;
producible number;
mlbotella number;
empresa varchar2(30);
comprueba number:=1;
begin

pr_llena_tabla_receta(cerveza,presentacionCerveza);

select em_nombre into empresa from empresa where em_id=(select em_id from fabrica where fa_nombre=fabrica);

pr_llena_tabla_receta_2(empresa);

select cantidad_producible from FALSE_TAB_RECETA where cantidad_producible <> null and rownum = 1;-- para cuando no se consiga el producto (No funciona)

	select cantidad_producible into menorValor from FALSE_TAB_RECETA where rownum=1 order by cantidad_producible desc ;

	select fa_id into idFabrica from fabrica where fa_nombre=fabrica;

	select em_id into idEmpresa from empresa where em_id=(select em_id from fabrica where fa_nombre=fabrica);

	select ce_id into idCerveza from cerveza where ce_nombreingles=cerveza and rownum=1;

	select pc_cantidad into mlbotella from presentacion_cerveza where pc_id=presentacionCerveza;

	producible:=mlbotella*menorValor;

	insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values(fecha,idFabrica ,idEmpresa,presentacionCerveza,idCerveza,producible);

delete from false_tab_receta;  -- no se si conviene borrarlo antes de llenar descuentopedidoparaproduccion
end AutoProduccionMensual;
/*
//=============================================//
//                                             //
//              proceso de pedido                  //
//=============================================//
*/
create or replace procedure pr_compraAProveedores(nombreProveedor varchar2, nombreEmpresa varchar2
    , tipoPedido varchar2, fechaSolicitada date)
is
contrato number;
proveedorId number;
empresaId number;
ultimoPedido number;
begin

contrato:=0;
select pr_id into proveedorId  from proveedores where pr_nombre=nombreProveedor;
dbms_output.put_line(proveedorId);
select em_id into empresaId from empresa where em_nombre=nombreEmpresa;
select con_numero into contrato from contrato where pr_id=proveedorId and em_id=empresaId and 
con_fechaemision+365>to_date(sysdate,'dd/mm/yyyy');

if (contrato>0) then

    dbms_output.put_line('El proveedor '||nombreProveedor|| ' tiene contrato con la Empresa '||nombreEmpresa);

    insert into pedido (pe_id,pe_fechapedido,pe_status,pe_tipo,pe_numfactura,pe_total,pe_fechasolicitada,pe_fechaentrega,con_numero) 
    values (seq_pe_id.nextval,to_date(sysdate,'dd/mm/yyyy'),'en proceso',tipoPedido,
    null,0,to_date(fechaSolicitada,'dd/mm/yyyy'),null,contrato);

    select pe_id into ultimoPedido from pedido where rownum=1 order by pe_id desc;

    dbms_output.put_line('Pedido #'||ultimoPedido || ' registrado con exito');

elsif (contrato=0) then

    dbms_output.put_line('El proveedor '|| nombreProveedor || 'no tiene contrato vigente');

end if;

end pr_compraAProveedores; 
/
create or replace procedure pr_agregarProductoAPedidoMP(materiaPrima varchar2, presentacion varchar2
    ,valorMedida varchar2, unidad varchar2, cantidad number)
    is
    ultimoPedido number;
    precioU number;
    proveedorId number;
    presentacionId number;
    total number;
    begin

    select pe_id into ultimoPedido from pedido where rownum=1 order by pe_id desc;

    select pr_id into proveedorId from proveedores where pr_id=(select pr_id from contrato 
    where con_numero=(select c.con_numero from contrato c, pedido p 
    where c.con_numero=p.con_numero and pe_id=ultimoPedido));

    select pre.pre_id into presentacionId 
    from presentacion pre, catalogo_proveedor_mp cp
    where                                                                         
    pre.cp_id=cp.cp_id and cp.cp_nombre=materiaPrima and pre.pre_tipo=presentacion 
	
     -- Si fuera un nested table abria que poner en el from  "presentacion pre, table (pre.pre_medida) " pero como en este caso en un tda sencillo solo hay que poner en la comparacion "pre.pre_medida.me_valor" que seria ALIAS.NOMBREATRIBUTOENLATABLA.NOMBREATRIBUTOENELTYPE 
    
	and pre.pre_medida.me_valor=valorMedida   and pre.pre_medida.me_unidad = unidad 
    and cp.pr_id=proveedorId and  rownum=1;

    insert into detalle_pedido (det_id, pe_id,pre_id,det_cantidad,ca_codigo,pr_id)
    values (seq_det_id.nextval, ultimoPedido, presentacionId, cantidad, null, proveedorId);

    dbms_output.put_line('Se ha agregado al pedido #'||ultimoPedido||' '||materiaPrima ||' en '||presentacion||' un total de '||cantidad);

    select p.pre_preciou into precioU from presentacion p where p.cp_id=(select cp_id from catalogo_proveedor_mp 
    where cp_nombre=materiaPrima and pr_id=proveedorId and rownum=1) and rownum=1;

    update pedido set pe_total=pe_total+precioU where pe_id=ultimoPedido;

    select pe_total into total from pedido where pe_id=ultimoPedido;

    dbms_output.put_line('El precio total de su pedido es ahora de '||total);

    end pr_agregarProductoAPedidoMP;
/
create or replace procedure pr_agregarProductoAPedidoE(equipo varchar2, cantidad number)
    is
    ultimoPedido number;
    catalogoProveedorEquipoId number;
    precio number;
    proveedorId number;
    total number;
    begin

    select pe_id into ultimoPedido from pedido where rownum=1 order by pe_id desc;

    select pr_id into proveedorId from proveedores where pr_id=(select pr_id from contrato 
    where con_numero=(select c.con_numero from contrato c, pedido p 
    where c.con_numero=p.con_numero and pe_id=ultimoPedido));

    select ca_codigo into catalogoProveedorEquipoId from catalogo_proveedor_eq where pr_id=ultimoPedido and ca_nombre=equipo;

    insert into detalle_pedido (det_id, pe_id,pre_id,det_cantidad,ca_codigo,pr_id)
    values (seq_det_id.nextval, ultimoPedido, null, cantidad, catalogoProveedorEquipoId, proveedorId);

    dbms_output.put_line('Se ha agregado al pedido #'||ultimoPedido||' la maquinaria'||equipo||' un total de '||cantidad);

    select ca_preciounitario into precio from catalogo_proveedor_eq where pr_id=ultimoPedido and ca_nombre=equipo;

    update pedido set pe_total=pe_total+precio where pe_id=ultimoPedido;

    select pe_total into total from pedido where pe_id=ultimoPedido;

    dbms_output.put_line('El precio total de su pedido es ahora de '||total);

    end pr_agregarProductoAPedidoE;
/
create or replace procedure pr_cancelarPedido(idPedido number)
    is 
    begin
    update pedido set pe_status='cancelada' where pe_id=idPedido;
    dbms_output.put_line('Pedido #'||idPedido||' cancelado');
    end pr_cancelarPedido;
/
create or replace procedure pr_realizarPago(idPedido number, monto number, fecha date, nro_cuotas number)
    is
    statusPedido varchar2(30);
    numFactura number;
    begin
    numFactura:=0;

    select pe_status into statusPedido from pedido where pe_id=idPedido;

    select pe_numfactura into numFactura from pedido where pe_id=idPedido;

    if (statusPedido not like 'rechazada por proveedor') then
        
    if (numFactura<>0) then
        
    insert into pago (pa_id, pe_id, pa_tipopago, pa_monto, pa_fecha, pa_cuota) 
    values (seq_pa_id.nextval, idPedido, 
    null, monto, fecha, nro_cuotas);

    dbms_output.put_line('El pedido #'||idPedido|| ' se ha cancelado por un total de '||monto);

    elsif (numFactura=0) then
        
    dbms_output.put_line('El pedido #'||idPedido||'no puede ser pagado aun');

    end if;

    elsif (statusPedido='rechazada por proveedor') then

    dbms_output.put_line('El pedido #'||idPedido||' ha sido rechazado por proveedor');

    end if;

    end pr_realizarPago;
/
create or replace procedure pr_confirmarLlegadaPedido (idPedido number)
    is
    begin

    update pedido set pe_status='finalizada' where pe_id=idPedido;

    dbms_output.put_line('El pedido #'||idPedido||' ha sido confirmado');

    end pr_confirmarLlegadaPedido ;
/
create or replace procedure pr_rechazadaPorProveedor(idPedido number)
    is 
    begin

    update pedido set pe_status='rechazada por proveedor' where pe_id= idPedido;

    dbms_output.put_line('El pedido #'||idPedido||' fue rechazada por proveedor');

    end pr_rechazadaPorProveedor;
/
create or replace procedure pr_confirmarPosibleDespacho(idPedido number, numFactura number)
    is
    begin

    update pedido set pe_numfactura=numFactura where pe_id=idPedido;

    dbms_output.put_line('El pedido #'||idPedido||' ha sido confirmado para despacho');

    end pr_confirmarPosibleDespacho;
/

/*
//=============================================//
//                                             //
//                    INSERT                   //
//=============================================//
*/
-------------PAIS

INSERT INTO pais (pa_id,pa_nombre,pa_continente) VALUES (seq_pa_id.NEXTVAL,'Dinamarca','Europa');
INSERT INTO pais (pa_id,pa_nombre,pa_continente) VALUES (seq_pa_id.NEXTVAL,'Inglaterra','Europa');
INSERT INTO pais (pa_id,pa_nombre,pa_continente) VALUES (seq_pa_id.NEXTVAL,'Alemania','Europa');

insert into pais (pa_id,pa_nombre,pa_continente) VALUES (seq_pa_id.NEXTVAL,'UNITED STATES','Norteamerica');


insert into pais (pa_id,pa_nombre,pa_continente) VALUES (seq_pa_id.NEXTVAL,'CANADA','Norteamerica');
insert into pais (pa_id,pa_nombre,pa_continente) VALUES (seq_pa_id.NEXTVAL,'AUSTRIA','Oceania');
insert into pais (pa_id,pa_nombre,pa_continente) VALUES (seq_pa_id.NEXTVAL,'BELGIUM','Europa');

insert into pais (pa_id,pa_nombre,pa_continente) VALUES (seq_pa_id.NEXTVAL,'FRANCE','Europa');
insert into pais (pa_id,pa_nombre,pa_continente) VALUES (seq_pa_id.NEXTVAL,'SWEDEN','Europa');

insert into pais (pa_id,pa_nombre,pa_continente) VALUES (seq_pa_id.NEXTVAL,'Republica Checa','Europa');
insert into pais (pa_id,pa_nombre,pa_continente) VALUES (seq_pa_id.NEXTVAL,'Belgica','Europa');
insert into pais (pa_id,pa_nombre,pa_continente) VALUES (seq_pa_id.NEXTVAL,'Reino Unido','Europa');

--------CIUDAD
INSERT INTO ciudad (ci_id,ci_nombre,pa_id) VALUES (seq_ci_id.NEXTVAL,'Copenhague',
(Select pa_id from pais where pa_nombre = 'Dinamarca'));

INSERT INTO ciudad (ci_id,ci_nombre,pa_id) VALUES (seq_ci_id.NEXTVAL,'Leeds',
(Select pa_id from pais where pa_nombre = 'Inglaterra'));

INSERT INTO ciudad (ci_id,ci_nombre,pa_id) VALUES (seq_ci_id.NEXTVAL,'Hamburgo',
(Select pa_id from pais where pa_nombre = 'Alemania'));

INSERT INTO ciudad (ci_id,ci_nombre,pa_id) VALUES (seq_ci_id.NEXTVAL,'West Yorkshire',
(Select pa_id from pais where pa_nombre = 'Inglaterra'));


--------ESTILO
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Honey Blond Ale','Cerveza inglesa',comida_nt(comida('Fruta Fria','Frutas frescas a su gusto'),comida('Ensaladas de Lechuga','Ensaladas fresca de lechuga'),comida('Carnes a la Parrilla','Cualquier tipo de carne'),comida('Pizza','Son las favoritas')),'18',medida('11','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Indian Pale Ale','Cerveza inglesa palida',comida_nt(comida('Alimento picantes','Cualquier tipo de Picante')),'50',medida('12','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Stout','Cerveza irlandesa',comida_nt(comida('Crustaceos','Ideal para los Crustaceos'),comida('Currys','Salsas'),comida('Quesos Fuertes','Cualquier tipo de queso')),'35',medida('9','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Red Ale','Cerveza Inglesa Roja',comida_nt(comida('Costillas','Costillas asadas'),comida('Jalapeños','Tipo de picante mexicano'),comida('Granos','Cualquier tipo de granos')),'8',medida('13','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Pilsner','La original Pilsner',comida_nt(comida('Ensaladas','Cualquier tipo de comida'),comida('Platos Asiaticos Picantes','Cualquier plato asiatico')),'35',medida('9','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Lager','Elaborado con malta de cerveza',comida_nt(comida('Hamburguesa','La favorita del publico')),'20',medida('11','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Pilsen','Clara, Ligera y refrescante',comida_nt(comida('Salchichas','Cualquier tipo de salchicha'),comida('Carne Asada','Carnes de cerdo')),'15',medida('7','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Munish','Color Oscuro y sabor a malta',comida_nt(comida('Pollo','Preferiblemente frito'),comida('Ensaladas','Cualquier tipo de ensalada')),'35',medida('9','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Viena','Dulce y de Color Rojizo',comida_nt(comida('Salmon','Pescado fresco')),'20',medida('9','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Porter','Cerveza Ligera y tostada',comida_nt(comida('Cerdo','Cualquier parte del cerdo')),'27',medida('13','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Altbier','Dusseldorf',comida_nt(comida('Hamburguesa','La favorita del publico')),'50',medida('11','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Kolsch','Es una Ale Dorada',comida_nt(comida('Costillas','Costillas asadas a la parrilla'),comida('Jalapeños','Tipo de picante mexicano'),comida('Granos','Cualquier tipo de granos')),'35',medida('9','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Trapenses','Elaboradas en monasterios',comida_nt(comida('Hamburguesa','La favorita del publico')),'12',medida('12','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Abadia','Amarga y negra',comida_nt(comida('Hamburguesa','La Favorita')),'16',medida('11','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Ale Americana','Suave, Negra y refrescante',comida_nt(comida('Todo','Cualquier tipo de comida'),comida('Mariscos','Tipo de pescado')),'28',medida('9','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Mild Ale','No Amarga',comida_nt(comida('Todo','Cualquier tipo de comida'),comida('Mariscos','Tipo de pescado')),'35',medida('13','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Bitter Ale','Amarga  ',comida_nt(comida('Hamburguesa','La favorita del publico')),'20',medida('13','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Pale Ale','Translucida',comida_nt(comida('Costillas','Costillas asadas'),comida('Jalapeños','Tipo de picante mexicano'),comida('Granos','Cualquier tipo de granos')),'15',medida('9','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Brown Ale','Envejecida',comida_nt(comida('Hamburguesa','La favorita del publico')),'9',medida('9','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Old Ale','Envejecida',comida_nt(comida('Costillas','Costillas asadas a la parrilla'),comida('Jalapeños','Tipo de picante mexicano'),comida('Granos','Cualquier tipo de granos')),'12',medida('13','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Lambic','Fermentada',comida_nt(comida('Hamburguesa','La favorita del publico')),'23',medida('12','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Gueuze','Fermentada',comida_nt(comida('Hamburguesa','La favorita del publico')),'22',medida('9','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Faro','Fermentada',comida_nt(comida('Todo','Cualquier tipo de comida'),comida('Mariscos','Tipo de pescado')),'35',medida('12','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Strong Pilsner','La original Pilsner',comida_nt(comida('Pescados','Cualquier tipo de pescados'),comida('Platos Asiaticos Picantes','Cualquier plato asiatico')),'21',medida('9','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Sidra','De manzana',comida_nt(comida('Todo','Cualquier tipo de comida')),'55',medida('8','°C'));
insert into estilo (es_id,es_nombre,es_descripcion,es_comida,es_ibu,ES_TEMPERATURA) values(seq_es_id.NEXTVAL,'Steam Beer','Origen en los Estados Unidos',comida_nt(comida('Atun','Atun fresco'),comida('Barbacoa','Carnes, pollo,etc')),'50',medida('15','°C'));

-----CERVEZA

insert into cerveza (ce_id,ce_fechacreacion,ce_porcetajealc,ce_calorias,ce_patrocinio,ce_marca,ce_nombreingles,ce_ibu,ce_abv,ce_temporada,ce_fotos,ce_descripcion,ce_paginaweb,ce_sabor,es_id) values(seq_ce_id.NEXTVAL,'01/01/1880',4,120,patrocinio_nt(patrocinio('Festival de Rosjilde','Festival musical en DK','5'),patrocinio('Green Fest','Festival Cultura','2'),patrocinio('Download Festival','Festival cultural','3'),patrocinio('Gron Koncert','Festival Musical','4')),'Tuborg','Tuborg',ce_ibu_va(12,15),4,'clasica',IMPORTAR_BINARIO('Tuborg.png'),'Tuborg es una marca cosmopolita y presente en más de 70 países de todo el mundo','www.tuborg.com','Suave',(select es_id from estilo where es_nombre='Pilsner'and rownum=1));
insert into cerveza (ce_id,ce_fechacreacion,ce_porcetajealc,ce_calorias,ce_patrocinio,ce_marca,ce_nombreingles,ce_ibu,ce_abv,ce_temporada,ce_fotos,ce_descripcion,ce_paginaweb,ce_sabor,es_id) values(seq_ce_id.NEXTVAL,'01/01/1980',4,120,patrocinio_nt(patrocinio('Festival de Rosjilde','Festival musical en DK','5'),patrocinio('Green Fest','Festival Cultura','2'),patrocinio('Download Festival','Festival cultural','3'),patrocinio('Gron Koncert','Festival Musical','4')),'Tuborg','Tuborg Strong',ce_ibu_va(15,20),7,'clasica',IMPORTAR_BINARIO('StrongTuborg.png'),'Tuborg es una marca cosmopolita y presente en más de 70 países de todo el mundo','www.tuborg.com','Suave',(select es_id from estilo where es_nombre='Lager'and rownum=1));
insert into cerveza (ce_id,ce_fechacreacion,ce_porcetajealc,ce_calorias,ce_patrocinio,ce_marca,ce_nombreingles,ce_ibu,ce_abv,ce_temporada,ce_fotos,ce_descripcion,ce_paginaweb,ce_sabor,es_id) values(seq_ce_id.NEXTVAL,'01/01/1895',4,120,patrocinio_nt(patrocinio('Festival de Rosjilde','Festival musical en DK','5'),patrocinio('Green Fest','Festival Cultura','2'),patrocinio('Download Festival','Festival cultural','3'),patrocinio('Gron Koncert','Festival Musical','4')),'Tuborg','Tuborg Gold',ce_ibu_va(15,20),5,'clasica',IMPORTAR_BINARIO('TuborgGold.png'),'Tuborg es una marca cosmopolita y presente en más de 70 países de todo el mundo','www.tuborg.com','Suave',(select es_id from estilo where es_nombre='Pilsner'and rownum=1));
insert into cerveza (ce_id,ce_fechacreacion,ce_porcetajealc,ce_calorias,ce_patrocinio,ce_marca,ce_nombreingles,ce_ibu,ce_abv,ce_temporada,ce_fotos,ce_descripcion,ce_paginaweb,ce_sabor,es_id) values(seq_ce_id.NEXTVAL,'01/01/1981',4,120,patrocinio_nt(patrocinio('Festival de Rosjilde','Festival musical en DK','5'),patrocinio('Green Fest','Festival Cultura','2'),patrocinio('Download Festival','Festival cultural','3'),patrocinio('Gron Koncert','Festival Musical','4')),'Tuborg','Tuborg Julebryg',ce_ibu_va(15,20),4,'temporada',IMPORTAR_BINARIO('TuborgJulebryg.png'),'Tuborg es una marca cosmopolita y presente en más de 70 países de todo el mundo','www.tuborg.com','Suave',(select es_id from estilo where es_nombre='Strong Pilsner'and rownum=1));
insert into cerveza (ce_id,ce_fechacreacion,ce_porcetajealc,ce_calorias,ce_patrocinio,ce_marca,ce_nombreingles,ce_ibu,ce_abv,ce_temporada,ce_fotos,ce_descripcion,ce_paginaweb,ce_sabor,es_id) values(seq_ce_id.NEXTVAL,'01/01/2012',3,120,null,'Tetleys','Tetleys Gold',ce_ibu_va(28,32),4,'clasica',IMPORTAR_BINARIO('TetleysGold.png'),'Tetley fue elaborada por primera vez en Yorkshire en 1822 por un joven ambicioso llama Joshua Tetley',null,'Suave',(select es_id from estilo where es_nombre='Pale Ale'and rownum=1));
insert into cerveza (ce_id,ce_fechacreacion,ce_porcetajealc,ce_calorias,ce_patrocinio,ce_marca,ce_nombreingles,ce_ibu,ce_abv,ce_temporada,ce_fotos,ce_descripcion,ce_paginaweb,ce_sabor,es_id) values
(seq_ce_id.NEXTVAL,
'01/01/2008',4,155,null,'Somersby','Appel Somersby',ce_ibu_va(8,12),4,'clasica',
IMPORTAR_BINARIO('SomersbyApple.png'),'Somersby es mayor venta de sidra de Carlsberg Group','www.somersbycider.com',
'Manzana',(select es_id from estilo where es_nombre='Sidra'and rownum=1 and rownum=1));

insert into cerveza (ce_id,ce_fechacreacion,ce_porcetajealc,ce_calorias,ce_patrocinio,ce_marca,ce_nombreingles,ce_ibu,ce_abv,ce_temporada,ce_fotos,ce_descripcion,ce_paginaweb,ce_sabor,es_id) values(seq_ce_id.NEXTVAL,'01/01/1952',3,160,null,'1664','Kronenbourg 1664',ce_ibu_va(15,20),5,'clasica',IMPORTAR_BINARIO('Kronenbourg1664.png'),'Kronenbourg 1664 es el francés de la cerveza más vendida en el mundo','www.kronenbourg1664.com','Amarga',(select es_id from estilo where es_nombre='Honey Blond Ale'and rownum=1));
insert into cerveza (ce_id,ce_fechacreacion,ce_porcetajealc,ce_calorias,ce_patrocinio,ce_marca,ce_nombreingles,ce_ibu,ce_abv,ce_temporada,ce_fotos,ce_descripcion,ce_paginaweb,ce_sabor,es_id) values(seq_ce_id.NEXTVAL,'01/01/2006',3,155,null,'1664','Blanc 1664',ce_ibu_va(8,12),5,'clasica',IMPORTAR_BINARIO('Blanc1664.png'),'1664 Blanc es una cerveza de trigo fresco y frutal','www.kronenbourg1664.com','Frutas',(select es_id from estilo where es_nombre='Sidra'and rownum=1 and rownum=1));
insert into cerveza (ce_id,ce_fechacreacion,ce_porcetajealc,ce_calorias,ce_patrocinio,ce_marca,ce_nombreingles,ce_ibu,ce_abv,ce_temporada,ce_fotos,ce_descripcion,ce_paginaweb,ce_sabor,es_id) values(seq_ce_id.NEXTVAL,'01/01/2012',3,162,null,'1664','Millesime 1664',ce_ibu_va(8,12),7,'clasica',IMPORTAR_BINARIO('Millesime1664.png'),'Millésime 1664 es una cerveza excepcional, elaborada con malta de la última cosecha','www.kronenbourg1664.com','Suave',(select es_id from estilo where es_nombre='Lager'and rownum=1));
insert into cerveza (ce_id,ce_fechacreacion,ce_porcetajealc,ce_calorias,ce_patrocinio,ce_marca,ce_nombreingles,ce_ibu,ce_abv,ce_temporada,ce_fotos,ce_descripcion,ce_paginaweb,ce_sabor,es_id) values(seq_ce_id.NEXTVAL,'01/01/2013',2,160,null,'1664','Rose 1664',ce_ibu_va(15,20),5,'clasica',IMPORTAR_BINARIO('Rose1664.png'),'Elaborada con un toque de melocotón y frambuesa ','www.kronenbourg1664.com','Frutas',(select es_id from estilo where es_nombre='Lager'and rownum=1));
insert into cerveza (ce_id,ce_fechacreacion,ce_porcetajealc,ce_calorias,ce_patrocinio,ce_marca,ce_nombreingles,ce_ibu,ce_abv,ce_temporada,ce_fotos,ce_descripcion,ce_paginaweb,ce_sabor,es_id) values(seq_ce_id.NEXTVAL,'01/01/2014',3,60,null,'Brewmasters Colección','Irish Red Ale',ce_ibu_va(8,12),4,'clasica',IMPORTAR_BINARIO('IrishRedAle.png'),'El Brewmasters Colección irlandesa Red Ale','www.brewmasterscollection.com','Amarga',(select es_id from estilo where es_nombre='Red Ale' and rownum=1 and rownum=1));
insert into cerveza (ce_id,ce_fechacreacion,ce_porcetajealc,ce_calorias,ce_patrocinio,ce_marca,ce_nombreingles,ce_ibu,ce_abv,ce_temporada,ce_fotos,ce_descripcion,ce_paginaweb,ce_sabor,es_id) values(seq_ce_id.NEXTVAL,'01/01/2014',3,70,null,'Brewmasters Colección','India Pale Ale',ce_ibu_va(15,20),5,'clasica',IMPORTAR_BINARIO('IndiaPaleAle.png'),'El Brewmasters Colección India Pale Ale es una cerveza seca-hopping','www.brewmasterscollection.com','Frutas',(select es_id from estilo where es_nombre='Indian Pale Ale' and rownum=1 and rownum=1));

insert into cerveza (ce_id,ce_fechacreacion,ce_porcetajealc,ce_calorias,ce_patrocinio,ce_marca,ce_nombreingles,ce_ibu,ce_abv,ce_temporada,ce_fotos,ce_descripcion,ce_paginaweb,ce_sabor,es_id) values(seq_ce_id.NEXTVAL,'01/01/2014',3,75,null,'Brewmasters Colección','California Steam Beer',ce_ibu_va(12,15),4,'clasica',IMPORTAR_BINARIO('CaliforniaSteamBeer.png'),'Esta cerveza de vapor aromático distintivo y Brewmasters','www.brewmasterscollection.com','Frutas',(select es_id from estilo where es_nombre='Sidra' and rownum=1 and rownum=1));


-----PRESENTACION CERVEZA

insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',660,(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',660,(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',660,(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',660,(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',330,(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',330,(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',220,(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',330,(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',220,(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',355,(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella retornable',220,(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella retornable',330,(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',330,(select ce_id from cerveza where ce_nombreingles='Tetleys Gold' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella retornable',220,(select ce_id from cerveza where ce_nombreingles='Tetleys Gold' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',330,(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',355,(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',220,(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',660,(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella retornable',220,(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella retornable',330,(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',330,(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',355,(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',220,(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',660,(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella retornable',220,(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella retornable',330,(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',330,(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',355,(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',220,(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',660,(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella retornable',220,(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella retornable',330,(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',330,(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',355,(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',220,(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',660,(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella retornable',220,(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella retornable',330,(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',330,(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',355,(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',220,(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella',660,(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella retornable',220,(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'botella retornable',330,(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'lata',222,(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'lata',355,(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'lata',295,(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'lata',222,(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'lata',355,(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'lata',295,(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'lata',222,(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'lata',355,(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1));
insert into presentacion_cerveza (pc_id,pc_tipo,pc_cantidad,ce_id) values(seq_pc_id.NEXTVAL,'lata',295,(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1));


-----DISTRIBUCION CERVEZA

insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/02/2010',10000)),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Dinamarca'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/02/2010',10000)),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=330 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Dinamarca'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/02/2010',10000)),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=220 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Dinamarca'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/05/2010',12000)),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/05/2010',12000)),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=330 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/05/2010',12000)),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=220 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/10/2010',9500)),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Alemania'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/10/2010',9500)),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=330 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Alemania'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/10/2010',9500)),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=220 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Alemania'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/03/2010',10000)),(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Dinamarca'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/03/2010',10000)),(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=330 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Dinamarca'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/03/2010',10000)),(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=355 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Dinamarca'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/05/2011',12000)),(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/05/2011',12000)),(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=330 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/05/2011',12000)),(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=355 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/12/2011',9500)),(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Alemania'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/03/2010',10000)),(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Dinamarca'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/05/2013',12000)),(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/12/2012',9500)),(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Alemania'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/01/2014',10000)),(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Dinamarca'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/05/2015',12000)),(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/12/2014',9500)),(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Alemania'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/07/2016',10000)),(select ce_id from cerveza where ce_nombreingles='Tetleys Gold' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=330 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tetleys Gold' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='UNITED STATES'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/09/2016',12000)),(select ce_id from cerveza where ce_nombreingles='Tetleys Gold' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=330 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tetleys Gold' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/12/2016',9500)),(select ce_id from cerveza where ce_nombreingles='Tetleys Gold' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=330 and ce_id=(select ce_id from cerveza where ce_nombreingles='Tetleys Gold' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='CANADA'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/01/2010',10000)),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='AUSTRIA'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/01/2010',10000)),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=330 and ce_id=(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='AUSTRIA'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/01/2010',10000)),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=355 and ce_id=(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='AUSTRIA'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/01/2010',10000)),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=220 and ce_id=(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='AUSTRIA'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/05/2010',12000)),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='BELGIUM'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/05/2010',12000)),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=330 and ce_id=(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='BELGIUM'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/05/2010',12000)),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=355 and ce_id=(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='BELGIUM'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/05/2010',12000)),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=220 and ce_id=(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='BELGIUM'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/10/2010',9500)),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='FRANCE'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/10/2010',9500)),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=330 and ce_id=(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='FRANCE'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/10/2010',9500)),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=355 and ce_id=(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='FRANCE'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/10/2010',9500)),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=220 and ce_id=(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='FRANCE'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/02/2011',10000)),(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='SWEDEN'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/06/2011',12000)),(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Dinamarca'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/11/2011',9500)),(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Alemania'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/03/2011',10000)),(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='SWEDEN'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/07/2011',12000)),(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Dinamarca'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/12/2011',9500)),(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Alemania'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/04/2011',10000)),(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='SWEDEN'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/08/2011',12000)),(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Dinamarca'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/01/2012',9500)),(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Alemania'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/05/2012',10000)),(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='SWEDEN'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/09/2012',12000)),(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Dinamarca'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/02/2013',9500)),(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='botella' and pc_cantidad=660 and ce_id=(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Alemania'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/06/2013',10000)),(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=355 and ce_id=(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/10/2013',12000)),(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=355 and ce_id=(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='UNITED STATES'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/03/2014',9500)),(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=222 and ce_id=(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/03/2014',9500)),(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=295 and ce_id=(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/07/2013',10000)),(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=355 and ce_id=(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/07/2013',10000)),(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=222 and ce_id=(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/07/2013',10000)),(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=295 and ce_id=(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/11/2013',12000)),(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=355 and ce_id=(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='UNITED STATES'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/11/2013',12000)),(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=222 and ce_id=(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='UNITED STATES'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/11/2013',12000)),(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=295 and ce_id=(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='UNITED STATES'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/08/2013',10000)),(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=355 and ce_id=(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/08/2013',10000)),(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=295 and ce_id=(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/08/2013',10000)),(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=222 and ce_id=(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='Inglaterra'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/12/2013',12000)),(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=355 and ce_id=(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='UNITED STATES'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/12/2013',12000)),(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=295 and ce_id=(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='UNITED STATES'));
insert into distribucion_cerveza (dis_cer_distribucion,ce_id,pc_id,pa_id) values(distribucion_nt(distribucion('01/12/2013',12000)),(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1),(select pc_id from presentacion_cerveza where pc_tipo='lata' and pc_cantidad=222 and ce_id=(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1) and rownum=1),(select pa_id from pais where pa_nombre='UNITED STATES'));



-----PROVEEDORES
INSERT INTO proveedores (pr_id,PA_ID,pr_nombre,pr_correo,pr_formasenvio,pr_formaspago,pr_contactos,pr_resultadoevaluacion,PR_WEB) 
VALUES (seq_pr_id.NEXTVAL,(Select pa_id from pais where pa_nombre ='Dinamarca'),'Silva','Kylie@et.us',
FORMAS_ENVIO_VA('Dropshipping','Envío desde almacén','Barco'),
FORMAPAGO_NT(FORMAPAGO('DEBITO',NULL,NULL,NULL,NULL),FORMAPAGO('CREDITO',NULL,'5',NULL,NULL)),CONTACTO('Maria','Suarez','gerente','+98-7893726'),NULL,'www.jumanji.com');

INSERT INTO proveedores (pr_id,PA_ID,pr_nombre,pr_correo,pr_formasenvio,pr_formaspago,pr_contactos,pr_resultadoevaluacion,PR_WEB) 
VALUES (seq_pr_id.NEXTVAL,(Select pa_id from pais where pa_nombre ='UNITED STATES'),'Roach','Orlando@consequat.com',
FORMAS_ENVIO_VA('Dropshipping','Envío desde almacén','Barco'),FORMAPAGO_NT(FORMAPAGO('DEBITO',NULL,NULL,NULL,NULL),
FORMAPAGO('CREDITO',NULL,'8',NULL,NULL)),CONTACTO('Antonio','Monpart','gerente','+56-738739'),NULL,'www.kasawa.com');

INSERT INTO proveedores (pr_id,PA_ID,pr_nombre,pr_correo,pr_formasenvio,pr_formaspago,pr_contactos,pr_resultadoevaluacion,PR_WEB) 
VALUES (seq_pr_id.NEXTVAL,(Select pa_id from pais where pa_nombre ='CANADA'),'Mcmillan','Silas@nisl.com',
FORMAS_ENVIO_VA('Dropshipping','Envío desde almacén','Barco'),FORMAPAGO_NT(FORMAPAGO('DEBITO',NULL,NULL,NULL,NULL),
FORMAPAGO('CREDITO',NULL,'2',NULL,NULL)),CONTACTO('Alejandro','Fernandez','gerente','+75-787384'),NULL,'www.tumercancia.com');

INSERT INTO proveedores (pr_id,PA_ID,pr_nombre,pr_correo,pr_formasenvio,pr_formaspago,pr_contactos,pr_resultadoevaluacion,PR_WEB) 
VALUES (seq_pr_id.NEXTVAl,(Select pa_id from pais where pa_nombre ='Alemania'),'Fields','Lewis@consectetuer.org',
FORMAS_ENVIO_VA('Dropshipping','Envío desde almacén','Barco'),
FORMAPAGO_NT(FORMAPAGO('CREDITO',NULL,'3',NULL,NULL)),CONTACTO('Haruki','Kimonura','gerente','+91-7839226'),NULL,'www.masterking.com');

INSERT INTO proveedores (pr_id,PA_ID,pr_nombre,pr_correo,pr_formasenvio,pr_formaspago,pr_contactos,pr_resultadoevaluacion,PR_WEB) 
VALUES (seq_pr_id.NEXTVAL,(Select pa_id from pais where pa_nombre ='Alemania'),'Patterson','Lewis@leo.net',
FORMAS_ENVIO_VA('Dropshipping','Envío desde almacén','Barco'),
FORMAPAGO_NT(FORMAPAGO('CREDITO',NULL,'5',NULL,NULL)),CONTACTO('Michelle','Graceling','gerente','+43-12326'),NULL,'www.walkingdead.com');

INSERT INTO proveedores (pr_id,PA_ID,pr_nombre,pr_correo,pr_formasenvio,pr_formaspago,pr_contactos,pr_resultadoevaluacion,PR_WEB) 
VALUES (seq_pr_id.NEXTVAL,(Select pa_id from pais where pa_nombre ='FRANCE'),'Ellis','Fuller@ultricies.edu'
,FORMAS_ENVIO_VA('Dropshipping','Envío desde almacén','Barco'),
FORMAPAGO_NT(FORMAPAGO('DEBITO',NULL,NULL,NULL,NULL),FORMAPAGO('CREDITO',NULL,'2',NULL,NULL)),CONTACTO('Hazzel','Grace','gerente','+15-12343'),NULL,'www.prodiproduce.com');

INSERT INTO proveedores (pr_id,PA_ID,pr_nombre,pr_correo,pr_formasenvio,pr_formaspago,pr_contactos,pr_resultadoevaluacion,PR_WEB) 
VALUES (seq_pr_id.NEXTVAL,(Select pa_id from pais where pa_nombre ='UNITED STATES'),'House','Christopher@pharetra.gov',
FORMAS_ENVIO_VA('Dropshipping','Envío desde almacén','Barco'),FORMAPAGO_NT(FORMAPAGO('DEBITO',NULL,NULL,NULL,NULL)),CONTACTO('Robin','Cook','gerente','+123-0987653'),NULL,'www.fevercop.com');

INSERT INTO proveedores (pr_id,PA_ID,pr_nombre,pr_correo,pr_formasenvio,pr_formaspago,pr_contactos,pr_resultadoevaluacion,PR_WEB) 
VALUES (seq_pr_id.NEXTVAL,(Select pa_id from pais where pa_nombre ='Dinamarca'),'Kirby','Neve@Phasellus.com',
FORMAS_ENVIO_VA('Dropshipping','Envío desde almacén','Barco'),FORMAPAGO_NT(FORMAPAGO('CREDITO',NULL,'4',NULL,NULL)),CONTACTO('Petter','Harris','gerente','+32-123455'),NULL,'www.bastoresuelto.com');

INSERT INTO proveedores (pr_id,PA_ID,pr_nombre,pr_correo,pr_formasenvio,pr_formaspago,pr_contactos,pr_resultadoevaluacion,PR_WEB) 
VALUES (seq_pr_id.NEXTVAL,(Select pa_id from pais where pa_nombre ='Inglaterra'),'Hayden','Todd@feugiat.us',
FORMAS_ENVIO_VA('Dropshipping','Envío desde almacén','Barco'),FORMAPAGO_NT(FORMAPAGO('DEBITO',NULL,NULL,NULL,NULL),
FORMAPAGO('CREDITO',NULL,'5',NULL,NULL)),CONTACTO('Anne','Rice','gerente','+98-7893726'),NULL,'www.bearsimp.com');

INSERT INTO proveedores (pr_id,PA_ID,pr_nombre,pr_correo,pr_formasenvio,pr_formaspago,pr_contactos,pr_resultadoevaluacion,PR_WEB) 
VALUES (seq_pr_id.NEXTVAL,(Select pa_id from pais where pa_nombre ='Dinamarca'),'Roy','Eric@venenatis.com',
FORMAS_ENVIO_VA('Dropshipping','Envío desde almacén','Barco'),FORMAPAGO_NT(FORMAPAGO('DEBITO',NULL,NULL,NULL,NULL)),
CONTACTO('Joseff','Conrad','gerente','+98-7893726'),NULL,'www.nextu.com');


-----ENVIOS
INSERT INTO envios (ci_id,pr_id,en_costo,en_tiempo_horas) 
VALUES ((Select ci_id from ciudad where ci_nombre = 'Copenhague' and rownum = 1),
(Select pr_id from (SELECT p.pr_id FROM proveedores p ORDER BY dbms_random.value )WHERE rownum = 1),
234,72);

INSERT INTO envios (ci_id,pr_id,en_costo,en_tiempo_horas) 
VALUES ((Select ci_id from ciudad where ci_nombre = 'Leeds' and rownum = 1),
(Select pr_id from (SELECT p.pr_id FROM proveedores p, envios e, ciudad c where e.pr_id <> p.pr_id and c.ci_id <> e.ci_id ORDER BY dbms_random.value )WHERE rownum = 1),
453,72);

INSERT INTO envios (ci_id,pr_id,en_costo,en_tiempo_horas) 
VALUES ((Select ci_id from ciudad where ci_nombre = 'Hamburgo' and rownum = 1),
(Select pr_id from (SELECT p.pr_id FROM proveedores p, envios e, ciudad c where e.pr_id <> p.pr_id and c.ci_id <> e.ci_id ORDER BY dbms_random.value )WHERE rownum = 1),
345,24);

INSERT INTO envios (ci_id,pr_id,en_costo,en_tiempo_horas) 
VALUES ((Select ci_id from ciudad where ci_nombre = 'West Yorkshire' and rownum = 1),
(Select pr_id from (SELECT p.pr_id FROM proveedores p, envios e, ciudad c where e.pr_id <> p.pr_id and c.ci_id <> e.ci_id ORDER BY dbms_random.value )WHERE rownum = 1),
29,31);

INSERT INTO envios (ci_id,pr_id,en_costo,en_tiempo_horas) 
VALUES ((Select ci_id from ciudad where ci_nombre = 'Copenhague' and rownum = 1),
(Select pr_id from (SELECT p.pr_id FROM proveedores p, envios e, ciudad c where e.pr_id <> p.pr_id and c.ci_id <> e.ci_id ORDER BY dbms_random.value )WHERE rownum = 1)
,321,49);

INSERT INTO envios (ci_id,pr_id,en_costo,en_tiempo_horas) 
VALUES ((Select ci_id from ciudad where ci_nombre = 'Leeds' and rownum = 1),
(Select pr_id from (SELECT p.pr_id FROM proveedores p, envios e, ciudad c where e.pr_id <> p.pr_id and c.ci_id <> e.ci_id ORDER BY dbms_random.value )WHERE rownum = 1)
,215,35);

INSERT INTO envios (ci_id,pr_id,en_costo,en_tiempo_horas) 
VALUES ((Select ci_id from ciudad where ci_nombre = 'Hamburgo' and rownum = 1),
(Select pr_id from (SELECT p.pr_id FROM proveedores p, envios e, ciudad c where e.pr_id <> p.pr_id and c.ci_id <> e.ci_id ORDER BY dbms_random.value )WHERE rownum = 1),
102,53);

INSERT INTO envios (ci_id,pr_id,en_costo,en_tiempo_horas) 
VALUES ((Select ci_id from ciudad where ci_nombre = 'West Yorkshire' and rownum = 1),
(Select pr_id from (SELECT p.pr_id FROM proveedores p, envios e, ciudad c where e.pr_id <> p.pr_id and c.ci_id <> e.ci_id ORDER BY dbms_random.value )WHERE rownum = 1)
,814,24);

-----EMPRESAS

INSERT INTO empresa (em_id,ci_id,em_nombre,em_fechaapertura,em_resumenh,em_logo,em_patrocinio,em_recetaprocesobasico,emp_em_id) VALUES (seq_em_id.NEXTVAL,
(Select ci_id from ciudad where ci_nombre ='Copenhague'),'Carlsberg group',1847,
RESUMENHISTORICO_NT(RESUMENHISTORICO('10-11-1847','Fue fundada la primera sede de la empresa en Copenhague'),
RESUMENHISTORICO('10-11-1875', 'Jacobsen creó el Laboratorio Carlsberg, que trabajó en problemas científicos relacionados con la elaboración de la cerveza'),
RESUMENHISTORICO('01-01-2001', 'Carlsberg se convirtio en el guro cervecero mas grande del mundo')),
IMPORTAR_BINARIO('logocarlsberg.png'),
PATROCINIO_NT(PATROCINIO('Liverpool FC','6,5 millones de pintas','56 años')),
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('Procesado','Obtencion del mosto',
'En la olla de crudos se vierte la totalidad de los grits, mas de 15% de malta en relacion a ellos',
'50°','55°')),null);

INSERT INTO empresa (em_id,ci_id,em_nombre,em_fechaapertura,em_resumenh,em_logo,em_patrocinio,em_recetaprocesobasico,emp_em_id) VALUES (seq_em_id.NEXTVAL,
(Select ci_id from ciudad where ci_nombre ='Hamburgo'),'Holsten-Brauerei AG',1879,
RESUMENHISTORICO_NT(RESUMENHISTORICO('24-05-1880',' La primera degustación de cerveza Holsten se llevó a cabo'),
RESUMENHISTORICO('01-01-1957', 'el aumento de los negocios Inglaterra'),
RESUMENHISTORICO('01-01-2014', 'Holsten-Brauerei AG fue disuelto y los empleados restantes fueron transferidos a Carlsberg Alemania Marca Empresa'),
RESUMENHISTORICO('01-01-1991', 'comienza Holsten de Foster licencias de elaboración de la cerveza y distribuir'),
RESUMENHISTORICO('01-01-2001', 'El cierre de la parte operativa Lüneburg Kronenbrauerei en Lüneburg con el traslado simultáneo de la producción de Moravia Pils de Hamburgo y la misión de la fabricación de Landas de Pilsener en flip-top botellas'),
RESUMENHISTORICO('01-01-2011', 'Las Landas de Pilsener está de vuelta en la caja (24 / 0,33l Longneck) vendidos')),
IMPORTAR_BINARIO('logoholstein.png'),
null,
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('Procesado','Obtencion del mosto',
'En la olla de crudos se vierte la totalidad de los grits, mas de 15% de malta en relacion a ellos',
'50°','55°'),
RECETAPROCESOBASICO('Procesado','Adecuacion de la materia prima',
'Una vez la materia se ha sometido a la limprieza adecuada son molidas al grado necesario',
null,null),RECETAPROCESOBASICO('Procesado','Transformacion del azucar',
'La solucion completa se somente a a cierta temperatura para transformar el almidon en azucar',
'76°',null)),(Select em_id from empresa where em_nombre = 'Carlsberg group'));

INSERT INTO empresa (em_id,ci_id,em_nombre,em_fechaapertura,em_resumenh,em_logo,em_patrocinio,em_recetaprocesobasico,emp_em_id) VALUES (seq_em_id.NEXTVAL,
(Select ci_id from ciudad where ci_nombre ='Leeds'),'Joshua tetley y Son Ltd',1881,
RESUMENHISTORICO_NT(RESUMENHISTORICO('01-01-1998','Asumida por CarlsbergGroup'),
RESUMENHISTORICO('01-01-1960', 'Una toma de control de la cercana fábrica de cerveza Melbourne aseguró la posición de Tetley como el mayor productor de cerveza en Leeds'),
RESUMENHISTORICO('01-01-1978', 'Se fusionó con Allied J. Lyons para formar Allied Lyons'),
RESUMENHISTORICO('01-01-1980', 'La fábrica de cerveza se convirtió en el mayor productor del mundo de la cerveza de barril'),
RESUMENHISTORICO('01-01-2011', 'El Leeds cervecería fue cerrada'),
RESUMENHISTORICO('01-01-2012', 'El Leeds es demolida')),
IMPORTAR_BINARIO('logotetleys.png'),
null,
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('Procesado','Obtencion del mosto',
'En la olla de crudos se vierte la totalidad de los grits, mas de 15% de malta en relacion a ellos',
'50°','55°'),
RECETAPROCESOBASICO('Procesado','Adecuacion de la materia prima',
'Una vez la materia se ha sometido a la limprieza adecuada son molidas al grado necesario',
null,null),RECETAPROCESOBASICO('Procesado','Transformacion del azucar',
'La solucion completa se somente a a cierta temperatura para transformar el almidon en azucar',
'76°',null)),(Select em_id from empresa where em_nombre = 'Carlsberg group'));


-----FABRICA
INSERT INTO fabrica (fa_id,em_id,ci_id,fa_nombre,fa_fechaapertura) VALUES (seq_fa_id.NEXTVAL,
(Select em_id from empresa where em_nombre ='Holsten-Brauerei AG'),
(Select ci_id from ciudad where ci_nombre = 'Hamburgo'),'Holsten-Brauerei','24-05-1879');


INSERT INTO fabrica (fa_id,em_id,ci_id,fa_nombre,fa_fechaapertura) VALUES (seq_fa_id.NEXTVAL,
(Select em_id from empresa where em_nombre ='Carlsberg group'),
(Select ci_id from ciudad where ci_nombre = 'Copenhague'),'Tuborg','01-01-1875');

INSERT INTO fabrica (fa_id,em_id,ci_id,fa_nombre,fa_fechaapertura) VALUES (seq_fa_id.NEXTVAL,
(Select em_id from empresa where em_nombre ='Carlsberg group'),
(Select ci_id from ciudad where ci_nombre = 'West Yorkshire'),'Leeds Tetley Brewery','01-01-1822');

-----CONTRATO
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Fields' ),'12-03-2016',(SELECT em_id FROM empresa where em_nombre = 'Carlsberg group'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Roy' ),'12-03-2016',(SELECT em_id FROM empresa where em_nombre = 'Carlsberg group'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Hayden' ),'12-03-2016',(SELECT em_id FROM empresa where em_nombre = 'Holsten-Brauerei AG'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Roy' ),'12-03-2016',(SELECT em_id FROM empresa where em_nombre = 'Holsten-Brauerei AG'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Fields' ),'12-03-2016',(SELECT em_id FROM empresa where em_nombre = 'Joshua tetley y Son Ltd'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Silva' ),'12-03-2016',(SELECT em_id FROM empresa where em_nombre = 'Joshua tetley y Son Ltd'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Fields' ),'12-03-2015',(SELECT em_id FROM empresa where em_nombre = 'Carlsberg group'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Roy' ),'12-03-2015',(SELECT em_id FROM empresa where em_nombre = 'Carlsberg group'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES(seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Hayden' ),'12-03-2015',(SELECT em_id FROM empresa where em_nombre = 'Holsten-Brauerei AG'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Roy' ),'12-03-2015',(SELECT em_id FROM empresa where em_nombre = 'Holsten-Brauerei AG'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Fields' ),'12-03-2015',(SELECT em_id FROM empresa where em_nombre = 'Joshua tetley y Son Ltd'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Silva' ),'12-03-2015',(SELECT em_id FROM empresa where em_nombre = 'Joshua tetley y Son Ltd'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Fields' ),'12-03-2014',(SELECT em_id FROM empresa where em_nombre = 'Carlsberg group'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Roy' ),'12-03-2014',(SELECT em_id FROM empresa where em_nombre = 'Carlsberg group'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Hayden' ),'12-03-2014',(SELECT em_id FROM empresa where em_nombre = 'Holsten-Brauerei AG'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Roy' ),'12-03-2014',(SELECT em_id FROM empresa where em_nombre = 'Holsten-Brauerei AG'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Fields' ),'12-03-2014',(SELECT em_id FROM empresa where em_nombre = 'Joshua tetley y Son Ltd'),null);
INSERT INTO contrato (con_numero,pr_id,CON_FECHAEMISION,em_id,con_condicionesadicionales) VALUES (seq_con_numero.NEXTVAL,(SELECT pr_id FROM proveedores where pr_nombre = 'Silva' ),'12-03-2014',(SELECT em_id FROM empresa where em_nombre = 'Joshua tetley y Son Ltd'),null);

-----MAQUINARIA

INSERT INTO maquinaria (ma_id,ma_nombre,ma_palabraclv,ma_descripcion_) VALUES (seq_ma_id.NEXTVAL,'Calderos',
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('etapa',null,'caldero',null,null),RECETAPROCESOBASICO(null,'proceso','generador de vapor',null,null)),
'constan de sopladores yquemadores para combustibles líquidos');

INSERT INTO maquinaria (ma_id,ma_nombre,ma_palabraclv,ma_descripcion_) VALUES (seq_ma_id.NEXTVAL,'Motores',
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('etapa',null,'motor',null,null),RECETAPROCESOBASICO(null,'proceso','accionar bandas transportadoras',null,null)),
'accionamiento de las bandas transportadoras');

INSERT INTO maquinaria (ma_id,ma_nombre,ma_palabraclv,ma_descripcion_) VALUES (seq_ma_id.NEXTVAL,'Motores Diesel',
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('etapa',null,'m diesel',null,null),RECETAPROCESOBASICO(null,'proceso','energia electrica',null,null)),
'empleados para la generación de energía eléctrica ');

INSERT INTO maquinaria (ma_id,ma_nombre,ma_palabraclv,ma_descripcion_) VALUES (seq_ma_id.NEXTVAL,'Bombas',
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('etapa',null,'bombas',null,null),RECETAPROCESOBASICO(null,'proceso','fluidos',null,null)),
'transportan los diferentes fluidos');

INSERT INTO maquinaria (ma_id,ma_nombre,ma_palabraclv,ma_descripcion_) VALUES (seq_ma_id.NEXTVAL,'Compresores',
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('etapa',null,'piston',null,null),RECETAPROCESOBASICO(null,'proceso','sistema de enfriamiento',null,null)),
'para la inyección del aire en la fermentación y en la maduración');

INSERT INTO maquinaria (ma_id,ma_nombre,ma_palabraclv,ma_descripcion_) VALUES (seq_ma_id.NEXTVAL,'Ventiladores',
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('etapa',null,'ventilador',null,null),RECETAPROCESOBASICO(null,'proceso','receptor de malta',null,null)),
'Se utilizan en las instalaciones de recepción de malta');

INSERT INTO maquinaria (ma_id,ma_nombre,ma_palabraclv,ma_descripcion_) VALUES (seq_ma_id.NEXTVAL,'Bandas Transportadoras'
,RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('etapa',null,'bandas',null,null),RECETAPROCESOBASICO(null,'proceso','transportar',null,null)),
'Usadas para el transporte de la malta y adjunto');

INSERT INTO maquinaria (ma_id,ma_nombre,ma_palabraclv,ma_descripcion_) VALUES (seq_ma_id.NEXTVAL,'Transportadores',
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('etapa',null,'transportador',null,null),RECETAPROCESOBASICO(null,'proceso','elevador',null,null)),
'Para mover la malta y los adjuntos en forma vertical');

INSERT INTO maquinaria (ma_id,ma_nombre,ma_palabraclv,ma_descripcion_) VALUES (seq_ma_id.NEXTVAL,'Montacargas',
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('etapa',null,'burro',null,null),RECETAPROCESOBASICO(null,'proceso','montagargas',null,null)),
'Utilizados como máquinas para manejo de materiales mas comunes');

INSERT INTO maquinaria (ma_id,ma_nombre,ma_palabraclv,ma_descripcion_) VALUES (seq_ma_id.NEXTVAL,'Molinos',
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('etapa',null,'molino',null,null),RECETAPROCESOBASICO(null,'proceso','moler',null,null)),
'Empleados para el desprendimiento de la película del grano de malta');

INSERT INTO maquinaria (ma_id,ma_nombre,ma_palabraclv,ma_descripcion_) VALUES (seq_ma_id.NEXTVAL,'Intercambiadors de calor',
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('etapa',null,'refigerante',null,null),RECETAPROCESOBASICO(null,'proceso','enfriamiento',null,null)),
'para enfriar el mosto en su recorrido hacia los tanques de fermentación');

INSERT INTO maquinaria (ma_id,ma_nombre,ma_palabraclv,ma_descripcion_) VALUES (seq_ma_id.NEXTVAL,'Horno de tunel',
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('etapa',null,'pasteurizador',null,null),RECETAPROCESOBASICO(null,'proceso','pasteurizante',null,null)),
'Pasteurizador');

INSERT INTO maquinaria (ma_id,ma_nombre,ma_palabraclv,ma_descripcion_) VALUES (seq_ma_id.NEXTVAL,'Llenadoras',
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('etapa',null,'llenador',null,null),RECETAPROCESOBASICO(null,'proceso','Envasar',null,null)),
'Envasadora');

INSERT INTO maquinaria (ma_id,ma_nombre,ma_palabraclv,ma_descripcion_) VALUES (seq_ma_id.NEXTVAL,'Tanques de Contrapresion',
RECETAPROCESOBASICO_NT(RECETAPROCESOBASICO('etapa',null,'tanques',null,null),RECETAPROCESOBASICO(null,'proceso','presiones de tanque',null,null)),
'Para almacenarla cerveza y asi evitar que exista desprendimiento de gas');

-----CATALOGO EQUIPO
INSERT INTO catalogo_proveedor_EQ (ca_codigo,ca_nombre,ca_descripcion,ca_preciounitario,ca_especificaionestecnicas,ca_fotos,ca_incluye,pr_id,ma_id) VALUES
 (seq_ca_codigo.NEXTVAL,'Caldera de vapor','Univeral U-HD',192389,FN_IMPORTAR_BINARIO_CLOB('caldero1.pdf'),FOTOS_NT(FOTOS(IMPORTAR_BINARIO('caldero1.png'))),null,
 (SELECT pr_id FROM(SELECT pr_id FROM proveedores ORDER BY dbms_random.value )WHERE rownum = 1),(Select ma_id from maquinaria where ma_nombre = 'Calderos' and rownum = 1));


 INSERT INTO catalogo_proveedor_EQ (ca_codigo,ca_nombre,ca_descripcion,ca_preciounitario,ca_especificaionestecnicas,ca_fotos,ca_incluye,pr_id,ma_id) VALUES
 (seq_ca_codigo.NEXTVAL,'Motor diesel Dresser','Eficiencia de consumo de combustrible',8273,FN_IMPORTAR_BINARIO_CLOB('motordiesel1.pdf'),FOTOS_NT(FOTOS(IMPORTAR_BINARIO('motordiesel.png'))),null,
 (SELECT pr_id FROM(SELECT pr_id FROM proveedores ORDER BY dbms_random.value )WHERE rownum = 1),(Select ma_id from maquinaria where ma_nombre = 'Motores Diesel' and rownum = 1));


INSERT INTO catalogo_proveedor_EQ (ca_codigo,ca_nombre,ca_descripcion,ca_preciounitario,ca_especificaionestecnicas,ca_fotos,ca_incluye,pr_id,ma_id) VALUES
 (seq_ca_codigo.NEXTVAL,'Ollas de Cocción','Acero Inox. AISI 304-2B',19384,FN_IMPORTAR_BINARIO_CLOB('ollainox1.pdf'),null,null,
 (SELECT pr_id FROM(SELECT pr_id FROM proveedores ORDER BY dbms_random.value )WHERE rownum = 1),(Select ma_id from maquinaria where ma_nombre = 'Calderos' and rownum = 1));
 
 
INSERT INTO catalogo_proveedor_EQ (ca_codigo,ca_nombre,ca_descripcion,ca_preciounitario,ca_especificaionestecnicas,ca_fotos,ca_incluye,pr_id,ma_id) VALUES
 (seq_ca_codigo.NEXTVAL,'Fermentadores Cilindro','Cónico en Acero Inox. cal. AISI 304-2B',17238,FN_IMPORTAR_BINARIO_CLOB('cilindro1.pdf'),FOTOS_NT(FOTOS(IMPORTAR_BINARIO('cilindro1.png'))),FN_IMPORTAR_BINARIO_CLOB('cilindro1incluye.pdf'),
 (SELECT pr_id FROM(SELECT pr_id FROM proveedores ORDER BY dbms_random.value )WHERE rownum = 1),(Select ma_id from maquinaria where ma_nombre = 'Calderos'and rownum =1));


INSERT INTO catalogo_proveedor_EQ (ca_codigo,ca_nombre,ca_descripcion,ca_preciounitario,ca_especificaionestecnicas,ca_fotos,ca_incluye,pr_id,ma_id) VALUES
 (seq_ca_codigo.NEXTVAl,
 'Llenadora Contra Presión',
 'Ideal para cerveza artesanal',
 2783,
 FN_IMPORTAR_BINARIO_CLOB('llenadura1.pdf')
 ,FOTOS_NT(FOTOS(IMPORTAR_BINARIO('llenaduras1.jpg'))),
 null,
 (SELECT pr_id FROM(SELECT pr_id FROM proveedores ORDER BY dbms_random.value )WHERE rownum = 1),
 (Select ma_id from maquinaria where ma_nombre = 'Llenadoras' and rownum =1));


-----MATERIA PRIMA
insert into materia_prima (mp_id,mp_nombre,mp_descripcion,mp_formasdislupulo) values(seq_mp_id.NEXTVAL,'Lupulo','Ingrediente seco e insustituible en la elaboracion','seco');
insert into materia_prima (mp_id,mp_nombre,mp_descripcion,mp_formasdislupulo) values(seq_mp_id.NEXTVAL,'Lupulo Plug','Ingrediente seco, comprimido en tabletas','plug');
insert into materia_prima (mp_id,mp_nombre,mp_descripcion,mp_formasdislupulo) values(seq_mp_id.NEXTVAL,'Lupulo Rehidratado','Ingrediente rehidratado','rehidratado');
insert into materia_prima (mp_id,mp_nombre,mp_descripcion,mp_formasdislupulo) values(seq_mp_id.NEXTVAL,'Adjuntos (Grits)','Debido a la alta fuerza diastastica (fermento)','');
insert into materia_prima (mp_id,mp_nombre,mp_descripcion,mp_formasdislupulo) values(seq_mp_id.NEXTVAL,'Agua','Se usa agua potablepor sus caracteristicas...','');
insert into materia_prima (mp_id,mp_nombre,mp_descripcion,mp_formasdislupulo) values(seq_mp_id.NEXTVAL,'Levadura','Son hongos microscopicos unicelulares','');
insert into materia_prima (mp_id,mp_nombre,mp_descripcion,mp_formasdislupulo) values(seq_mp_id.NEXTVAL,'Malta','Constituida por granos de cebada germinados','');

-----VARIEDAD
insert into variedad (var_id,var_tipo,var_nombre,var_max_uso,var_colorebcrangoi,var_colorebcrangof,mp_id) values(seq_var_id.NEXTVAL,'base','Malta Pilsner',100,3,3,(select mp_id from materia_prima where mp_nombre='Malta'));
insert into variedad (var_id,var_tipo,var_nombre,var_max_uso,var_colorebcrangoi,var_colorebcrangof,mp_id) values(seq_var_id.NEXTVAL,'base','Malta Lager',100,3,3,(select mp_id from materia_prima where mp_nombre='Malta'));
insert into variedad (var_id,var_tipo,var_nombre,var_max_uso,var_colorebcrangoi,var_colorebcrangof,mp_id) values(seq_var_id.NEXTVAL,'coloreada','Malta de Trigo',70,3,4,(select mp_id from materia_prima where mp_nombre='Malta'));
insert into variedad (var_id,var_tipo,var_nombre,var_max_uso,var_colorebcrangoi,var_colorebcrangof,mp_id) values(seq_var_id.NEXTVAL,'base','Malta Pale',100,5,5,(select mp_id from materia_prima where mp_nombre='Malta'));
insert into variedad (var_id,var_tipo,var_nombre,var_max_uso,var_colorebcrangoi,var_colorebcrangof,mp_id) values(seq_var_id.NEXTVAL,'coloreada','Malta Crystal',20,80,140,(select mp_id from materia_prima where mp_nombre='Malta'));
insert into variedad (var_id,var_tipo,var_nombre,var_max_uso,var_colorebcrangoi,var_colorebcrangof,mp_id) values(seq_var_id.NEXTVAL,'coloreada','Malta Amber',20,90,110,(select mp_id from materia_prima where mp_nombre='Malta'));
insert into variedad (var_id,var_tipo,var_nombre,var_max_uso,var_colorebcrangoi,var_colorebcrangof,mp_id) values(seq_var_id.NEXTVAL,'base','Malta Chocolate',10,800,800,(select mp_id from materia_prima where mp_nombre='Malta'));
insert into variedad (var_id,var_tipo,var_nombre,var_max_uso,var_colorebcrangoi,var_colorebcrangof,mp_id) values(seq_var_id.NEXTVAL,'coloreada','Malta Negra',10,1400,1400,(select mp_id from materia_prima where mp_nombre='Malta'));
insert into variedad (var_id,var_tipo,var_nombre,var_max_uso,var_colorebcrangoi,var_colorebcrangof,mp_id) values(seq_var_id.NEXTVAL,'base','Cebada Tostada',10,1400,1400,(select mp_id from materia_prima where mp_nombre='Malta'));

-----V_C

-----CATALOGO MATERIA PRIMA
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pilsner','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Silva'),null,(select var_id from variedad where var_nombre='Malta Pilsner'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Lager','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Silva'),null,(select var_id from variedad where var_nombre='Malta Lager'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta De Trigo','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Silva'),null,(select var_id from variedad where var_nombre='Malta de Trigo'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pale','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Silva'),null,(select var_id from variedad where var_nombre='Malta Pale'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Crystal','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Silva'),null,(select var_id from variedad where var_nombre='Malta Crystal'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Amber','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Silva'),null,(select var_id from variedad where var_nombre='Malta Amber'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Chocolate','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Silva'),null,(select var_id from variedad where var_nombre='Malta Chocolate'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Negra','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Silva'),null,(select var_id from variedad where var_nombre='Malta Negra'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Cebada Tostada','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Silva'),null,(select var_id from variedad where var_nombre='Cebada Tostada'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Seco','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Silva'),(select mp_id from materia_prima where mp_nombre='Lupulo'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Plug','Lupulo en tabletas',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Silva'),(select mp_id from materia_prima where mp_nombre='Lupulo Plug'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Rehidratado','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Silva'),(select mp_id from materia_prima where mp_nombre='Lupulo Rehidratado'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Adjuntos','Cereales',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Adjuntos.jpg'))),(select pr_id from proveedores where pr_nombre='Silva'),(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Agua','Agua Potable',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Agua.jpg'))),(select pr_id from proveedores where pr_nombre='Silva'),(select mp_id from materia_prima where mp_nombre='Agua'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Levadura','Son hongos microscopicos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Levadura.jpg'))),(select pr_id from proveedores where pr_nombre='Silva'),(select mp_id from materia_prima where mp_nombre='Levadura'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pilsner','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roach'),null,(select var_id from variedad where var_nombre='Malta Pilsner'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Lager','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roach'),null,(select var_id from variedad where var_nombre='Malta Lager'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta De Trigo','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roach'),null,(select var_id from variedad where var_nombre='Malta de Trigo'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pale','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roach'),null,(select var_id from variedad where var_nombre='Malta Pale'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Crystal','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roach'),null,(select var_id from variedad where var_nombre='Malta Crystal'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Amber','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roach'),null,(select var_id from variedad where var_nombre='Malta Amber'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Chocolate','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roach'),null,(select var_id from variedad where var_nombre='Malta Chocolate'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Negra','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roach'),null,(select var_id from variedad where var_nombre='Malta Negra'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Cebada Tostada','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roach'),null,(select var_id from variedad where var_nombre='Cebada Tostada'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Seco','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Roach'),(select mp_id from materia_prima where mp_nombre='Lupulo'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Plug','Lupulo en tabletas',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Roach'),(select mp_id from materia_prima where mp_nombre='Lupulo Plug'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Rehidratado','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Roach'),(select mp_id from materia_prima where mp_nombre='Lupulo Rehidratado'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Adjuntos','Cereales',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Adjuntos.jpg'))),(select pr_id from proveedores where pr_nombre='Roach'),(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Agua','Agua Potable',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Agua.jpg'))),(select pr_id from proveedores where pr_nombre='Roach'),(select mp_id from materia_prima where mp_nombre='Agua'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Levadura','Son hongos microscopicos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Levadura.jpg'))),(select pr_id from proveedores where pr_nombre='Roach'),(select mp_id from materia_prima where mp_nombre='Levadura'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pilsner','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Mcmillan'),null,(select var_id from variedad where var_nombre='Malta Pilsner'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Lager','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Mcmillan'),null,(select var_id from variedad where var_nombre='Malta Lager'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta De Trigo','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Mcmillan'),null,(select var_id from variedad where var_nombre='Malta de Trigo'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pale','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Mcmillan'),null,(select var_id from variedad where var_nombre='Malta Pale'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Crystal','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Mcmillan'),null,(select var_id from variedad where var_nombre='Malta Crystal'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Amber','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Mcmillan'),null,(select var_id from variedad where var_nombre='Malta Amber'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Chocolate','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Mcmillan'),null,(select var_id from variedad where var_nombre='Malta Chocolate'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Negra','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Mcmillan'),null,(select var_id from variedad where var_nombre='Malta Negra'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Cebada Tostada','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Mcmillan'),null,(select var_id from variedad where var_nombre='Cebada Tostada'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Seco','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Mcmillan'),(select mp_id from materia_prima where mp_nombre='Lupulo'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Plug','Lupulo en tabletas',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Mcmillan'),(select mp_id from materia_prima where mp_nombre='Lupulo Plug'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Rehidratado','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Mcmillan'),(select mp_id from materia_prima where mp_nombre='Lupulo Rehidratado'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Adjuntos','Cereales',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Adjuntos.jpg'))),(select pr_id from proveedores where pr_nombre='Mcmillan'),(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Agua','Agua Potable',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Agua.jpg'))),(select pr_id from proveedores where pr_nombre='Mcmillan'),(select mp_id from materia_prima where mp_nombre='Agua'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Levadura','Son hongos microscopicos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Levadura.jpg'))),(select pr_id from proveedores where pr_nombre='Mcmillan'),(select mp_id from materia_prima where mp_nombre='Levadura'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pilsner','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Fields'),null,(select var_id from variedad where var_nombre='Malta Pilsner'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Lager','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Fields'),null,(select var_id from variedad where var_nombre='Malta Lager'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta De Trigo','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Fields'),null,(select var_id from variedad where var_nombre='Malta de Trigo'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pale','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Fields'),null,(select var_id from variedad where var_nombre='Malta Pale'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Crystal','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Fields'),null,(select var_id from variedad where var_nombre='Malta Crystal'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Amber','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Fields'),null,(select var_id from variedad where var_nombre='Malta Amber'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Chocolate','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Fields'),null,(select var_id from variedad where var_nombre='Malta Chocolate'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Negra','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Fields'),null,(select var_id from variedad where var_nombre='Malta Negra'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Cebada Tostada','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Fields'),null,(select var_id from variedad where var_nombre='Cebada Tostada'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Seco','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Fields'),(select mp_id from materia_prima where mp_nombre='Lupulo'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Plug','Lupulo en tabletas',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Fields'),(select mp_id from materia_prima where mp_nombre='Lupulo Plug'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Rehidratado','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Fields'),(select mp_id from materia_prima where mp_nombre='Lupulo Rehidratado'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Adjuntos','Cereales',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Adjuntos.jpg'))),(select pr_id from proveedores where pr_nombre='Fields'),(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Agua','Agua Potable',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Agua.jpg'))),(select pr_id from proveedores where pr_nombre='Fields'),(select mp_id from materia_prima where mp_nombre='Agua'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Levadura','Son hongos microscopicos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Levadura.jpg'))),(select pr_id from proveedores where pr_nombre='Fields'),(select mp_id from materia_prima where mp_nombre='Levadura'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pilsner','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Patterson'),null,(select var_id from variedad where var_nombre='Malta Pilsner'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Lager','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Patterson'),null,(select var_id from variedad where var_nombre='Malta Lager'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta De Trigo','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Patterson'),null,(select var_id from variedad where var_nombre='Malta de Trigo'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pale','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Patterson'),null,(select var_id from variedad where var_nombre='Malta Pale'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Crystal','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Patterson'),null,(select var_id from variedad where var_nombre='Malta Crystal'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Amber','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Patterson'),null,(select var_id from variedad where var_nombre='Malta Amber'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Chocolate','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Patterson'),null,(select var_id from variedad where var_nombre='Malta Chocolate'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Negra','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Patterson'),null,(select var_id from variedad where var_nombre='Malta Negra'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Cebada Tostada','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Patterson'),null,(select var_id from variedad where var_nombre='Cebada Tostada'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Seco','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Patterson'),(select mp_id from materia_prima where mp_nombre='Lupulo'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Plug','Lupulo en tabletas',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Patterson'),(select mp_id from materia_prima where mp_nombre='Lupulo Plug'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Rehidratado','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Patterson'),(select mp_id from materia_prima where mp_nombre='Lupulo Rehidratado'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Adjuntos','Cereales',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Adjuntos.jpg'))),(select pr_id from proveedores where pr_nombre='Patterson'),(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Agua','Agua Potable',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Agua.jpg'))),(select pr_id from proveedores where pr_nombre='Patterson'),(select mp_id from materia_prima where mp_nombre='Agua'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Levadura','Son hongos microscopicos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Levadura.jpg'))),(select pr_id from proveedores where pr_nombre='Patterson'),(select mp_id from materia_prima where mp_nombre='Levadura'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pilsner','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Ellis'),null,(select var_id from variedad where var_nombre='Malta Pilsner'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Lager','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Ellis'),null,(select var_id from variedad where var_nombre='Malta Lager'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta De Trigo','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Ellis'),null,(select var_id from variedad where var_nombre='Malta de Trigo'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pale','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Ellis'),null,(select var_id from variedad where var_nombre='Malta Pale'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Crystal','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Ellis'),null,(select var_id from variedad where var_nombre='Malta Crystal'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Amber','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Ellis'),null,(select var_id from variedad where var_nombre='Malta Amber'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Chocolate','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Ellis'),null,(select var_id from variedad where var_nombre='Malta Chocolate'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Negra','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Ellis'),null,(select var_id from variedad where var_nombre='Malta Negra'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Cebada Tostada','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Ellis'),null,(select var_id from variedad where var_nombre='Cebada Tostada'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Seco','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Ellis'),(select mp_id from materia_prima where mp_nombre='Lupulo'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Plug','Lupulo en tabletas',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Ellis'),(select mp_id from materia_prima where mp_nombre='Lupulo Plug'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Rehidratado','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Ellis'),(select mp_id from materia_prima where mp_nombre='Lupulo Rehidratado'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Adjuntos','Cereales',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Adjuntos.jpg'))),(select pr_id from proveedores where pr_nombre='Ellis'),(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Agua','Agua Potable',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Agua.jpg'))),(select pr_id from proveedores where pr_nombre='Ellis'),(select mp_id from materia_prima where mp_nombre='Agua'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Levadura','Son hongos microscopicos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Levadura.jpg'))),(select pr_id from proveedores where pr_nombre='Ellis'),(select mp_id from materia_prima where mp_nombre='Levadura'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pilsner','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='House'),null,(select var_id from variedad where var_nombre='Malta Pilsner'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Lager','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='House'),null,(select var_id from variedad where var_nombre='Malta Lager'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta De Trigo','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='House'),null,(select var_id from variedad where var_nombre='Malta de Trigo'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pale','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='House'),null,(select var_id from variedad where var_nombre='Malta Pale'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Crystal','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='House'),null,(select var_id from variedad where var_nombre='Malta Crystal'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Amber','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='House'),null,(select var_id from variedad where var_nombre='Malta Amber'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Chocolate','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='House'),null,(select var_id from variedad where var_nombre='Malta Chocolate'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Negra','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='House'),null,(select var_id from variedad where var_nombre='Malta Negra'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Cebada Tostada','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='House'),null,(select var_id from variedad where var_nombre='Cebada Tostada'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Seco','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='House'),(select mp_id from materia_prima where mp_nombre='Lupulo'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Plug','Lupulo en tabletas',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='House'),(select mp_id from materia_prima where mp_nombre='Lupulo Plug'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Rehidratado','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='House'),(select mp_id from materia_prima where mp_nombre='Lupulo Rehidratado'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Adjuntos','Cereales',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Adjuntos.jpg'))),(select pr_id from proveedores where pr_nombre='House'),(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Agua','Agua Potable',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Agua.jpg'))),(select pr_id from proveedores where pr_nombre='House'),(select mp_id from materia_prima where mp_nombre='Agua'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Levadura','Son hongos microscopicos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Levadura.jpg'))),(select pr_id from proveedores where pr_nombre='House'),(select mp_id from materia_prima where mp_nombre='Levadura'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pilsner','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Kirby'),null,(select var_id from variedad where var_nombre='Malta Pilsner'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Lager','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Kirby'),null,(select var_id from variedad where var_nombre='Malta Lager'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta De Trigo','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Kirby'),null,(select var_id from variedad where var_nombre='Malta de Trigo'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pale','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Kirby'),null,(select var_id from variedad where var_nombre='Malta Pale'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Crystal','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Kirby'),null,(select var_id from variedad where var_nombre='Malta Crystal'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Amber','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Kirby'),null,(select var_id from variedad where var_nombre='Malta Amber'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Chocolate','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Kirby'),null,(select var_id from variedad where var_nombre='Malta Chocolate'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Negra','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Kirby'),null,(select var_id from variedad where var_nombre='Malta Negra'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Cebada Tostada','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Kirby'),null,(select var_id from variedad where var_nombre='Cebada Tostada'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Seco','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Kirby'),(select mp_id from materia_prima where mp_nombre='Lupulo'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Plug','Lupulo en tabletas',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Kirby'),(select mp_id from materia_prima where mp_nombre='Lupulo Plug'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Rehidratado','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Kirby'),(select mp_id from materia_prima where mp_nombre='Lupulo Rehidratado'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Adjuntos','Cereales',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Adjuntos.jpg'))),(select pr_id from proveedores where pr_nombre='Kirby'),(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Agua','Agua Potable',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Agua.jpg'))),(select pr_id from proveedores where pr_nombre='Kirby'),(select mp_id from materia_prima where mp_nombre='Agua'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Levadura','Son hongos microscopicos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Levadura.jpg'))),(select pr_id from proveedores where pr_nombre='Kirby'),(select mp_id from materia_prima where mp_nombre='Levadura'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pilsner','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Hayden'),null,(select var_id from variedad where var_nombre='Malta Pilsner'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Lager','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Hayden'),null,(select var_id from variedad where var_nombre='Malta Lager'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta De Trigo','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Hayden'),null,(select var_id from variedad where var_nombre='Malta de Trigo'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pale','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Hayden'),null,(select var_id from variedad where var_nombre='Malta Pale'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Crystal','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Hayden'),null,(select var_id from variedad where var_nombre='Malta Crystal'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Amber','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Hayden'),null,(select var_id from variedad where var_nombre='Malta Amber'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Chocolate','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Hayden'),null,(select var_id from variedad where var_nombre='Malta Chocolate'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Negra','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Hayden'),null,(select var_id from variedad where var_nombre='Malta Negra'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Cebada Tostada','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Hayden'),null,(select var_id from variedad where var_nombre='Cebada Tostada'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Seco','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Hayden'),(select mp_id from materia_prima where mp_nombre='Lupulo'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Plug','Lupulo en tabletas',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Hayden'),(select mp_id from materia_prima where mp_nombre='Lupulo Plug'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Rehidratado','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Hayden'),(select mp_id from materia_prima where mp_nombre='Lupulo Rehidratado'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Adjuntos','Cereales',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Adjuntos.jpg'))),(select pr_id from proveedores where pr_nombre='Hayden'),(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Agua','Agua Potable',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Agua.jpg'))),(select pr_id from proveedores where pr_nombre='Hayden'),(select mp_id from materia_prima where mp_nombre='Agua'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Levadura','Son hongos microscopicos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Levadura.jpg'))),(select pr_id from proveedores where pr_nombre='Hayden'),(select mp_id from materia_prima where mp_nombre='Levadura'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pilsner','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roy'),null,(select var_id from variedad where var_nombre='Malta Pilsner'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Lager','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roy'),null,(select var_id from variedad where var_nombre='Malta Lager'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta De Trigo','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roy'),null,(select var_id from variedad where var_nombre='Malta de Trigo'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Pale','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roy'),null,(select var_id from variedad where var_nombre='Malta Pale'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Crystal','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roy'),null,(select var_id from variedad where var_nombre='Malta Crystal'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Amber','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roy'),null,(select var_id from variedad where var_nombre='Malta Amber'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Chocolate','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roy'),null,(select var_id from variedad where var_nombre='Malta Chocolate'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Malta Negra','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roy'),null,(select var_id from variedad where var_nombre='Malta Negra'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Cebada Tostada','Constituida por granos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Malta.jpg'))),(select pr_id from proveedores where pr_nombre='Roy'),null,(select var_id from variedad where var_nombre='Cebada Tostada'));
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Seco','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Roy'),(select mp_id from materia_prima where mp_nombre='Lupulo'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Plug','Lupulo en tabletas',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Roy'),(select mp_id from materia_prima where mp_nombre='Lupulo Plug'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Lupulo Rehidratado','Ingrediente insustituible',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Lupulo.jpg'))),(select pr_id from proveedores where pr_nombre='Roy'),(select mp_id from materia_prima where mp_nombre='Lupulo Rehidratado'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Adjuntos','Cereales',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Adjuntos.jpg'))),(select pr_id from proveedores where pr_nombre='Roy'),(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Agua','Agua Potable',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Agua.jpg'))),(select pr_id from proveedores where pr_nombre='Roy'),(select mp_id from materia_prima where mp_nombre='Agua'),null);
insert into catalogo_proveedor_mp (cp_id,cp_nombre,cp_descripcion,cp_fotos,pr_id,mp_id,var_id) values(seq_cp_id.NEXTVAL,'Levadura','Son hongos microscopicos',FOTOS_NT(FOTOS(IMPORTAR_BINARIO('Levadura.jpg'))),(select pr_id from proveedores where pr_nombre='Roy'),(select mp_id from materia_prima where mp_nombre='Levadura'),null);

-----PEDIDO
INSERT INTO pedido (pe_id,con_numero,pe_fechapedido,pe_status,pe_fechaentrega,pe_tipo,pe_numfactura,pe_total,pe_fechasolicitada) 
VALUES (seq_pe_id.NEXTVAL,(SELECT con_numero FROM(SELECT con_numero FROM contrato ORDER BY dbms_random.value )WHERE rownum = 1),
(Select con_fechaemision from (SELECT con_fechaemision FROM contrato ORDER BY dbms_random.value )WHERE to_char(con_fechaemision,'YYYY')= '2016' and rownum = 1 )
,'en proceso',null,'materia prima',NULL,NULL,'12-12-2016');

INSERT INTO pedido (pe_id,con_numero,pe_fechapedido,pe_status,pe_fechaentrega,pe_tipo,pe_numfactura,pe_total,pe_fechasolicitada) 
VALUES (seq_pe_id.NEXTVAL,(SELECT con_numero FROM(SELECT con_numero FROM contrato ORDER BY dbms_random.value )WHERE rownum = 1),
(Select con_fechaemision from (SELECT con_fechaemision FROM contrato ORDER BY dbms_random.value )WHERE to_char(con_fechaemision,'YYYY')= '2016' and rownum = 1 ),
'en proceso',null,'equipo',NULL,NULL,'22-06-2016');

INSERT INTO pedido (pe_id,con_numero,pe_fechapedido,pe_status,pe_fechaentrega,pe_tipo,pe_numfactura,pe_total,pe_fechasolicitada) 
VALUES (seq_pe_id.NEXTVAL,(SELECT con_numero FROM(SELECT con_numero FROM contrato ORDER BY dbms_random.value )WHERE rownum = 1),
(Select con_fechaemision from (SELECT con_fechaemision FROM contrato ORDER BY dbms_random.value )WHERE to_char(con_fechaemision,'YYYY')= '2016' and rownum = 1 )
,'cancelada',null,'materia prima',NULL,NULL,'05-05-2016');

INSERT INTO pedido (pe_id,con_numero,pe_fechapedido,pe_status,pe_fechaentrega,pe_tipo,pe_numfactura,pe_total,pe_fechasolicitada) 
VALUES (seq_pe_id.NEXTVAL,(SELECT con_numero FROM(SELECT con_numero FROM contrato ORDER BY dbms_random.value )WHERE rownum = 1),
(Select con_fechaemision from (SELECT con_fechaemision FROM contrato ORDER BY dbms_random.value )WHERE to_char(con_fechaemision,'YYYY')= '2015' and rownum = 1 ),
'finalizada','22-09-2015','materia prima',123,23423,'22-09-2015');

INSERT INTO pedido (pe_id,con_numero,pe_fechapedido,pe_status,pe_fechaentrega,pe_tipo,pe_numfactura,pe_total,pe_fechasolicitada) 
VALUES (seq_pe_id.NEXTVAL,(SELECT con_numero FROM(SELECT con_numero FROM contrato ORDER BY dbms_random.value )WHERE rownum = 1),
(Select con_fechaemision from (SELECT con_fechaemision FROM contrato ORDER BY dbms_random.value )WHERE to_char(con_fechaemision,'YYYY')= '2015' and rownum = 1 ),
'finalizada','22-03-2015','materia prima',234,23421,'11-03-2015');

INSERT INTO pedido (pe_id,con_numero,pe_fechapedido,pe_status,pe_fechaentrega,pe_tipo,pe_numfactura,pe_total,pe_fechasolicitada) 
VALUES (seq_pe_id.NEXTVAL,(SELECT con_numero FROM(SELECT con_numero FROM contrato ORDER BY dbms_random.value )WHERE rownum = 1),
(Select con_fechaemision from (SELECT con_fechaemision FROM contrato ORDER BY dbms_random.value )WHERE to_char(con_fechaemision,'YYYY')= '2016' and rownum = 1 ),
'finalizada','02-03-2016','materia prima',543,12211,'02-02-2016');

-----PAGO
INSERT INTO pago (pa_id,pe_id,pa_tipopago,pa_monto,pa_fecha,pa_cuota) VALUES (seq_pa_id.NEXTVAL,
(Select pe_id from (SELECT pe_id FROM pedido where pe_status='cancelada' or pe_status='finalizada' and to_char(pe_fechapedido,'YYYY')= '2016' and pe_tipo ='materia prima'  ORDER BY dbms_random.value )WHERE rownum = 1) ,
FORMAPAGO_NT(FORMAPAGO('DEBITO','pago de materia prima',null,'3',DATOSCUENTA('HSBC Holdings',234454,'Jose Luis Garcia','ahorro','tender@treth.com'))),
183,'12-12-16',1);

INSERT INTO pago (pa_id,pe_id,pa_tipopago,pa_monto,pa_fecha,pa_cuota) VALUES (seq_pa_id.NEXTVAL,
(Select pe_id from (SELECT pe_id FROM pedido where pe_status='cancelada' or pe_status='finalizada' and to_char(pe_fechapedido,'YYYY')= '2015' and pe_tipo ='materia prima'  ORDER BY dbms_random.value )WHERE rownum = 1) ,
FORMAPAGO_NT(FORMAPAGO('DEBITO','pago de materia prima',null,'3',DATOSCUENTA('JP Morgan Chase y Co',234454,'Suzanne Collings','ahorro','tender@treth.com'))),
278,'12-12-15',2);


INSERT INTO pago (pa_id,pe_id,pa_tipopago,pa_monto,pa_fecha,pa_cuota) VALUES (seq_pa_id.NEXTVAL,
(Select pe_id from (SELECT pe_id FROM pedido where pe_status='cancelada' or pe_status='finalizada' and to_char(pe_fechapedido,'YYYY')= '2015' and pe_tipo ='materia prima'  ORDER BY dbms_random.value )WHERE rownum = 1) ,
FORMAPAGO_NT(FORMAPAGO('DEBITO','pago de materia prima',null,'3',DATOSCUENTA('Agricultural Bank of China',234454,'Scott Westerfeld','ahorro','tender@treth.com'))),
289,'12-06-15',3);

INSERT INTO pago (pa_id,pe_id,pa_tipopago,pa_monto,pa_fecha,pa_cuota) VALUES (seq_pa_id.NEXTVAL,
(Select pe_id from (SELECT pe_id FROM pedido where pe_status='cancelada' or pe_status='finalizada' and to_char(pe_fechapedido,'YYYY')= '2016' and pe_tipo ='materia prima'  ORDER BY dbms_random.value )WHERE rownum = 1) ,
FORMAPAGO_NT(FORMAPAGO('DEBITO','pago de materia prima',null,'3',DATOSCUENTA('Bank of America',234454,'Anne Rice','ahorro','tender@treth.com'))),
178,'12-08-16',1);

INSERT INTO pago (pa_id,pe_id,pa_tipopago,pa_monto,pa_fecha,pa_cuota) VALUES (seq_pa_id.NEXTVAL,
(Select pe_id from (SELECT pe_id FROM pedido where pe_status='cancelada' or pe_status='finalizada' and to_char(pe_fechapedido,'YYYY')= '2016' and pe_tipo ='materia prima'  ORDER BY dbms_random.value )WHERE rownum = 1) ,
FORMAPAGO_NT(FORMAPAGO('DEBITO','pago de materia prima',null,'3',DATOSCUENTA('Bank of America',234454,'Giorgio Faletti','ahorro','tender@treth.com'))),
3232,'12-09-16',2);

-----COMPOSICION
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,30,null,(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),(select var_id from variedad where var_nombre='Malta Pilsner' and rownum=1),null);
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,10,null,(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Lupulo' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,5,null,(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,40,null,(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Agua' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Levadura' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,20,null,(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1),(select var_id from variedad where var_nombre='Malta Lager' and rownum=1),null);
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Lupulo Rehidratado' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,35,null,(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Agua' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Levadura' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,30,null,(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1),(select var_id from variedad where var_nombre='Malta Pilsner' and rownum=1),null);
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Lupulo Rehidratado' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,40,null,(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Agua' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,10,null,(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Levadura' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,25,null,(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1),(select var_id from variedad where var_nombre='Malta Pale' and rownum=1),null);
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Lupulo Plug' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,10,null,(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,30,null,(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Agua' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,20,null,(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Levadura' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,35,null,(select ce_id from cerveza where ce_nombreingles='Tetleys Gold' and rownum=1),(select var_id from variedad where var_nombre='Malta Pale' and rownum=1),null);
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,10,null,(select ce_id from cerveza where ce_nombreingles='Tetleys Gold' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Lupulo Plug' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='Tetleys Gold' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,30,null,(select ce_id from cerveza where ce_nombreingles='Tetleys Gold' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Agua' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,10,null,(select ce_id from cerveza where ce_nombreingles='Tetleys Gold' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Levadura' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),(select var_id from variedad where var_nombre='Malta de Trigo' and rownum=1),null);
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,25,null,(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Lupulo'));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,10,null,(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,35,null,(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Agua' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Levadura' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,30,null,(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1),(select var_id from variedad where var_nombre='Malta Crystal' and rownum=1),null);
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,10,null,(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Lupulo' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,25,null,(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Agua' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,20,null,(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Levadura' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,25,null,(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1),(select var_id from variedad where var_nombre='Malta Lager' and rownum=1),null);
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Lupulo' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,10,null,(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,30,null,(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Agua' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,20,null,(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Levadura' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,25,null,(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1),(select var_id from variedad where var_nombre='Malta Lager' and rownum=1),null);
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,10,null,(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Lupulo Plug' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,35,null,(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Agua' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Levadura' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,30,null,(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1),(select var_id from variedad where var_nombre='Malta Amber' and rownum=1),null);
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,10,null,(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Lupulo Plug' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,10,null,(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,30,null,(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Agua' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,20,null,(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Levadura' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,35,null,(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1),(select var_id from variedad where var_nombre='Malta Pale Ale' and rownum=1),null);
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,10,null,(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Lupulo Rehidratado' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,10,null,(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,25,null,(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Agua' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,20,null,(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Levadura' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,35,null,(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1),(select var_id from variedad where var_nombre='Malta Pale Ale' and rownum=1),null);
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,20,null,(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Lupulo Rehidratado' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,25,null,(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Agua' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,5,null,(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Levadura' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1),(select var_id from variedad where var_nombre='Cebada Tostada' and rownum=1),null);
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,20,null,(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Lupulo Rehidratado' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,15,null,(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Adjuntos (Grits)' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,45,null,(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Agua' and rownum=1));
insert into composicion (c_id,c_proporcion,c_descripcion,ce_id,var_id,mp_id) values (seq_c_id.NEXTVAL,5,null,(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1),null,(select mp_id from materia_prima where mp_nombre='Levadura' and rownum=1));

-----PRODUCCION MENSUAL

insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/02/2010',(select fa_id from fabrica where fa_nombre='Tuborg'),(select f.em_id from fabrica f, empresa e where fa_nombre='Tuborg' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg' and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/02/2010',(select fa_id from fabrica where fa_nombre='Tuborg'),(select f.em_id from fabrica f, empresa e where fa_nombre='Tuborg' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg' and pc.pc_tipo='botella' and pc.pc_cantidad=330 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/02/2010',(select fa_id from fabrica where fa_nombre='Tuborg'),(select f.em_id from fabrica f, empresa e where fa_nombre='Tuborg' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg' and pc.pc_tipo='botella' and pc.pc_cantidad=220 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/04/2010',(select fa_id from fabrica where fa_nombre='Tuborg'),(select f.em_id from fabrica f, empresa e where fa_nombre='Tuborg' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg Strong' and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1),25000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/04/2010',(select fa_id from fabrica where fa_nombre='Tuborg'),(select f.em_id from fabrica f, empresa e where fa_nombre='Tuborg' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg Strong' and pc.pc_tipo='botella' and pc.pc_cantidad=330 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1),25000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/04/2010',(select fa_id from fabrica where fa_nombre='Tuborg'),(select f.em_id from fabrica f, empresa e where fa_nombre='Tuborg' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg Strong' and pc.pc_tipo='botella' and pc.pc_cantidad=355 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg Strong' and rownum=1),25000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/06/2010',(select fa_id from fabrica where fa_nombre='Tuborg'),(select f.em_id from fabrica f, empresa e where fa_nombre='Tuborg' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg Gold' and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1),25000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/06/2010',(select fa_id from fabrica where fa_nombre='Tuborg'),(select f.em_id from fabrica f, empresa e where fa_nombre='Tuborg' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg Gold' and pc.pc_tipo='botella' and pc.pc_cantidad=220 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1),25000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/06/2010',(select fa_id from fabrica where fa_nombre='Tuborg'),(select f.em_id from fabrica f, empresa e where fa_nombre='Tuborg' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg Gold' and pc.pc_tipo='botella retornable' and pc.pc_cantidad=220 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg Gold' and rownum=1),25000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/08/2011',(select fa_id from fabrica where fa_nombre='Tuborg'),(select f.em_id from fabrica f, empresa e where fa_nombre='Tuborg' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg Julebryg' and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/08/2011',(select fa_id from fabrica where fa_nombre='Tuborg'),(select f.em_id from fabrica f, empresa e where fa_nombre='Tuborg' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg Julebryg' and pc.pc_tipo='botella' and pc.pc_cantidad=330 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/08/2011',(select fa_id from fabrica where fa_nombre='Tuborg'),(select f.em_id from fabrica f, empresa e where fa_nombre='Tuborg' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg Julebryg' and pc.pc_tipo='botella retornable' and pc.pc_cantidad=330 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg Julebryg' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/10/2011',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tetleys Gold' and pc.pc_tipo='botella' and pc.pc_cantidad=330 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tetleys Gold' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/10/2011',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tetleys Gold' and pc.pc_tipo='botella retornable' and pc.pc_cantidad=220 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tetleys Gold' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/12/2011',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Appel Somersby' and pc.pc_tipo='botella' and pc.pc_cantidad=330 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),10000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/12/2011',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Appel Somersby' and pc.pc_tipo='botella' and pc.pc_cantidad=355 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),10000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/12/2011',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Appel Somersby' and pc.pc_tipo='botella' and pc.pc_cantidad=220 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),10000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/12/2011',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Appel Somersby' and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),10000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/12/2011',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Appel Somersby' and pc.pc_tipo='botella retornable' and pc.pc_cantidad=220 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),10000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/12/2011',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Appel Somersby' and pc.pc_tipo='botella retornable' and pc.pc_cantidad=330 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Appel Somersby' and rownum=1),10000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/03/2012',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Kronenbourg 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=330 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1),15000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/03/2012',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Kronenbourg 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=355 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1),15000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/03/2012',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Kronenbourg 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=220 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1),15000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/03/2012',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Kronenbourg 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1),15000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/03/2012',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Kronenbourg 1664' and pc.pc_tipo='botella retornable' and pc.pc_cantidad=220 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1),15000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/03/2012',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Kronenbourg 1664' and pc.pc_tipo='botella retornable' and pc.pc_cantidad=330 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Kronenbourg 1664' and rownum=1),15000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/06/2012',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Blanc 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=330 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1),15000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/06/2012',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Blanc 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=355 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1),15000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/06/2012',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Blanc 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=220 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1),15000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/06/2012',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Blanc 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1),15000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/06/2012',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Blanc 1664' and pc.pc_tipo='botella retornable' and pc.pc_cantidad=220 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1),15000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/06/2012',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Blanc 1664' and pc.pc_tipo='botella retornable' and pc.pc_cantidad=330 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Blanc 1664' and rownum=1),15000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/09/2013',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Millesime 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=330 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/09/2013',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Millesime 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=355 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/09/2013',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Millesime 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=220 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/09/2013',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Millesime 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/09/2013',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Millesime 1664' and pc.pc_tipo='botella retornable' and pc.pc_cantidad=220 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/09/2013',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Millesime 1664' and pc.pc_tipo='botella retornable' and pc.pc_cantidad=330 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Millesime 1664' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/12/2013',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Rose 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=330 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/12/2013',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Rose 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=355 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/12/2013',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Rose 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=220 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/12/2013',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Rose 1664' and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/12/2013',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Rose 1664' and pc.pc_tipo='botella retornable' and pc.pc_cantidad=220 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/12/2013',(select fa_id from fabrica where fa_nombre='Leeds Tetley Brewery'),(select f.em_id from fabrica f, empresa e where fa_nombre='Leeds Tetley Brewery' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Rose 1664' and pc.pc_tipo='botella retornable' and pc.pc_cantidad=330 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Rose 1664' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/01/2014',(select fa_id from fabrica where fa_nombre='Holsten-Brauerei'),(select f.em_id from fabrica f, empresa e where fa_nombre='Holsten-Brauerei' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Irish Red Ale' and pc.pc_tipo='lata' and pc.pc_cantidad=295 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/01/2014',(select fa_id from fabrica where fa_nombre='Holsten-Brauerei'),(select f.em_id from fabrica f, empresa e where fa_nombre='Holsten-Brauerei' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Irish Red Ale' and pc.pc_tipo='lata' and pc.pc_cantidad=222 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/01/2014',(select fa_id from fabrica where fa_nombre='Holsten-Brauerei'),(select f.em_id from fabrica f, empresa e where fa_nombre='Holsten-Brauerei' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Irish Red Ale' and pc.pc_tipo='lata' and pc.pc_cantidad=355 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Irish Red Ale' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/05/2015',(select fa_id from fabrica where fa_nombre='Holsten-Brauerei'),(select f.em_id from fabrica f, empresa e where fa_nombre='Holsten-Brauerei' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='India Pale Ale' and pc.pc_tipo='lata' and pc.pc_cantidad=222 and rownum=1),(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/05/2015',(select fa_id from fabrica where fa_nombre='Holsten-Brauerei'),(select f.em_id from fabrica f, empresa e where fa_nombre='Holsten-Brauerei' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='India Pale Ale' and pc.pc_tipo='lata' and pc.pc_cantidad=355 and rownum=1),(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/05/2015',(select fa_id from fabrica where fa_nombre='Holsten-Brauerei'),(select f.em_id from fabrica f, empresa e where fa_nombre='Holsten-Brauerei' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='India Pale Ale' and pc.pc_tipo='lata' and pc.pc_cantidad=295 and rownum=1),(select ce_id from cerveza where ce_nombreingles='India Pale Ale' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/07/2016',(select fa_id from fabrica where fa_nombre='Holsten-Brauerei'),(select f.em_id from fabrica f, empresa e where fa_nombre='Holsten-Brauerei' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='California Steam Beer' and pc.pc_tipo='lata' and pc.pc_cantidad=222 and rownum=1),(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/07/2016',(select fa_id from fabrica where fa_nombre='Holsten-Brauerei'),(select f.em_id from fabrica f, empresa e where fa_nombre='Holsten-Brauerei' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='California Steam Beer' and pc.pc_tipo='lata' and pc.pc_cantidad=355 and rownum=1),(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1),20000);
insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values ('01/07/2016',(select fa_id from fabrica where fa_nombre='Holsten-Brauerei'),(select f.em_id from fabrica f, empresa e where fa_nombre='Holsten-Brauerei' and f.em_id=e.em_id),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='California Steam Beer' and pc.pc_tipo='lata' and pc.pc_cantidad=295 and rownum=1),(select ce_id from cerveza where ce_nombreingles='California Steam Beer' and rownum=1),20000);


-----PRESENTACION
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pilsner' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Lager' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta De Trigo' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pale' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Crystal' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Amber' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Chocolate' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Negra' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Cebada Tostada' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1','kg'),'bolsa',2,'Bolsa de 1 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Seco' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',5,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Plug' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','kg'),'caja',25,'Caja sellada de 20 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Rehidratado' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',2,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Adjuntos' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','litros'),'otros',12,'Galon de Agua',(select cp_id from catalogo_proveedor_mp where cp_nombre='Agua' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1/2','litro'),'otros',6,'Cultivo Liquido',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('6','gr'),'sachet',1,'Sachets Liofilizados',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('500','gr'),'otros',4,'Empaque de 500 gramos',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Silva' and rownum=1) and rownum=1));



insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pilsner' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Lager' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta De Trigo' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pale' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Crystal' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Amber' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Chocolate' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Negra' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Cebada Tostada' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1','kg'),'bolsa',2,'Bolsa de 1 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Seco' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',5,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Plug' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','kg'),'caja',25,'Caja sellada de 20 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Rehidratado' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',2,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Adjuntos' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','litros'),'otros',12,'Galon de Agua',(select cp_id from catalogo_proveedor_mp where cp_nombre='Agua' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1/2','litro'),'otros',6,'Cultivo Liquido',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('6','gr'),'sachet',1,'Sachets Liofilizados',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('500','gr'),'otros',4,'Empaque de 500 gramos',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Roach' and rownum=1) and rownum=1));



insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pilsner' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Lager' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta De Trigo' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pale' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Crystal' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Amber' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Chocolate' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Negra' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Cebada Tostada' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1','kg'),'bolsa',2,'Bolsa de 1 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Seco' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',5,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Plug' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','kg'),'caja',25,'Caja sellada de 20 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Rehidratado' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',2,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Adjuntos' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','litros'),'otros',12,'Galon de Agua',(select cp_id from catalogo_proveedor_mp where cp_nombre='Agua' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1/2','litro'),'otros',6,'Cultivo Liquido',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('6','gr'),'sachet',1,'Sachets Liofilizados',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('500','gr'),'otros',4,'Empaque de 500 gramos',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Mcmillan' and rownum=1) and rownum=1));



insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pilsner' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Lager' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta De Trigo' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pale' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Crystal' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Amber' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Chocolate' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Negra' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Cebada Tostada' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1','kg'),'bolsa',2,'Bolsa de 1 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Seco' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',5,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Plug' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','kg'),'caja',25,'Caja sellada de 20 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Rehidratado' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',2,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Adjuntos' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','litros'),'otros',12,'Galon de Agua',(select cp_id from catalogo_proveedor_mp where cp_nombre='Agua' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1/2','litro'),'otros',6,'Cultivo Liquido',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('6','gr'),'sachet',1,'Sachets Liofilizados',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('500','gr'),'otros',4,'Empaque de 500 gramos',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Fields' and rownum=1) and rownum=1));


insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pilsner' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Lager' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta De Trigo' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pale' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Crystal' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Amber' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Chocolate' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Negra' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Cebada Tostada' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1','kg'),'bolsa',2,'Bolsa de 1 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Seco' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',5,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Plug' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','kg'),'caja',25,'Caja sellada de 20 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Rehidratado' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',2,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Adjuntos' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','litros'),'otros',12,'Galon de Agua',(select cp_id from catalogo_proveedor_mp where cp_nombre='Agua' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1/2','litro'),'otros',6,'Cultivo Liquido',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('6','gr'),'sachet',1,'Sachets Liofilizados',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('500','gr'),'otros',4,'Empaque de 500 gramos',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Patterson' and rownum=1) and rownum=1));



insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pilsner' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Lager' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta De Trigo' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pale' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Crystal' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Amber' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Chocolate' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Negra' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Cebada Tostada' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1','kg'),'bolsa',2,'Bolsa de 1 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Seco' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',5,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Plug' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','kg'),'caja',25,'Caja sellada de 20 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Rehidratado' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',2,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Adjuntos' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','litros'),'otros',12,'Galon de Agua',(select cp_id from catalogo_proveedor_mp where cp_nombre='Agua' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1/2','litro'),'otros',6,'Cultivo Liquido',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('6','gr'),'sachet',1,'Sachets Liofilizados',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('500','gr'),'otros',4,'Empaque de 500 gramos',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Ellis' and rownum=1) and rownum=1));



insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('500','gr'),'otros',4,'Empaque de 500 gramos',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pilsner' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Lager' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta De Trigo' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pale' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Crystal' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Amber' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Chocolate' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Negra' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Cebada Tostada' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1','kg'),'bolsa',2,'Bolsa de 1 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Seco' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',5,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Plug' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','kg'),'caja',25,'Caja sellada de 20 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Rehidratado' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',2,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Adjuntos' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','litros'),'otros',12,'Galon de Agua',(select cp_id from catalogo_proveedor_mp where cp_nombre='Agua' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1/2','litro'),'otros',6,'Cultivo Liquido',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('6','gr'),'sachet',1,'Sachets Liofilizados',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='House' and rownum=1) and rownum=1));



insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pilsner' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Lager' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta De Trigo' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pale' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Crystal' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Amber' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Chocolate' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Negra' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Cebada Tostada' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1','kg'),'bolsa',2,'Bolsa de 1 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Seco' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',5,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Plug' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','kg'),'caja',25,'Caja sellada de 20 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Rehidratado' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',2,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Adjuntos' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','litros'),'otros',12,'Galon de Agua',(select cp_id from catalogo_proveedor_mp where cp_nombre='Agua' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1/2','litro'),'otros',6,'Cultivo Liquido',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('6','gr'),'sachet',1,'Sachets Liofilizados',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('500','gr'),'otros',4,'Empaque de 500 gramos',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Kirby' and rownum=1) and rownum=1));



insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pilsner' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Lager' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta De Trigo' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pale' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Crystal' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Amber' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Chocolate' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Negra' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Cebada Tostada' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1','kg'),'bolsa',2,'Bolsa de 1 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Seco' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',5,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Plug' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','kg'),'caja',25,'Caja sellada de 20 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Rehidratado' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',2,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Adjuntos' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','litros'),'otros',12,'Galon de Agua',(select cp_id from catalogo_proveedor_mp where cp_nombre='Agua' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1/2','litro'),'otros',6,'Cultivo Liquido',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('6','gr'),'sachet',1,'Sachets Liofilizados',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('500','gr'),'otros',4,'Empaque de 500 gramos',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Hayden' and rownum=1) and rownum=1));



insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pilsner' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Lager' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta De Trigo' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Pale' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Crystal' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Amber' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Chocolate' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Malta Negra' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('50','kg'),'saco',20,'Saco Sellado de 50 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Cebada Tostada' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1','kg'),'bolsa',2,'Bolsa de 1 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Seco' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',5,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Plug' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','kg'),'caja',25,'Caja sellada de 20 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Lupulo Rehidratado' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('5','kg'),'bolsa',2,'Bolsa de 5 kg',(select cp_id from catalogo_proveedor_mp where cp_nombre='Adjuntos' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('20','litros'),'otros',12,'Galon de Agua',(select cp_id from catalogo_proveedor_mp where cp_nombre='Agua' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('1/2','litro'),'otros',6,'Cultivo Liquido',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('6','gr'),'sachet',1,'Sachets Liofilizados',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));
insert into presentacion (pre_id,pre_medida,pre_tipo,pre_preciou,pre_descripcion,cp_id) values (seq_pre_id.NEXTVAL,medida('500','gr'),'otros',4,'Empaque de 500 gramos',(select cp_id from catalogo_proveedor_mp where cp_nombre='Levadura' and pr_id=(select pr_id from proveedores where pr_nombre='Roy' and rownum=1) and rownum=1));





-----DETALLE PEDIDO

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,(Select p.pe_id from pedido p, contrato c, proveedores pr, empresa e where c.con_numero= p.con_numero and pr.pr_nombre ='Fields' and to_char(p.pe_fechapedido,'yyyy')='2016' and e.em_nombre='Carlsberg group' and p.PE_STATUS='finalizada' and rownum=1 ),(Select p.pre_id from presentacion p, catalogo_proveedor_mp m, materia_prima mp, proveedores pr where mp.mp_id=m.mp_id and m.cp_id=p.cp_id and m.pr_id = pr.pr_id and pr.pr_nombre='Fields' and mp.mp_nombre='Levadura' and rownum =1),6000,null,(Select pr_id from proveedores where pr_nombre = 'Fields'));
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,(Select p.pe_id from pedido p, contrato c, proveedores pr, empresa e where c.con_numero= p.con_numero and pr.pr_nombre ='Fields' and to_char(p.pe_fechapedido,'yyyy')='2016' and e.em_nombre='Carlsberg group' and p.PE_STATUS='finalizada' and rownum=1 ),(Select p.pre_id from presentacion p, catalogo_proveedor_mp m, materia_prima mp, proveedores pr where mp.mp_id=m.mp_id and m.cp_id=p.cp_id and m.pr_id = pr.pr_id and pr.pr_nombre='Fields' and mp.mp_nombre='Agua' and rownum =1),6000,null,(Select pr_id from proveedores where pr_nombre = 'Fields'));
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,(Select p.pe_id from pedido p, contrato c, proveedores pr, empresa e where c.con_numero= p.con_numero and pr.pr_nombre ='Fields' and to_char(p.pe_fechapedido,'yyyy')='2016' and e.em_nombre='Carlsberg group' and p.PE_STATUS='finalizada' and rownum=1 ),(Select p.pre_id from presentacion p, catalogo_proveedor_mp m, materia_prima mp, proveedores pr where mp.mp_id=m.mp_id and m.cp_id=p.cp_id and m.pr_id = pr.pr_id and pr.pr_nombre='Fields' and mp.mp_nombre='Adjuntos (Grits)' and rownum =1),6000,null,(Select pr_id from proveedores where pr_nombre = 'Fields'));
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,(Select p.pe_id from pedido p, contrato c, proveedores pr, empresa e where c.con_numero= p.con_numero and pr.pr_nombre ='Fields' and to_char(p.pe_fechapedido,'yyyy')='2016' and e.em_nombre='Carlsberg group' and p.PE_STATUS='finalizada' and rownum=1 ),(Select p.pre_id from presentacion p, catalogo_proveedor_mp m, materia_prima mp, proveedores pr where mp.mp_id=m.mp_id and m.cp_id=p.cp_id and m.pr_id = pr.pr_id and pr.pr_nombre='Fields' and mp.mp_nombre='Lupulo' and rownum =1),6000,null,(Select pr_id from proveedores where pr_nombre = 'Fields'));
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,(Select p.pe_id from pedido p, contrato c, proveedores pr, empresa e where c.con_numero= p.con_numero and pr.pr_nombre ='Fields' and to_char(p.pe_fechapedido,'yyyy')='2016' and e.em_nombre='Carlsberg group' and p.PE_STATUS='finalizada' and rownum=1 ),(Select p.pre_id from presentacion p, catalogo_proveedor_mp m, materia_prima mp, proveedores pr where mp.mp_id=m.mp_id and m.cp_id=p.cp_id and m.pr_id = pr.pr_id and pr.pr_nombre='Fields' and mp.mp_nombre='Lupulo Rehidratado' and rownum =1),600,null,(Select pr_id from proveedores where pr_nombre = 'Fields'));
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,(Select p.pe_id from pedido p, contrato c, proveedores pr, empresa e where c.con_numero= p.con_numero and pr.pr_nombre ='Fields' and to_char(p.pe_fechapedido,'yyyy')='2016' and e.em_nombre='Carlsberg group' and p.PE_STATUS='finalizada' and rownum=1 ),(Select p.pre_id from presentacion p, catalogo_proveedor_mp m, materia_prima mp, proveedores pr where mp.mp_id=m.mp_id and m.cp_id=p.cp_id and m.pr_id = pr.pr_id and pr.pr_nombre='Fields' and mp.mp_nombre='Lupulo Plug' and rownum =1),9000,null,(Select pr_id from proveedores where pr_nombre = 'Fields'));
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,(Select p.pe_id from pedido p, contrato c, proveedores pr, empresa e where c.con_numero= p.con_numero and pr.pr_nombre ='Fields' and to_char(p.pe_fechapedido,'yyyy')='2016' and e.em_nombre='Carlsberg group' and p.PE_STATUS='finalizada' and rownum=1 ),(Select p.pre_id from presentacion p, catalogo_proveedor_mp m, materia_prima mp, proveedores pr where mp.mp_id=m.mp_id and m.cp_id=p.cp_id and m.pr_id = pr.pr_id and pr.pr_nombre='Fields' and mp.mp_nombre='Lupulo Rehidratado' and rownum =1),600,null,(Select pr_id from proveedores where pr_nombre = 'Roy'));


INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,(Select p.pe_id from pedido p, contrato c, proveedores pr, empresa e where c.con_numero= p.con_numero and pr.pr_nombre ='Fields' and to_char(p.pe_fechapedido,'yyyy')='2016' and e.em_nombre='Joshua tetley y Son Ltd' and p.PE_STATUS='finalizada' and rownum=1 ),(Select p.pre_id from presentacion p, catalogo_proveedor_mp m, materia_prima mp, proveedores pr where mp.mp_id=m.mp_id and m.cp_id=p.cp_id and m.pr_id = pr.pr_id and pr.pr_nombre='Fields' and mp.mp_nombre='Levadura' and rownum =1),400,null,(Select pr_id from proveedores where pr_nombre = 'Fields'));
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,(Select p.pe_id from pedido p, contrato c, proveedores pr, empresa e where c.con_numero= p.con_numero and pr.pr_nombre ='Fields' and to_char(p.pe_fechapedido,'yyyy')='2016' and e.em_nombre='Joshua tetley y Son Ltd' and p.PE_STATUS='finalizada' and rownum=1 ),(Select p.pre_id from presentacion p, catalogo_proveedor_mp m, materia_prima mp, proveedores pr where mp.mp_id=m.mp_id and m.cp_id=p.cp_id and m.pr_id = pr.pr_id and pr.pr_nombre='Fields' and mp.mp_nombre='Agua' and rownum =1),600,null,(Select pr_id from proveedores where pr_nombre = 'Fields'));
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,(Select p.pe_id from pedido p, contrato c, proveedores pr, empresa e where c.con_numero= p.con_numero and pr.pr_nombre ='Fields' and to_char(p.pe_fechapedido,'yyyy')='2016' and e.em_nombre='Joshua tetley y Son Ltd' and p.PE_STATUS='finalizada' and rownum=1 ),(Select p.pre_id from presentacion p, catalogo_proveedor_mp m, materia_prima mp, proveedores pr where mp.mp_id=m.mp_id and m.cp_id=p.cp_id and m.pr_id = pr.pr_id and pr.pr_nombre='Fields' and mp.mp_nombre='Adjuntos (Grits)' and rownum =1),1000,null,(Select pr_id from proveedores where pr_nombre = 'Fields'));
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,(Select p.pe_id from pedido p, contrato c, proveedores pr, empresa e where c.con_numero= p.con_numero and pr.pr_nombre ='Fields' and to_char(p.pe_fechapedido,'yyyy')='2016' and e.em_nombre='Joshua tetley y Son Ltd' and p.PE_STATUS='finalizada' and rownum=1 ),(Select p.pre_id from presentacion p, catalogo_proveedor_mp m, materia_prima mp, proveedores pr where mp.mp_id=m.mp_id and m.cp_id=p.cp_id and m.pr_id = pr.pr_id and pr.pr_nombre='Fields' and mp.mp_nombre='Lupulo' and rownum =1),3000,null,(Select pr_id from proveedores where pr_nombre = 'Fields'));
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,(Select p.pe_id from pedido p, contrato c, proveedores pr, empresa e where c.con_numero= p.con_numero and pr.pr_nombre ='Fields' and to_char(p.pe_fechapedido,'yyyy')='2016' and e.em_nombre='Joshua tetley y Son Ltd' and p.PE_STATUS='finalizada' and rownum=1 ),(Select p.pre_id from presentacion p, catalogo_proveedor_mp m, materia_prima mp, proveedores pr where mp.mp_id=m.mp_id and m.cp_id=p.cp_id and m.pr_id = pr.pr_id and pr.pr_nombre='Fields' and mp.mp_nombre='Lupulo Rehidratado' and rownum =1),200,null,(Select pr_id from proveedores where pr_nombre = 'Fields'));
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,(Select p.pe_id from pedido p, contrato c, proveedores pr, empresa e where c.con_numero= p.con_numero and pr.pr_nombre ='Fields' and to_char(p.pe_fechapedido,'yyyy')='2016' and e.em_nombre='Joshua tetley y Son Ltd' and p.PE_STATUS='finalizada' and rownum=1 ),(Select p.pre_id from presentacion p, catalogo_proveedor_mp m, materia_prima mp, proveedores pr where mp.mp_id=m.mp_id and m.cp_id=p.cp_id and m.pr_id = pr.pr_id and pr.pr_nombre='Fields' and mp.mp_nombre='Lupulo Plug' and rownum =1),90,null,(Select pr_id from proveedores where pr_nombre = 'Fields'));
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,(Select p.pe_id from pedido p, contrato c, proveedores pr, empresa e where c.con_numero= p.con_numero and pr.pr_nombre ='Fields' and to_char(p.pe_fechapedido,'yyyy')='2016' and e.em_nombre='Joshua tetley y Son Ltd' and p.PE_STATUS='finalizada' and rownum=1 ),(Select p.pre_id from presentacion p, catalogo_proveedor_mp m, materia_prima mp, proveedores pr where mp.mp_id=m.mp_id and m.cp_id=p.cp_id and m.pr_id = pr.pr_id and pr.pr_nombre='Fields' and mp.mp_nombre='Lupulo Rehidratado' and rownum =1),200,null,(Select pr_id from proveedores where pr_nombre = 'Roy'));

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,
(SELECT pe_id FROM(SELECT pe_id FROM pedido where pe_tipo='materia prima' ORDER BY dbms_random.value )WHERE rownum = 1),
(SELECT pre_id FROM(SELECT pre_id FROM presentacion ORDER BY dbms_random.value )WHERE rownum = 1),20,null,null);

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,
(SELECT pe_id FROM(SELECT pe_id FROM pedido where pe_tipo='materia prima' ORDER BY dbms_random.value )WHERE rownum = 1),
(SELECT pre_id FROM(SELECT pre_id FROM presentacion ORDER BY dbms_random.value )WHERE rownum = 1),10,null,null);

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,
(SELECT pe_id FROM(SELECT pe_id FROM pedido where pe_tipo='materia prima' ORDER BY dbms_random.value )WHERE rownum = 1),
(SELECT pre_id FROM(SELECT pre_id FROM presentacion ORDER BY dbms_random.value )WHERE rownum = 1),60,null,null);

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,
(SELECT pe_id FROM(SELECT pe_id FROM pedido where pe_tipo='materia prima' ORDER BY dbms_random.value )WHERE rownum = 1),
(SELECT pre_id FROM(SELECT pre_id FROM presentacion ORDER BY dbms_random.value )WHERE rownum = 1),80,null,null);

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,
(SELECT pe_id FROM(SELECT pe_id FROM pedido where pe_tipo='materia prima' ORDER BY dbms_random.value )WHERE rownum = 1),
(SELECT pre_id FROM(SELECT pre_id FROM presentacion ORDER BY dbms_random.value )WHERE rownum = 1),60,null,null);

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,
(SELECT pe_id FROM(SELECT pe_id FROM pedido where pe_tipo='materia prima' ORDER BY dbms_random.value )WHERE rownum = 1),
(SELECT pre_id FROM(SELECT pre_id FROM presentacion ORDER BY dbms_random.value )WHERE rownum = 1),20,null,null);

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,
(SELECT pe_id FROM(SELECT pe_id FROM pedido where pe_tipo='materia prima' ORDER BY dbms_random.value )WHERE rownum = 1),
(SELECT pre_id FROM(SELECT pre_id FROM presentacion ORDER BY dbms_random.value )WHERE rownum = 1),10,null,null);

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,
(SELECT pe_id FROM(SELECT pe_id FROM pedido where pe_tipo='materia prima' ORDER BY dbms_random.value )WHERE rownum = 1),
(SELECT pre_id FROM(SELECT pre_id FROM presentacion ORDER BY dbms_random.value )WHERE rownum = 1),60,null,null);

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,
(SELECT pe_id FROM(SELECT pe_id FROM pedido where pe_tipo='materia prima' ORDER BY dbms_random.value )WHERE rownum = 1),
(SELECT pre_id FROM(SELECT pre_id FROM presentacion ORDER BY dbms_random.value )WHERE rownum = 1),80,null,null);

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,
(SELECT pe_id FROM(SELECT pe_id FROM pedido where pe_tipo='materia prima' ORDER BY dbms_random.value )WHERE rownum = 1),
(SELECT pre_id FROM(SELECT pre_id FROM presentacion ORDER BY dbms_random.value )WHERE rownum = 1),60,null,null);


INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,
(SELECT pe_id FROM(SELECT pe_id FROM pedido where pe_tipo='materia prima' ORDER BY dbms_random.value )WHERE rownum = 1),
(SELECT pre_id FROM(SELECT pre_id FROM presentacion ORDER BY dbms_random.value )WHERE rownum = 1),20,null,null);

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,
(SELECT pe_id FROM(SELECT pe_id FROM pedido where pe_tipo='materia prima' ORDER BY dbms_random.value )WHERE rownum = 1),
(SELECT pre_id FROM(SELECT pre_id FROM presentacion ORDER BY dbms_random.value )WHERE rownum = 1),10,null,null);

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,
(SELECT pe_id FROM(SELECT pe_id FROM pedido where pe_tipo='materia prima' ORDER BY dbms_random.value )WHERE rownum = 1),
(SELECT pre_id FROM(SELECT pre_id FROM presentacion ORDER BY dbms_random.value )WHERE rownum = 1),60,null,null);

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,
(SELECT pe_id FROM(SELECT pe_id FROM pedido where pe_tipo='materia prima' ORDER BY dbms_random.value )WHERE rownum = 1),
(SELECT pre_id FROM(SELECT pre_id FROM presentacion ORDER BY dbms_random.value )WHERE rownum = 1),80,null,null);

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,
(SELECT pe_id FROM(SELECT pe_id FROM pedido where pe_tipo='materia prima' ORDER BY dbms_random.value )WHERE rownum = 1),
(SELECT pre_id FROM(SELECT pre_id FROM presentacion ORDER BY dbms_random.value )WHERE rownum = 1),60,null,null);

INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,8,23,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,8,25,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,8,27,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,8,29,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,8,31,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,9,33,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,9,12,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,9,14,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,9,16,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,9,18,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,10,20,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,10,22,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,10,24,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,10,26,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,10,28,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,11,30,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,11,32,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,11,6,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,11,8,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,11,10,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,12,12,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,12,14,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,12,16,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,12,18,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,12,20,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,13,22,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,13,24,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,13,26,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,13,28,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,13,30,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,14,32,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,14,42,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,14,46,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,14,50,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,14,54,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,15,58,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,15,62,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,15,64,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,15,68,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,15,72,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,16,76,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,16,85,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,16,46,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,16,65,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,16,15,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,17,56,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,17,84,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,17,56,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,17,56,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,17,26,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,18,23,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,18,56,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,18,45,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,18,23,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,18,12,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,19,19,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,19,89,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,19,98,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,19,87,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,19,65,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,20,54,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,20,32,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,20,21,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,20,53,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,20,75,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,21,42,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,21,86,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,21,23,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,21,20,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,21,30,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,22,40,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,22,50,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,22,60,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,22,70,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,22,10,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,23,11,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,23,22,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,23,33,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,23,44,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,23,45,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,24,55,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,24,66,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,24,77,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,24,88,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,24,12,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,8,64,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,9,31,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,10,13,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,11,79,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,12,46,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,13,19,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,14,18,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,15,17,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,16,23,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,17,66,6000,null,2);
INSERT INTO detalle_pedido (det_id,pe_id,pre_id,det_cantidad,ca_codigo,pr_id) VALUES (seq_det_id.NEXTVAL,18,69,6000,null,2);


-----DESCUENTO PARA PRODUCCION

insert into descuentopedidioparaproduccion (des_id,pro_fecha,fa_id,em_id,pc_id,ce_id,det_id,pe_id,des_cantidad) values ((seq_des_pred_id.NEXTVAL),(select pm.pro_fecha from produccionmensual pm, fabrica f, empresa e, presentacion_cerveza pc, cerveza c where pm.fa_id=f.fa_id and f.fa_nombre='Tuborg' and e.em_id=f.em_id and e.em_nombre='Carlsberg group' and c.ce_id=pm.ce_id and c.ce_nombreingles='Tuborg' and pc.ce_id=c.ce_id and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select fa_id from fabrica where fa_nombre='Tuborg' and rownum=1),(select em_id from empresa where em_nombre ='Carlsberg group'),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg' and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),(Select dp.det_id from detalle_pedido dp, presentacion p, catalogo_proveedor_mp cp, pedido pe, materia_prima mp where mp.mp_id=cp.mp_id and cp.cp_id=p.cp_id and p.pre_id=dp.pre_id and dp.pe_id = pe.pe_id and upper(mp.mp_nombre)=upper('levadura') and rownum = 1),(Select pe.pe_id from detalle_pedido dp, presentacion p, catalogo_proveedor_mp cp, pedido pe, materia_prima mp where mp.mp_id=cp.mp_id and cp.cp_id=p.cp_id and p.pre_id=dp.pre_id and dp.pe_id = pe.pe_id and upper(mp.mp_nombre)=upper('levadura') and rownum = 1),507);

insert into descuentopedidioparaproduccion (des_id,pro_fecha,fa_id,em_id,pc_id,ce_id,det_id,pe_id,des_cantidad) values ((seq_des_pred_id.NEXTVAL),(select pm.pro_fecha from produccionmensual pm, fabrica f, empresa e, presentacion_cerveza pc, cerveza c where pm.fa_id=f.fa_id and f.fa_nombre='Tuborg' and e.em_id=f.em_id and e.em_nombre='Carlsberg group' and c.ce_id=pm.ce_id and c.ce_nombreingles='Tuborg' and pc.ce_id=c.ce_id and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select fa_id from fabrica where fa_nombre='Tuborg' and rownum=1),(select em_id from empresa where em_nombre ='Carlsberg group'),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg' and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),(Select dp.det_id from detalle_pedido dp, presentacion p, catalogo_proveedor_mp cp, pedido pe, materia_prima mp where mp.mp_id=cp.mp_id and cp.cp_id=p.cp_id and p.pre_id=dp.pre_id and dp.pe_id = pe.pe_id and upper(mp.mp_nombre)=upper('Agua') and rownum = 1),(Select pe.pe_id from detalle_pedido dp, presentacion p, catalogo_proveedor_mp cp, pedido pe, materia_prima mp where mp.mp_id=cp.mp_id and cp.cp_id=p.cp_id and p.pre_id=dp.pre_id and dp.pe_id = pe.pe_id and upper(mp.mp_nombre)=upper('Agua') and rownum = 1),5600);

insert into descuentopedidioparaproduccion (des_id,pro_fecha,fa_id,em_id,pc_id,ce_id,det_id,pe_id,des_cantidad) values ((seq_des_pred_id.NEXTVAL),(select pm.pro_fecha from produccionmensual pm, fabrica f, empresa e, presentacion_cerveza pc, cerveza c where pm.fa_id=f.fa_id and f.fa_nombre='Tuborg' and e.em_id=f.em_id and e.em_nombre='Carlsberg group' and c.ce_id=pm.ce_id and c.ce_nombreingles='Tuborg' and pc.ce_id=c.ce_id and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select fa_id from fabrica where fa_nombre='Tuborg' and rownum=1),(select em_id from empresa where em_nombre ='Carlsberg group'),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg' and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),(Select dp.det_id from detalle_pedido dp, presentacion p, catalogo_proveedor_mp cp, pedido pe, materia_prima mp where mp.mp_id=cp.mp_id and cp.cp_id=p.cp_id and p.pre_id=dp.pre_id and dp.pe_id = pe.pe_id and upper(mp.mp_nombre)=upper('Adjuntos (Grits)') and rownum = 1),(Select pe.pe_id from detalle_pedido dp, presentacion p, catalogo_proveedor_mp cp, pedido pe, materia_prima mp where mp.mp_id=cp.mp_id and cp.cp_id=p.cp_id and p.pre_id=dp.pre_id and dp.pe_id = pe.pe_id and upper(mp.mp_nombre)=upper('Adjuntos (Grits)') and rownum = 1),50);

insert into descuentopedidioparaproduccion (des_id,pro_fecha,fa_id,em_id,pc_id,ce_id,det_id,pe_id,des_cantidad) values ((seq_des_pred_id.NEXTVAL),(select pm.pro_fecha from produccionmensual pm, fabrica f, empresa e, presentacion_cerveza pc, cerveza c where pm.fa_id=f.fa_id and f.fa_nombre='Tuborg' and e.em_id=f.em_id and e.em_nombre='Carlsberg group' and c.ce_id=pm.ce_id and c.ce_nombreingles='Tuborg' and pc.ce_id=c.ce_id and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select fa_id from fabrica where fa_nombre='Tuborg' and rownum=1),(select em_id from empresa where em_nombre ='Carlsberg group'),(select pc.pc_id from presentacion_cerveza pc, cerveza ce where pc.ce_id=ce.ce_id and ce.ce_nombreingles='Tuborg' and pc.pc_tipo='botella' and pc.pc_cantidad=660 and rownum=1),(select ce_id from cerveza where ce_nombreingles='Tuborg' and rownum=1),(Select dp.det_id from detalle_pedido dp, presentacion p, catalogo_proveedor_mp cp, pedido pe, materia_prima mp where mp.mp_id=cp.mp_id and cp.cp_id=p.cp_id and p.pre_id=dp.pre_id and dp.pe_id = pe.pe_id and upper(mp.mp_nombre)=upper('Lupulo') and rownum = 1),(Select pe.pe_id from detalle_pedido dp, presentacion p, catalogo_proveedor_mp cp, pedido pe, materia_prima mp where mp.mp_id=cp.mp_id and cp.cp_id=p.cp_id and p.pre_id=dp.pre_id and dp.pe_id = pe.pe_id and upper(mp.mp_nombre)=upper('Lupulo') and rownum = 1),500);




