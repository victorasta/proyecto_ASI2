-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 25-09-2019 a las 01:35:28
-- Versión del servidor: 10.4.6-MariaDB
-- Versión de PHP: 7.3.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `cardoffice`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_categoria` (IN `nombre` VARCHAR(255))  NO SQL
INSERT INTO `categorias` (`id`, `nombre`, `estado`, `updated_at`) VALUES (NULL,nombre, 'activo', NULL)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_cliente` (IN `nombre` VARCHAR(100), IN `apellido` VARCHAR(100), IN `correo` VARCHAR(255), IN `passwrd` VARCHAR(255))  NO SQL
BEGIN
INSERT INTO `cliente` (`id`, `nombre`, `apellido`, `telefono`) VALUES (NULL,nombre,apellido, NULL);
INSERT INTO `usuario` (`id`, `correo`, `passwrd`, `id_rol`, `estado`, `id_empleado`, `id_cliente`) VALUES (NULL,correo,passwrd,'4', 'activo',NULL, (SELECT id from cliente where cliente.nombre = nombre AND cliente.apellido = apellido));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_empleado` (IN `nombre` VARCHAR(100), IN `apellido` VARCHAR(100), IN `dui` VARCHAR(10), IN `telefono` VARCHAR(10), IN `movil` VARCHAR(10), IN `direccion` VARCHAR(255), IN `foto` VARCHAR(255), IN `codigo` VARCHAR(10), IN `correo` VARCHAR(100), IN `passwrd` VARCHAR(255), IN `rol` VARCHAR(255))  NO SQL
BEGIN

INSERT INTO `empleado` (`id`, `nombre`, `apellido`, `dui`, `telefono1`, `movil`, `direccion`, `foto`, `fecha_registro`, `codigo`) VALUES (NULL,nombre,apellido,dui,telefono,movil,direccion,foto, CURRENT_TIMESTAMP,codigo);
INSERT INTO `usuario` (`id`, `correo`, `passwrd`, `id_rol`, `estado`, `id_empleado`, `id_cliente`) VALUES (NULL,correo,passwrd,rol, 'activo',(SELECT id from empleado where empleado.dui = dui), NULL);
UPDATE empleado set empleado.codigo =(SELECT codigo_empleado(dui)) WHERE empleado.dui = dui;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_marca` (IN `nombre` VARCHAR(100))  NO SQL
INSERT INTO `marca` (`id`, `nombre`, `estado`) VALUES (NULL,nombre, 'activo')$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_producto` (IN `nombre` VARCHAR(100), IN `descripcion` MEDIUMTEXT, IN `foto` VARCHAR(255), IN `categoria` INT(255), IN `marca` INT(255), IN `stock` INT(255), IN `precio` DECIMAL(10,2))  NO SQL
BEGIN

INSERT INTO `producto` (`id`, `nombre`, `descripcion`, `imagen`, `id_categoria`, `estado`, `id_marca`) VALUES (NULL,nombre,descripcion,foto, categoria, 'activo',marca);
INSERT INTO `inventario` (`id`, `codigo`, `stock`, `precio_venta`, `fecha_registro`, `id_producto`) VALUES (NULL, NULL,stock, precio, CURRENT_TIMESTAMP,(SELECT id from producto where producto.nombre = nombre));

UPDATE inventario set inventario.codigo = (SELECT codigo_producto(nombre)) WHERE inventario.id = (SELECT id FROM producto where producto.nombre = nombre);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `crear_proveedor` (IN `empresa` VARCHAR(255), IN `encargado` VARCHAR(255), IN `telefono` VARCHAR(10), IN `movil` VARCHAR(10), IN `correo` VARCHAR(100))  NO SQL
BEGIN

INSERT INTO `proveedores` (`id_proveedor`, `empresa`, `encargado`, `telefono`, `movil`, `correo`, `codigo`, `fecha_registro`,`estado`) VALUES (NULL,empresa,encargado,telefono,movil,correo, NULL,CURRENT_DATE,'activo');
UPDATE proveedores SET codigo =(SELECT codigo_proveedor(empresa)) WHERE proveedores.empresa = empresa;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generarModulos` ()  BEGIN
      INSERT INTO `modulo` (`id`, `modulo`) VALUES (NULL, 'producto');  
      INSERT INTO `modulo` (`id`, `modulo`) VALUES (NULL, 'proveedor');
      INSERT INTO `modulo` (`id`, `modulo`) VALUES (NULL, 'marca');
      INSERT INTO `modulo` (`id`, `modulo`) VALUES (NULL, 'categoria');
      INSERT INTO `modulo` (`id`, `modulo`) VALUES (NULL, 'configuracion');
      INSERT INTO `modulo` (`id`, `modulo`) VALUES (NULL, 'empleado');
      INSERT INTO `modulo` (`id`, `modulo`) VALUES (NULL, 'devoluciones');
      INSERT INTO `modulo` (`id`, `modulo`) VALUES (NULL, 'ofertas');
      INSERT INTO `modulo` (`id`, `modulo`) VALUES (NULL, 'auditoria');
      INSERT INTO `modulo` (`id`, `modulo`) VALUES (NULL, 'publico');
      INSERT INTO `modulo` (`id`, `modulo`) VALUES (NULL, 'ajustes');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generarRoles` ()  BEGIN
      INSERT INTO `rol` (`id`, `nombre`) VALUES (NULL, 'administrador');
      INSERT INTO `rol` (`id`, `nombre`) VALUES (NULL, 'gerente');
      INSERT INTO `rol` (`id`, `nombre`) VALUES (NULL, 'empleado');
      INSERT INTO `rol` (`id`, `nombre`) VALUES (NULL, 'cliente');
      INSERT INTO `rol` (`id`, `nombre`) VALUES (NULL, 'master');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_submenu` (IN `id_rol` INT(255), IN `id_menu` INT(255))  NO SQL
