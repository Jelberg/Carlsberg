create or replace function fn_resultado_rubro_2(id_proveedor proveedores.pr_id%type) return number is
fecha_ultimo_contrato date;
id_ultimo_contrato number;
cont_pedidos_tardios number;
cont_pedidos_notardios number;
BEGIN 
--DEVUELVE EL ULTIMO CONTRATO
Select con_fechaemision, con_numero into fecha_ultimo_contrato, id_ultimo_contrato          
from (Select con_numero, con_fechaemision 
from contrato c
where pr_id=id_proveedor
order by c.con_fechaemision desc) 
where rownum =1;

-- no se si se hacen entregas si el estatus es 'en proceso'

select count(pe_id) into cont_pedidos_tardios
from pedido where PE_STATUS = 'finalizada' and con_numero=id_ultimo_contrato and 
(TO_NUMBER(TO_CHAR(TO_DATE(PE_FECHASOLICITADA,'DD-mm-yyyy'),'ddmmYYYY'),99999999) < 
TO_NUMBER(TO_CHAR(TO_DATE(PE_FECHAENTREGA,'DD-mm-yyyy'),'ddmmYYYY'),99999999));

select count(pe_id) into cont_pedidos_notardios
from pedido where PE_STATUS = 'finalizada' and con_numero=id_ultimo_contrato and 
(TO_NUMBER(TO_CHAR(TO_DATE(PE_FECHASOLICITADA,'DD-mm-yyyy'),'ddmmYYYY'),99999999) >= 
TO_NUMBER(TO_CHAR(TO_DATE(PE_FECHAENTREGA,'DD-mm-yyyy'),'ddmmYYYY'),99999999));

if cont_pedidos_notardios >= cont_pedidos_tardios then return 0;
else return -10;
end if;

END;