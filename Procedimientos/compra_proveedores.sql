create or replace procedure pr_compraAProveedores(nombreProveedor varchar2, nombreEmpresa varchar2
    , tipoPedido varchar2, fechaSolicitada date)
is
contrato number;
proveedorId number;
empresaId number;
ultimoPedido number;
begin

contrato:=0;
select pr_id into proveedorId  from proveedores where pr_nombre=nombreProveedor;
dbms_output.put_line(proveedorId);
select em_id into empresaId from empresa where em_nombre=nombreEmpresa;
select con_numero into contrato from contrato where pr_id=proveedorId and em_id=empresaId and 
con_fechaemision+365>to_date(sysdate,'dd/mm/yyyy');

if (contrato>0) then

    dbms_output.put_line('El proveedor '||nombreProveedor|| ' tiene contrato con la Empresa '||nombreEmpresa);

    insert into pedido (pe_id,pe_fechapedido,pe_status,pe_tipo,pe_numfactura,pe_total,pe_fechasolicitada,pe_fechaentrega,con_numero) 
    values (seq_pe_id.nextval,to_date(sysdate,'dd/mm/yyyy'),'en proceso',tipoPedido,
    null,0,to_date(fechaSolicitada,'dd/mm/yyyy'),null,contrato);

    select pe_id into ultimoPedido from pedido where rownum=1 order by pe_id desc;

    dbms_output.put_line('Pedido #'||ultimoPedido || ' registrado con exito');

elsif (contrato=0) then

    dbms_output.put_line('El proveedor '|| nombreProveedor || 'no tiene contrato vigente');

end if;

end pr_compraAProveedores; 
/
create or replace procedure pr_agregarProductoAPedidoMP(materiaPrima varchar2, presentacion varchar2
    ,valorMedida varchar2, medida varchar2, cantidad number)
    is
    ultimoPedido number;
    precioU number;
    proveedorId number;
    presentacionId number;
    total number;
    begin

    select pe_id into ultimoPedido from pedido where rownum=1 order by pe_id desc;

    select pr_id into proveedorId from proveedores where pr_id=(select pr_id from contrato 
    where con_numero=(select c.con_numero from contrato c, pedido p 
    where c.con_numero=p.con_numero and pe_id=ultimoPedido));

    select pre.pre_id into presentacionId from presentacion pre, catalogo_proveedor_mp cp where 
    pre.cp_id=cp.cp_id and cp.cp_nombre=materiaPrima and pre.pre_tipo=presentacion 
    --and pre_medida=medida(valorMedida,medida) 
    and cp.pr_id=proveedorId and  rownum=1;

    insert into detalle_pedido (det_id, pe_id,pre_id,det_cantidad,ca_codigo,pr_id)
    values (seq_det_id.nextval, ultimoPedido, presentacionId, cantidad, null, proveedorId);

    dbms_output.put_line('Se ha agregado al pedido #'||ultimoPedido||' '||materiaPrima ||' en '||presentacion||' un total de '||cantidad);

    select p.pre_preciou into precioU from presentacion p where p.cp_id=(select cp_id from catalogo_proveedor_mp 
    where cp_nombre=materiaPrima and pr_id=proveedorId and rownum=1) and rownum=1;

    update pedido set pe_total=pe_total+precioU where pe_id=ultimoPedido;

    select pe_total into total from pedido where pe_id=ultimoPedido;

    dbms_output.put_line('El precio total de su pedido es ahora de '||total);

    end pr_agregarProductoAPedidoMP;
/
create or replace procedure pr_agregarProductoAPedidoE(equipo varchar2, cantidad number)
    is
    ultimoPedido number;
    catalogoProveedorEquipoId number;
    precio number;
    proveedorId number;
    total number;
    begin

    select pe_id into ultimoPedido from pedido where rownum=1 order by pe_id desc;

    select pr_id into proveedorId from proveedores where pr_id=(select pr_id from contrato 
    where con_numero=(select c.con_numero from contrato c, pedido p 
    where c.con_numero=p.con_numero and pe_id=ultimoPedido));

    select ca_codigo into catalogoProveedorEquipoId from catalogo_proveedor_eq where pr_id=ultimoPedido and ca_nombre=equipo;

    insert into detalle_pedido (det_id, pe_id,pre_id,det_cantidad,ca_codigo,pr_id)
    values (seq_det_id.nextval, ultimoPedido, null, cantidad, catalogoProveedorEquipoId, proveedorId);

    dbms_output.put_line('Se ha agregado al pedido #'||ultimoPedido||' la maquinaria'||equipo||' un total de '||cantidad);

    select ca_preciounitario into precio from catalogo_proveedor_eq where pr_id=ultimoPedido and ca_nombre=equipo;

    update pedido set pe_total=pe_total+precio where pe_id=ultimoPedido;

    select pe_total into total from pedido where pe_id=ultimoPedido;

    dbms_output.put_line('El precio total de su pedido es ahora de '||total);

    end pr_agregarProductoAPedidoE;
/
create or replace procedure pr_cancelarPedido(idPedido number)
    is 
    begin
    update pedido set pe_status='cancelada' where pe_id=idPedido;
    dbms_output.put_line('Pedido #'||idPedido||' cancelado');
    end pr_cancelarPedido;
/
create or replace procedure pr_realizarPago(idPedido number, monto number, fecha date, nro_cuotas number)
    is
    statusPedido varchar2(30);
    numFactura number;
    begin
    numFactura:=0;

    select pe_status into statusPedido from pedido where pe_id=idPedido;

    select pe_numfactura into numFactura from pedido where pe_id=idPedido;

    if (statusPedido not like 'rechazada por proveedor') then
        
    if (numFactura<>0) then
        
    insert into pago (pa_id, pe_id, pa_tipopago, pa_monto, pa_fecha, pa_cuota) 
    values (seq_pa_id.nextval, idPedido, 
    null, monto, fecha, nro_cuotas);

    dbms_output.put_line('El pedido #'||idPedido|| ' se ha cancelado por un total de '||monto);

    elsif (numFactura=0) then
        
    dbms_output.put_line('El pedido #'||idPedido||'no puede ser pagado aun');

    end if;

    elsif (statusPedido='rechazada por proveedor') then

    dbms_output.put_line('El pedido #'||idPedido||' ha sido rechazado por proveedor');

    end if;

    end pr_realizarPago;
/
create or replace procedure pr_confirmarLlegadaPedido (idPedido number)
    is
    begin

    update pedido set pe_status='finalizada' where pe_id=idPedido;

    dbms_output.put_line('El pedido #'||idPedido||' ha sido confirmado');

    end pr_confirmarLlegadaPedido ;
/
create or replace procedure pr_rechazadaPorProveedor(idPedido number)
    is 
    begin

    update pedido set pe_status='rechazada por proveedor' where pe_id= idPedido;

    dbms_output.put_line('El pedido #'||idPedido||' fue rechazada por proveedor');

    end pr_rechazadaPorProveedor;
/
create or replace procedure pr_confirmarPosibleDespacho(idPedido number, numFactura number)
    is
    begin

    update pedido set pe_numfactura=numFactura where pe_id=idPedido;

    dbms_output.put_line('El pedido #'||idPedido||' ha sido confirmado para despacho');

    end pr_confirmarPosibleDespacho;
/