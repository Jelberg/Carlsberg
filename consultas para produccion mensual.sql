

---- Consulta que retorna la cantidad de lo que se halla en el invetario
select (sum(dp.det_cantidad)- sum(des.des_cantidad)) cantidas_inventario, mp.CP_NOMBRE

from detalle_pedido dp, pedido p, presentacion pre, catalogo_proveedor_mp mp, DESCUENTOPEDIDIOPARAPRODUCCION des, 
empresa e, contrato c

where   
 pre.pre_id = dp.pre_id and mp.cp_id =pre.cp_id and des.DET_ID=dp.DET_ID and des.em_id=e.em_id
and c.em_id=e.em_id and c.CON_NUMERO=p.CON_NUMERO and  p.pe_id = dp.pe_id and p.PE_STATUS = 'finalizada'
and upper(e.EM_NOMBRE)= upper('carlsberg group')

group by mp.CP_NOMBRE; 


--- cursor que retorna la cantidad en ml de la receta de una cerveza en especifico con su presentacion 
cursor lista_receta (nombre_cerveza cerveza.ce_nombreingles%type, id_presentacion presentacion_cerveza.pc_id%type) is
select c.ce_nombreingles, mp.mp_nombre, ((com.c_proporcion/100)*pc.pc_cantidad) cantidad_ml 
from cerveza c, composicion com ,materia_prima mp, presentacion_cerveza pc
where c.ce_id = com.ce_id and mp.mp_id = com.mp_id and upper(c.ce_nombreingles) = upper(nombre_cerveza) and 
pc.ce_id=c.ce_id and pc.pc_id= id_presentacion;


-- para la consulta del reporte 

select (sum(dp.det_cantidad)- sum(des.des_cantidad)) cantidas_inventario, mp.CP_NOMBRE, em.em_nombre
from detalle_pedido dp, pedido p, presentacion pre, catalogo_proveedor_mp mp, DESCUENTOPEDIDIOPARAPRODUCCION des, empresa em, contrato con, pedido pe
where p.pe_id = dp.pe_id
and pre.pre_id = dp.pre_id and mp.cp_id =pre.cp_id and des.DET_ID=dp.DET_ID
and  upper(em.em.nombre) = upper($P{nombre empresa}) and em.em_id = con.em_id and pe.con_numero = con.con_numero and dp.pe_id=pe.pe_id
group by mp.cp_nombre, em.em_nombre