SELECT mt.*,pr.operaciones FROM menu_item mt, rol_menu rm , privilegios_rol pr WHERE mt.id_menu_padre=id_menu AND rm.id_rol =id_rol AND rm.id_menu =id_menu AND pr.id_rol =id_rol AND rm.id_modulo = pr.id_modulo AND pr.id_rol=id_rol$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `modificar_categoria` (IN `nombre` VARCHAR(255), IN `id` INT(255))  NO SQL
UPDATE `categorias` SET `nombre` = nombre WHERE `categorias`.`id` = id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `modificar_cliente` (IN `telefono` VARCHAR(10), IN `correo` VARCHAR(255), IN `passwrd` VARCHAR(255), IN `id` INT(255))  NO SQL
BEGIN

UPDATE `cliente` SET `telefono` = telefono WHERE `cliente`.`id` = id;
UPDATE `usuario` SET `correo` = correo, `passwrd` = passwrd  WHERE `usuario`.`id_cliente` = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `modificar_empleado` (IN `telefono` VARCHAR(10), IN `movil` VARCHAR(10), IN `direccion` MEDIUMTEXT, IN `foto` VARCHAR(255), IN `correo` VARCHAR(255), IN `passwrd` VARCHAR(255), IN `id` INT)  NO SQL
BEGIN

UPDATE `empleado` SET `telefono1` = telefono ,`movil` = movil,`direccion` = direccion,`foto` = foto WHERE `empleado`.`id` = id;


UPDATE `usuario` SET `correo` = correo, `passwrd` = passwrd  WHERE `usuario`.`id_empleado` = id;


