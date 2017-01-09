create or replace function fn_resultado_rubro_3(id_proveedor proveedores.pr_id%type) return number is
contador_variedad_mp number;

BEGIN 

select count(cp.cp_id) into contador_variedad_mp
from CATALOGO_PROVEEDOR_MP cp, proveedores p
where cp.pr_id = p.pr_id and p.pr_id=id_proveedor;

return contador_variedad_mp;

END;