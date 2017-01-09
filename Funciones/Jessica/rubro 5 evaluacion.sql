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