END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `codigo_empleado` (`dui` VARCHAR(20)) RETURNS VARCHAR(20) CHARSET utf8 COLLATE utf8_spanish_ci NO SQL
BEGIN
   DECLARE codigo VARCHAR(100);   
   SET codigo = (SELECT concat((SELECT LEFT((SELECT UPPER(empleado.apellido) from empleado where empleado.dui=dui),2)),(SELECT year(empleado.fecha_registro) FROM empleado WHERE empleado.dui =dui),(SELECT id FROM usuario WHERE usuario.id_empleado=(SELECT id FROM empleado WHERE empleado.dui=dui))));
        
      
   RETURN codigo;
              
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `codigo_producto` (`producto` VARCHAR(100)) RETURNS VARCHAR(100) CHARSET utf8 COLLATE utf8_spanish_ci BEGIN
        DECLARE codigo VARCHAR(100);   
        SET codigo = (SELECT CONCAT( (SELECT UPPER(LEFT(nombre,2))FROM categorias WHERE categorias.id =(SELECT id_categoria FROM producto WHERE producto.nombre =producto)), (SELECT id FROM producto WHERE producto.nombre =producto), (SELECT id_marca FROM producto WHERE producto.nombre =producto), (SELECT id FROM inventario WHERE inventario.id_producto = (SELECT id FROM producto WHERE producto.nombre =producto)), (SELECT year(fecha_registro) FROM inventario WHERE inventario.id_producto = (SELECT id FROM producto WHERE producto.nombre =producto))));
        
        RETURN codigo;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `codigo_proveedor` (`empresa` VARCHAR(100)) RETURNS VARCHAR(100) CHARSET utf8 COLLATE utf8_spanish_ci NO SQL
BEGIN
        DECLARE codigo VARCHAR(100);   
        SET codigo = CONCAT((SELECT LEFT((SELECT UPPER('empresa')),2)),
                     (SELECT id FROM proveedores WHERE proveedores.empresa = empresa),(SELECT YEAR(fecha_registro) FROM proveedores WHERE proveedores.empresa= 'VIDRI'));
        
        RETURN codigo;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `cargar_menu`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `cargar_menu` (
`rol` varchar(50)
,`menu` varchar(45)
,`submenu` varchar(45)
,`id_rol` int(11)
,`id_menu` int(11)
,`id_menu_item` int(11)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo guarda en nombre de cada categoria del menu,',
  `estado` enum('activo','inactivo','eliminado') COLLATE utf8_spanish_ci DEFAULT 'activo' COMMENT 'Este campo guarda el estado de cada categoria\nActivo = es visible al publico\nInactivo = no es visible al publico\nEliminado = Elimininacion logica del sistema',
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Este campo registra el nombre del cliente',
  `apellido` varchar(45) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Este campo registra el apellido del cliente',
  `telefono` varchar(10) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo registra el telefono del cliente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`id`, `nombre`, `apellido`, `telefono`) VALUES
