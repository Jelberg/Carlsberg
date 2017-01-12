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

