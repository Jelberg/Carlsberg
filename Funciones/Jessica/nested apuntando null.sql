create or replace function fn_nested_vacio (ids proveedores.PR_id%type) return number is
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