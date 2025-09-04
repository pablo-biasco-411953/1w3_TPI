CREATE DATABASE VETERINARIA17;
GO

USE VETERINARIA17;
GO

-- ==============================
-- ESPECIES Y RAZAS
-- ==============================

CREATE TABLE ESPECIES (
    id_especie INT IDENTITY(1,1) NOT NULL,
    nombreEspecie VARCHAR(200) NOT NULL,
    CONSTRAINT pk_especies PRIMARY KEY (id_especie)
);

CREATE TABLE RAZAS(
    id_raza INT IDENTITY(1,1) NOT NULL,
    nombreRaza VARCHAR(200) NOT NULL,
    id_especie INT NOT NULL,
    CONSTRAINT pk_razas PRIMARY KEY (id_raza),
    CONSTRAINT fk_razas_especies FOREIGN KEY (id_especie) REFERENCES ESPECIES(id_especie)
);
-- ==============================
-- UBICACIONES
-- ==============================

CREATE TABLE PAISES (
    id_pais INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    CONSTRAINT pk_paises PRIMARY KEY (id_pais)
);

CREATE TABLE PROVINCIAS (
    id_provincia INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    id_pais INT NOT NULL,
    CONSTRAINT pk_provincias PRIMARY KEY (id_provincia),
    CONSTRAINT fk_provincias_paises FOREIGN KEY (id_pais) REFERENCES PAISES(id_pais)
);

CREATE TABLE LOCALIDADES (
    id_localidad INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    id_provincia INT NOT NULL,
    CONSTRAINT pk_localidades PRIMARY KEY (id_localidad),
    CONSTRAINT fk_localidades_provincias FOREIGN KEY (id_provincia) REFERENCES PROVINCIAS(id_provincia)
);

CREATE TABLE DOMICILIOS (
    id_domicilio INT IDENTITY(1,1) NOT NULL,
    calle VARCHAR(60) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    id_localidad INT NOT NULL,
    CONSTRAINT pk_domicilios PRIMARY KEY (id_domicilio),
    CONSTRAINT fk_domicilios_localidades FOREIGN KEY (id_localidad) REFERENCES LOCALIDADES(id_localidad)
);
-- ==============================
-- MUTUAL
-- ==============================
CREATE TABLE MUTUALES(
	id_mutual int IDENTITY(1,1),
	descripcion varchar (60),
	CONSTRAINT pk_mutuales PRIMARY KEY (id_mutual)
);
-- ==============================
-- PACIENTES
-- ==============================

CREATE TABLE PACIENTES (
    id_paciente INT IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NULL,
    sexo CHAR(1) NULL, -- M: macho, H: hembra
    id_raza INT NOT NULL,
    id_especie INT NOT NULL,
    id_domicilio INT NULL,
	id_mutual INT NULL,
    observaciones VARCHAR(500) NULL,
	CONSTRAINT pk_pacientes PRIMARY KEY (id_paciente),
    CONSTRAINT fk_pacientes_razas FOREIGN KEY (id_raza) REFERENCES RAZAS(id_raza),
    CONSTRAINT fk_pacientes_especies FOREIGN KEY (id_especie) REFERENCES ESPECIES(id_especie),
    CONSTRAINT fk_pacientes_domicilio FOREIGN KEY (id_domicilio) REFERENCES DOMICILIOS(id_domicilio),
	CONSTRAINT fk_pacientes_mutual FOREIGN KEY (id_mutual) REFERENCES MUTUALES(id_mutual)
);

-- ==============================
-- VETERINARIOS
-- ==============================

CREATE TABLE VETERINARIOS (
    id_veterinario INT IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    matricula VARCHAR(50) NULL,
    especialidad VARCHAR(100) NULL,
	CONSTRAINT pk_veterinarios PRIMARY KEY (id_veterinario)

);

CREATE TABLE TUTORES (
    id_tutor INT IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dni VARCHAR(20) NULL,
    fecha_nacimiento DATE NULL,
    id_domicilio INT NULL,
    observaciones VARCHAR(500) NULL,
	CONSTRAINT pk_tutores PRIMARY KEY (id_tutor),
    CONSTRAINT fk_tutores_domicilio FOREIGN KEY (id_domicilio) REFERENCES DOMICILIOS(id_domicilio)
);


-- ==============================
-- CONTACTOS
-- ==============================

CREATE TABLE TIPOS_CONTACTO (
    id_tipo_contacto INT IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL -- Teléfono, Celular, Email, WhatsApp, etc.
	CONSTRAINT pk_tipos_contacto PRIMARY KEY (id_tipo_contacto)

);