(3, 'Donald Remberto', 'Miranda ', NULL),
(4, 'Fernanda ', 'Perdomo', NULL),
(5, 'samuelbran', 'bran', NULL),
(6, 'jose', 'carlos', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comprobante`
--

CREATE TABLE `comprobante` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) COLLATE utf8_spanish_ci NOT NULL COMMENT 'nombre del comprobante\nFactura,TICKET, CREDITO FISCAL'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `datos_auditoria`
--

CREATE TABLE `datos_auditoria` (
  `id_auditoria` int(11) NOT NULL,
  `fecha` timestamp NULL DEFAULT NULL COMMENT 'Este registro guarda la fecha y hora en que se realiza la operacion\n',
  `operacion` enum('insert','delete','update','select') COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo guarda el tipo de operacion que se realizo',
  `usuario_creacion` int(11) DEFAULT NULL COMMENT 'El campo guarda el id del usuario de realizo la operacion\n',
  `tabla` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo guarda el nombre de la tabla en que se realizo la operacion'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `devoluciones`
--

CREATE TABLE `devoluciones` (
  `id` int(11) NOT NULL,
  `detalle` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `fecha_ingreso` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL,
  `cliente` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleado`
--

CREATE TABLE `empleado` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Este campo guarda nombre de empleado',
  `apellido` varchar(45) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Este campo guarda apellido de empleado',
  `dui` varchar(9) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Este campo guarda el numero unico de identidad de cada empleado.',
  `telefono1` varchar(10) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo guarda el telefono alternativo de cada empleado',
  `movil` varchar(10) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Este campo registra el movil de cada empleado',
  `direccion` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo registra direccion de cada uno de los empleados',
  `foto` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo guarda la direccion de la fotografia de cada empleado\n',
  `fecha_registro` timestamp NULL DEFAULT NULL COMMENT 'Este campo registrar la fecha en que cada empleado es dado de alta.',
  `codigo` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo registra el codigo de cada empleado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `empleado`
--

INSERT INTO `empleado` (`id`, `nombre`, `apellido`, `dui`, `telefono1`, `movil`, `direccion`, `foto`, `fecha_registro`, `codigo`) VALUES
(1, 'Carlos', 'Lopez', '', '77848912', '', '', '', '2019-09-21 03:46:13', 'LO20191'),
(4, 'gerente', ' ', '01', ' ', ' ', ' ', ' ', '2019-09-24 00:35:16', ' 20198'),
(5, 'empleado', ' ', '02', ' ', '', '', '', '2019-09-24 00:37:14', ' 20199');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario`
--

CREATE TABLE `inventario` (
  `id` int(11) NOT NULL,
  `codigo` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo guarda el codigo del producto',
  `stock` int(11) DEFAULT NULL COMMENT 'Este campo guarda la Cantidad existente de producto.',
  `precio_venta` decimal(10,0) DEFAULT NULL COMMENT 'precio de venta',
  `fecha_registro` date DEFAULT NULL COMMENT 'fecha de registro de producto',
  `id_producto` int(11) NOT NULL COMMENT 'id producto que se ingresa a inventario\n'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marca`
--

CREATE TABLE `marca` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo el nombre de marca registrada',
  `estado` enum('activo','inactivo','eliminado') COLLATE utf8_spanish_ci DEFAULT 'activo' COMMENT 'estado de la marca\nACTIVO, INACTIVO, ELIMINADA'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menu`
--

CREATE TABLE `menu` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Este campo guarda el nombre de menu',
  `url` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `estado` enum('activo','inactivo','Eliminado') COLLATE utf8_spanish_ci DEFAULT 'inactivo' COMMENT 'estaod de opcion de menu\nactivo=visible para empleados o clientes\ninactivo = no es visible para empleado o clientes\neliminado = no es visible en el sistema',
  `icon` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `menu`
--

INSERT INTO `menu` (`id`, `nombre`, `url`, `estado`, `icon`) VALUES
(1, 'Empleado', NULL, 'inactivo', '<i class=\"fas fa-address-book\"></i>'),
(2, 'Productos', NULL, 'inactivo', '<i class=\"fas fa-dice-d6\"></i>'),
(3, 'Inventario', 'inventario.php', 'inactivo', '<i class=\"fas fa-clipboard-list\"></i>'),
(4, 'Ventas', NULL, 'inactivo', '<i class=\"fas fa-shopping-cart\"></i>'),
(5, 'Proveedores', NULL, 'inactivo', '<i class=\"fas fa-truck-loading\"></i>'),
(6, 'Auditoria', 'auditoria.php', 'inactivo', '<i class=\"fas fa-shield-alt\"></i>'),
(7, 'Devoluciones', 'devoluciones.php', 'inactivo', '<i class=\"fas fa-book\"></i>');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menu_item`
--

CREATE TABLE `menu_item` (
  `id_item` int(11) NOT NULL,
  `nombre` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `url` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL,
  `id_menu_padre` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `menu_item`
--

INSERT INTO `menu_item` (`id_item`, `nombre`, `url`, `id_menu_padre`) VALUES
(1, 'Lista Empleado', 'listaEmpleados.php', 1),
(2, 'Nuevo Empleado', 'nuevoEmpleado.php', 1),
(3, 'Lista Productos', 'listaProductos.php', 2),
(4, 'Nuevo Producto', 'nuevoProducto.php', 2),
(5, 'Ofertas', 'ofertas.php', 2),
(6, 'Categorias', 'categorias.php', 2),
(7, 'Marcas', 'marcas.php', 2),
(8, 'Lista Ventas', 'listaVentas.php', 4),
(9, 'Nueva Venta', 'nuevaVenta.php', 4),
(10, 'Lista Proveedores', 'listaProveedores.php', 5),
(11, 'Nuevo Proveedor', 'nuevoProveedor.php', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modulo`
--

CREATE TABLE `modulo` (
  `id` int(11) NOT NULL,
  `modulo` varchar(100) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `modulo`
--

INSERT INTO `modulo` (`id`, `modulo`) VALUES
(11, 'ajustes'),
(9, 'auditoria'),
(4, 'categoria'),
(5, 'configuracion'),
(7, 'devoluciones'),
(6, 'empleado'),
(3, 'marca'),
(8, 'ofertas'),
(1, 'producto'),
(2, 'proveedor'),
(10, 'publico');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ofertas`
--

CREATE TABLE `ofertas` (
  `id_inventario` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL COMMENT 'Este campo guarda el id del producto que se pondra en promocion',
  `fechaInicio` date DEFAULT NULL COMMENT 'Este campo guarda la fecha en que inicia la promocion',
  `fechaFinalizacion` date DEFAULT NULL COMMENT 'Este campo guarda la fecha que finaliza promocion',
  `descuento` decimal(10,0) DEFAULT NULL COMMENT 'Este campo guarda precio con descuento del producto'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `privilegios_rol`
--

CREATE TABLE `privilegios_rol` (
  `id_rol` int(11) NOT NULL,
  `id_modulo` int(11) NOT NULL,
  `operaciones` longtext COLLATE utf8_spanish_ci DEFAULT NULL,
  `operaciones_modi` longtext COLLATE utf8_spanish_ci DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `privilegios_rol`
--

INSERT INTO `privilegios_rol` (`id_rol`, `id_modulo`, `operaciones`, `operaciones_modi`, `id_usuario`) VALUES
(1, 1, '{\"SELECT\":TRUE,\"UPDATE\":TRUE,\"DELETE\":TRUE,\"INSERT\":TRUE}', NULL, NULL),
(1, 2, '{\"SELECT\":TRUE,\"UPDATE\":TRUE,\"DELETE\":TRUE,\"INSERT\":TRUE}', NULL, NULL),
(1, 3, '{\"SELECT\":TRUE,\"UPDATE\":TRUE,\"DELETE\":TRUE,\"INSERT\":TRUE}', NULL, NULL),
(1, 4, '{\"SELECT\":TRUE,\"UPDATE\":TRUE,\"DELETE\":TRUE,\"INSERT\":TRUE}', NULL, NULL),
(1, 6, '{\"SELECT\":TRUE,\"UPDATE\":TRUE,\"DELETE\":TRUE,\"INSERT\":TRUE}', NULL, NULL),
(1, 7, '{\"SELECT\":TRUE,\"UPDATE\":TRUE,\"DELETE\":TRUE,\"INSERT\":TRUE}', NULL, NULL),
(1, 8, '{\"SELECT\":TRUE,\"UPDATE\":TRUE,\"DELETE\":TRUE,\"INSERT\":TRUE}', NULL, NULL),
(1, 9, '{\"SELECT\":TRUE,\"UPDATE\":TRUE,\"DELETE\":TRUE,\"INSERT\":TRUE}', NULL, NULL),
(2, 2, '{\"SELECT\":TRUE,\"UPDATE\":TRUE,\"DELETE\":TRUE,\"INSERT\":TRUE}', NULL, NULL),
(2, 3, '{\"SELECT\":TRUE,\"UPDATE\":TRUE,\"DELETE\":TRUE,\"INSERT\":TRUE}', NULL, NULL),
(2, 4, '{\"SELECT\":TRUE,\"UPDATE\":TRUE,\"DELETE\":TRUE,\"INSERT\":TRUE}', NULL, NULL),
(2, 6, '{\"SELECT\":TRUE,\"UPDATE\":TRUE,\"DELETE\":TRUE,\"INSERT\":TRUE}', NULL, NULL),
(2, 7, '{\"SELECT\":TRUE,\"UPDATE\":TRUE,\"DELETE\":TRUE,\"INSERT\":TRUE}', NULL, NULL),
(2, 8, '{\"SELECT\":TRUE,\"UPDATE\":TRUE,\"DELETE\":TRUE,\"INSERT\":TRUE}', NULL, NULL),
(2, 1, '{\"SELECT\":TRUE,\"UPDATE\":TRUE,\"DELETE\":TRUE,\"INSERT\":TRUE}', NULL, NULL),
(3, 1, '{\"SELECT\":TRUE,\"UPDATE\":FALSE,\"DELETE\":FALSE,\"INSERT\":FALSE}', NULL, NULL),
(3, 8, '{\"SELECT\":TRUE,\"UPDATE\":FALSE,\"DELETE\":FALSE,\"INSERT\":TRUE}', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo registra el nombre de cada producto',
  `descripcion` varchar(45) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Este campo guarda la descripcion de cada producto',
  `imagen` varchar(255) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo guarda la direccion de la imagen del producto',
  `id_categoria` int(11) NOT NULL COMMENT 'Este campo guarda id de la categoria al que pertenece el producto',
  `estado` enum('activo','inactivo','eliminado') COLLATE utf8_spanish_ci DEFAULT 'activo' COMMENT 'Estado del Producto (''activo'',''inactivo'',''eliminado'')\nactivo= si hay existencias\ninactivo = si stock es igual a 0\neliminado= no se muestra en el catalogo de producto',
  `id_marca` int(11) NOT NULL COMMENT 'Este campo guarda el id de la marca del producto\n'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id` int(11) NOT NULL,
  `empresa` varchar(100) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Este campo nombre de la empresa proveedora',
  `encargado` varchar(100) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Este campo contacto de la empresa proveedora',
  `telefono` varchar(10) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo telefono de encargado',
  `movil` varchar(10) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo guarda el telefono movil de proveedor de la empresa',
  `correo` varchar(45) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Este campo guarda el correo de proveedor',
  `codigo` varchar(45) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'codigo de proveedor\n'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo guarda el nombre de los creados(''Administrador'',Supervisor'''',''Empleado'',''Cliente'')'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id`, `nombre`) VALUES
(1, 'administrador'),
(2, 'gerente'),
(3, 'empleado'),
(4, 'cliente'),
(5, 'master');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol_menu`
--

CREATE TABLE `rol_menu` (
  `id_menu` int(11) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `id_modulo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `rol_menu`
--

INSERT INTO `rol_menu` (`id_menu`, `id_rol`, `id_modulo`) VALUES
(1, 1, 6),
(2, 1, 1),
(3, 1, 1),
(4, 1, 1),
(5, 1, 2),
(6, 1, 9),
(7, 1, 7),
(1, 2, 6),
(2, 2, 1),
(3, 2, 1),
(4, 2, 1),
(5, 2, 2),
(7, 2, 7),
(4, 3, 1),
(2, 3, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `correo` varchar(45) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Este campo guarda el correo de cada usuario que se registra en el sistema.',
  `passwrd` varchar(255) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Este campo guarda la clave de encriptada de cada uno de los usuarios',
  `id_rol` int(11) NOT NULL COMMENT 'Este campo guarda el id del rol que se le asigna a cada usuario',
  `estado` enum('activo','inactivo','Eliminado') COLLATE utf8_spanish_ci NOT NULL DEFAULT 'activo' COMMENT 'Estados de usuario \nactivo= El usuario puede acceder al sistema\ninactivo = El usuario no puede acceder al sistema temporalmente, su cuenta esta bloqueada.\nEliminado = El usuario no puede acceder al sistema definitivamente',
  `id_empleado` int(11) DEFAULT NULL COMMENT 'Este campo guarda el id de empleado que se encuentra registrado en el sistema\n',
  `id_cliente` int(11) DEFAULT NULL COMMENT 'Este campo guarda el id de cada cliente que se encuentra registrado en el sistema.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id`, `correo`, `passwrd`, `id_rol`, `estado`, `id_empleado`, `id_cliente`) VALUES
(1, 'admin@cardoffice.sv', '$2y$04$RcBk752n.CCmmHgd.Eq.YOVR4JcaHoSffW3qe.QT.st2aDROFWA3O', 1, 'activo', 1, NULL),
(7, 'carlos@gmail.com', '$2y$04$RcBk752n.CCmmHgd.Eq.YOVR4JcaHoSffW3qe.QT.st2aDROFWA3O', 4, 'activo', NULL, 6),
(8, 'gerente@cardoffice.sv', '$2y$04$RcBk752n.CCmmHgd.Eq.YOVR4JcaHoSffW3qe.QT.st2aDROFWA3O', 2, 'activo', 4, NULL),
(9, 'empleado@cardoffice.sv', '$2y$04$RcBk752n.CCmmHgd.Eq.YOVR4JcaHoSffW3qe.QT.st2aDROFWA3O', 3, 'activo', 5, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta`
--

CREATE TABLE `venta` (
  `id` int(11) NOT NULL,
  `detalle` longtext COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo guarda la lista de detalles de productos que se compran.',
  `subtotal` decimal(10,0) NOT NULL COMMENT 'Este campo guarda el subtotal de la  compra realizada.',
  `total` decimal(10,0) DEFAULT NULL COMMENT 'Este campo guarda el total de la compra',
  `estado` enum('pendiente','realizado') COLLATE utf8_spanish_ci DEFAULT 'pendiente' COMMENT 'Este campo guarda el estado cada una de las ventas realizadas\nPendiente=''no se ha entregado la mercaderia'';\nrealizado =''la mercaderia ya fue entragada al cliente'';\n',
  `fecha_emision` timestamp NULL DEFAULT NULL COMMENT 'Este campo registra la fecha y hora en que se realizo el pedido',
  `IVA` decimal(10,0) DEFAULT NULL COMMENT 'Este campo guarda el monto del IVA que se debe cancelar.\n',
  `id_usuario` int(11) NOT NULL COMMENT 'Este campo guarda el id del usuario que usuario al que pernetece la venta',
  `id_comprobante` int(11) NOT NULL COMMENT 'Es campo guarda el Id del tipo de comprobante de la venta.',
  `id_cliente` int(11) DEFAULT NULL,
  `direccion` mediumtext COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Este campo guarda la direccion de envio de la venta si se realiza de manera online',
  `tipo_venta` enum('online','local') COLLATE utf8_spanish_ci NOT NULL COMMENT 'Especifica el tipo de venta si se hizo a traves de una cuenta online o si se realizo a de manera local'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura para la vista `cargar_menu`
--
DROP TABLE IF EXISTS `cargar_menu`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `cargar_menu`  AS  select `r`.`nombre` AS `rol`,`m`.`nombre` AS `menu`,`mt`.`nombre` AS `submenu`,`r`.`id` AS `id_rol`,`m`.`id` AS `id_menu`,`mt`.`id_item` AS `id_menu_item` from (((`rol` `r` join `rol_menu` `rm`) join `menu` `m`) join `menu_item` `mt`) where `r`.`id` = `rm`.`id_rol` and `rm`.`id_menu` = `m`.`id` and `mt`.`id_menu_padre` = `m`.`id` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `comprobante`
--
ALTER TABLE `comprobante`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `datos_auditoria`
--
ALTER TABLE `datos_auditoria`
  ADD PRIMARY KEY (`id_auditoria`);

--
-- Indices de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `dui_UNIQUE` (`dui`),
  ADD UNIQUE KEY `codigo_UNIQUE` (`codigo`);

--
-- Indices de la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_inventario_producto_idx` (`id_producto`);

--
-- Indices de la tabla `marca`
--
ALTER TABLE `marca`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `menu_item`
--
ALTER TABLE `menu_item`
  ADD PRIMARY KEY (`id_item`),
  ADD KEY `fk_menu_item_menu1_idx` (`id_menu_padre`);

--
-- Indices de la tabla `modulo`
--
ALTER TABLE `modulo`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `modulo_UNIQUE` (`modulo`);

--
-- Indices de la tabla `ofertas`
--
ALTER TABLE `ofertas`
  ADD PRIMARY KEY (`id_inventario`,`id_producto`),
  ADD KEY `fk_inventario_has_producto_producto1_idx` (`id_producto`),
  ADD KEY `fk_inventario_has_producto_inventario1_idx` (`id_inventario`);

--
-- Indices de la tabla `privilegios_rol`
--
ALTER TABLE `privilegios_rol`
  ADD KEY `fk_rol_has_operaciones_rol1_idx` (`id_rol`),
  ADD KEY `fk_privilegios_rol_modulo1_idx` (`id_modulo`),
  ADD KEY `fk_privilegios_rol_usuario1_idx` (`id_usuario`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_producto_categorias1_idx` (`id_categoria`),
  ADD KEY `fk_producto_marca1_idx` (`id_marca`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `rol_menu`
--
ALTER TABLE `rol_menu`
  ADD KEY `fk_menu_has_rol_rol1_idx` (`id_rol`),
  ADD KEY `fk_menu_has_rol_menu1_idx` (`id_menu`),
  ADD KEY `fk_rol_menu_modulo1_idx` (`id_modulo`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `correo_UNIQUE` (`correo`),
  ADD KEY `fk_usuario_rol1_idx` (`id_rol`),
  ADD KEY `fk_usuario_empleado1_idx` (`id_empleado`),
  ADD KEY `fk_usuario_cliente1_idx` (`id_cliente`);

--
-- Indices de la tabla `venta`
--
ALTER TABLE `venta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_venta_usuario1_idx` (`id_usuario`),
  ADD KEY `fk_venta_comprobante1_idx` (`id_comprobante`),
  ADD KEY `fk_venta_cliente1_idx` (`id_cliente`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `comprobante`
--
ALTER TABLE `comprobante`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `datos_auditoria`
--
ALTER TABLE `datos_auditoria`
  MODIFY `id_auditoria` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `devoluciones`
--
ALTER TABLE `devoluciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `empleado`
--
ALTER TABLE `empleado`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `inventario`
--
ALTER TABLE `inventario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `marca`
--
ALTER TABLE `marca`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `menu`
--
ALTER TABLE `menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `menu_item`
--
ALTER TABLE `menu_item`
  MODIFY `id_item` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `modulo`
--
ALTER TABLE `modulo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `ofertas`
--
ALTER TABLE `ofertas`
  MODIFY `id_inventario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `privilegios_rol`
--
ALTER TABLE `privilegios_rol`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `venta`
--
ALTER TABLE `venta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD CONSTRAINT `fk_inventario_producto` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `menu_item`
--
ALTER TABLE `menu_item`
  ADD CONSTRAINT `fk_menu_item_menu1` FOREIGN KEY (`id_menu_padre`) REFERENCES `menu` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `ofertas`
--
ALTER TABLE `ofertas`
  ADD CONSTRAINT `fk_inventario_has_producto_inventario1` FOREIGN KEY (`id_inventario`) REFERENCES `inventario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_inventario_has_producto_producto1` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `privilegios_rol`
--
ALTER TABLE `privilegios_rol`
  ADD CONSTRAINT `fk_privilegios_rol_modulo1` FOREIGN KEY (`id_modulo`) REFERENCES `modulo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_privilegios_rol_usuario1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_rol_has_operaciones_rol1` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `fk_producto_categorias1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_producto_marca1` FOREIGN KEY (`id_marca`) REFERENCES `marca` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `rol_menu`
--
ALTER TABLE `rol_menu`
  ADD CONSTRAINT `fk_menu_has_rol_menu1` FOREIGN KEY (`id_menu`) REFERENCES `menu` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_menu_has_rol_rol1` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_rol_menu_modulo1` FOREIGN KEY (`id_modulo`) REFERENCES `modulo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_usuario_cliente1` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_usuario_empleado1` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_usuario_rol1` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `venta`
--
ALTER TABLE `venta`
  ADD CONSTRAINT `fk_venta_cliente1` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_venta_comprobante1` FOREIGN KEY (`id_comprobante`) REFERENCES `comprobante` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_venta_usuario1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
