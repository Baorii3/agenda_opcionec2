# Agenda - Versión Barata (EC2)

Esta versión está diseñada para minimizar costes en AWS, corriendo todo el stack (Base de Datos, API y Web) en una única instancia EC2 (t3.micro).

## Requisitos
*   AWS CLI configurado.
*   Terraform instalado.
*   Una llave SSH (Key Pair) creada en AWS.

## Despliegue de Infraestructura
1.  Entra en la carpeta `terraform`.
2.  Ejecuta `terraform init`.
3.  Ejecuta `terraform apply -var="key_name=TU_LLAVE_SSH"`.
4.  Copia la `public_ip` que salga al finalizar.

## Configuración de la Aplicación
1.  Crea un archivo `.env` en esta carpeta con tus secretos:
    ```env
    GOOGLE_CLIENT_ID=...
    GOOGLE_CLIENT_SECRET=...
    AWS_COGNITO_USER_POOL_ID=...
    AWS_COGNITO_CLIENT_ID=...
    DB_PASSWORD=1234
    ```

## Despliegue / Recarga
Para subir cambios o iniciar la aplicación:
1.  Asegúrate de que los archivos estén en la EC2 (puedes usar `git clone` o `scp`).
2.  Ejecuta el script de recarga:
    ```bash
    chmod +x reload.sh
    ./reload.sh
    ```

ssh -i agenda_ec2_barata/agenda-key.pem -L 80:localhost:80 ec2-user@54.235.9.25