CREATE TABLE CONTACTOS (
    id_contacto INT IDENTITY(1,1) NOT NULL,
    id_tipo_contacto INT NOT NULL,
    id_tutor INT NULL,
    id_veterinario INT NULL,
    CONSTRAINT pk_contactos PRIMARY KEY (id_contacto),
    CONSTRAINT fk_contactos_tipos FOREIGN KEY (id_tipo_contacto) REFERENCES TIPOS_CONTACTO(id_tipo_contacto),
    CONSTRAINT fk_contactos_tutores FOREIGN KEY (id_tutor) REFERENCES TUTORES(id_tutor),
    CONSTRAINT fk_contactos_veterinarios FOREIGN KEY (id_veterinario) REFERENCES VETERINARIOS(id_veterinario)
);



-- ==============================
-- TIPOS DE ESTUDIOS
-- ==============================

CREATE TABLE TIPOS_ESTUDIOS (
    id_tipo_estudio INT IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500) NULL,
	CONSTRAINT pk_tipos_estudio PRIMARY KEY (id_tipo_estudio)
);

CREATE TABLE ESTUDIOS (
    id_estudio INT IDENTITY(1,1),
    id_tipo_estudio INT NOT NULL,
    observaciones VARCHAR(500) NULL,
	CONSTRAINT pk_estudios PRIMARY KEY (id_estudio),
    CONSTRAINT fk_estudios_tipos FOREIGN KEY (id_tipo_estudio) REFERENCES TIPOS_ESTUDIOS(id_tipo_estudio)
);

-- ==============================
-- ESTADOS DE TURNOS
-- ==============================

CREATE TABLE ESTADOS_TURNO (
    id_estado INT IDENTITY(1,1),
    nombre_estado VARCHAR(50) NOT NULL -- Pendiente, Confirmado, Cancelado, Realizado
	CONSTRAINT pk_estados_turnos PRIMARY KEY (id_estado)
);

-- ==============================
-- TURNOS
-- ==============================

CREATE TABLE TURNOS (
    id_turno INT IDENTITY(1,1),
    id_paciente INT NOT NULL,
    id_veterinario INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    motivo VARCHAR(500) NULL,
    id_estado INT NOT NULL,
	CONSTRAINT pk_turnos PRIMARY KEY (id_turno),
    CONSTRAINT fk_turnos_pacientes FOREIGN KEY (id_paciente) REFERENCES PACIENTES(id_paciente),
    CONSTRAINT fk_turnos_veterinarios FOREIGN KEY (id_veterinario) REFERENCES VETERINARIOS(id_veterinario),
    CONSTRAINT fk_turnos_estados FOREIGN KEY (id_estado) REFERENCES ESTADOS_TURNO(id_estado)
);

-- ==============================
-- RELACIÓN N:M TURNOS - ESTUDIOS
-- ==============================

CREATE TABLE TURNOS_ESTUDIOS (
    id_turnos_estado INT NOT NULL,
    id_estudio INT NOT NULL,
    resultados VARCHAR(1000) NULL,
    fecha_realizacion DATE NULL,
	CONSTRAINT pk_turnos_estado PRIMARY KEY (id_turnos_estado),
    CONSTRAINT fk_te_turnos FOREIGN KEY (id_turnos_estado) REFERENCES TURNOS(id_turno),
    CONSTRAINT fk_te_estudios FOREIGN KEY (id_estudio) REFERENCES ESTUDIOS(id_estudio)
);

-- ==============================
-- SERVICIOS
-- ==============================

CREATE TABLE SERVICIOS (
    id_servicio INT IDENTITY(1,1),
    nombre_servicio VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500) NULL,
	CONSTRAINT pk_servicios PRIMARY KEY (id_servicio)

);

CREATE TABLE TURNOS_SERVICIOS (
    id_turnos_servicio INT NOT NULL,
    id_servicio INT NOT NULL,
    observaciones VARCHAR(500) NULL,
	CONSTRAINT pk_turnos_servicio PRIMARY KEY (id_turnos_servicio),
    CONSTRAINT fk_ts_turnos FOREIGN KEY (id_turnos_servicio) REFERENCES TURNOS(id_turno),
    CONSTRAINT fk_ts_servicios FOREIGN KEY (id_servicio) REFERENCES SERVICIOS(id_servicio)
);

-- ==============================
-- MEDICAMENTOS
-- ==============================
CREATE TABLE TIPOS_MEDICAMENTO(
	id_tipo int identity (1,1),
	descripcion varchar (50) not null,

	Constraint pk_tp_medicamento primary key (id_tipo)
);

CREATE TABLE MEDICAMENTOS (
    id_medicamento INT IDENTITY(1,1),
    nombre_medicamento VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500) NULL,
	id_tipo int not null
	CONSTRAINT pk_medicamentos PRIMARY KEY (id_medicamento)
	CONSTRAINT fk_tp_medicamento foreign key (id_tipo)
	REFERENCES TIPOS_MEDICAMENTO(id_tipo)
);



