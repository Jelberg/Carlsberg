alter table PAIS
   add constraint CHK_CONTINENTE check (PA_CONTINENTE in ('Africa','Asia','Antartida','Europa','Norteamerica','Oceania','Sudamerica'));

alter table CIUDAD
   add constraint FK_PAIS foreign key (PA_ID)
     references PAIS (PA_ID);
	 
alter table DISTRIBUCION
   add constraint FK_PAIS foreign key (PA_ID)
      references PAIS(PA_ID);

alter table DISTRIBUCION
   add constraint CHK_PRESENTACION check (DIS_PRESENTACION in ('botella','botella retornable','lata','sifon'));

   alter table PROVEEDORES
   add constraint FK_PAIS foreign key (PA_ID)
   references PAIS(PA_ID);
   
alter table ENVIOS
   add constraint FK_PROVEEDOR foreign key (PR_ID)
   references PROVEEDORES(PR_ID);

alter table ENVIOS
   add constraint FK_CIUDAD foreign key (CI_ID)
   references CIUDAD(CI_ID);
   
alter table EMPRESA
   add constraint FK_CIUDAD_UBICACION foreign key (CI_ID)
   references CIUDAD(CI_ID);

alter table EMPRESA
   add constraint FK_CIUDAD_PRINCIPAL foreign key (CIU_CI_ID)
   references CIUDAD(CI_ID);

alter table EMPRESA
   add constraint FK_DUEÑO foreign key (EMP_EM_ID)
   references EMPRESA(EMP_EM_ID);
   
alter table FABRICA
   add constraint FK_EMPRESA foreign key (EM_ID)
   references EMPRESA(EM_ID);

alter table FABRICA
   add constraint FK_CIUDAD foreign key (CI_ID)
   references CIUDAD(CI_ID);

alter table CONTRATO
   add constraint FK_EMPRESA foreign key (EM_ID)
   references EMPRESA(EM_ID);

alter table CONTRATO
   add constraint FK_PROVEEDOR foreign key (PR_ID)
   references PROVEEDORES(PR_ID);
   
alter table CATALOGO_PROVEEDOR_EQ
   add constraint FK_PROVEEDOR foreign key (PR_ID)
   references PROVEEDORES(PR_ID);

alter table CATALOGO_PROVEEDOR_EQ
   add constraint FK_MAQUINARIA foreign key (MA_ID)
   references MAQUINARIA(MA_ID);
   
alter table MATERIA_PRIMA
   add constraint CHK_FORMASDISLUPULO check (MP_FORMASDISLUPULO in ('seco','plug','rehidratado'));

alter table VARIEDAD
   add constraint FK_MATERIAPRIMA foreign key (MP_ID)
   references MATERIA_PRIMA(MP_ID);
   
alter table V_C
   add constraint FK_VARIEDAD foreign key (VAR_ID)
   references VARIEDAD(VAR_ID);

alter table V_C
   add constraint FK_PAIS foreign key (PA_ID)
   references  PAIS(PA_ID);
   
   
alter table CATALOGO_PROVEEDOR_MP
   add constraint FK_MATERIAPRIMA foreign key (MP_ID)
   references MATERIA_PRIMA(MP_ID);

alter table CATALOGO_PROVEEDOR_MP
   add constraint FK_PROVEEDOR foreign key (PR_ID)
   references PROVEEDORES(PR_ID);

alter table CATALOGO_PROVEEDOR_MP
   add constraint FK_VARIEDAD foreign key (VAR_ID)
   references VARIEDAD(VAR_ID);

alter table PEDIDO
   add constraint CHK_STATUS check (PE_STATUS in ('en proceso','cancelada','rechazada por proveedor','finalizada'));

alter table PEDIDO
   add constraint CHK_TIPO check (PE_TIPO IN ('materia prima','equipo'));

alter table PEDIDO
   add constraint FK_CONTRATO foreign key (CON_NUMERO)
   references CONTRATO(CON_NUMERO);
   
alter table PAGO
   add constraint FK_PEDIDO foreign key (PE_ID)
   references PEDIDO(PE_ID);

alter table PAGO
   add constraint CHK_TIPOPAGO check (PA_TIPOPAGO in ('efectivo','transferencia','deposito','cheque'));

alter table ESTILO
   add constraint CHK_TEMPORADA check (ES_NOMBRETEMPORADA in ('navidad','pascua','halloween','otra'))

alter table CERVEZA
   add constraint FK_ESTILO foreign key (ES_ID)
   references ESTILO(ES_ID);

alter table CERVEZA
   add constraint CHK_PORCENTAJEALC check (CE_PORCETAJEALC between 0 and 100);

alter table PRESENTACION_CERVEZA
   add constraint FK_CERVEZA foreign key (CE_ID)
   references CERVEZA(CE_ID);
   
alter table COMPOSICION
   add constraint FK_CERVEZA foreign key (CE_ID)
   references CERVEZA(CE_ID);

alter table COMPOSICION
   add constraint CHK_PROPORCION check (C_PROPORCION between 1 and 100);

alter table COMPOSICION
   add constraint FK_VARIABLE foreign key (VAR_ID)
   references VARIEDAD(VAR_ID);

alter table MATERIA_PRIMA
   add constraint FK_MATERIAPRIMA foreign key (MP_ID)     -- PORQUE??
   references MATERIA_PRIMA(MA_ID);
   
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
   
alter table PRESENTACION
   add constraint FK_CATALOGO_PROVEEDOR_MP foreign key (CP_ID)
   references CATALOGO_PROVEEDOR_MP(CP_ID);
   
alter table DETALLE_PEDIDO
   add constraint FK_CATALOGO_PROVEEDOR_EQ foreign key (CA_CODIGO)  -- EQUIPO
   references CATALOGO_PROVEEDOR_EQ(CA_CODIGO);

alter table DETALLE_PEDIDO
   add constraint FK_PEDIDO foreign key (PE_ID)
   references PEDIDO(PE_ID);

alter table DETALLE_PEDIDO
   add constraint FK_PRESENTACION foreign key (PRE_ID)    -- MATERI PRIMA
   references PRESENTACION(PRE_ID);
   
alter table VALORACION_PEDIDO
   add constraint FK_DETALLE_PEDIDO foreign key (DET_ID)
   refernces DETALLE_PEDIDO(DET_ID);

alter table VALORACION_PEDIDO
   add constraint FK_DETALLE_PEDIDO2 foreign key (PE_ID)
   references DETALLE_PEDIDO(PE_ID);
   
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

	  
	  