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

create or replace procedure pr_llena_cantidad_producible(empresa empresa.em_nombre%type) is

cursor inventario is 
select (sum(dp.det_cantidad)- sum(des.des_cantidad)) cantidas_inventario, m.MP_NOMBRE as nombre_inv
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
group by  m.MP_NOMBRE;

cursor receta is 
select nombre_mp as nombre_rec, cantidad_ml as cant_rec
from false_tab_receta;

registro_1 receta%rowtype;
registro_2 inventario%rowtype;

producible number(10,2):=0;

min_valor number (7);
max_valor number (7);

cont_num number(7);

valor_nombre varchar2(7);
valor_ml   number(7);
begin 	

select false_id into min_valor from false_tab_receta where rownum=1 order by false_id;
select false_id into max_valor from false_tab_receta where rownum=1 order by false_id desc;

cont_num:= min_valor;

while (cont_num <= max_valor) loop 
 open inventario;
     loop
       fetch inventario into registro_2;
              select nombre_mp, cantidad_ml into valor_nombre, valor_ml from false_tab_receta where false_id = cont_num; 
              DBMS_OUTPUT.PUT_LINE(valor_ml);
              DBMS_OUTPUT.PUT_LINE(valor_nombre);
					    if registro_2.nombre_inv = valor_nombre then 
                    producible := (registro_2.cantidas_inventario/valor_ml);
                   -- DBMS_OUTPUT.PUT_LINE(producible);
                      if (producible > 0) then 
                     --DBMS_OUTPUT.PUT_LINE('Si produce');
                        	update false_tab_receta set cantidad_producible = producible 
                        	where upper(nombre_mp) = upper(valor_nombre) ;
                          producible:=0;
                      end if;
                end if;
                exit when inventario%NOTFOUND;
			  end loop;
      cont_num:= cont_num+1;
end loop;
close inventario;
END;


/



create or replace procedure pr_llena_cantidad_producible(empresa empresa.em_nombre%type) is

cursor inventario is 
select (sum(dp.det_cantidad)- sum(des.des_cantidad)) cantidas_inventario, m.MP_NOMBRE as nombre
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
group by  m.MP_NOMBRE;

nombre varchar2(50);
cantidad number(10,2);

cursor receta is 
select nombre_mp, cantidad_ml from false_tab_receta;

rec_nombre varchar2(50);
rec_cantidad number(10,2);

registro_1 receta%rowtype;
registro_2 inventario%rowtype;

producible number(10,2):=0;

begin 	
		for registro_1 in receta loop
			for registro_2 in inventario loop
					if registro_2.nombre = registro_1.nombre_mp then 
						producible := (registro_2.cantidas_inventario/registro_1.cantidad_ml);
						if (producible > 0) then 
							update false_tab_receta set cantidad_producible = round(producible,0) 
							where registro_1.nombre_mp = registro_2.nombre and registro_1.cantidad_ml=registro_2.cantidas_inventario;
						end if;
					end if;
			end loop;
	    end loop;
end;























