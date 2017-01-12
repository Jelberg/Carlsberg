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

/*
--DE ESTA MANERA SI EXISTE VALORES EN EL OBJETO
insert into  table(PR_RESULTADOEVALUACION from proveedores where pr_id = 1) values ('12-12-12',2,2,2,'HOLA');

--SI NO EXISTEN VALORES LA TABLA ESTA APUNTANDO A NULL POR LO QUE VA A GENERAR ERROR Y NO VA A SABER COMO INSERTAR POR LO QUE SE USA:
UPDATE PROVEEDORES SET PR_RESULTADOEVALUACION =  
 RESULTADOEVALUACION_NT(RESULTADOEVALUACION('12-12-12',2,2,2,'HOLA'))
WHERE id_orden = 1; 

*/