create or replace trigger tr_actualiza_descuento
after insert on detalle_pedido
declare 
id_pedido   pedido.pe_id%type ;
id_detalle  detalle_pedido.det_id%type;
id_contrato contrato.con_numero%type;
id_empresa   empresa.em_id%type;
begin

select det_id into  id_detalle from (Select det_id from detalle_pedido order by det_id desc) where rownum=1;
  select p.pe_id into id_pedido from pedido p, detalle_pedido dp where p.pe_id= dp.pe_id and det_id = id_detalle;
  
  select c.con_numero into id_contrato from contrato c, pedido p where p.con_numero=c.con_numero and p.pe_id= id_pedido;
  select e.em_id into id_empresa from empresa e, contrato c where c.em_id=e.em_id and c.con_numero= id_contrato;
  
insert into descuentopedidioparaproduccion (DES_ID,pro_fecha,fa_id,em_id,pc_id,ce_id,det_id,pe_id,des_cantidad) 
values (seq_des_pred_id.nextval,null,null,id_empresa,null,null,id_detalle,id_pedido,0);

end;