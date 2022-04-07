create database farmacia CHARACTER SET utf8 COLLATE utf8_general_ci;
use farmacia;
create table Proveedor( 
	idProveedor int AUTO_INCREMENT,
	nombre varchar(50),
	detalle text,
	telefono varchar(20),
	fechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	primary key (idProveedor)
);

create table Producto( 
	idProducto int AUTO_INCREMENT,
	nombre varchar(50),
	detalle text,
	precioVenta float,
	fechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	primary key (idProducto)
);

create table Compra( 
	idCompra int AUTO_INCREMENT,
	idProducto_fk int,
	idProveedor_fk int,
	cantidadCompra int,
	precioCompra float,
	fechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	primary key (idCompra),
	foreign key (idProducto_fk) references Producto (idProducto),
	foreign key (idProveedor_fk) references Proveedor (idProveedor)
);

create table Venta( 
	idVenta int AUTO_INCREMENT,
	idProducto_fk int,
	cantidadVenta int,
	precioVenta float,
	fechaCreacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	primary key (idVenta),
	foreign key (idProducto_fk) references Producto (idProducto)
);

INSERT INTO `Proveedor` (`nombre`, `detalle`, `telefono`) VALUES 
('Bayer', 'Bayer empresa multinacional', '2563335'),
('Mecamax', 'Empresa de elaboración de productos farmaceúticos', '253665');

INSERT INTO `Producto` (`nombre`, `detalle`, `precioVenta`) VALUES 
('Ibuprofeno', 'Caja 3x15', 5000),
('Calmidol', 'Caja 3x10', 7000),
('Acetaminofen', 'Caja 3x8', 4000);

INSERT INTO `Compra` (`idProducto_fk`,`idProveedor_fk`, `cantidadCompra`,`precioCompra`) VALUES 
(1, 1, 100, 4000),
(2, 2, 120, 6000),
(1, 2, 200, 4000);

INSERT INTO `Venta` (`idProducto_fk`,`cantidadVenta`, `precioVenta`) VALUES 
(1, 50, 5000),
(2, 20, 7000),
(1, 10, 5000);

drop view if exists ventaTotal;

CREATE VIEW ventaTotal as SELECT idProducto_fk, producto.nombre, SUM(cantidadVenta) as "ventasRealizadas"
FROM `venta` INNER JOIN producto ON producto.idProducto = venta.idProducto_fk GROUP BY idProducto_fk;

drop view if exists compraTotal;

CREATE VIEW compraTotal as SELECT compra.idProducto_fk, producto.nombre, SUM(compra.cantidadCompra) as "comprasRealizadas" 
FROM compra INNER JOIN producto ON producto.idProducto = compra.idProducto_fk GROUP BY idProducto_fk;

drop view if exists stock;

CREATE VIEW stock as SELECT compratotal.nombre, (compratotal.comprasRealizadas - ventatotal.ventasRealizadas) AS stock 
FROM ventatotal, compratotal WHERE ventatotal.idProducto_fk = compratotal.idProducto_fk GROUP BY ventatotal.idProducto_fk;
