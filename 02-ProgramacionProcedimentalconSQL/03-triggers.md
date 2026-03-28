> Triggers: 
>- Insert, Update, Delete.
>
>Asociado a una tabla
>
>Restricciones -> Aditorias

>Utilizar el trigger para una auditoria o para restricciones 


# **TRIGGERS** (Disparadores)

## ¿Qué es un Trigger?

Es un bloque de codigo SQL que se ejecuta automáticamente 
cuando ocurre un evanto en una tabla 

## 🦥 EVENTOS

- INSERT
- UPDATE
- DELETE

🤖No se enecutan manualmente, se ejecutan solos. 

## 🤯Para que sirven:
- VALIDACIÓNES
- AUDITORIA
- REGALS DE NEGOCIO 
- AUTOMATICACIÓN

## 🦁 Tipos de Tiggers en SQL SERVER 

- AFTER TRIGGER
> Se ejecuta despues del evento 
- INSTED OF (en lugar de)
> Remplaza la operación original 

## 🔩 Sintaxis Básica

```sql
    CREATE TRIGGER nombre_trigger
    ON nombre_tabla
    AFTER INSERT
    AS 
    BEGIN
        --Código
    END;
```
## Tablas Especiales

| **Tabla** | **Contenido** |
| :--- | :--- |
| INSERTED | Nuevos Datos |
| DELETED | Datos Anteriores |


- git status
- git add.
- git commit -m "Joins y stored Procedures terminados"
- git check main
- git marge rama-joins
- git add origin -------
- git push -u origin main

- git branch rm rama-joi
