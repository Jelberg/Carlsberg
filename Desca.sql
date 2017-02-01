jdbc:oracle:thin:@//localhost:1521/XE
create table pais_dist (
	id_pais number(7),
	pais_dist varchar2(300) not null,
	fecha_carga_dist date not null,
	constraint pk_pais_dist primary key (id_pais)
);
create table tiempo_dist (
	año date not null,
	fecha_carga date,
	constraint pk_tiempo_dist primary key (fecha_carga)
);
create table estilo_dist (
	id_estilo number(7),
	nombre_dist varchar2(300) not null,
	fecha_carga_dist date not null,
	constraint pk_estilo_dist primary key (id_estilo)
);
create table cervesa_dist (
	id_cerveza number(7),
	nombre_dist varchar2(300) not null,
	fecha_carga_dist date not null,
	constraint pk_cerveza_dist primary key (id_cerveza)
);




create table cerveza_p (
	id_cerveza number(7),
	cerveza_p varchar2(300) not null,
	presentacion_p varchar2(300) not null,
	fecha_carga_p date not null, 
	constraint pk_cerveza_p primary key (id_cerveza)
);
create table empresa_p (
	id_empresa number(7),
	empresa_p varchar2(300) not null,
	fecha_carga_p date not null,
	constraint pk_empresa_p primary key (id_empresa)
);
create table tiempo_p (
	mensual date not null,
	año date not null,
	fecha_carga date,
	constraint pk_tiempo_p primary key (fecha_carga)
);
create table estilo_p (
	id_estilo number(7),
	estilo_p varchar2(300) not null,
	fecha_carga_p date not null,
	constraint pk_estilo_p primary key (id_estilo)
);
create table fabrica_p (
	id_fabrica number(7),
	fabrica varchar2(300) not null,
	fecha_carga_p date not null,
	constraint pk_fabrica_p primary key (id_fabrica)
);
select distinct c.ce_id,c.ce_nombreingles,(p.pc_tipo||' de '||p.pc_cantidad||'ml')as presentacion,sysdate
from CERVEZEROS.CERVEZA c, CERVEZEROS.PRESENTACION_CERVEZA p
where c.ce_id=p.ce_id
order by c.ce_id

select e.em_id,e.em_nombre, sysdate
from CERVEZEROS.EMPRESA e

select e.es_id,e.es_nombre,sysdate
from CERVEZEROS.ESTILO e

select f.fa_id, f.fa_nombre,sysdate
from CERVEZEROS.FABRICA f





create table proveedor_ef (
	id_proveedor number(7),
	proveedor_ef varchar2(300) not null,
	fecha_carga_ef date not null,
	constraint pk_proveedor_ef primary key (id_proveedor)
);
create table tiempo_ef (
	año date not null,
	fecha_carga date,
	constraint pk_tiempo_ef priamry key (fecha_carga)
);

select p.pr_id,p.pr_nombre,sysdate
from CERVEZEROS.PROVEEDORES p

