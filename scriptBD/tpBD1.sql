CREATE DATABASE VETERINARIA_COMPLETA2;
GO

USE VETERINARIA_COMPLETA2;
GO

-- ==============================
-- TABLAS BASE
-- ==============================

CREATE TABLE Tutores (
    id_tutor INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_registro DATE NOT NULL 
);

CREATE TABLE Pacientes (
    id_paciente INT IDENTITY(1,1) PRIMARY KEY,
    id_tutor INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    especie VARCHAR(50) NOT NULL,   -- perro, gato, etc
    raza VARCHAR(50) NULL,
    fecha_nacimiento DATE NULL,
    sexo CHAR(1) NULL CHECK (sexo IN ('M','H')), -- M: macho, H: hembra
    observaciones VARCHAR(500) NULL,
    CONSTRAINT fk_pacientes_tutores FOREIGN KEY (id_tutor) REFERENCES Tutores(id_tutor)
);

CREATE TABLE Veterinarios (
    id_veterinario INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    matricula VARCHAR(50) NULL,
    especialidad VARCHAR(100) NULL
);

-- ==============================
-- CONTACTOS
-- ==============================

CREATE TABLE Tipos_Contacto (
    id_tipo_contacto INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL  -- Teléfono, Email, WhatsApp, etc.
);

CREATE TABLE Contactos (
    id_contacto INT IDENTITY(1,1) PRIMARY KEY,
    id_tipo_contacto INT NOT NULL,
    entidad_tipo VARCHAR(20) NOT NULL CHECK (entidad_tipo IN ('TUTOR','VETERINARIO')),
    entidad_id INT NOT NULL,
    valor_contacto VARCHAR(100) NOT NULL,
    CONSTRAINT fk_contactos_tipo FOREIGN KEY (id_tipo_contacto) REFERENCES Tipos_Contacto(id_tipo_contacto)
    -- entidad_id depende de entidad_tipo ? validar en capa de aplicación
);

-- ==============================
-- ESTUDIOS
-- ==============================

CREATE TABLE Tipos_Estudios (
    id_tipo_estudio INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,   -- ej: Hemograma, Radiografía, Ecografía
    descripcion VARCHAR(500) NULL
);

CREATE TABLE Estudios (
    id_estudio INT IDENTITY(1,1) PRIMARY KEY,
    id_tipo_estudio INT NOT NULL,
    observaciones VARCHAR(500) NULL,
    CONSTRAINT fk_estudios_tipos FOREIGN KEY (id_tipo_estudio) REFERENCES Tipos_Estudios(id_tipo_estudio)
);

-- ==============================
-- ESTADOS DE TURNOS
-- ==============================

CREATE TABLE Estados_Turno (
    id_estado INT IDENTITY(1,1) PRIMARY KEY,
    nombre_estado VARCHAR(50) NOT NULL  -- Pendiente, Confirmado, Cancelado, Realizado
);

-- ==============================
-- TURNOS
-- ==============================

CREATE TABLE Turnos (
    id_turno INT IDENTITY(1,1) PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_veterinario INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    motivo VARCHAR(500) NULL,
    id_estado INT NOT NULL, 
    CONSTRAINT fk_turnos_pacientes FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    CONSTRAINT fk_turnos_veterinarios FOREIGN KEY (id_veterinario) REFERENCES Veterinarios(id_veterinario),
    CONSTRAINT fk_turnos_estados FOREIGN KEY (id_estado) REFERENCES Estados_Turno(id_estado)
);

-- ==============================
-- RELACIÓN N:M TURNOS - ESTUDIOS
-- ==============================

CREATE TABLE Turnos_Estudios (
    id_turno INT NOT NULL,
    id_estudio INT NOT NULL,
    resultados VARCHAR(1000) NULL,  -- ej: "Glóbulos rojos dentro de rango"
    fecha_realizacion DATE NULL,
    PRIMARY KEY (id_turno, id_estudio),
    CONSTRAINT fk_turnosest_turnos FOREIGN KEY (id_turno) REFERENCES Turnos(id_turno),
    CONSTRAINT fk_turnosest_estudios FOREIGN KEY (id_estudio) REFERENCES Estudios(id_estudio)
);

-- ==============================
-- SERVICIOS
-- ==============================

CREATE TABLE Servicios (
    id_servicio INT IDENTITY(1,1) PRIMARY KEY,
    nombre_servicio VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500) NULL
);

CREATE TABLE Turnos_Servicios (
    id_turno INT NOT NULL,
    id_servicio INT NOT NULL,
    observaciones VARCHAR(500) NULL,
    PRIMARY KEY (id_turno, id_servicio),
    CONSTRAINT fk_ts_turnos FOREIGN KEY (id_turno) REFERENCES Turnos(id_turno),
    CONSTRAINT fk_ts_servicios FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio)
);

-- ==============================
-- MEDICAMENTOS
-- ==============================

CREATE TABLE Medicamentos (
    id_medicamento INT IDENTITY(1,1) PRIMARY KEY,
    nombre_medicamento VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500) NULL
);

CREATE TABLE Turnos_Medicamentos (
    id_turno INT NOT NULL,
    id_medicamento INT NOT NULL,
    dosis VARCHAR(50) NOT NULL,
    frecuencia VARCHAR(50) NOT NULL,
    duracion VARCHAR(50) NULL,
    observaciones VARCHAR(500) NULL,
    PRIMARY KEY (id_turno, id_medicamento),
    CONSTRAINT fk_tm_turnos FOREIGN KEY (id_turno) REFERENCES Turnos(id_turno),
    CONSTRAINT fk_tm_medicamentos FOREIGN KEY (id_medicamento) REFERENCES Medicamentos(id_medicamento)
);

-- ==============================
-- HISTORIAL CLÍNICO
-- ==============================

CREATE TABLE Historial_Clinico (
    id_historial INT IDENTITY(1,1) PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_veterinario INT NOT NULL,
    fecha DATE NOT NULL,
    motivo VARCHAR(200) NOT NULL,
    diagnostico VARCHAR(500) NULL,
    tratamiento VARCHAR(500) NULL,
    observaciones VARCHAR(500) NULL,
    CONSTRAINT fk_historial_paciente FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    CONSTRAINT fk_historial_veterinario FOREIGN KEY (id_veterinario) REFERENCES Veterinarios(id_veterinario)
);

-- ==============================
-- FACTURACIÓN
-- ==============================

CREATE TABLE Facturas (
    id_factura INT IDENTITY(1,1) PRIMARY KEY,
    id_tutor INT NOT NULL,
    fecha DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_facturas_tutores FOREIGN KEY (id_tutor) REFERENCES Tutores(id_tutor)
);

CREATE TABLE Detalle_Factura (
    id_detalle INT IDENTITY(1,1) PRIMARY KEY,
    id_factura INT NOT NULL,
    concepto VARCHAR(200) NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal AS (cantidad * precio_unitario) PERSISTED,
    CONSTRAINT fk_detalle_factura FOREIGN KEY (id_factura) REFERENCES Facturas(id_factura)
);
