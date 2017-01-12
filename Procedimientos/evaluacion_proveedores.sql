create or replace procedure PR_resultado_evaluacion_pc(id_empresa empresa.em_id%type) is --Proveedores conocidos

resultado_1 number;
resultado_2 number;
resultado_3 number;
resultado_4 number;
resultado_5 number;
resultado_6 number;

position number :=0;

cursor proveedores_conocidos is 
Select p.pr_id from proveedores p, contrato c where c.pr_id=p.pr_id;  

REGISTRO number;
begin

	OPEN proveedores_conocidos;

	LOOP
		FETCH proveedores_conocidos into REGISTRO;

		resultado_1 := fn_resultado_rubro_1(REGISTRO,id_empresa);
                              -- solo ocurre una vez este if
		if fn_nested_vacio(REGISTRO) = 0 THEN 
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

create or replace PROCEDURE EVALUACION IS     -- PARA PONER LA POSICION 

position number :=0;

cursor actualiza_posicion is 
select p.pr_id --, n.RES_RESULTADO,p.pr_nombre , to_char(n.res_año,'dd-mm-yyyy')
from proveedores p, table(p.pr_resultadoevaluacion) n, empresa e
where n.res_rubro = upper('total') and e.em_id = n.res_IDPRODUCTOR
and to_char(n.res_año,'dd-mm-yyyy')= to_char(sysdate,'dd-mm-yyyy')
order by n.res_resultado desc;

REGISTRO NUMBER;
BEGIN

--EXEC PR_resultado_evaluacion_pc(id_empresa);

	OPEN actualiza_posicion;
	LOOP
		FETCH actualiza_posicion into REGISTRO;
			update table (select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) n 
			set n.RES_POSICION = position + 1;
      position:= position +1;
			EXIT WHEN actualiza_posicion%NOTFOUND ;
	END LOOP;
	CLOSE actualiza_posicion;
COMMIT;
END;