# monitoreo-pulso-saturacion-oxigeno

### Alumnos:
- Hurtado Santos, Estiven Salvador
- López Terrones, Xiomy Ximena
- Mondragón Zúñiga, Rubén Alberto
- Morales Robladillo, Nicole Maria
  
###Descripción:

Este sistema monitorea el nivel de oxígeno en la sangre del paciente en cuestión. La lectura que recibirá el sensor MAX 30100 que estará conectado a una placa SP32, por medio del bluetooth se lo enviará al dispositivo móvil asociado del paciente el cual se conectará al back de la aplicación que estará desarrollada en SPRING y enviará esta información a un servidor MQTT Server y alojará toda la información histórica de los clientes en una base de datos no estructural como es Mongo. Una vez que se tenga esta información del cliente por medio del oxímetro, este estará asociado a un médico el cual podrá monitorizar el estado del paciente en cuanto a los niveles de oxígeno y si este está con estado crítico, el médico recibirá una alerta con la información del cliente que se encuentra con malos niveles de oxígeno para que agende una cita.

Adicionalmente, esta información histórica de los pacientes y sus niveles de oxígeno se podrán visualizar en una aplicación web para tener una vista más controlada de los pacientes en general.

Este proyecto servirá para que los médicos tengan una facilidad de control de sus pacientes en particular de los que tienen problemas respiratorios o de presión tanto alta como baja para darles un seguimiento más exhaustivo y que los pacientes se sientan más seguros. A su vez, con la data histórica, en un futuro crear un modelo predictivo que permita prevenir un posible desastre con el cliente en caso los patrones de salud lo reflejan.
