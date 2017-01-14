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


-------------------PROCEDURE

create or replace procedure PR_resultado_evaluacion_pc(id_empresa empresa.em_id%type) is --Proveedores conocidos

resultado_1 number;
resultado_2 number;
resultado_3 number;
resultado_4 number;
resultado_5 number;
resultado_6 number;

position number :=0;

cursor proveedores_conocidos is 
Select distinct p.pr_id from proveedores p, contrato c where p.pr_id = c.pr_id; 

REGISTRO number;
begin

	OPEN proveedores_conocidos;

	LOOP
		FETCH proveedores_conocidos into REGISTRO;

		resultado_1 := fn_resultado_rubro_1(REGISTRO,id_empresa);
                              -- solo ocurre una vez este if
		if fn_nested_evaluacion_vacio(REGISTRO) = 0 THEN 
			insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_1,null,id_empresa,'1');
		ELSE 
			UPDATE PROVEEDORES SET PR_RESULTADOEVALUACION = RESULTADOEVALUACION_NT(RESULTADOEVALUACION(SYSDATE,resultado_1,NULL,id_empresa,'1')) WHERE PR_ID = REGISTRO; 
		END IF;
		
		resultado_2:= fn_resultado_rubro_2(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_2,null,id_empresa,'2');
		
		resultado_3:= fn_resultado_rubro_3(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_3,null,id_empresa,'3');
		
		resultado_4:= fn_resultado_rubro_4(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_4,null,id_empresa,'4');
		
		resultado_5:= fn_resultado_rubro_5(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_5,null,id_empresa,'5');
		
		resultado_6:= fn_resultado_rubro_6(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_6,null,id_empresa,'6');
		
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,(100+resultado_1+resultado_2
		+resultado_3+resultado_4+resultado_5+resultado_6),null,id_empresa,'TOTAL');
		
		-- FALTA PONER LA POSICION PERO NO SE COMO 
		
		EXIT WHEN proveedores_conocidos%NOTFOUND ;

	END LOOP;

	close proveedores_conocidos;
	
COMMIT;
end;
/



create or replace procedure PR_Resultado_eval_no_conocidos(id_empresa empresa.em_id%type) is --Proveedores conocidos

resultado_1 number;

resultado_3 number;

resultado_5 number;
resultado_6 number;

position number :=0;

cursor proveedores_no_conocidos is 
Select distinct p.pr_id from proveedores p where  p.pr_id not in (Select c.pr_id from contrato c);  

REGISTRO number;
begin

	OPEN proveedores_no_conocidos;

	LOOP
		FETCH proveedores_no_conocidos into REGISTRO;

		resultado_1 := fn_resultado_rubro_1(REGISTRO,id_empresa);
                              -- solo ocurre una vez este if
		if fn_nested_evaluacion_vacio(REGISTRO) = 0 THEN 
			insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_1,null,id_empresa,'1');
		ELSE 
			UPDATE PROVEEDORES SET PR_RESULTADOEVALUACION = RESULTADOEVALUACION_NT(RESULTADOEVALUACION(SYSDATE,resultado_1,NULL,id_empresa,'1')) WHERE PR_ID = REGISTRO; 
		END IF;
		
		
		resultado_3:= fn_resultado_rubro_3(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_3,null,id_empresa,'3');
		
	
		resultado_5:= fn_resultado_rubro_5(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_5,null,id_empresa,'5');
		
		resultado_6:= fn_resultado_rubro_6(REGISTRO);
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_6,null,id_empresa,'6');
		
		insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,(65+resultado_1
		+resultado_3+resultado_5+resultado_6),null,id_empresa,'TOTAL');
	
		EXIT WHEN proveedores_no_conocidos%NOTFOUND ;

	END LOOP;

	close proveedores_no_conocidos;
	
COMMIT;
end;
/

create or replace PROCEDURE pr_agrega_posicion IS     -- PARA PONER LA POSICION 

position number :=0;

cursor actualiza_posicion is 
select distinct p.pr_id, n.res_resultado
from proveedores p, table(p.pr_resultadoevaluacion) n 
where n.res_rubro = upper('total')
and to_char(n.res_año,'dd-mm-yyyy')= to_char(sysdate,'dd-mm-yyyy')
order by n.res_resultado desc;

REGISTRO NUMBER;
RESULTADO_EVA NUMBER;
BEGIN

	OPEN actualiza_posicion;
	LOOP
		FETCH actualiza_posicion into REGISTRO, RESULTADO_EVA;
			update table (select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) n 
			set n.RES_POSICION = position + 1;
			EXIT WHEN actualiza_posicion%NOTFOUND ;
      position:= position +1;
	END LOOP;
	CLOSE actualiza_posicion;
COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE PR_EVALUACION_A_PROVEEDORES(id_empresa empresa.em_id%type) IS
BEGIN 
PR_RESULTADO_EVALUACION_PC(id_empresa);
PR_RESULTADO_EVAL_NO_CONOCIDOS(id_empresa);
PR_AGREGA_POSICION;
END;
/

/*   CONSULTA DEL REPORTE DE RESULTADO DE PROVEEDORES       


select DISTINCT p.pr_id,n.RES_RESULTADO,p.pr_nombre, to_char(n.res_año,'dd-mm-yyyy'), e.em_nombre, n.res_posicion
from proveedores p, table(p.pr_resultadoevaluacion) n, empresa e
where n.res_rubro = upper('total') and e.em_id = n.res_IDPRODUCTOR
and to_char(n.res_año,'yyyy')=$P{año_evaluacion}
order by n.res_posicion 

*/


