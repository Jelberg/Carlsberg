create or replace fn_resultado_rubro_2(id_proveedor proveedores.pr_id%type, id_empresa empresa.em_id%type) return number is
id_contrato number(7);
fecha_emision date;

begin 
Select con_numero, con_fechaemision into id_contrato, fecha_emision
from (Select con_numero, con_fechaemision 
from contrato c
where pr_id=id_proveedor
order by c.con_fechaemision desc) 
where rownum =1;

end;