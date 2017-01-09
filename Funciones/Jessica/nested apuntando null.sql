create or replace function fn_nested_vacio (ids proveedores.PR_id%type) return number is
rgistro proveedores.PR_RESULTADOEVALUACION%type
begin 
select PR_RESULTADOEVALUACION into rgistro from proveedores where pr_id = ids;

if rgistro = null then return 1;
else return 0;

end;