CREATE TABLE TURNOS_MEDICAMENTOS (
    id_turnos_medicamento INT NOT NULL,
    id_medicamento INT NOT NULL,
    dosis VARCHAR(50) NOT NULL,
    frecuencia VARCHAR(50) NOT NULL,
    duracion VARCHAR(50) NULL,
    observaciones VARCHAR(500) NULL,
	CONSTRAINT pk_turnos_medicamento PRIMARY KEY (id_turnos_medicamento),
    CONSTRAINT fk_tm_turnos FOREIGN KEY (id_turnos_medicamento) REFERENCES TURNOS(id_turno),
    CONSTRAINT fk_tm_medicamentos FOREIGN KEY (id_medicamento) REFERENCES MEDICAMENTOS(id_medicamento)
);


CREATE TABLE HISTORIAL_CLINICO (
    id_historial INT IDENTITY(1,1),
    id_paciente INT NOT NULL,
    id_veterinario INT NOT NULL,
    fecha DATETIME NOT NULL,
    motivo VARCHAR(500) NULL,
    diagnostico VARCHAR(1000) NULL,
    tratamiento VARCHAR(1000) NULL,
    observaciones VARCHAR(1000) NULL,
	CONSTRAINT pk_historial PRIMARY KEY (id_historial),
    CONSTRAINT fk_historial_paciente FOREIGN KEY (id_paciente) REFERENCES PACIENTES(id_paciente),
    CONSTRAINT fk_historial_veterinario FOREIGN KEY (id_veterinario) REFERENCES VETERINARIOS(id_veterinario)
);




CREATE TABLE FACTURAS (
    id_factura INT IDENTITY(1,1) NOT NULL,
    numero_factura VARCHAR(50) NOT NULL,          -- N° de factura
    id_tutor INT NOT NULL,                        -- Quien recibe la factura
    fecha_emision DATETIME NOT NULL,
    total DECIMAL(10,2) NOT NULL DEFAULT 0,      -- Total calculado
    observaciones VARCHAR(500) NULL,
    CONSTRAINT pk_facturas PRIMARY KEY (id_factura),
    CONSTRAINT fk_facturas_tutor FOREIGN KEY (id_tutor) REFERENCES TUTORES(id_tutor)
);

CREATE TABLE DETALLES_FACTURA (
    id_detalle INT IDENTITY(1,1) NOT NULL,
    id_factura INT NOT NULL,         -- Factura a la que pertenece
    id_turno INT NULL,               -- Puede vincular a un turno específico
    id_servicio INT NULL,            -- O un servicio
    id_estudio INT NULL,             -- O un estudio
    id_medicamento INT NULL,         -- O un medicamento
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal AS (cantidad * precio_unitario) PERSISTED,
    CONSTRAINT pk_detalles_factura PRIMARY KEY (id_detalle),
    CONSTRAINT fk_detalles_factura FOREIGN KEY (id_factura) REFERENCES FACTURAS(id_factura),
    CONSTRAINT fk_detalles_turno FOREIGN KEY (id_turno) REFERENCES TURNOS(id_turno),
    CONSTRAINT fk_detalles_servicio FOREIGN KEY (id_servicio) REFERENCES SERVICIOS(id_servicio),
    CONSTRAINT fk_detalles_estudio FOREIGN KEY (id_estudio) REFERENCES ESTUDIOS(id_estudio),
    CONSTRAINT fk_detalles_medicamento FOREIGN KEY (id_medicamento) REFERENCES MEDICAMENTOS(id_medicamento)
);


CREATE TABLE FORMAS_PAGO (
    id_forma_pago INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL, -- Ej: Efectivo, Tarjeta, Transferencia
    descripcion VARCHAR(200) NULL,
    CONSTRAINT pk_formas_pago PRIMARY KEY (id_forma_pago)
);

CREATE TABLE PAGOS (
    id_pago INT IDENTITY(1,1) NOT NULL,
    id_turno INT NOT NULL,            
    id_tutor INT NOT NULL,             
    id_forma_pago INT NOT NULL,       
    monto DECIMAL(10,2) NOT NULL,     
    fecha_pago DATETIME NOT NULL,
    observaciones VARCHAR(500) NULL,
    CONSTRAINT pk_pagos PRIMARY KEY (id_pago),
    CONSTRAINT fk_pagos_turnos FOREIGN KEY (id_turno) REFERENCES TURNOS(id_turno),
    CONSTRAINT fk_pagos_tutores FOREIGN KEY (id_tutor) REFERENCES TUTORES(id_tutor),
    CONSTRAINT fk_pagos_formas_pago FOREIGN KEY (id_forma_pago) REFERENCES FORMAS_PAGO(id_forma_pago)
);

