create or replace procedure PR_resultado_evaluacion_pc(id_empresa empresa.em_id%type) is 

resultado_1 number;
resultado_2 number;
resultado_3 number;
resultado_4 number;
resultado_5 number;
resultado_6 number;

cursor proveedores_conocidos is 
Select p.pr_id from proveedores p, contrato c where c.pr_id=p.pr_id;  

REGISTRO number;
begin

OPEN proveedores_conocidos;

LOOP
FETCH proveedores_conocidos into REGISTRO;

resultado_1 := fn_resultado_rubro_1(REGISTRO,id_empresa);

insert into table(select PR_RESULTADOEVALUACION from proveedores where pr_id = REGISTRO) values (sysdate,resultado_1,null,id_empresa,'1');

EXIT WHEN proveedores_conocidos%NOTFOUND ;

END LOOP;

close proveedores_conocidos;

end;