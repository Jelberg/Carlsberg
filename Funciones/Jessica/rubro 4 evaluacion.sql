create or replace function fn_resultado_rubro_4(id_proveedor proveedores.pr_id%type, id_empresa empresa.em_id%type) return number is
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


/*     PARA ELRUBRO 2
select n.fotos , cp.cp_nombre, cp.cp_descripcion, cp.cp_id, p.pr_nombre, p.pr_id
from CATALOGO_PROVEEDOR_MP cp, proveedores p, table(cp.cp_fotos) n
where cp.pr_id = p.pr_id and
*/