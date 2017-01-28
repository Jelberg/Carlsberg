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

--select cantidad_producible from FALSE_TAB_RECETA where cantidad_producible <> null and rownum = 1;-- para cuando no se consiga el producto (No funciona)

	select cantidad_producible into menorValor from FALSE_TAB_RECETA where rownum=1 order by cantidad_producible desc ;

	select fa_id into idFabrica from fabrica where fa_nombre=fabrica;

	select em_id into idEmpresa from empresa where em_id=(select em_id from fabrica where fa_nombre=fabrica);

	select ce_id into idCerveza from cerveza where ce_nombreingles=cerveza and rownum=1;

	select pc_cantidad into mlbotella from presentacion_cerveza where pc_id=presentacionCerveza;

	producible:=mlbotella*menorValor;

	insert into produccionmensual (pro_fecha,fa_id,em_id,pc_id,ce_id,pro_cantidadenml) values(fecha,idFabrica ,idEmpresa,presentacionCerveza,idCerveza,producible);

delete from false_tab_receta;  -- no se si conviene borrarlo antes de llenar descuentopedidoparaproduccion
end AutoProduccionMensual;





















