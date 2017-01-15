

---- Consulta que retorna la cantidad de lo que se halla en el invetario
select (sum(dp.det_cantidad)- sum(des.des_cantidad)) cantidas_inventario, mp.CP_NOMBRE
from detalle_pedido dp, pedido p, presentacion pre, catalogo_proveedor_mp mp, DESCUENTOPEDIDIOPARAPRODUCCION des
where p.pe_id = dp.pe_id --and p.PE_FECHAENTREGA <> null or p.PE_FECHAENTREGa <> '' 
and pre.pre_id = dp.pre_id and mp.cp_id =pre.cp_id and des.DET_ID=dp.DET_ID 
group by mp.cp_nombre; 


--- cursor que retorna la cantidad en ml de la receta de una cerveza en especifico con su presentacion 
cursor lista_receta (nombre_cerveza cerveza.ce_nombreingles%type, id_presentacion presentacion_cerveza.pc_id%type) is
select c.ce_nombreingles, mp.mp_nombre, ((com.c_proporcion/100)*pc.pc_cantidad) cantidad_ml 
from cerveza c, composicion com ,materia_prima mp, presentacion_cerveza pc
where c.ce_id = com.ce_id and mp.mp_id = com.mp_id and c.ce_nombreingles = nombre_cerveza and pc.ce_id=c.ce_id and pc.pc_id= id_presentacion;
